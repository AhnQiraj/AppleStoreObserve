//
//  StoreModel.m
//  Iphone
//
//  Created by 刘洋 on 16/9/18.
//  Copyright © 2016年 ddicar. All rights reserved.
//

#import "StoreModel.h"

@implementation StoreModel
- (instancetype)init
{
    if (self = [super init]) {
        _storeName = @"";
        _isHave = @"NONE";
        _count = 0;
    }
    return self;
}
@end
