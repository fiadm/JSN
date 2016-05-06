//
//  SCListsViewModel.h
//  SocialConnector
//
//  Created by Semyon Novikov on 05/05/16.
//  Copyright © 2016 Whatever. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SCRouter.h"
#import "SCSocialWrapper.h"

typedef NS_ENUM(NSUInteger, SCListMode) {
    SCListModeVk,
    SCListModeFacebook
};

@interface SCListsViewModel : NSObject

@property (strong, nonatomic) NSArray *vkFriends;
@property (strong, nonatomic) NSArray *facebookFriends;
@property (strong, nonatomic) NSError *lastError;

@property (assign, nonatomic) SCListMode mode;
@property (assign, nonatomic) BOOL isReady;

- (instancetype)initWithRouter:(SCRouter *)router socialWrapper:(SCSocialWrapper *)wrapper;

- (void)fetchVkFriends;
- (void)vk_sendVkMessage:(VKUser *)user message:(NSString *)message;

- (void)fetchFacebookFriends;

@end
