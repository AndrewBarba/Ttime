//
//  TTMBTAClient.m
//  Ttime
//
//  Created by Andrew Barba on 9/24/13.
//  Copyright (c) 2013 Andrew Barba. All rights reserved.
//

#import "TTMBTAClient.h"

#define TT_CONCURRENT_REQUESTS 1 // enable this when the MBTA gets their shit together

@interface TTMBTAClient() {
    NSMutableArray *_requestQueue;
    BOOL _isProcessingQueue;
}

@end

@implementation TTMBTAClient

- (id)init
{
    self = [super init];
    if (self) {
        _isProcessingQueue = NO;
        _requestQueue = [NSMutableArray array];
    }
    return self;
}

- (void)asyncMBTARequest:(NSString *)endpoint
                                      data:(NSDictionary *)data
                                completion:(TTRequestBlock)complete
{
    if (TT_CONCURRENT_REQUESTS) {
        [self _asyncMBTARequest:endpoint data:data completion:complete];
    } else {
        NSArray *parts = @[ endpoint, data, [complete copy] ];
        [_requestQueue addObject:parts];
        
        if (!_isProcessingQueue) {
            _isProcessingQueue = YES;
            [self _processQueue];
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
        }
    }
}

- (void)_asyncMBTARequest:(NSString *)endpoint
                    data:(NSDictionary *)data
              completion:(TTRequestBlock)complete
{
    NSString *path = [NSString stringWithFormat:@"%@%@", TT_MBTA_BASE_URL, endpoint];
    
    NSMutableDictionary *params = [data mutableCopy];
    params[@"api_key"] = TT_MBTA_API_KEY;
    
    if (TL_IS_IOS7()) {
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        [manager GET:path parameters:params success:^(NSURLSessionDataTask *task, NSDictionary *response){
            if (complete) {
                complete(response, nil);
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error){
            NSLog(@"ERROR: %@", task.originalRequest.URL);
            if (complete) {
                complete(nil, error);
            }
        }];
    } else {
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        [manager GET:path parameters:params success:^(AFHTTPRequestOperation *task, NSDictionary *response){
            if (complete) {
                complete(response, nil);
            }
        } failure:^(AFHTTPRequestOperation *task, NSError *error){
            NSLog(@"ERROR: %@", task.request.URL);
            if (complete) {
                complete(nil, error);
            }
        }];
    }
}

- (void)_processQueue
{
    NSArray *requestParts = [_requestQueue firstObject];
    
    if (!requestParts) {
        _isProcessingQueue = NO;
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        return;
    }
    
    NSString *endpoint = requestParts[0];
    NSDictionary *data = requestParts[1];
    TTRequestBlock complete = requestParts[2];
    
    [self _asyncMBTARequest:endpoint data:data completion:^(id resp, NSError *error){
        if (complete) {
            complete(resp, error);
        }
        TTDispatchMain(^{
            [self _processQueue];
        });
    }];
    
    [_requestQueue removeObjectAtIndex:0];
}

#pragma mark - Make Request

+ (void)asyncMBTARequest:(NSString *)endpoint data:(NSDictionary *)data completion:(TTRequestBlock)complete
{
    static TTMBTAClient *client = nil;
    
    TT_DISPATCH_ONCE(^{
        client = [[TTMBTAClient alloc] init];
    });
    
    [client asyncMBTARequest:endpoint data:data completion:complete];
}

@end
