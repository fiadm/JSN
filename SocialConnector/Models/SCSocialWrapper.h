//
//  SocialConnector.h
//  SocialConnector
//
//  Created by Semyon Novikov on 05/05/16.
//  Copyright © 2016 Whatever. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "SCSocialAuthResult.h"
#import "VKSdk.h"

@protocol SCSocialWrapperDelegate

- (void)socialWrapperLoginCompletedWithSocialResult:(SCSocialAuthResult *)result;

@end

@interface SCSocialWrapper : NSObject <VKSdkDelegate>

- (instancetype)initWithDelegate:(UIViewController<SCSocialWrapperDelegate, VKSdkUIDelegate> *)delegate;

- (void)vkLogin;
- (void)facebookLogin;
- (void)twitterLogin;

@end