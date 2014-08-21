//
//  NSObject+MethodDeep.m
//  DaiMethodTracing
//
//  Created by 啟倫 陳 on 2014/6/3.
//  Copyright (c) 2014年 ChilunChen. All rights reserved.
//

#import "NSObject+MethodDeep.h"

#import <objc/runtime.h>

@implementation NSObject (MethodDeep)

- (void)incDeep
{
	[[self methodDeep] addObject:[NSObject new]];
}

- (void)decDeep
{
	[[self methodDeep] removeLastObject];
}

- (NSUInteger)deep
{
	return [[self methodDeep] count];
}

- (NSMutableArray *)methodDeep
{
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
	    objc_setAssociatedObject(self, _cmd, [NSMutableArray array], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
	});
	return objc_getAssociatedObject(self, _cmd);
}

@end
