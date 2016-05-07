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
#import <FBSDKShareKit/FBSDKShareKit.h>
#import <Fabric/Fabric.h>
#import <TwitterKit/TwitterKit.h>
#import "FBSDKAccessToken.h"
#import "VKUser.h"

#define VK_SCOPE @[VK_PER_WALL, VK_PER_FRIENDS, VK_PER_MESSAGES]
#define FB_SCOPE @[@"public_profile", @"user_friends"]

typedef void(^AuthCallback)(void);

@interface SCSocialWrapper () <FBSDKSharingDelegate>
@end

@implementation SCSocialWrapper {
    VKSdk *_vk;
    FBSDKLoginManager *_fbLogin;
    SCSocialWrapperCallback _facebookSendMessageCallback;
    SCSocialWrapperLoginCallback _vkLoginCallback;
}

- (instancetype)initWithConfig:(SCSocialWrapperConfig *)config {
    if (self = [super init]) {
        _vk = [VKSdk initializeWithAppId:config.vkAppId];
        [FBSDKSettings setAppID:config.facebookAppId];
        _fbLogin = [[FBSDKLoginManager alloc] init];
        [[Twitter sharedInstance] startWithConsumerKey:config.twitterAppId
                                        consumerSecret:config.twitterConsumerSecret];
    }
    return self;
}

#pragma mark - VK Stuff

