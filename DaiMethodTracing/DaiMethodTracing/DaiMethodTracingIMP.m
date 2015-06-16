//
//  DaiMethodTracingIMP.m
//  DaiMethodTracing
//
//  Created by DaidoujiChen on 2015/6/10.
//  Copyright (c) 2015年 ChilunChen. All rights reserved.
//

#import "DaiMethodTracingIMP.h"

#import <objc/runtime.h>

#import "DaiMethodTracingDefine.h"
#import "DaiMethodTracingType.h"
#import "DaiSugarCoating.h"
#import "DaiMethodTracingLog.h"

#pragma mark - private function

NSInvocation *createInvocation(id self, SEL _cmd, va_list list, NSString *deep)
{
    NSString *methodName = NSStringFromSelector(_cmd);
    SEL swizzlingSelector = NSSelectorFromString([NSString stringWithFormat:@"%@%@", swizzlingPrefix, methodName]);
    NSMethodSignature *signature = [self methodSignatureForSelector:swizzlingSelector];
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
    [invocation setTarget:self];
    [invocation setSelector:swizzlingSelector];
    
    for (NSUInteger i = 2; i < invocation.methodSignature.numberOfArguments; i++) {
        NSMutableString *argumentLogString = [NSMutableString string];
        
        [argumentLogString appendFormat:@"arg%td ", i - 1];
        
        NSString *argumentType = [NSString stringWithCString:[invocation.methodSignature getArgumentTypeAtIndex:i] encoding:NSUTF8StringEncoding];
        switch (tracingType(argumentType)) {
            case DaiMethodTracingTypeChar:
            {
                char argument = va_arg(list, int);
                [invocation setArgument:&argument atIndex:i];
                [argumentLogString appendFormat:@"(char) %c", argument];
                break;
            }
                
            case DaiMethodTracingTypeInt:
            {
                int argument = va_arg(list, int);
                [invocation setArgument:&argument atIndex:i];
                [argumentLogString appendFormat:@"(int) %i", argument];
                break;
            }
                
            case DaiMethodTracingTypeShort:
            {
                short argument = va_arg(list, int);
                [invocation setArgument:&argument atIndex:i];
                [argumentLogString appendFormat:@"(short) %i", argument];
                break;
            }
                
            case DaiMethodTracingTypeLong:
            {
                long argument = va_arg(list, long);
                [invocation setArgument:&argument atIndex:i];
                [argumentLogString appendFormat:@"(long) %li", argument];
                break;
            }
                
            case DaiMethodTracingTypeLongLong:
            {
                long long argument = va_arg(list, long long);
                [invocation setArgument:&argument atIndex:i];
                [argumentLogString appendFormat:@"(long long) %lld", argument];
                break;
            }
                
            case DaiMethodTracingTypeUnsignedChar:
            {
                unsigned char argument = va_arg(list, int);
                [invocation setArgument:&argument atIndex:i];
                [argumentLogString appendFormat:@"(unsigened char) %c", argument];
                break;
            }
                
            case DaiMethodTracingTypeUnsignedInt:
            {
                unsigned int argument = va_arg(list, unsigned int);
                [invocation setArgument:&argument atIndex:i];
                [argumentLogString appendFormat:@"(unsigned int) %i", argument];
                break;
            }
                
            case DaiMethodTracingTypeUnsignedShort:
            {
                unsigned short argument = va_arg(list, int);
                [invocation setArgument:&argument atIndex:i];
                [argumentLogString appendFormat:@"(unsigned short) %i", argument];
                break;
            }
                
            case DaiMethodTracingTypeUnsignedLong:
            {
                unsigned long argument = va_arg(list, unsigned long);
                [invocation setArgument:&argument atIndex:i];
                [argumentLogString appendFormat:@"(unsigned long) %lu", argument];
                break;
            }
                
            case DaiMethodTracingTypeUnsignedLongLong:
            {
                unsigned long long argument = va_arg(list, unsigned long long);
                [invocation setArgument:&argument atIndex:i];
                [argumentLogString appendFormat:@"(unsigned long long) %llu", argument];
                break;
            }
                
            case DaiMethodTracingTypeFloat:
            {
                float argument = va_arg(list, double);
                [invocation setArgument:&argument atIndex:i];
                [argumentLogString appendFormat:@"(float) %f", argument];
                break;
            }
                
            case DaiMethodTracingTypeDouble:
            {
                double argument = va_arg(list, double);
                [invocation setArgument:&argument atIndex:i];
                [argumentLogString appendFormat:@"(double) %f", argument];
                break;
            }
                
            case DaiMethodTracingTypeBool:
            {
                BOOL argument = va_arg(list, int);
                [invocation setArgument:&argument atIndex:i];
                [argumentLogString appendFormat:@"(BOOL) %@", argument ? @"YES":@"NO"];
                break;
            }
                
            case DaiMethodTracingTypeVoidPointer:
            {
                void *argument = va_arg(list, void *);
                [invocation setArgument:&argument atIndex:i];
                [argumentLogString appendFormat:@"(%@) %s", voidPointerAnalyze(argumentType), argument];
                break;
            }
                
            case DaiMethodTracingTypeCharPointer:
            {
                char *argument = va_arg(list, char *);
                [invocation setArgument:&argument atIndex:i];
                [argumentLogString appendFormat:@"(char*) %s", argument];
                break;
            }
                
            case DaiMethodTracingTypeObject:
            {
                id argument = va_arg(list, id);
                if ([argument isKindOfClass:NSClassFromString(@"NSBlock")]) {
                    argument = [DaiSugarCoating wrapBlock:argument];
                }
                [invocation setArgument:&argument atIndex:i];
                [argumentLogString appendFormat:@"(%@) %@", objectAnalyze(argumentType), [DaiMethodTracingLog simpleObject:argument]];
                break;
            }
                
            case DaiMethodTracingTypeClass:
            {
                Class argument = va_arg(list, Class);
                [invocation setArgument:&argument atIndex:i];
                [argumentLogString appendFormat:@"(Class) %@", argument];
                break;
            }
                
            case DaiMethodTracingTypeSelector:
            {
                SEL argument = va_arg(list, SEL);
                [invocation setArgument:&argument atIndex:i];
                [argumentLogString appendFormat:@"(SEL) %@", NSStringFromSelector(argument)];
                break;
            }
                
            case DaiMethodTracingTypeCGRect:
            {
                CGRect argument = va_arg(list, CGRect);
                [invocation setArgument:&argument atIndex:i];
                [argumentLogString appendFormat:@"(CGRect) %@", NSStringFromCGRect(argument)];
                break;
            }
                
            case DaiMethodTracingTypeCGPoint:
            {
                CGPoint argument = va_arg(list, CGPoint);
                [invocation setArgument:&argument atIndex:i];
                [argumentLogString appendFormat:@"(CGPoint) %@", NSStringFromCGPoint(argument)];
                break;
            }
                
            case DaiMethodTracingTypeCGSize:
            {
                CGSize argument = va_arg(list, CGSize);
                [invocation setArgument:&argument atIndex:i];
                [argumentLogString appendFormat:@"(CGSize) %@", NSStringFromCGSize(argument)];
                break;
            }
                
            case DaiMethodTracingTypeCGAffineTransform:
            {
                CGAffineTransform argument = va_arg(list, CGAffineTransform);
                [invocation setArgument:&argument atIndex:i];
                [argumentLogString appendFormat:@"(CGAffineTransform) %@", NSStringFromCGAffineTransform(argument)];
                break;
            }
                
            case DaiMethodTracingTypeUIEdgeInsets:
            {
                UIEdgeInsets argument = va_arg(list, UIEdgeInsets);
                [invocation setArgument:&argument atIndex:i];
                [argumentLogString appendFormat:@"(UIEdgeInsets) %@", NSStringFromUIEdgeInsets(argument)];
                break;
            }
                
            case DaiMethodTracingTypeUIOffset:
            {
                UIOffset argument = va_arg(list, UIOffset);
                [invocation setArgument:&argument atIndex:i];
                [argumentLogString appendFormat:@"(UIOffset) %@", NSStringFromUIOffset(argument)];
                break;
            }
                
            default:
                NSLog(@"%@, %@", NSStringFromSelector([invocation selector]), [NSString stringWithCString:[invocation.methodSignature getArgumentTypeAtIndex:i] encoding:NSUTF8StringEncoding]);
                break;
        }
        
        [DaiMethodTracingLog tracingLog:argumentLogString stack:deep logType:DaiMethodTracingLogArgument];
    }
    
    return invocation;
}

