//
//  SFExecuteOnDeallocInternalObject.h
//  DaiMethodTracing
//
//  Created by DaidoujiChen on 2015/6/11.
//  Copyright (c) 2015年 DaidoujiChen. All rights reserved.
//

//https://github.com/krzysztofzablocki/NSObject-SFExecuteOnDealloc
//用來檢測物件是否 dealloc

#import <Foundation/Foundation.h>

@interface SFExecuteOnDeallocInternalObject : NSObject

@property (nonatomic, copy) void (^block)();

- (id)initWithBlock:(void (^)(void))aBlock;

@end