- (void)vk_fetchFriends:(SCSocialWrapperFriendsCallback)callback {
    [VKSdk wakeUpSession:VK_SCOPE completeBlock:^(VKAuthorizationState state, NSError *error) {
        if (state == VKAuthorizationAuthorized) {
            [self _fetchVkFriends:callback];
        } else if (error) {
            callback(nil, error);
        } else {
            [self vk_login:^(SCSocialAuthResult *result) {
                if (error == nil) {
                    [self vk_fetchFriends:callback];
                }
            } delegate:nil];
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

- (void)vk_sendMessage:(NSString *)message user:(VKUser *)user callback:(SCSocialWrapperCallback)callback {
    [VKSdk wakeUpSession:VK_SCOPE completeBlock:^(VKAuthorizationState state, NSError *error) {
        if (state == VKAuthorizationAuthorized) {
            [self _vk_sendMessage:message user:user callback:callback];
        } else if (error) {
            callback(nil, error);
        } else {
            [self vk_login:^(SCSocialAuthResult *result) {
                if (error == nil) {
                    [self vk_fetchFriends:callback];
                }
            } delegate:nil];
        }
    }];
}

- (void)_vk_sendMessage:(NSString *)message user:(VKUser *)user callback:(SCSocialWrapperCallback)callback {
    VKRequest *sendMessage = [VKApi requestWithMethod:@"messages.send"
                                        andParameters:@{@"user_id": user.id, @"message": message}];
    sendMessage.completeBlock = ^(VKResponse *resp) {
        if (callback) {
            callback(resp.parsedModel, nil);
        }
    };

    sendMessage.errorBlock = ^(NSError *err) {
        if (callback) {
            callback(nil, err);
        }
    };
    [sendMessage start];
}

- (void)vk_share:(NSString *)message link:(NSURL *)link controller:(UIViewController *)ctrl {
    [VKSdk wakeUpSession:VK_SCOPE completeBlock:^(VKAuthorizationState state, NSError *error) {
        if (state == VKAuthorizationAuthorized) {
            [self _vk_share:message link:link controller:ctrl];
        } else if (error) {
            return;
        } else {
            [self vk_login:^(SCSocialAuthResult *result) {
                if (error == nil) {
                    [self _vk_share:message link:link controller:ctrl];
                }
            } delegate:nil];
        }
    }];
}

- (void)_vk_share:(NSString *)message link:(NSURL *)link controller:(UIViewController *)ctrl {
    VKShareDialogController *shareDialog = [VKShareDialogController new];
    shareDialog.text = message;
    shareDialog.shareLink = [[VKShareLink alloc] initWithTitle:nil link:link];
    [shareDialog setCompletionHandler:^(UIViewController *controller, VKShareDialogControllerResult result) {
        [controller dismissViewControllerAnimated:YES completion:nil];
    }];
    [ctrl presentViewController:shareDialog animated:YES completion:nil];
}

- (void)vk_login:(SCSocialWrapperLoginCallback)callback
        delegate:(UIViewController<VKSdkUIDelegate> *)delegate {
    _vkLoginCallback = callback;
    [_vk registerDelegate:self];
    [_vk setUiDelegate:delegate];
    [VKSdk authorize:VK_SCOPE];
}


- (void)vkSdkAccessAuthorizationFinishedWithResult:(VKAuthorizationResult *)result {
}

- (void)vkSdkAuthorizationStateUpdatedWithResult:(VKAuthorizationResult *)result {
    if (result.state == VKAuthorizationAuthorized) {
        SCSocialAuthResult *res = [[SCSocialAuthResult alloc] initWithType:SCSocialAuthTypeVK
                                                                    result:SCSocialAuthResultSuccess];
        if (_vkLoginCallback) {
            _vkLoginCallback(res);
        }
    }
}


- (void)vkSdkUserAuthorizationFailed {
    SCSocialAuthResult *res = [[SCSocialAuthResult alloc] initWithType:SCSocialAuthTypeVK
                                                                result:SCSocialAuthResultFailure];
    if (_vkLoginCallback) {
        _vkLoginCallback(res);
    }
}

#pragma mark - Facebook Stuff

- (void)fb_login:(SCSocialWrapperLoginCallback)callback delegate:(UIViewController *)delegate {
    [_fbLogin
     logInWithReadPermissions:FB_SCOPE
     fromViewController:delegate
     handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
         if (error || result.isCancelled) {
             SCSocialAuthResult *res = [[SCSocialAuthResult alloc] initWithType:SCSocialAuthTypeFacebook
                                                                         result:SCSocialAuthResultFailure];
             callback(res);
         } else {
             SCSocialAuthResult *res = [[SCSocialAuthResult alloc] initWithType:SCSocialAuthTypeFacebook
                                                                         result:SCSocialAuthResultSuccess];
             callback(res);
         }
     }];
}

- (void)fb_fetchFriends:(SCSocialWrapperFriendsCallback)callback {
    if ([FBSDKAccessToken currentAccessToken]) {
        [self _fb_fetchFriends:callback];
    } else {
        [self fb_login:^(SCSocialAuthResult *result) {
            if (result.result == SCSocialAuthResultSuccess) {
                [self _fb_fetchFriends:callback];
            }
        } delegate:nil];
    }
}

- (void)_fb_fetchFriends:(SCSocialWrapperFriendsCallback)callback {
    FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc]
                                  initWithGraphPath:@"me/invitable_friends"
                                  parameters:@{@"fields": @"id, name, picture, username", @"limit": @(99999)}
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


- (void)fb_sendMessage:(NSString *)message
              callback:(SCSocialWrapperCallback)callback {
    if ([FBSDKAccessToken currentAccessToken]) {
        [self _fb_sendMessage:message
                     callback:callback];
    } else {
        [self fb_login:^(SCSocialAuthResult *result) {
            if (result.result == SCSocialAuthResultSuccess) {
                [self _fb_sendMessage:message
                             callback:callback];
            }
        } delegate:nil];
    }
}

- (void)_fb_sendMessage:(NSString *)message
              callback:(SCSocialWrapperCallback)callback {
    FBSDKMessageDialog *dialog = [[FBSDKMessageDialog alloc] init];
    if ([dialog canShow]) {
        _facebookSendMessageCallback = callback;
        FBSDKShareLinkContent *content = [FBSDKShareLinkContent new];
        content.contentURL = [NSURL URLWithString:@"http://jelin.ru"];
        dialog.shareContent = content;
        dialog.delegate = self;
        [dialog show];
    } else {
        callback(nil, [NSError errorWithDomain:@"facebook"
                                          code:-1
                                      userInfo:@{@"description": @"Facebook Messenger is not installed"}]);
    }
}

- (void)fb_share:(NSString *)message link:(NSURL *)link controller:(UIViewController *)ctrl {
    FBSDKShareDialog *dialog = [[FBSDKShareDialog alloc] init];
    dialog.fromViewController = ctrl;
    FBSDKShareLinkContent *content = [[FBSDKShareLinkContent alloc] init];
    content.contentDescription = message;
    content.contentURL = link;
    dialog.shareContent = content;
    dialog.mode = FBSDKShareDialogModeShareSheet;
    if (![dialog canShow]) {
        dialog.mode = FBSDKShareDialogModeWeb;
    }
    [dialog show];
}

- (void)sharer:(id<FBSDKSharing>)sharer didCompleteWithResults:(NSDictionary *)results {
    if (_facebookSendMessageCallback) {
        _facebookSendMessageCallback(results, nil);
    }
}

- (void)sharer:(id<FBSDKSharing>)sharer didFailWithError:(NSError *)error {
    if (_facebookSendMessageCallback) {
        _facebookSendMessageCallback(nil, error);
    }
}

- (void)sharerDidCancel:(id<FBSDKSharing>)sharer {
    if (_facebookSendMessageCallback) {
        _facebookSendMessageCallback(nil, nil);
    }
}

#pragma mark - Twitter Stuff

- (void)tw_login:(SCSocialWrapperLoginCallback)callback {
    [[Twitter sharedInstance] logInWithCompletion:^(TWTRSession *session, NSError *error) {
        if (session) {
            SCSocialAuthResult *res = [[SCSocialAuthResult alloc] initWithType:SCSocialAuthTypeTwitter
                                                                        result:SCSocialAuthResultSuccess];
            callback(res);
        } else {
            SCSocialAuthResult *res = [[SCSocialAuthResult alloc] initWithType:SCSocialAuthTypeTwitter
                                                                        result:SCSocialAuthResultFailure];
            callback(res);
        }
    }];
}

- (void)tw_share:(NSString *)message link:(NSURL *)link controller:(UIViewController *)ctrl {
    TWTRComposer *composer = [[TWTRComposer alloc] init];

    [composer setText:message];
    [composer setURL:link];

    [composer showFromViewController:ctrl completion:^(TWTRComposerResult result) {}];
}


@end
