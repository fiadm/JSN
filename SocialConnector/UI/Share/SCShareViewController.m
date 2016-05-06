//
//  SCShareViewController.m
//  SocialConnector
//
//  Created by Semyon Novikov on 06/05/16.
//  Copyright © 2016 Whatever. All rights reserved.
//

#import "SCShareViewController.h"
#import "Masonry.h"
#import "ReactiveCocoa.h"

@implementation SCShareViewController {
    SCShareViewModel *_viewModel;
    UIButton *_vkShare;
    UIButton *_fbShare;
    UIButton *_twShare;
}

- (instancetype)initWithViewModel:(SCShareViewModel *)viewModel {
    if (self = [super init]) {
        _viewModel = viewModel;
        _vkShare = [UIButton new];
        _fbShare = [UIButton new];
        _twShare = [UIButton new];

        self.tabBarItem = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemFeatured
                                                                     tag:1];
        self.tabBarItem.title = @"Share";
    }
    return self;
}

- (void)viewDidLoad {
    self.view.backgroundColor = [UIColor whiteColor];
    [super viewDidLoad];

    [self.view addSubview:_vkShare];
    [self.view addSubview:_fbShare];
    [self.view addSubview:_twShare];

    [_vkShare setTitle:@"Share with VK" forState:UIControlStateNormal];
    [_fbShare setTitle:@"Share with Facebook" forState:UIControlStateNormal];
    [_twShare setTitle:@"Share with Twitter" forState:UIControlStateNormal];

    [_vkShare setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [_fbShare setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [_twShare setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];

    [[[_vkShare rac_signalForControlEvents:UIControlEventTouchUpInside]
      takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id x) {
        [_viewModel vk_share:self];
    }];

    [[[_fbShare rac_signalForControlEvents:UIControlEventTouchUpInside]
      takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id x) {
       [_viewModel fb_share:self];
    }];

    [[[_twShare rac_signalForControlEvents:UIControlEventTouchUpInside]
      takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id x) {
        //[_viewModel twitterShare:_social];
    }];

    [self layout];
}

- (void)layout {
    [_vkShare mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_centerY).offset(-40);
        make.centerX.equalTo(self.view);
    }];

    [_fbShare mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_vkShare.mas_bottom).offset(12);
        make.centerX.equalTo(self.view);
    }];

    [_twShare mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_fbShare.mas_bottom).offset(12);
        make.centerX.equalTo(self.view);
    }];
}

@end
