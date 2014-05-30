//
//  DaiMethodTracing+AccessObject.m
//  DaiMethodTracing
//
//  Created by 啟倫 陳 on 2014/5/29.
//  Copyright (c) 2014年 ChilunChen. All rights reserved.
//

#import "DaiMethodTracing+AccessObject.h"

#import <objc/runtime.h>

@implementation DaiMethodTracing (AccessObject)

static const char METHODDEEPPOINTER;

NSMutableArray* methodDeep() {
    
    static id self;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        self = [DaiMethodTracing class];
        objc_setAssociatedObject(self, &METHODDEEPPOINTER, [NSMutableArray array], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    });
    return objc_getAssociatedObject(self, &METHODDEEPPOINTER);
    
}

@end
