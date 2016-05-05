//
//  SCListsViewModel.m
//  SocialConnector
//
//  Created by Semyon Novikov on 05/05/16.
//  Copyright © 2016 Whatever. All rights reserved.
//

#import "SCListsViewModel.h"

@implementation SCListsViewModel {
    __weak SCRouter *_router;
}

- (instancetype)initWithRouter:(SCRouter *)router {
    if (self = [super init]) {
        _router = router;
    }
    return self;
}

@end
