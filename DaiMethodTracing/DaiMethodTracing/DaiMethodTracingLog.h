//
//  DaiMethodTracingLog.h
//  DaiMethodTracing
//
//  Created by DaidoujiChen on 2015/6/16.
//  Copyright (c) 2015年 ChilunChen. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    DaiMethodTracingLogStart,
    DaiMethodTracingLogArgument,
    DaiMethodTracingLogReturn,
    DaiMethodTracingLogFinish
} DaiMethodTracingLogType;

@interface DaiMethodTracingLog : NSObject

+ (void)tracingLog:(NSString *)log stack:(NSString *)stack logType:(DaiMethodTracingLogType)logType;
+ (NSString *)methodFace:(id)target aSelector:(SEL)aSelector;
+ (NSString *)blockFaces:(NSMethodSignature *)signature;
+ (NSString *)stackSymbol;
+ (NSString *)simpleObject:(id)anObject;
+ (void)simpleMode:(BOOL)simpleMode;

@end
