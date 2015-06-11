//
//  SFExecuteOnDeallocInternalObject.m
//  DaiMethodTracing
//
//  Created by DaidoujiChen on 2015/6/11.
//  Copyright (c) 2015年 DaidoujiChen. All rights reserved.
//

#import "SFExecuteOnDeallocInternalObject.h"

@implementation SFExecuteOnDeallocInternalObject

- (id)initWithBlock:(void (^)(void))aBlock
{
    self = [super init];
    if (self) {
        self.block = aBlock;
    }
    return self;
}

- (void)dealloc
{
    if (self.block) {
        self.block();
    }
}

@end