#pragma mark - public function

char charMethodIMP(id self, SEL _cmd, ...)
{
    NSString *deep = [DaiMethodTracingLog stackSymbol];
    [DaiMethodTracingLog tracingLog:[NSString stringWithFormat:@"%@ at %@ {", [DaiMethodTracingLog simpleObject:self], [DaiMethodTracingLog methodFace:self aSelector:_cmd]] stack:deep logType:DaiMethodTracingLogStart];
    
    // 建立 invocation, 並填入變數
    va_list list;
    va_start(list, _cmd);
    NSInvocation *invocation = createInvocation(self, _cmd, list, deep);
    va_end(list);
    
    // 運行
    NSTimeInterval startTime = [[NSDate date] timeIntervalSince1970];
    [invocation invoke];
    
    // 處理回傳值
    char returnValue;
    [invocation getReturnValue:&returnValue];
    [DaiMethodTracingLog tracingLog:[NSString stringWithFormat:@"return %c", returnValue] stack:deep logType:DaiMethodTracingLogReturn];
    
    [DaiMethodTracingLog tracingLog:[NSString stringWithFormat:@"} %@ at %@, cost %fs", [DaiMethodTracingLog simpleObject:self], [DaiMethodTracingLog methodFace:self aSelector:_cmd], [[NSDate date] timeIntervalSince1970] - startTime] stack:deep logType:DaiMethodTracingLogFinish];
    return returnValue;
}

int intMethodIMP(id self, SEL _cmd, ...)
{
    NSString *deep = [DaiMethodTracingLog stackSymbol];
    [DaiMethodTracingLog tracingLog:[NSString stringWithFormat:@"%@ at %@ {", [DaiMethodTracingLog simpleObject:self], [DaiMethodTracingLog methodFace:self aSelector:_cmd]] stack:deep logType:DaiMethodTracingLogStart];;
    
    // 建立 invocation, 並填入變數
    va_list list;
    va_start(list, _cmd);
    NSInvocation *invocation = createInvocation(self, _cmd, list, deep);
    va_end(list);
    
    // 運行
    NSTimeInterval startTime = [[NSDate date] timeIntervalSince1970];
    [invocation invoke];
    
    // 處理回傳值
    int returnValue;
    [invocation getReturnValue:&returnValue];
    [DaiMethodTracingLog tracingLog:[NSString stringWithFormat:@"return %c", returnValue] stack:deep logType:DaiMethodTracingLogReturn];
    
    [DaiMethodTracingLog tracingLog:[NSString stringWithFormat:@"} %@ at %@, cost %fs", [DaiMethodTracingLog simpleObject:self], [DaiMethodTracingLog methodFace:self aSelector:_cmd], [[NSDate date] timeIntervalSince1970] - startTime] stack:deep logType:DaiMethodTracingLogFinish];;
    return returnValue;
}

