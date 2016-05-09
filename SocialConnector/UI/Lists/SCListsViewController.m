//
//  SCListsViewController.m
//  SocialConnector
//
//  Created by Semyon Novikov on 05/05/16.
//  Copyright © 2016 Whatever. All rights reserved.
//

#import "SCListsViewController.h"
#import "Masonry.h"
#import "ReactiveCocoa.h"
#import "Haneke.h"
#import "VKSdk.h"

@interface SCListsViewController () <UITableViewDelegate, UITableViewDataSource, VKSdkUIDelegate>

@end

@implementation SCListsViewController {
    SCListsViewModel *_viewModel;
    UISegmentedControl *_socialNetworkSelector;
    UITableView *_tableView;
    UIView *_loadingView;
}

- (instancetype)initWithViewModel:(SCListsViewModel *)viewModel {
    if (self = [super init]) {
        _viewModel = viewModel;
        _socialNetworkSelector = [UISegmentedControl new];
        [_socialNetworkSelector insertSegmentWithTitle:@"Vk.com" atIndex:0 animated:NO];
        [_socialNetworkSelector insertSegmentWithTitle:@"Facebook" atIndex:1 animated:NO];
        _tableView = [UITableView new];
        _tableView.delegate = self;
        _tableView.dataSource = self;

        _loadingView = [UIView new];
        UIActivityIndicatorView *activity = [[UIActivityIndicatorView alloc]
                                             initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [activity startAnimating];
        [_loadingView addSubview:activity];
        _loadingView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        [activity mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(_loadingView);
        }];
        _loadingView.hidden = YES;

        self.tabBarItem = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemContacts
                                                                     tag:0];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBarHidden = YES;

    [self.view addSubview:_socialNetworkSelector];
    [_socialNetworkSelector mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(22);
        make.centerX.equalTo(self.view);
    }];

    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_socialNetworkSelector.mas_bottom).offset(12);
        make.leading.equalTo(self.view);
        make.trailing.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];

    [self.view addSubview:_loadingView];
    [_loadingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [[RACObserve(_viewModel, isReady) takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id x) {
        BOOL ready = [x boolValue];
        _loadingView.hidden = ready;
        if (ready) {
            [_tableView reloadData];
        }
    }];
    RAC(_viewModel, mode) = RACObserve(_socialNetworkSelector, selectedSegmentIndex);
    @weakify(self);
    [[RACObserve(_viewModel, lastError) takeUntil:self.rac_willDeallocSignal]
     subscribeNext:^(NSError *x) {
         @strongify(self);
         if (x != nil) {
             BOOL facebookFailure = [x.domain hasPrefix:@"com.facebook"];
             BOOL vkFailure = [x.domain hasPrefix:@"VKSdk"];
             NSString *errorMsg = x.userInfo[@"message"];

             if (errorMsg == nil) {
                 errorMsg = facebookFailure ? @"Facebook request failed. Try to login first" : @"Vk.com request failed. Try to login first";
             }
             UIAlertController *error = [UIAlertController alertControllerWithTitle:@"Error"
                                                                            message:errorMsg
                                                                     preferredStyle:UIAlertControllerStyleAlert];
             [error addAction:[UIAlertAction actionWithTitle:@"Cancel"
                                                       style:UIAlertActionStyleCancel
                                                     handler:nil]];
             if (facebookFailure || vkFailure) {
                 [error addAction:[UIAlertAction actionWithTitle:@"Login"
                                                           style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * _Nonnull action) {
                                                             if (facebookFailure) {
                                                                 [_viewModel.wrapper fb_login:^(SCSocialAuthResult *result) {
                                                                     [_socialNetworkSelector setSelectedSegmentIndex:0];
                                                                 } delegate:self];
                                                             } else if (vkFailure) {
                                                                 [_viewModel.wrapper vk_login:^(SCSocialAuthResult *result) {
                                                                     [_socialNetworkSelector setSelectedSegmentIndex:1];
                                                                 } delegate:self];
                                                             }
                                                         }]];
             }
             [self presentViewController:error animated:YES completion:nil];
         }
     }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [_socialNetworkSelector setSelectedSegmentIndex:0];
}


#pragma mark - Table View Stuff

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_viewModel.mode == SCListModeVk) {
        return _viewModel.vkFriends.count;
    } else {
        return _viewModel.facebookFriends.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }

    switch (_viewModel.mode) {
        case SCListModeVk: {
            VKUser *user = _viewModel.vkFriends[indexPath.row];
            cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", user.first_name, user.last_name];
            cell.imageView.image = [UIImage imageNamed:@"userpic-placeholder"];
            [cell.imageView sizeToFit];
            [cell.imageView hnk_setImageFromURL:[NSURL URLWithString:user.photo_100]];
            break;
        }
        case SCListModeFacebook: {
            NSDictionary *user = _viewModel.facebookFriends[indexPath.row];
            cell.textLabel.text = user[@"name"];
            cell.imageView.image = [UIImage imageNamed:@"userpic-placeholder"];
            [cell.imageView sizeToFit];
            [cell.imageView hnk_setImageFromURL:[NSURL URLWithString:user[@"picture"][@"data"][@"url"]]];
            break;
        }
        default:
            break;
    }

    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (_viewModel.mode == SCListModeVk) {
        VKUser *user = _viewModel.vkFriends[indexPath.row];
        UIAlertController *sendMessage = [UIAlertController alertControllerWithTitle:@"Send Message"
                                                                             message:@""
                                                                      preferredStyle:UIAlertControllerStyleAlert];
        [sendMessage addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.placeholder = @"Enter message here";
        }];

        UIAlertAction *send = [UIAlertAction actionWithTitle:@"Send"
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * _Nonnull action) {
                                                         NSString *msg = sendMessage.textFields.firstObject.text;
                                                         if (msg) {
                                                             [_viewModel vk_sendVkMessage:user message:msg];
                                                         }
                                                     }];

        [sendMessage addAction:send];
        [sendMessage addAction:[UIAlertAction actionWithTitle:@"Cancel"
                                                        style:UIAlertActionStyleCancel
                                                      handler:nil]];
         [self presentViewController:sendMessage animated:YES completion:nil];
    } else {
        NSDictionary *user = _viewModel.facebookFriends[indexPath.row];
        [_viewModel fb_sendVkMessageTo:user message:@"test" showIn:self];
    }
}

#pragma mark - VK Stuff

- (void)vkSdkShouldPresentViewController:(UIViewController *)controller {
    [self presentViewController:controller animated:YES completion:nil];
}

- (void)vkSdkNeedCaptchaEnter:(VKError *)captchaError {

}

@end
