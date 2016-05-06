//
//  SCLoginViewModel.m
//  SocialConnector
//
//  Created by Semyon Novikov on 04/05/16.
//  Copyright © 2016 Whatever. All rights reserved.
//

#import "SCLoginViewModel.h"
#import <VKSdk.h>


@interface SCLoginViewModel () 
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


- (void)vkLogin:(SCSocialWrapper *)wrapper {
    [wrapper vk_login];
}


- (void)facebookLogin:(SCSocialWrapper *)wrapper {
    [wrapper fb_login];
}


- (void)twitterLogin:(SCSocialWrapper *)wrapper {
    [wrapper tw_login];
}


- (void)loginFinished:(SCSocialAuthResult *)result wrapper:(SCSocialWrapper *)wrapper {
    if (result.result == SCSocialAuthResultSuccess) {
        [_router proceedToListsWithWrapper:wrapper];
    }
}

@end
