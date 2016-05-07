//
//  SCRouter.m
//  SocialConnector
//
//  Created by Semyon Novikov on 04/05/16.
//  Copyright © 2016 Whatever. All rights reserved.
//

#import "SCRouter.h"

#import "SCLoginViewModel.h"
#import "SCLoginViewController.h"

#import "SCListsViewModel.h"
#import "SCListsViewController.h"

#import "SCShareViewModel.h"
#import "SCShareViewController.h"

#import "SCSocialWrapper.h"

@implementation SCRouter {
    UINavigationController *_navigation;
    SCSocialWrapper *_wrapper;
    UITabBarController *_tabBar;
}

- (instancetype)initWithNavigation:(UINavigationController *)navigation {
    if (self = [super init]) {
        _navigation = navigation;
        _tabBar = [UITabBarController new];
        SCSocialWrapperConfig *wrapperCfg =
        [[SCSocialWrapperConfig alloc] initWithFacebookAppId:@"273643682973780"
                                                     vkAppId:@"5152823"
                                                twitterAppId:@"JfzELiWaW3kJcD8XZvWnFyfGb"
                                               twitterSecret:@"MPo6csdORo0t4V7Tg90KEUnr7k1XaktjSdvxAYPbRuYFwzjtiI"];
        _wrapper = [[SCSocialWrapper alloc] initWithConfig:wrapperCfg];
    }
    return self;
}

- (void)showAuth {
    SCLoginViewModel *vm = [[SCLoginViewModel alloc] initWithRouter:self];
    SCLoginViewController *loginCtrl = [[SCLoginViewController alloc] initWithViewModel:vm
                                                                          socialWrapper:_wrapper];
    [_navigation pushViewController:loginCtrl animated:NO];
}

- (void)proceedToListsWithWrapper:(id)wrapper {
    SCListsViewModel *vm = [[SCListsViewModel alloc] initWithRouter:self socialWrapper:wrapper];
    SCListsViewController *ctrl = [[SCListsViewController alloc] initWithViewModel:vm];

    SCShareViewModel *shareVm = [[SCShareViewModel alloc] initWithSocialWrapper:wrapper];
    SCShareViewController *shareCtrl = [[SCShareViewController alloc] initWithViewModel:shareVm];

    _tabBar.viewControllers = @[ctrl, shareCtrl];
    _navigation.navigationBarHidden = YES;
    [_navigation pushViewController:_tabBar animated:YES];
}

@end
