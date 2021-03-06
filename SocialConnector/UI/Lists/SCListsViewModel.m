//
//  SCListsViewModel.m
//  SocialConnector
//
//  Created by Semyon Novikov on 05/05/16.
//  Copyright © 2016 Whatever. All rights reserved.
//

#import "SCListsViewModel.h"
#import "ReactiveCocoa.h"

@implementation SCListsViewModel {
    __weak SCRouter *_router;
}

- (instancetype)initWithRouter:(SCRouter *)router socialWrapper:(SCSocialWrapper *)wrapper {
    if (self = [super init]) {
        _router = router;
        _wrapper = wrapper;
        self.isReady = NO;
    }
    return self;
}

- (void)setMode:(SCListMode)mode {
    _mode = mode;
    switch (mode) {
        case SCListModeVk:
            [self fetchVkFriends];
        case SCListModeFacebook:
            [self fetchFacebookFriends];
            break;
    }
}

- (void)fetchVkFriends {
    self.isReady = NO;
    @weakify(self);
    [_wrapper vk_fetchFriends:^(NSArray *users, NSError *error) {
        @strongify(self);
        if (error == nil) {
            self.vkFriends = users;
        } else {
            self.lastError = error;
        }
        self.isReady = YES;
    }];
}


- (void)vk_sendVkMessage:(VKUser *)user message:(NSString *)message {
    [_wrapper vk_sendMessage:message user:user callback:^(id response, NSError *error) {
        NSLog(@"Finished send: %@, %@", response, error);
    }];
}

- (void)fetchFacebookFriends {
    self.isReady = NO;
    @weakify(self);
    [_wrapper fb_fetchFriends:^(NSArray *users, NSError *error) {
        @strongify(self);
        if (users) {
            self.facebookFriends = users;
        } else {
            self.lastError = error;
        }
        self.isReady = YES;
    }];
}


- (void)fb_sendVkMessageTo:(NSDictionary *)user
                   message:(NSString *)message
                    showIn:(UIViewController *)ctrl {
    [_wrapper fb_sendMessage:message callback:^(id response, NSError *error) {
        if (error != nil) {
            self.lastError = error;
        }
    }];
}

@end
