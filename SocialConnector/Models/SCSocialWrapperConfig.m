//
//  SCSocialWrapperConfig.m
//  SocialConnector
//
//  Created by Semyon Novikov on 07/05/16.
//  Copyright © 2016 Whatever. All rights reserved.
//

#import "SCSocialWrapperConfig.h"

@implementation SCSocialWrapperConfig

- (instancetype)initWithFacebookAppId:(NSString *)fbAppId
                              vkAppId:(NSString *)vkAppId
                         twitterAppId:(NSString *)twitterAppId
                        twitterSecret:(NSString *)twitterConsumerSecret {
    if (self = [super init]) {
        _facebookAppId = fbAppId;
        _vkAppId = vkAppId;
        _twitterAppId = twitterAppId;
        _twitterConsumerSecret = twitterConsumerSecret;
    }
    return self;
}

@end
