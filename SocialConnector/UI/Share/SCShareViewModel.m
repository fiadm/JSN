//
//  SCShareViewModel.m
//  SocialConnector
//
//  Created by Semyon Novikov on 06/05/16.
//  Copyright © 2016 Whatever. All rights reserved.
//

#import "SCShareViewModel.h"

@implementation SCShareViewModel {
    SCSocialWrapper *_wrapper;
}

- (instancetype)initWithSocialWrapper:(SCSocialWrapper *)wrapper {
    if (self = [super init]) {
        _wrapper = wrapper;
    }
    return self;
}

- (void)vk_share:(UIViewController *)ctrl {
    [_wrapper vk_share:@"Look at this link, this links is amazing!"
                  link:[NSURL URLWithString:@"http://jelin.ru"]
            controller:ctrl];
}

- (void)fb_share:(UIViewController *)ctrl {
    [_wrapper fb_share:@"Look at this link, this links is amazing!"
                  link:[NSURL URLWithString:@"http://jelin.ru"]
            controller:ctrl];
}

@end
