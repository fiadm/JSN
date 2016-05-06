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

/**
 Обёрточный класс для удобной работы с социальными сетями.
 
 Методы работы с разными соцсетями разделены префиксами:
 - `vk_` — vk.com
 - `fb_` — Facebook
 - `tw_` — Twitter
 */
@interface SCSocialWrapper : NSObject <VKSdkDelegate>

/**
 К сожалению, для авторизации через VKSdk очень нужен UIViewController,
 который отвечает протоколу VKSdkUIDelegate. Именно с этого контроллера будет стартовать
 отображение формы логина в Web View. Поэтому пришлось засунуть кусок UIKit в этот класс 
 таким вот образом.
 */
- (instancetype)initWithDelegate:(UIViewController<SCSocialWrapperDelegate, VKSdkUIDelegate> *)delegate;

- (void)vk_login;
- (void)vk_fetchFriends:(SCSocialWrapperFriendsCallback)callback;
- (void)vk_sendMessage:(NSString *)message
                  user:(VKUser *)user
              callback:(SCSocialWrapperCallback)callback;
- (void)vk_share:(NSString *)message link:(NSURL *)link controller:(UIViewController *)ctrl;

- (void)fb_login;
- (void)fb_fetchFriends:(SCSocialWrapperFriendsCallback)callback;
- (void)fb_sendMessage:(NSString *)message
                  user:(NSString *)userId
                showIn:(UIViewController *)controller
              callback:(SCSocialWrapperCallback)callback;
- (void)fb_share:(NSString *)message link:(NSURL *)link controller:(UIViewController *)ctrl;

- (void)tw_login;

@end
