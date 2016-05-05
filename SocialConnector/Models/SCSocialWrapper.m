//
//  SocialConnector.m
//  SocialConnector
//
//  Created by Semyon Novikov on 05/05/16.
//  Copyright © 2016 Whatever. All rights reserved.
//

#import "SCSocialWrapper.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <Fabric/Fabric.h>
#import <TwitterKit/TwitterKit.h>

@implementation SCSocialWrapper {
    UIViewController<SCSocialWrapperDelegate, VKSdkUIDelegate> *_delegate;
}

- (instancetype)initWithDelegate:(UIViewController<SCSocialWrapperDelegate, VKSdkUIDelegate> *)delegate {
    if (self = [super init]) {
        _delegate = delegate;
    }
    return self;
}

#pragma mark - VK Stuff

- (void)vkLogin {
    VKSdk *vk = [VKSdk initializeWithAppId:@"5152823"];
    [vk registerDelegate:self];
    [vk setUiDelegate:_delegate];
    [VKSdk authorize:@[VK_PER_WALL]];
}


- (void)vkSdkAccessAuthorizationFinishedWithResult:(VKAuthorizationResult *)result {
}

- (void)vkSdkAuthorizationStateUpdatedWithResult:(VKAuthorizationResult *)result {
    if (result.state == VKAuthorizationAuthorized) {
        [_delegate socialWrapperLoginCompletedWithSocialResult:
         [[SCSocialAuthResult alloc] initWithType:SCSocialAuthTypeVK result:SCSocialAuthResultSuccess]];
    }
}


- (void)vkSdkUserAuthorizationFailed {
    [_delegate socialWrapperLoginCompletedWithSocialResult:
     [[SCSocialAuthResult alloc] initWithType:SCSocialAuthTypeVK result:SCSocialAuthResultFailure]];
}

#pragma mark - Facebook Stuff

- (void)facebookLogin {
    [FBSDKSettings setAppID:@"273643682973780"];
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    [login
     logInWithReadPermissions: @[@"public_profile"]
     fromViewController:_delegate
     handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
         if (error) {
             [_delegate socialWrapperLoginCompletedWithSocialResult:
              [[SCSocialAuthResult alloc] initWithType:SCSocialAuthTypeFacebook result:SCSocialAuthResultFailure]];
         } else if (result.isCancelled) {
             [_delegate socialWrapperLoginCompletedWithSocialResult:
              [[SCSocialAuthResult alloc] initWithType:SCSocialAuthTypeFacebook result:SCSocialAuthResultFailure]];
         } else {
             [_delegate socialWrapperLoginCompletedWithSocialResult:
              [[SCSocialAuthResult alloc] initWithType:SCSocialAuthTypeFacebook result:SCSocialAuthResultSuccess]];
         }
     }];
}


#pragma mark - Twitter Stuff

- (void)twitterLogin {
    [[Twitter sharedInstance] startWithConsumerKey:@"JfzELiWaW3kJcD8XZvWnFyfGb"
                                    consumerSecret:@"MPo6csdORo0t4V7Tg90KEUnr7k1XaktjSdvxAYPbRuYFwzjtiI"];
    [[Twitter sharedInstance] logInWithCompletion:^(TWTRSession *session, NSError *error) {
        if (session) {
            [_delegate socialWrapperLoginCompletedWithSocialResult:
             [[SCSocialAuthResult alloc] initWithType:SCSocialAuthTypeTwitter
                                               result:SCSocialAuthResultSuccess]];
        } else {
            [_delegate socialWrapperLoginCompletedWithSocialResult:
             [[SCSocialAuthResult alloc] initWithType:SCSocialAuthTypeTwitter
                                               result:SCSocialAuthResultFailure]];
        }
    }];
}


@end