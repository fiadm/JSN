//
//  SCRouter.h
//  SocialConnector
//
//  Created by Semyon Novikov on 04/05/16.
//  Copyright © 2016 Whatever. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SCRouter : NSObject

- (instancetype)initWithNavigation:(UINavigationController *)navigation;

- (void)showAuth;
- (void)proceedToLists;

@end
