//
//  SCLoginViewModel.m
//  SocialConnector
//
//  Created by Semyon Novikov on 04/05/16.
//  Copyright © 2016 Whatever. All rights reserved.
//

#import "SCLoginViewModel.h"
#import <VKSdk.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <Fabric/Fabric.h>
#import <TwitterKit/TwitterKit.h>


@interface SCLoginViewModel () <VKSdkDelegate, VKSdkUIDelegate>
@end

@implementation SCLoginViewModel {
    __weak SCRouter *_router;    
}

- (instancetype)initWithRouter:(id)router {
    if (self = [super init]) {
        _router = router;
    }
    return self;
}

#pragma mark - VK Stuff

- (void)vkLogin {
    VKSdk *vk = [VKSdk initializeWithAppId:@"5152823"];
    [vk registerDelegate:self];
    [vk setUiDelegate:self];
    [VKSdk authorize:@[VK_PER_WALL]];
}


- (void)vkSdkAccessAuthorizationFinishedWithResult:(VKAuthorizationResult *)result {
    NSLog(@"Result: %@", result);
}

- (void)vkSdkAuthorizationStateUpdatedWithResult:(VKAuthorizationResult *)result {
    NSLog(@"Result: %@", result);
    if (result.state == VKAuthorizationAuthorized) {
        [_router proceedToLists];
    }
}

- (void)vkSdkShouldPresentViewController:(UIViewController *)controller {
    self.vkLoginVC = controller;
}


#pragma mark - Facebook Stuff

- (void)facebookLogin {
    [FBSDKSettings setAppID:@"273643682973780"];
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    [login
     logInWithReadPermissions: @[@"public_profile"]
     fromViewController:self.viewController
     handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
         if (error) {
             NSLog(@"Process error");
         } else if (result.isCancelled) {
             NSLog(@"Cancelled");
         } else {
             NSLog(@"Logged in");
         }
     }];
}


#pragma mark - Twitter Stuff

- (void)twitterLogin {
    [[Twitter sharedInstance] startWithConsumerKey:@"JfzELiWaW3kJcD8XZvWnFyfGb"
                                    consumerSecret:@"MPo6csdORo0t4V7Tg90KEUnr7k1XaktjSdvxAYPbRuYFwzjtiI"];
    [[Twitter sharedInstance] logInWithCompletion:^(TWTRSession *session, NSError *error) {
        if (session) {
            NSLog(@"signed in as %@", [session userName]);
        } else {
            NSLog(@"error: %@", [error localizedDescription]);
        }
    }];
}

@end
