//
//  SCSocialWrapperConfig.h
//  SocialConnector
//
//  Created by Semyon Novikov on 07/05/16.
//  Copyright © 2016 Whatever. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SCSocialWrapperConfig : NSObject

@property (strong, nonatomic) NSString *facebookAppId;
@property (strong, nonatomic) NSString *vkAppId;
@property (strong, nonatomic) NSString *twitterAppId;
@property (strong, nonatomic) NSString *twitterConsumerSecret;

- (instancetype)initWithFacebookAppId:(NSString *)fbAppId
                              vkAppId:(NSString *)vkAppId
                         twitterAppId:(NSString *)twitterAppId
                        twitterSecret:(NSString *)twitterConsumerSecret;

@end
