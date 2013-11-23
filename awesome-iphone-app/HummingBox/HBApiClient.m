//
//  HBApiClient.m
//  HummingBox
//
//  Created by Stefan Filip on 23/11/13.
//  Copyright (c) 2013 Hack Attack. All rights reserved.
//

#import "HBApiClient.h"
#import <AFNetworking/AFNetworking.h>

#define kHBApiBaseURL                               @"http://172.28.101.50:5000"

@implementation HBApiClient

+ (HBApiClient *)sharedClient {
    static HBApiClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[HBApiClient alloc] initWithBaseURL:[NSURL URLWithString:kHBApiBaseURL]];
        [_sharedClient registerHTTPOperationClass:[AFJSONRequestOperation class]];
    });
    
    return _sharedClient;
}

+ (void)loginWithGoogeUserId:(NSString *)googleUserID fullname:(NSString *)fullName andCallback:(boolWithErrorBlock)callback {
    NSDictionary *params = @{ @"googlePlusId" : googleUserID,
                              @"fullName" : fullName
                              };
    [[HBApiClient sharedClient] postPath:@"users.json"
                              parameters:params
                                 success:^(AFHTTPRequestOperation *operation, id JSON) {
                                     if (callback) {
                                         callback(YES, nil);
                                     }
                                 }
                                 failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                     if (callback) {
                                         callback(NO, nil);
                                     }
                                 }];
}

+ (void)getTimelineWithCallback:(arrayWithErrorBlock)callback {
    [[HBApiClient sharedClient] getPath:@"timeline.json"
                             parameters:nil
                                success:^(AFHTTPRequestOperation *operation, id JSON) {
                                    NSMutableArray *result = [[NSMutableArray alloc] init];
                                    for (NSDictionary *dict in JSON) {
                                        HBTimelineItem *timelineItem = [[HBTimelineItem alloc] initWithAttributes:dict];
                                        [result addObject:timelineItem];
                                    }
                                    if (callback) {
                                        callback(result, nil);
                                    }
                                }
                                failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                    if (callback) {
                                        callback(nil, error);
                                    }
                                }
     ];
}

@end
