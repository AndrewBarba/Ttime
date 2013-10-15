//
//  TTMBTAClient.m
//  Ttime
//
//  Created by Andrew Barba on 9/24/13.
//  Copyright (c) 2013 Andrew Barba. All rights reserved.
//

#import "TTMBTAClient.h"

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
    NSArray *parts = @[ endpoint, data, [complete copy] ];
    [_requestQueue addObject:parts];
    
    if (!_isProcessingQueue) {
        [self _processQueue];
    }
}

- (void)_asyncMBTARequest:(NSString *)endpoint
                    data:(NSDictionary *)data
              completion:(TTRequestBlock)complete
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    NSString *path = [NSString stringWithFormat:@"%@%@", TT_MBTA_BASE_URL, endpoint];
    
    NSMutableDictionary *params = [data mutableCopy];
    params[@"api_key"] = TT_MBTA_API_KEY;
    
    [manager GET:path parameters:params success:^(NSURLSessionDataTask *task, NSDictionary *response){
        if (complete) {
            complete(response, nil);
        }
        [self _processQueue];
    } failure:^(NSURLSessionDataTask *task, NSError *error){
        if (complete) {
            complete(nil, error);
        }
        [self _processQueue];
    }];
}

- (void)_processQueue
{
    _isProcessingQueue = YES;
    
    NSArray *requestParts = [_requestQueue firstObject];
    
    if (!requestParts) {
        _isProcessingQueue = NO;
        return;
    }
    
    NSString *endpoint = requestParts[0];
    NSDictionary *data = requestParts[1];
    TTRequestBlock complete = requestParts[2];
    
    [self _asyncMBTARequest:endpoint data:data completion:^(id resp, NSError *error){
        if (complete) {
            complete(resp, error);
        }
        [self _processQueue];
    }];
    
    [_requestQueue removeObjectAtIndex:0];
}

#pragma mark - Make Request

+ (void)asyncMBTARequest:(NSString *)endpoint
                                      data:(NSDictionary *)data
                                completion:(TTRequestBlock)complete
{
    static TTMBTAClient *client = nil;
    
    TT_DISPATCH_ONCE(^{
        client = [[TTMBTAClient alloc] init];
    });
    
    [client asyncMBTARequest:endpoint data:data completion:complete];
}

@end
