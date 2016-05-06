//
//  SCShareViewModel.h
//  SocialConnector
//
//  Created by Semyon Novikov on 06/05/16.
//  Copyright © 2016 Whatever. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SCSocialWrapper.h"

@interface SCShareViewModel : NSObject

- (instancetype)initWithSocialWrapper:(SCSocialWrapper *)wrapper;
- (void)vk_share:(UIViewController *)ctrl;
- (void)fb_share:(UIViewController *)ctrl;

@end
