//
//  SocialConnector.h
//  SocialConnector
//
//  Created by Semyon Novikov on 05/05/16.
//  Copyright © 2016 Whatever. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "SCSocialAuthResult.h"
#import "VKSdk.h"

@protocol SCSocialWrapperDelegate

- (void)socialWrapperLoginCompletedWithSocialResult:(SCSocialAuthResult *)result;

@end

typedef void(^SCSocialWrapperCallback)(id response, NSError *error);
typedef void(^SCSocialWrapperFriendsCallback)(NSArray *users, NSError *error);

@interface SCSocialWrapper : NSObject <VKSdkDelegate>

- (instancetype)initWithDelegate:(UIViewController<SCSocialWrapperDelegate, VKSdkUIDelegate> *)delegate;

- (void)vkLogin;
- (void)fetchVkFriends:(SCSocialWrapperFriendsCallback)callback;
- (void)vk_sendMessage:(NSString *)message user:(VKUser *)user callback:(SCSocialWrapperCallback)callback;

- (void)facebookLogin;
- (void)fetchFacebookFriends:(SCSocialWrapperFriendsCallback)callback;
- (void)fb_sendMessage:(NSString *)message
                  user:(NSString *)userId
                showIn:(UIViewController *)controller
              callback:(SCSocialWrapperCallback)callback;

- (void)twitterLogin;

@end
