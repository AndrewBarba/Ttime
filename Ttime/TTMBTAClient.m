//
//  TTMBTAClient.m
//  Ttime
//
//  Created by Andrew Barba on 9/24/13.
//  Copyright (c) 2013 Andrew Barba. All rights reserved.
//

#import "TTMBTAClient.h"

@interface TTMBTAClient()

@end

@implementation TTMBTAClient

#pragma mark - Make Request

- (void)asyncMBTARequest:(NSString *)endpoint onComplettion:(TTObjectBlock)complete
{
    NSURL *url = [self mbtaURLForEndpoint:endpoint withURLData:nil];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url
                                                                cachePolicy:NSURLCacheStorageAllowedInMemoryOnly
                                                            timeoutInterval:30];
    
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    // copy the given block
    TTObjectBlock blockCopy = [complete copy];
    
    NSOperationQueue *requestQueue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:request queue:requestQueue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error){
        
        id returnObject = nil;
        
        if (!error) {
            returnObject = [NSJSONSerialization JSONObjectWithData:data
                                                           options:NSJSONReadingMutableContainers
                                                             error:nil];
        }
        
        TTDispatchMain(^{
            if (blockCopy) {
                blockCopy(returnObject);
            }
        });
    }];
}

- (NSURL *)mbtaURLForEndpoint:(NSString *)endpoint withURLData:(NSDictionary *)data
{
    NSString *path = [NSString stringWithFormat:@"%@%@", TT_MBTA_BASE_URL, endpoint];
    BOOL hasURLData = [path rangeOfString:@"?"].location != NSNotFound;
    if (hasURLData) {
        path = [path stringByAppendingFormat:@"&api_key=%@", TT_MBTA_API_KEY];
    } else {
        path = [path stringByAppendingFormat:@"?api_key=%@", TT_MBTA_API_KEY];
    }
    
    NSURL *url = [NSURL URLWithString:path];
    return url;
}

#pragma mark - Initialization

- (id)init
{
    [super doesNotRecognizeSelector:_cmd];
    return nil;
}

- (instancetype)_initPrivate
{
    self = [super init];
    if (self) {
        // custom setup
    }
    return self;
}

#pragma mark - Shared Client

+ (instancetype)sharedClient
{
    static TTMBTAClient *client = nil;
    TT_DISPATCH_ONCE(^{
        client = [[self alloc] _initPrivate];
    });
    return client;
}

@end
