//
//  SCLoginViewController.m
//  SocialConnector
//
//  Created by Semyon Novikov on 04/05/16.
//  Copyright © 2016 Whatever. All rights reserved.
//

#import "SCLoginViewController.h"
#import "ReactiveCocoa.h"
#import "Masonry.h"

@interface SCLoginViewController ()

@end

@implementation SCLoginViewController {
    SCLoginViewModel *_viewModel;
    UIButton *_vkLogin;
    UIButton *_fbLogin;
    UIButton *_twLogin;
}

- (instancetype)initWithViewModel:(SCLoginViewModel *)viewModel {
    if (self = [super init]) {
        _viewModel = viewModel;
        _viewModel.viewController = self;
        _vkLogin = [UIButton new];
        _fbLogin = [UIButton new];
        _twLogin = [UIButton new];
    }
    return self;
}

- (void)viewDidLoad {
    self.view.backgroundColor = [UIColor whiteColor];
    [super viewDidLoad];

    [self.view addSubview:_vkLogin];
    [self.view addSubview:_fbLogin];
    [self.view addSubview:_twLogin];

    [_vkLogin setTitle:@"Login with VK" forState:UIControlStateNormal];
    [_fbLogin setTitle:@"Login with Facebook" forState:UIControlStateNormal];
    [_twLogin setTitle:@"Login with Twitter" forState:UIControlStateNormal];

    [_vkLogin setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [_fbLogin setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [_twLogin setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];

    [[[_vkLogin rac_signalForControlEvents:UIControlEventTouchUpInside]
      takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id x) {
        [_viewModel vkLogin];
    }];

    [[[_fbLogin rac_signalForControlEvents:UIControlEventTouchUpInside]
      takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id x) {
        [_viewModel facebookLogin];
    }];

    [[[_twLogin rac_signalForControlEvents:UIControlEventTouchUpInside]
      takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id x) {
        [_viewModel twitterLogin];
    }];

    [[RACObserve(_viewModel, vkLoginVC) takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id x) {
        if (x != nil) {
            [self presentViewController:x animated:YES completion:nil];
        }
    }];

    [self layout];
}

- (void)layout {
    [_vkLogin mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_centerY).offset(-40);
        make.centerX.equalTo(self.view);
    }];

    [_fbLogin mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_vkLogin.mas_bottom).offset(12);
        make.centerX.equalTo(self.view);
    }];

    [_twLogin mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_fbLogin.mas_bottom).offset(12);
        make.centerX.equalTo(self.view);
    }];
}

@end
