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
#import "FBSDKAccessToken.h"

#define VK_SCOPE @[VK_PER_WALL, VK_PER_FRIENDS, VK_PER_MESSAGES]

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

- (void)fetchVkFriends:(SCSocialWrapperFriendsCallback)callback {
    [VKSdk wakeUpSession:VK_SCOPE completeBlock:^(VKAuthorizationState state, NSError *error) {
        if (state == VKAuthorizationAuthorized) {
            [self _fetchVkFriends:callback];
        } else if (error) {
            [self vkLogin];
            callback(nil, nil);
        }
    }];
}

- (void)_fetchVkFriends:(SCSocialWrapperFriendsCallback)callback {
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
    [VKSdk authorize:VK_SCOPE];
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
    if ([FBSDKAccessToken currentAccessToken] == nil) {
        [self facebookLogin];
        return;
    }
    [_fbLogin
     logInWithReadPermissions:@[@"public_profile", @"user_friends"]
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

- (void)fetchFacebookFriends:(SCSocialWrapperFriendsCallback)callback {
    FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc]
                                  initWithGraphPath:@"me/invitable_friends"
                                  parameters:@{@"fields": @"id, name, picture", @"limit": @(99999)}
                                  HTTPMethod:@"GET"];
    [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
        if (error) {
            callback(nil, error);
        } else {
            NSArray *users = result[@"data"];
            if (users) {
                callback(users, nil);
            }
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