short shortMethodIMP(id self, SEL _cmd, ...)
{
    NSString *deep = [DaiMethodTracingLog stackSymbol];
    [DaiMethodTracingLog tracingLog:[NSString stringWithFormat:@"%@ at %@ {", [DaiMethodTracingLog simpleObject:self], [DaiMethodTracingLog methodFace:self aSelector:_cmd]] stack:deep logType:DaiMethodTracingLogStart];;
    
    // 建立 invocation, 並填入變數
    va_list list;
    va_start(list, _cmd);
    NSInvocation *invocation = createInvocation(self, _cmd, list, deep);
    va_end(list);
    
    // 運行
    NSTimeInterval startTime = [[NSDate date] timeIntervalSince1970];
    [invocation invoke];
    
    // 處理回傳值
    short returnValue;
    [invocation getReturnValue:&returnValue];
    [DaiMethodTracingLog tracingLog:[NSString stringWithFormat:@"return %c", returnValue] stack:deep logType:DaiMethodTracingLogReturn];
    
    [DaiMethodTracingLog tracingLog:[NSString stringWithFormat:@"} %@ at %@, cost %fs", [DaiMethodTracingLog simpleObject:self], [DaiMethodTracingLog methodFace:self aSelector:_cmd], [[NSDate date] timeIntervalSince1970] - startTime] stack:deep logType:DaiMethodTracingLogFinish];;
    return returnValue;
}

long longMethodIMP(id self, SEL _cmd, ...)
{
    NSString *deep = [DaiMethodTracingLog stackSymbol];
    [DaiMethodTracingLog tracingLog:[NSString stringWithFormat:@"%@ at %@ {", [DaiMethodTracingLog simpleObject:self], [DaiMethodTracingLog methodFace:self aSelector:_cmd]] stack:deep logType:DaiMethodTracingLogStart];;
    
    // 建立 invocation, 並填入變數
    va_list list;
    va_start(list, _cmd);
    NSInvocation *invocation = createInvocation(self, _cmd, list, deep);
    va_end(list);
    
    // 運行
    NSTimeInterval startTime = [[NSDate date] timeIntervalSince1970];
    [invocation invoke];
    
    // 處理回傳值
    long returnValue;
    [invocation getReturnValue:&returnValue];
    [DaiMethodTracingLog tracingLog:[NSString stringWithFormat:@"return %ld", returnValue] stack:deep logType:DaiMethodTracingLogReturn];
    
    [DaiMethodTracingLog tracingLog:[NSString stringWithFormat:@"} %@ at %@, cost %fs", [DaiMethodTracingLog simpleObject:self], [DaiMethodTracingLog methodFace:self aSelector:_cmd], [[NSDate date] timeIntervalSince1970] - startTime] stack:deep logType:DaiMethodTracingLogFinish];;
    return returnValue;
}

long long longlongMethodIMP(id self, SEL _cmd, ...)
{
    NSString *deep = [DaiMethodTracingLog stackSymbol];
    [DaiMethodTracingLog tracingLog:[NSString stringWithFormat:@"%@ at %@ {", [DaiMethodTracingLog simpleObject:self], [DaiMethodTracingLog methodFace:self aSelector:_cmd]] stack:deep logType:DaiMethodTracingLogStart];;
    
    // 建立 invocation, 並填入變數
    va_list list;
    va_start(list, _cmd);
    NSInvocation *invocation = createInvocation(self, _cmd, list, deep);
    va_end(list);
    
    // 運行
    NSTimeInterval startTime = [[NSDate date] timeIntervalSince1970];
    [invocation invoke];
    
    // 處理回傳值
    long long returnValue;
    [invocation getReturnValue:&returnValue];
    [DaiMethodTracingLog tracingLog:[NSString stringWithFormat:@"return %lld", returnValue] stack:deep logType:DaiMethodTracingLogReturn];
    
    [DaiMethodTracingLog tracingLog:[NSString stringWithFormat:@"} %@ at %@, cost %fs", [DaiMethodTracingLog simpleObject:self], [DaiMethodTracingLog methodFace:self aSelector:_cmd], [[NSDate date] timeIntervalSince1970] - startTime] stack:deep logType:DaiMethodTracingLogFinish];;
    return returnValue;
}

unsigned char unsignedCharMethodIMP(id self, SEL _cmd, ...)
{
    NSString *deep = [DaiMethodTracingLog stackSymbol];
    [DaiMethodTracingLog tracingLog:[NSString stringWithFormat:@"%@ at %@ {", [DaiMethodTracingLog simpleObject:self], [DaiMethodTracingLog methodFace:self aSelector:_cmd]] stack:deep logType:DaiMethodTracingLogStart];;
    
    // 建立 invocation, 並填入變數
    va_list list;
    va_start(list, _cmd);
    NSInvocation *invocation = createInvocation(self, _cmd, list, deep);
    va_end(list);
    
    // 運行
    NSTimeInterval startTime = [[NSDate date] timeIntervalSince1970];
    [invocation invoke];
    
    // 處理回傳值
    unsigned char returnValue;
    [invocation getReturnValue:&returnValue];
    [DaiMethodTracingLog tracingLog:[NSString stringWithFormat:@"return %c", returnValue] stack:deep logType:DaiMethodTracingLogReturn];
    
    [DaiMethodTracingLog tracingLog:[NSString stringWithFormat:@"} %@ at %@, cost %fs", [DaiMethodTracingLog simpleObject:self], [DaiMethodTracingLog methodFace:self aSelector:_cmd], [[NSDate date] timeIntervalSince1970] - startTime] stack:deep logType:DaiMethodTracingLogFinish];;
    return returnValue;
}

