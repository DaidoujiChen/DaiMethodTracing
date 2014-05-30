//
//  DaiMethodTracing+AccessObject.h
//  DaiMethodTracing
//
//  Created by 啟倫 陳 on 2014/5/29.
//  Copyright (c) 2014年 ChilunChen. All rights reserved.
//

#import "DaiMethodTracing.h"

#define incDeep [methodDeep() addObject:[NSObject new]]
#define decDeep [methodDeep() removeLastObject]
#define deep [methodDeep() count]

@interface DaiMethodTracing (AccessObject)

NSMutableArray* methodDeep();

@end
