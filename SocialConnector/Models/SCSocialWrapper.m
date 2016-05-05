//
//  SocialConnector.m
//  SocialConnector
//
//  Created by Semyon Novikov on 05/05/16.
//  Copyright © 2016 Whatever. All rights reserved.
//

#import "SCSocialWrapper.h"

#import "VKSdk.h"
#import "VKUser.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <Fabric/Fabric.h>
#import <TwitterKit/TwitterKit.h>

@implementation SCSocialWrapper {
    UIViewController<SCSocialWrapperDelegate, VKSdkUIDelegate> *_delegate;
    VKSdk *_vk;
    FBSDKLoginManager *_fbLogin;
}

- (instancetype)initWithDelegate:(UIViewController<SCSocialWrapperDelegate, VKSdkUIDelegate> *)delegate {
    if (self = [super init]) {
        _delegate = delegate;
        _vk = [VKSdk initializeWithAppId:@"5152823"];
        [FBSDKSettings setAppID:@"273643682973780"];
        _fbLogin = [[FBSDKLoginManager alloc] init];
        [[Twitter sharedInstance] startWithConsumerKey:@"JfzELiWaW3kJcD8XZvWnFyfGb"
                                        consumerSecret:@"MPo6csdORo0t4V7Tg90KEUnr7k1XaktjSdvxAYPbRuYFwzjtiI"];
    }
    return self;
}

#pragma mark - VK Stuff

- (void)fetchVkFriends:(SCSocialWrapperVkFriendsCallback)callback {
    NSLog(@"Fetch vk friends");
    VKRequest *req = [[VKApi friends] get:@{@"fields": @[@"photo_100"], @"order": @"name", @"name_case": @"ins"}];
    req.completeBlock = ^(VKResponse *resp) {
        if (callback) {
            NSArray *users = [(VKUsersArray *)resp.parsedModel items];
            callback(users, nil);
        }
    };
    req.errorBlock = ^(NSError *err) {
        if (callback) {
            callback(nil, err);
        }
    };
    [req start];
}

- (void)vkLogin {
    [_vk registerDelegate:self];
    [_vk setUiDelegate:_delegate];
    [VKSdk authorize:@[VK_PER_WALL, VK_PER_FRIENDS, VK_PER_MESSAGES]];
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
    [_fbLogin
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
