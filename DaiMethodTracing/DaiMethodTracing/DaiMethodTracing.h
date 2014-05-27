//
//  DaiMethodTracing.h
//  DaiMethodTracing
//
//  Created by 啟倫 陳 on 2014/5/27.
//  Copyright (c) 2014年 ChilunChen. All rights reserved.
//

#import <Foundation/Foundation.h>

#define dstLength 256
#define swizzlingPrefix @"daiSwizzling_"

@interface DaiMethodTracing : NSObject

+(void) tracingClass : (Class) aClass;

@end