unsigned int unsignedIntMethodIMP(id self, SEL _cmd, ...)
{
    NSString *deep = [DaiMethodTracingLog stackSymbol];
    [DaiMethodTracingLog tracingLog:[NSString stringWithFormat:@"%@ at %@ {", [DaiMethodTracingLog simpleObject:self], [DaiMethodTracingLog methodFace:self aSelector:_cmd]] stack:deep logType:DaiMethodTracingLogStart];;
    
    // 建立 invocation, 並填入變數
    va_list list;
    va_start(list, _cmd);
    NSInvocation *invocation = createInvocation(self, _cmd, list, deep);
    va_end(list);
    
    // 運行
    NSTimeInterval startTime = [[NSDate date] timeIntervalSince1970];
    [invocation invoke];
    
    // 處理回傳值
    unsigned int returnValue;
    [invocation getReturnValue:&returnValue];
    [DaiMethodTracingLog tracingLog:[NSString stringWithFormat:@"return %c", returnValue] stack:deep logType:DaiMethodTracingLogReturn];
    
    [DaiMethodTracingLog tracingLog:[NSString stringWithFormat:@"} %@ at %@, cost %fs", [DaiMethodTracingLog simpleObject:self], [DaiMethodTracingLog methodFace:self aSelector:_cmd], [[NSDate date] timeIntervalSince1970] - startTime] stack:deep logType:DaiMethodTracingLogFinish];;
    return returnValue;
}

unsigned short unsignedShortMethodIMP(id self, SEL _cmd, ...)
{
    NSString *deep = [DaiMethodTracingLog stackSymbol];
    [DaiMethodTracingLog tracingLog:[NSString stringWithFormat:@"%@ at %@ {", [DaiMethodTracingLog simpleObject:self], [DaiMethodTracingLog methodFace:self aSelector:_cmd]] stack:deep logType:DaiMethodTracingLogStart];;
    
    // 建立 invocation, 並填入變數
    va_list list;
    va_start(list, _cmd);
    NSInvocation *invocation = createInvocation(self, _cmd, list, deep);
    va_end(list);
    
    // 運行
    NSTimeInterval startTime = [[NSDate date] timeIntervalSince1970];
    [invocation invoke];
    
    // 處理回傳值
    unsigned short returnValue;
    [invocation getReturnValue:&returnValue];
    [DaiMethodTracingLog tracingLog:[NSString stringWithFormat:@"return %c", returnValue] stack:deep logType:DaiMethodTracingLogReturn];
    
    [DaiMethodTracingLog tracingLog:[NSString stringWithFormat:@"} %@ at %@, cost %fs", [DaiMethodTracingLog simpleObject:self], [DaiMethodTracingLog methodFace:self aSelector:_cmd], [[NSDate date] timeIntervalSince1970] - startTime] stack:deep logType:DaiMethodTracingLogFinish];;
    return returnValue;
}

unsigned long unsignedLongMethodIMP(id self, SEL _cmd, ...)
{
    NSString *deep = [DaiMethodTracingLog stackSymbol];
    [DaiMethodTracingLog tracingLog:[NSString stringWithFormat:@"%@ at %@ {", [DaiMethodTracingLog simpleObject:self], [DaiMethodTracingLog methodFace:self aSelector:_cmd]] stack:deep logType:DaiMethodTracingLogStart];;
    
    // 建立 invocation, 並填入變數
    va_list list;
    va_start(list, _cmd);
    NSInvocation *invocation = createInvocation(self, _cmd, list, deep);
    va_end(list);
    
    // 運行
    NSTimeInterval startTime = [[NSDate date] timeIntervalSince1970];
    [invocation invoke];
    
    // 處理回傳值
    unsigned long returnValue;
    [invocation getReturnValue:&returnValue];
    [DaiMethodTracingLog tracingLog:[NSString stringWithFormat:@"return %lu", returnValue] stack:deep logType:DaiMethodTracingLogReturn];
    
    [DaiMethodTracingLog tracingLog:[NSString stringWithFormat:@"} %@ at %@, cost %fs", [DaiMethodTracingLog simpleObject:self], [DaiMethodTracingLog methodFace:self aSelector:_cmd], [[NSDate date] timeIntervalSince1970] - startTime] stack:deep logType:DaiMethodTracingLogFinish];;
    return returnValue;
}

unsigned long long unsignedLongLongMethodIMP(id self, SEL _cmd, ...)
{
    NSString *deep = [DaiMethodTracingLog stackSymbol];
    [DaiMethodTracingLog tracingLog:[NSString stringWithFormat:@"%@ at %@ {", [DaiMethodTracingLog simpleObject:self], [DaiMethodTracingLog methodFace:self aSelector:_cmd]] stack:deep logType:DaiMethodTracingLogStart];;
    
    // 建立 invocation, 並填入變數
    va_list list;
    va_start(list, _cmd);
    NSInvocation *invocation = createInvocation(self, _cmd, list, deep);
    va_end(list);
    
    // 運行
    NSTimeInterval startTime = [[NSDate date] timeIntervalSince1970];
    [invocation invoke];
    
    // 處理回傳值
    unsigned long long returnValue;
    [invocation getReturnValue:&returnValue];
    [DaiMethodTracingLog tracingLog:[NSString stringWithFormat:@"return %llu", returnValue] stack:deep logType:DaiMethodTracingLogReturn];
    
    [DaiMethodTracingLog tracingLog:[NSString stringWithFormat:@"} %@ at %@, cost %fs", [DaiMethodTracingLog simpleObject:self], [DaiMethodTracingLog methodFace:self aSelector:_cmd], [[NSDate date] timeIntervalSince1970] - startTime] stack:deep logType:DaiMethodTracingLogFinish];;
    return returnValue;
}

