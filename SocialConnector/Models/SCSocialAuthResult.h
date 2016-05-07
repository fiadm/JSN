//
//  SCSocialAuthResult.h
//  SocialConnector
//
//  Created by Semyon Novikov on 05/05/16.
//  Copyright © 2016 Whatever. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, SCSocialAuthResultEnum) {
    SCSocialAuthResultSuccess,
    SCSocialAuthResultFailure
};

typedef NS_ENUM(NSUInteger, SCSocialAuthType) {
    SCSocialAuthTypeVK,
    SCSocialAuthTypeFacebook,
    SCSocialAuthTypeTwitter,
};

@interface SCSocialAuthResult : NSObject

- (instancetype)initWithType:(SCSocialAuthType)type result:(SCSocialAuthResultEnum)result;
- (instancetype)initWithType:(SCSocialAuthType)type error:(NSError *)error;

@property (assign, nonatomic) SCSocialAuthResultEnum result;
@property (assign, nonatomic) SCSocialAuthType type;
@property (strong, nonatomic) NSError *error;

@end
