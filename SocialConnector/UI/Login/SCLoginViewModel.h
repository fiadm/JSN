//
//  SCLoginViewModel.h
//  SocialConnector
//
//  Created by Semyon Novikov on 04/05/16.
//  Copyright © 2016 Whatever. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "SCSocialWrapper.h"
#import "SCRouter.h"

@interface SCLoginViewModel : NSObject

@property (strong, nonatomic) UIViewController *vkLoginVC;
@property (weak, nonatomic) UIViewController *viewController;

- (instancetype)initWithRouter:(id)router;

- (void)loginFinished:(SCSocialAuthResult *)result wrapper:(SCSocialWrapper *)wrapper;

@end