float floatMethodIMP(id self, SEL _cmd, ...)
{
    NSString *deep = [DaiMethodTracingLog stackSymbol];
    [DaiMethodTracingLog tracingLog:[NSString stringWithFormat:@"%@ at %@ {", [DaiMethodTracingLog simpleObject:self], [DaiMethodTracingLog methodFace:self aSelector:_cmd]] stack:deep logType:DaiMethodTracingLogStart];;
    
    // 建立 invocation, 並填入變數
    va_list list;
    va_start(list, _cmd);
    NSInvocation *invocation = createInvocation(self, _cmd, list, deep);
    va_end(list);
    
    // 運行
    NSTimeInterval startTime = [[NSDate date] timeIntervalSince1970];
    [invocation invoke];
    
    // 處理回傳值
    float returnValue;
    [invocation getReturnValue:&returnValue];
    [DaiMethodTracingLog tracingLog:[NSString stringWithFormat:@"return %f", returnValue] stack:deep logType:DaiMethodTracingLogReturn];
    
    [DaiMethodTracingLog tracingLog:[NSString stringWithFormat:@"} %@ at %@, cost %fs", [DaiMethodTracingLog simpleObject:self], [DaiMethodTracingLog methodFace:self aSelector:_cmd], [[NSDate date] timeIntervalSince1970] - startTime] stack:deep logType:DaiMethodTracingLogFinish];;
    return returnValue;
}

double doubleMethodIMP(id self, SEL _cmd, ...)
{
    NSString *deep = [DaiMethodTracingLog stackSymbol];
    [DaiMethodTracingLog tracingLog:[NSString stringWithFormat:@"%@ at %@ {", [DaiMethodTracingLog simpleObject:self], [DaiMethodTracingLog methodFace:self aSelector:_cmd]] stack:deep logType:DaiMethodTracingLogStart];;
    
    // 建立 invocation, 並填入變數
    va_list list;
    va_start(list, _cmd);
    NSInvocation *invocation = createInvocation(self, _cmd, list, deep);
    va_end(list);
    
    // 運行
    NSTimeInterval startTime = [[NSDate date] timeIntervalSince1970];
    [invocation invoke];
    
    // 處理回傳值
    double returnValue;
    [invocation getReturnValue:&returnValue];
    [DaiMethodTracingLog tracingLog:[NSString stringWithFormat:@"return %f", returnValue] stack:deep logType:DaiMethodTracingLogReturn];
    
    [DaiMethodTracingLog tracingLog:[NSString stringWithFormat:@"} %@ at %@, cost %fs", [DaiMethodTracingLog simpleObject:self], [DaiMethodTracingLog methodFace:self aSelector:_cmd], [[NSDate date] timeIntervalSince1970] - startTime] stack:deep logType:DaiMethodTracingLogFinish];;
    return returnValue;
}

BOOL boolMethodIMP(id self, SEL _cmd, ...)
{
    NSString *deep = [DaiMethodTracingLog stackSymbol];
    [DaiMethodTracingLog tracingLog:[NSString stringWithFormat:@"%@ at %@ {", [DaiMethodTracingLog simpleObject:self], [DaiMethodTracingLog methodFace:self aSelector:_cmd]] stack:deep logType:DaiMethodTracingLogStart];;
    
    // 建立 invocation, 並填入變數
    va_list list;
    va_start(list, _cmd);
    NSInvocation *invocation = createInvocation(self, _cmd, list, deep);
    va_end(list);
    
    // 運行
    NSTimeInterval startTime = [[NSDate date] timeIntervalSince1970];
    [invocation invoke];
    
    // 處理回傳值
    BOOL returnValue;
    [invocation getReturnValue:&returnValue];
    [DaiMethodTracingLog tracingLog:[NSString stringWithFormat:@"return %@", returnValue ? @"YES" : @"NO"] stack:deep logType:DaiMethodTracingLogReturn];
    
    [DaiMethodTracingLog tracingLog:[NSString stringWithFormat:@"} %@ at %@, cost %fs", [DaiMethodTracingLog simpleObject:self], [DaiMethodTracingLog methodFace:self aSelector:_cmd], [[NSDate date] timeIntervalSince1970] - startTime] stack:deep logType:DaiMethodTracingLogFinish];;
    return returnValue;
}

