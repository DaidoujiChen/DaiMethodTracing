//
//  DaiMethodTracing+IMPs.h
//  DaiMethodTracing
//
//  Created by 啟倫 陳 on 2014/5/27.
//  Copyright (c) 2014年 ChilunChen. All rights reserved.
//

#import "DaiMethodTracing.h"

@interface DaiMethodTracing (IMPs)

char charMethodIMP(id self, SEL _cmd, ...);
int intMethodIMP(id self, SEL _cmd, ...);
short shortMethodIMP(id self, SEL _cmd, ...);
long longMethodIMP(id self, SEL _cmd, ...);
long long longlongMethodIMP(id self, SEL _cmd, ...);
unsigned char unsignedCharMethodIMP(id self, SEL _cmd, ...);
unsigned int unsignedIntMethodIMP(id self, SEL _cmd, ...);
unsigned short unsignedShortMethodIMP(id self, SEL _cmd, ...);
unsigned long unsignedLongMethodIMP(id self, SEL _cmd, ...);
unsigned long long unsignedLongLongMethodIMP(id self, SEL _cmd, ...);
float floatMethodIMP(id self, SEL _cmd, ...);
double doubleMethodIMP(id self, SEL _cmd, ...);
BOOL boolMethodIMP(id self, SEL _cmd, ...);
void voidMethodIMP(id self, SEL _cmd, ...);
char* charPointerMethodIMP(id self, SEL _cmd, ...);
id idMethodIMP(id self, SEL _cmd, ...);
Class classMethodIMP(id self, SEL _cmd, ...);
SEL selMethodIMP(id self, SEL _cmd, ...);

@end
