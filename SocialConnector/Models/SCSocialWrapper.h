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
#import "SCSocialWrapperConfig.h"

typedef void(^SCSocialWrapperLoginCallback)(SCSocialAuthResult *result);
typedef void(^SCSocialWrapperCallback)(id response, NSError *error);
typedef void(^SCSocialWrapperFriendsCallback)(NSArray *users, NSError *error);

/**
 Обёрточный класс для работы с социальными сетями.
 
 Методы работы с разными соцсетями разделены префиксами:
 - `vk_` — vk.com
 - `fb_` — Facebook
 - `tw_` — Twitter
 */
@interface SCSocialWrapper : NSObject <VKSdkDelegate>

- (instancetype)initWithConfig:(SCSocialWrapperConfig *)config;

/**
 Запуск процесса входа через социальную сеть vk.com
 
 @param callback блок, который будет выполнен после авторизации, содержит результат входа
 @param delegate совместимый с протоколом VKSdkUIDelegate объект, который VKSdk будет использовать
 для своих тёмных дел.
 */
- (void)vk_login:(SCSocialWrapperLoginCallback)callback
        delegate:(UIViewController<VKSdkUIDelegate> *)delegate;

/**
 Получение друзей пользователя из vk.com
 В случае, если пользователь не авторизован, сначала будет выполнен метод `vk_login:`
 
 @param callback блок, который будет выполнен после получения друзей.
 */
- (void)vk_fetchFriends:(SCSocialWrapperFriendsCallback)callback;

/**
 Отправка пользователю сообщения
 
 @param message Сообщение, которое будет отправлено
 @param user объект VKUser, которому будет отправлено сообщение
 @param callback блок кода, который будет выполнен после отправки сообщения
 */
- (void)vk_sendMessage:(NSString *)message
                  user:(VKUser *)user
              callback:(SCSocialWrapperCallback)callback;

/**
 Написать на стене
 
 @param message Что писать
 @param link URL, который будет приложен к сообщению
 @param controller Контроллер, на котором будет отображаться интерфейс шейринга
 */
- (void)vk_share:(NSString *)message link:(NSURL *)link controller:(UIViewController *)ctrl;

/**
 Запуск процесса входа через социальную сеть Facebook

 @param callback блок, который будет выполнен после авторизации, содержит результат входа
 @param delegate совместимый с протоколом VKSdkUIDelegate объект, который Facebook будет использовать
 для своих тёмных дел.
 */
- (void)fb_login:(SCSocialWrapperLoginCallback)callback delegate:(UIViewController *)delegate;

/**
 Получение друзей пользователя из Facebook
 В случае, если пользователь не авторизован, сначала будет выполнен метод `fb_login:`

 @param callback блок, который будет выполнен после получения друзей.
 */
- (void)fb_fetchFriends:(SCSocialWrapperFriendsCallback)callback;

/**
 Отправка пользователю Facebook сообщения.
 В случае, если пользователь не авторизован, сначала будет выполнен метод `fb_login:`.
 
 Если на устройстве не установлен Facebook Messenger, callback будет вызван с ошибкой.

 @param message Сообщение, которое будет отправлено
 @param callback блок кода, который будет выполнен после отправки сообщения
 */
- (void)fb_sendMessage:(NSString *)message
              callback:(SCSocialWrapperCallback)callback;

/**
 Написать на стене

 @param message Что писать
 @param link URL, который будет приложен к сообщению
 @param ctrl Контроллер, на котором будет отображаться интерфейс шейринга
 */
- (void)fb_share:(NSString *)message link:(NSURL *)link controller:(UIViewController *)ctrl;

/**
 Запуск процесса входа через социальную сеть Twitter

 @param callback блок, который будет выполнен после авторизации, содержит результат входа
 */
- (void)tw_login:(SCSocialWrapperLoginCallback)callback;

/**
 Написать твит

 @param message Что писать
 @param link URL, который будет приложен к сообщению
 @param ctrl Контроллер, на котором будет отображаться интерфейс шейринга
 */
- (void)tw_share:(NSString *)message link:(NSURL *)link controller:(UIViewController *)ctrl;

@end