void voidMethodIMP(id self, SEL _cmd, ...)
{
    NSString *deep = [DaiMethodTracingLog stackSymbol];
    [DaiMethodTracingLog tracingLog:[NSString stringWithFormat:@"%@ at %@ {", [DaiMethodTracingLog simpleObject:self], [DaiMethodTracingLog methodFace:self aSelector:_cmd]] stack:deep logType:DaiMethodTracingLogStart];;
    
    // 建立 invocation, 並填入變數
    va_list list;
    va_start(list, _cmd);
    NSInvocation *invocation = createInvocation(self, _cmd, list, deep);
    va_end(list);
    
    // 運行
    NSTimeInterval startTime = [[NSDate date] timeIntervalSince1970];
    [invocation invoke];
    
    [DaiMethodTracingLog tracingLog:@"return void" stack:deep logType:DaiMethodTracingLogReturn];
    [DaiMethodTracingLog tracingLog:[NSString stringWithFormat:@"} %@ at %@, cost %fs", [DaiMethodTracingLog simpleObject:self], [DaiMethodTracingLog methodFace:self aSelector:_cmd], [[NSDate date] timeIntervalSince1970] - startTime] stack:deep logType:DaiMethodTracingLogFinish];;
}

void *voidPointerMethodIMP(id self, SEL _cmd, ...)
{
    NSString *deep = [DaiMethodTracingLog stackSymbol];
    [DaiMethodTracingLog tracingLog:[NSString stringWithFormat:@"%@ at %@ {", [DaiMethodTracingLog simpleObject:self], [DaiMethodTracingLog methodFace:self aSelector:_cmd]] stack:deep logType:DaiMethodTracingLogStart];;
    
    // 建立 invocation, 並填入變數
    va_list list;
    va_start(list, _cmd);
    NSInvocation *invocation = createInvocation(self, _cmd, list, deep);
    va_end(list);
    
    // 運行
    NSTimeInterval startTime = [[NSDate date] timeIntervalSince1970];
    [invocation invoke];
    
    // 處理回傳值
    void *returnValue;
    [invocation getReturnValue:&returnValue];
    [DaiMethodTracingLog tracingLog:[NSString stringWithFormat:@"return %s", returnValue] stack:deep logType:DaiMethodTracingLogReturn];
    
    [DaiMethodTracingLog tracingLog:[NSString stringWithFormat:@"} %@ at %@, cost %fs", [DaiMethodTracingLog simpleObject:self], [DaiMethodTracingLog methodFace:self aSelector:_cmd], [[NSDate date] timeIntervalSince1970] - startTime] stack:deep logType:DaiMethodTracingLogFinish];;
    return returnValue;
}

char *charPointerMethodIMP(id self, SEL _cmd, ...)
{
    NSString *deep = [DaiMethodTracingLog stackSymbol];
    [DaiMethodTracingLog tracingLog:[NSString stringWithFormat:@"%@ at %@ {", [DaiMethodTracingLog simpleObject:self], [DaiMethodTracingLog methodFace:self aSelector:_cmd]] stack:deep logType:DaiMethodTracingLogStart];;
    
    // 建立 invocation, 並填入變數
    va_list list;
    va_start(list, _cmd);
    NSInvocation *invocation = createInvocation(self, _cmd, list, deep);
    va_end(list);
    
    // 運行
    NSTimeInterval startTime = [[NSDate date] timeIntervalSince1970];
    [invocation invoke];
    
    // 處理回傳值
    char *returnValue;
    [invocation getReturnValue:&returnValue];
    [DaiMethodTracingLog tracingLog:[NSString stringWithFormat:@"return %s", returnValue] stack:deep logType:DaiMethodTracingLogReturn];
    
    [DaiMethodTracingLog tracingLog:[NSString stringWithFormat:@"} %@ at %@, cost %fs", [DaiMethodTracingLog simpleObject:self], [DaiMethodTracingLog methodFace:self aSelector:_cmd], [[NSDate date] timeIntervalSince1970] - startTime] stack:deep logType:DaiMethodTracingLogFinish];;
    return returnValue;
}

id objectMethodIMP(id self, SEL _cmd, ...)
{
    NSString *deep = [DaiMethodTracingLog stackSymbol];
    [DaiMethodTracingLog tracingLog:[NSString stringWithFormat:@"%@ at %@ {", [DaiMethodTracingLog simpleObject:self], [DaiMethodTracingLog methodFace:self aSelector:_cmd]] stack:deep logType:DaiMethodTracingLogStart];;
    
    // 建立 invocation, 並填入變數
    va_list list;
    va_start(list, _cmd);
    NSInvocation *invocation = createInvocation(self, _cmd, list, deep);
    va_end(list);
    
    // 運行
    NSTimeInterval startTime = [[NSDate date] timeIntervalSince1970];
    [invocation invoke];
    
    // 處理回傳值
    __unsafe_unretained id returnValue;
    [invocation getReturnValue:&returnValue];
    [DaiMethodTracingLog tracingLog:[NSString stringWithFormat:@"return %@", [DaiMethodTracingLog simpleObject:returnValue]] stack:deep logType:DaiMethodTracingLogReturn];
    
    [DaiMethodTracingLog tracingLog:[NSString stringWithFormat:@"} %@ at %@, cost %fs", [DaiMethodTracingLog simpleObject:self], [DaiMethodTracingLog methodFace:self aSelector:_cmd], [[NSDate date] timeIntervalSince1970] - startTime] stack:deep logType:DaiMethodTracingLogFinish];;
    return returnValue;
}

