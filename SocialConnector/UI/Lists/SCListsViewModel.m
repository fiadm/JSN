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
    SCSocialWrapper *_wrapper;
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
    [_wrapper fetchVkFriends:^(NSArray *users, NSError *error) {
        @strongify(self);
        if (error == nil) {
            self.vkFriends = users;
        } else {
            self.lastError = error;
        }
        self.isReady = YES;
    }];
}


- (void)test_sendVkMessage:(VKUser *)user {
    [_wrapper vk_sendMessage:@"test" user:user callback:^(id response, NSError *error) {
        NSLog(@"Finished send: %@, %@", response, error);
    }];
}

- (void)fetchFacebookFriends {
    self.isReady = NO;
    @weakify(self);
    [_wrapper fetchFacebookFriends:^(NSArray *users, NSError *error) {
        @strongify(self);
        if (users) {
            self.facebookFriends = users;
        } else {
            self.lastError = error;
        }
        self.isReady = YES;
    }];
}


@end
