//
//  SCSocialAuthResult.m
//  SocialConnector
//
//  Created by Semyon Novikov on 05/05/16.
//  Copyright © 2016 Whatever. All rights reserved.
//

#import "SCSocialAuthResult.h"

@implementation SCSocialAuthResult

- (instancetype)initWithType:(SCSocialAuthType)type result:(SCSocialAuthResultEnum)result {
    if (self = [super init]) {
        _type = type;
        _result = result;
    }
    return self;
}

- (instancetype)initWithType:(SCSocialAuthType)type error:(NSError *)error {
    if (self = [self initWithType:type result:SCSocialAuthResultFailure]) {
        _error = error;
    }
    return self;
}

@end