Class classMethodIMP(id self, SEL _cmd, ...)
{
    NSString *deep = [DaiMethodTracingLog stackSymbol];
    [DaiMethodTracingLog tracingLog:[NSString stringWithFormat:@"%@ at %@ {", [DaiMethodTracingLog simpleObject:self], [DaiMethodTracingLog methodFace:self aSelector:_cmd]] stack:deep logType:DaiMethodTracingLogStart];;
    
    // 建立 invocation, 並填入變數
    va_list list;
    va_start(list, _cmd);
    NSInvocation *invocation = createInvocation(self, _cmd, list, deep);
    va_end(list);
    
    // 運行
    NSTimeInterval startTime = [[NSDate date] timeIntervalSince1970];
    [invocation invoke];
    
    // 處理回傳值
    Class returnValue;
    [invocation getReturnValue:&returnValue];
    [DaiMethodTracingLog tracingLog:[NSString stringWithFormat:@"return %@", returnValue] stack:deep logType:DaiMethodTracingLogReturn];
    
    [DaiMethodTracingLog tracingLog:[NSString stringWithFormat:@"} %@ at %@, cost %fs", [DaiMethodTracingLog simpleObject:self], [DaiMethodTracingLog methodFace:self aSelector:_cmd], [[NSDate date] timeIntervalSince1970] - startTime] stack:deep logType:DaiMethodTracingLogFinish];;
    return returnValue;
}

SEL selectorMethodIMP(id self, SEL _cmd, ...)
{
    NSString *deep = [DaiMethodTracingLog stackSymbol];
    [DaiMethodTracingLog tracingLog:[NSString stringWithFormat:@"%@ at %@ {", [DaiMethodTracingLog simpleObject:self], [DaiMethodTracingLog methodFace:self aSelector:_cmd]] stack:deep logType:DaiMethodTracingLogStart];;
    
    // 建立 invocation, 並填入變數
    va_list list;
    va_start(list, _cmd);
    NSInvocation *invocation = createInvocation(self, _cmd, list, deep);
    va_end(list);
    
    // 運行
    NSTimeInterval startTime = [[NSDate date] timeIntervalSince1970];
    [invocation invoke];
    
    // 處理回傳值
    SEL returnValue;
    [invocation getReturnValue:&returnValue];
    [DaiMethodTracingLog tracingLog:[NSString stringWithFormat:@"return %@", NSStringFromSelector(returnValue)] stack:deep logType:DaiMethodTracingLogReturn];
    
    [DaiMethodTracingLog tracingLog:[NSString stringWithFormat:@"} %@ at %@, cost %fs", [DaiMethodTracingLog simpleObject:self], [DaiMethodTracingLog methodFace:self aSelector:_cmd], [[NSDate date] timeIntervalSince1970] - startTime] stack:deep logType:DaiMethodTracingLogFinish];;
    return returnValue;
}

CGRect cgRectMethodIMP(id self, SEL _cmd, ...)
{
    NSString *deep = [DaiMethodTracingLog stackSymbol];
    [DaiMethodTracingLog tracingLog:[NSString stringWithFormat:@"%@ at %@ {", [DaiMethodTracingLog simpleObject:self], [DaiMethodTracingLog methodFace:self aSelector:_cmd]] stack:deep logType:DaiMethodTracingLogStart];;
    
    // 建立 invocation, 並填入變數
    va_list list;
    va_start(list, _cmd);
    NSInvocation *invocation = createInvocation(self, _cmd, list, deep);
    va_end(list);
    
    // 運行
    NSTimeInterval startTime = [[NSDate date] timeIntervalSince1970];
    [invocation invoke];
    
    // 處理回傳值
    CGRect returnValue;
    [invocation getReturnValue:&returnValue];
    [DaiMethodTracingLog tracingLog:[NSString stringWithFormat:@"return %@", NSStringFromCGRect(returnValue)] stack:deep logType:DaiMethodTracingLogReturn];
    
    [DaiMethodTracingLog tracingLog:[NSString stringWithFormat:@"} %@ at %@, cost %fs", [DaiMethodTracingLog simpleObject:self], [DaiMethodTracingLog methodFace:self aSelector:_cmd], [[NSDate date] timeIntervalSince1970] - startTime] stack:deep logType:DaiMethodTracingLogFinish];;
    return returnValue;
}

CGPoint cgPointMethodIMP(id self, SEL _cmd, ...)
{
    NSString *deep = [DaiMethodTracingLog stackSymbol];
    [DaiMethodTracingLog tracingLog:[NSString stringWithFormat:@"%@ at %@ {", [DaiMethodTracingLog simpleObject:self], [DaiMethodTracingLog methodFace:self aSelector:_cmd]] stack:deep logType:DaiMethodTracingLogStart];;
    
    // 建立 invocation, 並填入變數
    va_list list;
    va_start(list, _cmd);
    NSInvocation *invocation = createInvocation(self, _cmd, list, deep);
    va_end(list);
    
    // 運行
    NSTimeInterval startTime = [[NSDate date] timeIntervalSince1970];
    [invocation invoke];
    
    // 處理回傳值
    CGPoint returnValue;
    [invocation getReturnValue:&returnValue];
    [DaiMethodTracingLog tracingLog:[NSString stringWithFormat:@"return %@", NSStringFromCGPoint(returnValue)] stack:deep logType:DaiMethodTracingLogReturn];
    
    [DaiMethodTracingLog tracingLog:[NSString stringWithFormat:@"} %@ at %@, cost %fs", [DaiMethodTracingLog simpleObject:self], [DaiMethodTracingLog methodFace:self aSelector:_cmd], [[NSDate date] timeIntervalSince1970] - startTime] stack:deep logType:DaiMethodTracingLogFinish];;
    return returnValue;
}

