//
//  DaiSugarCoating.h
//  DaiMethodTracing
//
//  Created by DaidoujiChen on 2015/6/9.
//  Copyright (c) 2015年 DaidoujiChen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DaiSugarCoating : NSObject

// 傳一個包裝過的 block
+ (id)wrapBlock:(id)block;

@end
