//
//  NSObject+MethodDeep.h
//  DaiMethodTracing
//
//  Created by 啟倫 陳 on 2014/6/3.
//  Copyright (c) 2014年 ChilunChen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (MethodDeep)

-(void) incDeep;
-(void) decDeep;
-(NSUInteger) deep;

@end