CGSize cgSizeMethodIMP(id self, SEL _cmd, ...)
{
    NSString *deep = [DaiMethodTracingLog stackSymbol];
    [DaiMethodTracingLog tracingLog:[NSString stringWithFormat:@"%@ at %@ {", [DaiMethodTracingLog simpleObject:self], [DaiMethodTracingLog methodFace:self aSelector:_cmd]] stack:deep logType:DaiMethodTracingLogStart];;
    
    // 建立 invocation, 並填入變數
    va_list list;
    va_start(list, _cmd);
    NSInvocation *invocation = createInvocation(self, _cmd, list, deep);
    va_end(list);
    
    // 運行
    NSTimeInterval startTime = [[NSDate date] timeIntervalSince1970];
    [invocation invoke];
    
    // 處理回傳值
    CGSize returnValue;
    [invocation getReturnValue:&returnValue];
    [DaiMethodTracingLog tracingLog:[NSString stringWithFormat:@"return %@", NSStringFromCGSize(returnValue)] stack:deep logType:DaiMethodTracingLogReturn];
    
    [DaiMethodTracingLog tracingLog:[NSString stringWithFormat:@"} %@ at %@, cost %fs", [DaiMethodTracingLog simpleObject:self], [DaiMethodTracingLog methodFace:self aSelector:_cmd], [[NSDate date] timeIntervalSince1970] - startTime] stack:deep logType:DaiMethodTracingLogFinish];;
    return returnValue;
}

CGAffineTransform cgAffineTransformMethodIMP(id self, SEL _cmd, ...)
{
    NSString *deep = [DaiMethodTracingLog stackSymbol];
    [DaiMethodTracingLog tracingLog:[NSString stringWithFormat:@"%@ at %@ {", [DaiMethodTracingLog simpleObject:self], [DaiMethodTracingLog methodFace:self aSelector:_cmd]] stack:deep logType:DaiMethodTracingLogStart];;
    
    // 建立 invocation, 並填入變數
    va_list list;
    va_start(list, _cmd);
    NSInvocation *invocation = createInvocation(self, _cmd, list, deep);
    va_end(list);
    
    // 運行
    NSTimeInterval startTime = [[NSDate date] timeIntervalSince1970];
    [invocation invoke];
    
    // 處理回傳值
    CGAffineTransform returnValue;
    [invocation getReturnValue:&returnValue];
    [DaiMethodTracingLog tracingLog:[NSString stringWithFormat:@"return %@", NSStringFromCGAffineTransform(returnValue)] stack:deep logType:DaiMethodTracingLogReturn];
    
    [DaiMethodTracingLog tracingLog:[NSString stringWithFormat:@"} %@ at %@, cost %fs", [DaiMethodTracingLog simpleObject:self], [DaiMethodTracingLog methodFace:self aSelector:_cmd], [[NSDate date] timeIntervalSince1970] - startTime] stack:deep logType:DaiMethodTracingLogFinish];;
    return returnValue;
}

UIEdgeInsets uiEdgeInsetsMethodIMP(id self, SEL _cmd, ...)
{
    NSString *deep = [DaiMethodTracingLog stackSymbol];
    [DaiMethodTracingLog tracingLog:[NSString stringWithFormat:@"%@ at %@ {", [DaiMethodTracingLog simpleObject:self], [DaiMethodTracingLog methodFace:self aSelector:_cmd]] stack:deep logType:DaiMethodTracingLogStart];;
    
    // 建立 invocation, 並填入變數
    va_list list;
    va_start(list, _cmd);
    NSInvocation *invocation = createInvocation(self, _cmd, list, deep);
    va_end(list);
    
    // 運行
    NSTimeInterval startTime = [[NSDate date] timeIntervalSince1970];
    [invocation invoke];
    
    // 處理回傳值
    UIEdgeInsets returnValue;
    [invocation getReturnValue:&returnValue];
    [DaiMethodTracingLog tracingLog:[NSString stringWithFormat:@"return %@", NSStringFromUIEdgeInsets(returnValue)] stack:deep logType:DaiMethodTracingLogReturn];
    
    [DaiMethodTracingLog tracingLog:[NSString stringWithFormat:@"} %@ at %@, cost %fs", [DaiMethodTracingLog simpleObject:self], [DaiMethodTracingLog methodFace:self aSelector:_cmd], [[NSDate date] timeIntervalSince1970] - startTime] stack:deep logType:DaiMethodTracingLogFinish];;
    return returnValue;
}

UIOffset uiOffsetMethodIMP(id self, SEL _cmd, ...)
{
    NSString *deep = [DaiMethodTracingLog stackSymbol];
    [DaiMethodTracingLog tracingLog:[NSString stringWithFormat:@"%@ at %@ {", [DaiMethodTracingLog simpleObject:self], [DaiMethodTracingLog methodFace:self aSelector:_cmd]] stack:deep logType:DaiMethodTracingLogStart];;
    
    // 建立 invocation, 並填入變數
    va_list list;
    va_start(list, _cmd);
    NSInvocation *invocation = createInvocation(self, _cmd, list, deep);
    va_end(list);
    
    // 運行
    NSTimeInterval startTime = [[NSDate date] timeIntervalSince1970];
    [invocation invoke];
    
    // 處理回傳值
    UIOffset returnValue;
    [invocation getReturnValue:&returnValue];
    [DaiMethodTracingLog tracingLog:[NSString stringWithFormat:@"return %@", NSStringFromUIOffset(returnValue)] stack:deep logType:DaiMethodTracingLogReturn];
    
    [DaiMethodTracingLog tracingLog:[NSString stringWithFormat:@"} %@ at %@, cost %fs", [DaiMethodTracingLog simpleObject:self], [DaiMethodTracingLog methodFace:self aSelector:_cmd], [[NSDate date] timeIntervalSince1970] - startTime] stack:deep logType:DaiMethodTracingLogFinish];;
    return returnValue;
}
