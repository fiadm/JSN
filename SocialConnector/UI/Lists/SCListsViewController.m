//
//  SCListsViewController.m
//  SocialConnector
//
//  Created by Semyon Novikov on 05/05/16.
//  Copyright © 2016 Whatever. All rights reserved.
//

#import "SCListsViewController.h"
#import "Masonry.h"

@implementation SCListsViewController {
    SCListsViewModel *_viewModel;
}

- (instancetype)initWithViewModel:(SCListsViewModel *)viewModel {
    if (self = [super init]) {
        _viewModel = viewModel;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    UILabel *underDevelopment = [UILabel new];
    underDevelopment.text = @"Nothing to see here. Please disperse";
    underDevelopment.font = [UIFont boldSystemFontOfSize:24];
    underDevelopment.textAlignment = NSTextAlignmentCenter;
    underDevelopment.numberOfLines = 0;

    [self.view addSubview:underDevelopment];
    [underDevelopment mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.leading.equalTo(self.view);
        make.trailing.equalTo(self.view);
    }];
}

@end
