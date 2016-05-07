//
//  SCLoginViewController.h
//  SocialConnector
//
//  Created by Semyon Novikov on 04/05/16.
//  Copyright © 2016 Whatever. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCLoginViewModel.h"

@interface SCLoginViewController : UIViewController

- (instancetype)initWithViewModel:(SCLoginViewModel *)viewModel
                    socialWrapper:(SCSocialWrapper *)wrapper;

@end
