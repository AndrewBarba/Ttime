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

+ (NSURLSessionDataTask *)asyncMBTARequest:(NSString *)endpoint
                                      data:(NSDictionary *)data
                                completion:(TTRequestBlock)complete
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    NSString *path = [NSString stringWithFormat:@"%@%@", TT_MBTA_BASE_URL, endpoint];
    
    NSMutableDictionary *params = [data mutableCopy];
    params[@"api_key"] = TT_MBTA_API_KEY;
    
    return [manager GET:path parameters:params success:^(NSURLSessionDataTask *task, NSDictionary *response){
        if (complete) {
            complete(response, nil);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error){
        if (complete) {
            complete(nil, error);
        }
    }];
}

@end
