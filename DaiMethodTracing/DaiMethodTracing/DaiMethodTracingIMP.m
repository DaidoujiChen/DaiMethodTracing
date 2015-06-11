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
#import "NSObject+MethodDeep.h"
#import "DaiSugarCoating.h"

#pragma mark - private function

NSInvocation *createInvocation(id self, SEL _cmd, va_list list)
{
    NSString *methodName = NSStringFromSelector(_cmd);
    SEL swizzlingSelector = NSSelectorFromString([NSString stringWithFormat:@"%@%@", swizzlingPrefix, methodName]);
    NSMethodSignature *signature = [self methodSignatureForSelector:swizzlingSelector];
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
    [invocation setTarget:self];
    [invocation setSelector:swizzlingSelector];
    
    for (NSUInteger i = 2; i < invocation.methodSignature.numberOfArguments; i++) {
        NSMutableString *argumentLogString = [NSMutableString string];
        
        [argumentLogString appendFormat:@"(%lu)> ", (unsigned long)[invocation.target deep]];
        
        switch (tracingType([NSString stringWithCString:[invocation.methodSignature getArgumentTypeAtIndex:i]
                                                encoding:NSUTF8StringEncoding])) {
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
                [argumentLogString appendFormat:@"(shot) %i", argument];
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
                char *argument = va_arg(list, void *);
                [invocation setArgument:&argument atIndex:i];
                [argumentLogString appendFormat:@"(void*) %s", argument];
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
                [argumentLogString appendFormat:@"(id) %@", argument];
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
        
        NSLog(@"%@", argumentLogString);
    }
    
    return invocation;
}

#pragma mark - public function

char charMethodIMP(id self, SEL _cmd, ...)
{
    [self incDeep];
    NSLog(@"(%lu)> start %@ at %@", (unsigned long)[self deep], self, NSStringFromSelector(_cmd));
    
    // 建立 invocation, 並填入變數
    va_list list;
    va_start(list, _cmd);
    NSInvocation *invocation = createInvocation(self, _cmd, list);
    va_end(list);
    
    // 運行
    NSTimeInterval startTime = [[NSDate date] timeIntervalSince1970];
    [invocation invoke];
    NSLog(@"(%lu)> finish %@ at %@, use %fs", (unsigned long)[self deep], self, NSStringFromSelector(_cmd), [[NSDate date] timeIntervalSince1970] - startTime);
    
    // 處理回傳值
    char returnValue;
    [invocation getReturnValue:&returnValue];
    NSLog(@"(%lu)> return %c", (unsigned long)[self deep], returnValue);
    
    [self decDeep];
    return returnValue;
}

int intMethodIMP(id self, SEL _cmd, ...)
{
    [self incDeep];
    NSLog(@"(%lu)> start %@ at %@", (unsigned long)[self deep], self, NSStringFromSelector(_cmd));
    
    // 建立 invocation, 並填入變數
    va_list list;
    va_start(list, _cmd);
    NSInvocation *invocation = createInvocation(self, _cmd, list);
    va_end(list);
    
    // 運行
    NSTimeInterval startTime = [[NSDate date] timeIntervalSince1970];
    [invocation invoke];
    NSLog(@"(%lu)> finish %@ at %@, use %fs", (unsigned long)[self deep], self, NSStringFromSelector(_cmd), [[NSDate date] timeIntervalSince1970] - startTime);
    
    // 處理回傳值
    int returnValue;
    [invocation getReturnValue:&returnValue];
    NSLog(@"(%lu)> return %i", (unsigned long)[self deep], returnValue);
    
    [self decDeep];
    return returnValue;
}

short shortMethodIMP(id self, SEL _cmd, ...)
{
    [self incDeep];
    NSLog(@"(%lu)> start %@ at %@", (unsigned long)[self deep], self, NSStringFromSelector(_cmd));
    
    // 建立 invocation, 並填入變數
    va_list list;
    va_start(list, _cmd);
    NSInvocation *invocation = createInvocation(self, _cmd, list);
    va_end(list);
    
    // 運行
    NSTimeInterval startTime = [[NSDate date] timeIntervalSince1970];
    [invocation invoke];
    NSLog(@"(%lu)> finish %@ at %@, use %fs", (unsigned long)[self deep], self, NSStringFromSelector(_cmd), [[NSDate date] timeIntervalSince1970] - startTime);
    
    // 處理回傳值
    short returnValue;
    [invocation getReturnValue:&returnValue];
    NSLog(@"(%lu)> return %i", (unsigned long)[self deep], returnValue);
    
    [self decDeep];
    return returnValue;
}

long longMethodIMP(id self, SEL _cmd, ...)
{
    [self incDeep];
    NSLog(@"(%lu)> start %@ at %@", (unsigned long)[self deep], self, NSStringFromSelector(_cmd));
    
    // 建立 invocation, 並填入變數
    va_list list;
    va_start(list, _cmd);
    NSInvocation *invocation = createInvocation(self, _cmd, list);
    va_end(list);
    
    // 運行
    NSTimeInterval startTime = [[NSDate date] timeIntervalSince1970];
    [invocation invoke];
    NSLog(@"(%lu)> finish %@ at %@, use %fs", (unsigned long)[self deep], self, NSStringFromSelector(_cmd), [[NSDate date] timeIntervalSince1970] - startTime);
    
    // 處理回傳值
    long returnValue;
    [invocation getReturnValue:&returnValue];
    NSLog(@"(%lu)> return %ld", (unsigned long)[self deep], returnValue);
    
    [self decDeep];
    return returnValue;
}

long long longlongMethodIMP(id self, SEL _cmd, ...)
{
    [self incDeep];
    NSLog(@"(%lu)> start %@ at %@", (unsigned long)[self deep], self, NSStringFromSelector(_cmd));
    
    // 建立 invocation, 並填入變數
    va_list list;
    va_start(list, _cmd);
    NSInvocation *invocation = createInvocation(self, _cmd, list);
    va_end(list);
    
    // 運行
    NSTimeInterval startTime = [[NSDate date] timeIntervalSince1970];
    [invocation invoke];
    NSLog(@"(%lu)> finish %@ at %@, use %fs", (unsigned long)[self deep], self, NSStringFromSelector(_cmd), [[NSDate date] timeIntervalSince1970] - startTime);
    
    // 處理回傳值
    long long returnValue;
    [invocation getReturnValue:&returnValue];
    NSLog(@"(%lu)> return %lld", (unsigned long)[self deep], returnValue);
    
    [self decDeep];
    return returnValue;
}

unsigned char unsignedCharMethodIMP(id self, SEL _cmd, ...)
{
    [self incDeep];
    NSLog(@"(%lu)> start %@ at %@", (unsigned long)[self deep], self, NSStringFromSelector(_cmd));
    
    // 建立 invocation, 並填入變數
    va_list list;
    va_start(list, _cmd);
    NSInvocation *invocation = createInvocation(self, _cmd, list);
    va_end(list);
    
    // 運行
    NSTimeInterval startTime = [[NSDate date] timeIntervalSince1970];
    [invocation invoke];
    NSLog(@"(%lu)> finish %@ at %@, use %fs", (unsigned long)[self deep], self, NSStringFromSelector(_cmd), [[NSDate date] timeIntervalSince1970] - startTime);
    
    // 處理回傳值
    unsigned char returnValue;
    [invocation getReturnValue:&returnValue];
    NSLog(@"(%lu)> return %c", (unsigned long)[self deep], returnValue);
    
    [self decDeep];
    return returnValue;
}

unsigned int unsignedIntMethodIMP(id self, SEL _cmd, ...)
{
    [self incDeep];
    NSLog(@"(%lu)> start %@ at %@", (unsigned long)[self deep], self, NSStringFromSelector(_cmd));
    
    // 建立 invocation, 並填入變數
    va_list list;
    va_start(list, _cmd);
    NSInvocation *invocation = createInvocation(self, _cmd, list);
    va_end(list);
    
    // 運行
    NSTimeInterval startTime = [[NSDate date] timeIntervalSince1970];
    [invocation invoke];
    NSLog(@"(%lu)> finish %@ at %@, use %fs", (unsigned long)[self deep], self, NSStringFromSelector(_cmd), [[NSDate date] timeIntervalSince1970] - startTime);
    
    // 處理回傳值
    unsigned int returnValue;
    [invocation getReturnValue:&returnValue];
    NSLog(@"(%lu)> return %i", (unsigned long)[self deep], returnValue);
    
    [self decDeep];
    return returnValue;
}

unsigned short unsignedShortMethodIMP(id self, SEL _cmd, ...)
{
    [self incDeep];
    NSLog(@"(%lu)> start %@ at %@", (unsigned long)[self deep], self, NSStringFromSelector(_cmd));
    
    // 建立 invocation, 並填入變數
    va_list list;
    va_start(list, _cmd);
    NSInvocation *invocation = createInvocation(self, _cmd, list);
    va_end(list);
    
    // 運行
    NSTimeInterval startTime = [[NSDate date] timeIntervalSince1970];
    [invocation invoke];
    NSLog(@"(%lu)> finish %@ at %@, use %fs", (unsigned long)[self deep], self, NSStringFromSelector(_cmd), [[NSDate date] timeIntervalSince1970] - startTime);
    
    // 處理回傳值
    unsigned short returnValue;
    [invocation getReturnValue:&returnValue];
    NSLog(@"(%lu)> return %i", (unsigned long)[self deep], returnValue);
    
    [self decDeep];
    return returnValue;
}

unsigned long unsignedLongMethodIMP(id self, SEL _cmd, ...)
{
    [self incDeep];
    NSLog(@"(%lu)> start %@ at %@", (unsigned long)[self deep], self, NSStringFromSelector(_cmd));
    
    // 建立 invocation, 並填入變數
    va_list list;
    va_start(list, _cmd);
    NSInvocation *invocation = createInvocation(self, _cmd, list);
    va_end(list);
    
    // 運行
    NSTimeInterval startTime = [[NSDate date] timeIntervalSince1970];
    [invocation invoke];
    NSLog(@"(%lu)> finish %@ at %@, use %fs", (unsigned long)[self deep], self, NSStringFromSelector(_cmd), [[NSDate date] timeIntervalSince1970] - startTime);
    
    // 處理回傳值
    unsigned long returnValue;
    [invocation getReturnValue:&returnValue];
    NSLog(@"(%lu)> return %lu", (unsigned long)[self deep], returnValue);
    
    [self decDeep];
    return returnValue;
}

unsigned long long unsignedLongLongMethodIMP(id self, SEL _cmd, ...)
{
    [self incDeep];
    NSLog(@"(%lu)> start %@ at %@", (unsigned long)[self deep], self, NSStringFromSelector(_cmd));
    
    // 建立 invocation, 並填入變數
    va_list list;
    va_start(list, _cmd);
    NSInvocation *invocation = createInvocation(self, _cmd, list);
    va_end(list);
    
    // 運行
    NSTimeInterval startTime = [[NSDate date] timeIntervalSince1970];
    [invocation invoke];
    NSLog(@"(%lu)> finish %@ at %@, use %fs", (unsigned long)[self deep], self, NSStringFromSelector(_cmd), [[NSDate date] timeIntervalSince1970] - startTime);
    
    // 處理回傳值
    unsigned long long returnValue;
    [invocation getReturnValue:&returnValue];
    NSLog(@"(%lu)> return %llu", (unsigned long)[self deep], returnValue);
    
    [self decDeep];
    return returnValue;
}

float floatMethodIMP(id self, SEL _cmd, ...)
{
    [self incDeep];
    NSLog(@"(%lu)> start %@ at %@", (unsigned long)[self deep], self, NSStringFromSelector(_cmd));
    
    // 建立 invocation, 並填入變數
    va_list list;
    va_start(list, _cmd);
    NSInvocation *invocation = createInvocation(self, _cmd, list);
    va_end(list);
    
    // 運行
    NSTimeInterval startTime = [[NSDate date] timeIntervalSince1970];
    [invocation invoke];
    NSLog(@"(%lu)> finish %@ at %@, use %fs", (unsigned long)[self deep], self, NSStringFromSelector(_cmd), [[NSDate date] timeIntervalSince1970] - startTime);
    
    // 處理回傳值
    float returnValue;
    [invocation getReturnValue:&returnValue];
    NSLog(@"(%lu)> return %f", (unsigned long)[self deep], returnValue);
    
    [self decDeep];
    return returnValue;
}

double doubleMethodIMP(id self, SEL _cmd, ...)
{
    [self incDeep];
    NSLog(@"(%lu)> start %@ at %@", (unsigned long)[self deep], self, NSStringFromSelector(_cmd));
    
    // 建立 invocation, 並填入變數
    va_list list;
    va_start(list, _cmd);
    NSInvocation *invocation = createInvocation(self, _cmd, list);
    va_end(list);
    
    // 運行
    NSTimeInterval startTime = [[NSDate date] timeIntervalSince1970];
    [invocation invoke];
    NSLog(@"(%lu)> finish %@ at %@, use %fs", (unsigned long)[self deep], self, NSStringFromSelector(_cmd), [[NSDate date] timeIntervalSince1970] - startTime);
    
    // 處理回傳值
    double returnValue;
    [invocation getReturnValue:&returnValue];
    NSLog(@"(%lu)> return %f", (unsigned long)[self deep], returnValue);
    
    [self decDeep];
    return returnValue;
}

BOOL boolMethodIMP(id self, SEL _cmd, ...)
{
    [self incDeep];
    NSLog(@"(%lu)> start %@ at %@", (unsigned long)[self deep], self, NSStringFromSelector(_cmd));
    
    // 建立 invocation, 並填入變數
    va_list list;
    va_start(list, _cmd);
    NSInvocation *invocation = createInvocation(self, _cmd, list);
    va_end(list);
    
    // 運行
    NSTimeInterval startTime = [[NSDate date] timeIntervalSince1970];
    [invocation invoke];
    NSLog(@"(%lu)> finish %@ at %@, use %fs", (unsigned long)[self deep], self, NSStringFromSelector(_cmd), [[NSDate date] timeIntervalSince1970] - startTime);
    
    // 處理回傳值
    BOOL returnValue;
    [invocation getReturnValue:&returnValue];
    NSLog(@"(%lu)> return %@", (unsigned long)[self deep], returnValue ? @"YES" : @"NO");
    
    [self decDeep];
    return returnValue;
}

void voidMethodIMP(id self, SEL _cmd, ...)
{
    [self incDeep];
    NSLog(@"(%lu)> start %@ at %@", (unsigned long)[self deep], self, NSStringFromSelector(_cmd));
    
    // 建立 invocation, 並填入變數
    va_list list;
    va_start(list, _cmd);
    NSInvocation *invocation = createInvocation(self, _cmd, list);
    va_end(list);
    
    // 運行
    NSTimeInterval startTime = [[NSDate date] timeIntervalSince1970];
    [invocation invoke];
    NSLog(@"(%lu)> finish %@ at %@, use %fs", (unsigned long)[self deep], self, NSStringFromSelector(_cmd), [[NSDate date] timeIntervalSince1970] - startTime);
    
    [self decDeep];
}

char *charPointerMethodIMP(id self, SEL _cmd, ...)
{
    [self incDeep];
    NSLog(@"(%lu)> start %@ at %@", (unsigned long)[self deep], self, NSStringFromSelector(_cmd));
    
    // 建立 invocation, 並填入變數
    va_list list;
    va_start(list, _cmd);
    NSInvocation *invocation = createInvocation(self, _cmd, list);
    va_end(list);
    
    // 運行
    NSTimeInterval startTime = [[NSDate date] timeIntervalSince1970];
    [invocation invoke];
    NSLog(@"(%lu)> finish %@ at %@, use %fs", (unsigned long)[self deep], self, NSStringFromSelector(_cmd), [[NSDate date] timeIntervalSince1970] - startTime);
    
    // 處理回傳值
    char *returnValue;
    [invocation getReturnValue:&returnValue];
    NSLog(@"(%lu)> return %s", (unsigned long)[self deep], returnValue);
    
    [self decDeep];
    return returnValue;
}

id idMethodIMP(id self, SEL _cmd, ...)
{
    [self incDeep];
    NSLog(@"(%lu)> start %@ at %@", (unsigned long)[self deep], self, NSStringFromSelector(_cmd));
    
    // 建立 invocation, 並填入變數
    va_list list;
    va_start(list, _cmd);
    NSInvocation *invocation = createInvocation(self, _cmd, list);
    va_end(list);
    
    // 運行
    NSTimeInterval startTime = [[NSDate date] timeIntervalSince1970];
    [invocation invoke];
    NSLog(@"(%lu)> finish %@ at %@, use %fs", (unsigned long)[self deep], self, NSStringFromSelector(_cmd), [[NSDate date] timeIntervalSince1970] - startTime);
    
    // 處理回傳值
    __unsafe_unretained id returnValue;
    [invocation getReturnValue:&returnValue];
    NSLog(@"(%lu)> return %@", (unsigned long)[self deep], returnValue);
    
    [self decDeep];
    return returnValue;
}

Class classMethodIMP(id self, SEL _cmd, ...)
{
    [self incDeep];
    NSLog(@"(%lu)> start %@ at %@", (unsigned long)[self deep], self, NSStringFromSelector(_cmd));
    
    // 建立 invocation, 並填入變數
    va_list list;
    va_start(list, _cmd);
    NSInvocation *invocation = createInvocation(self, _cmd, list);
    va_end(list);
    
    // 運行
    NSTimeInterval startTime = [[NSDate date] timeIntervalSince1970];
    [invocation invoke];
    NSLog(@"(%lu)> finish %@ at %@, use %fs", (unsigned long)[self deep], self, NSStringFromSelector(_cmd), [[NSDate date] timeIntervalSince1970] - startTime);
    
    // 處理回傳值
    Class returnValue;
    [invocation getReturnValue:&returnValue];
    NSLog(@"(%lu)> return %@", (unsigned long)[self deep], returnValue);
    
    [self decDeep];
    return returnValue;
}

SEL selMethodIMP(id self, SEL _cmd, ...)
{
    [self incDeep];
    NSLog(@"(%lu)> start %@ at %@", (unsigned long)[self deep], self, NSStringFromSelector(_cmd));
    
    // 建立 invocation, 並填入變數
    va_list list;
    va_start(list, _cmd);
    NSInvocation *invocation = createInvocation(self, _cmd, list);
    va_end(list);
    
    // 運行
    NSTimeInterval startTime = [[NSDate date] timeIntervalSince1970];
    [invocation invoke];
    NSLog(@"(%lu)> finish %@ at %@, use %fs", (unsigned long)[self deep], self, NSStringFromSelector(_cmd), [[NSDate date] timeIntervalSince1970] - startTime);
    
    // 處理回傳值
    SEL returnValue;
    [invocation getReturnValue:&returnValue];
    NSLog(@"(%lu)> return %@", (unsigned long)[self deep], NSStringFromSelector(returnValue));
    
    [self decDeep];
    return returnValue;
}

CGRect cgRectMethodIMP(id self, SEL _cmd, ...)
{
    [self incDeep];
    NSLog(@"(%lu)> start %@ at %@", (unsigned long)[self deep], self, NSStringFromSelector(_cmd));
    
    // 建立 invocation, 並填入變數
    va_list list;
    va_start(list, _cmd);
    NSInvocation *invocation = createInvocation(self, _cmd, list);
    va_end(list);
    
    // 運行
    NSTimeInterval startTime = [[NSDate date] timeIntervalSince1970];
    [invocation invoke];
    NSLog(@"(%lu)> finish %@ at %@, use %fs", (unsigned long)[self deep], self, NSStringFromSelector(_cmd), [[NSDate date] timeIntervalSince1970] - startTime);
    
    // 處理回傳值
    CGRect returnValue;
    [invocation getReturnValue:&returnValue];
    NSLog(@"(%lu)> return %@", (unsigned long)[self deep], NSStringFromCGRect(returnValue));
    
    [self decDeep];
    return returnValue;
}

CGPoint cgPointMethodIMP(id self, SEL _cmd, ...)
{
    [self incDeep];
    NSLog(@"(%lu)> start %@ at %@", (unsigned long)[self deep], self, NSStringFromSelector(_cmd));
    
    // 建立 invocation, 並填入變數
    va_list list;
    va_start(list, _cmd);
    NSInvocation *invocation = createInvocation(self, _cmd, list);
    va_end(list);
    
    // 運行
    NSTimeInterval startTime = [[NSDate date] timeIntervalSince1970];
    [invocation invoke];
    NSLog(@"(%lu)> finish %@ at %@, use %fs", (unsigned long)[self deep], self, NSStringFromSelector(_cmd), [[NSDate date] timeIntervalSince1970] - startTime);
    
    // 處理回傳值
    CGPoint returnValue;
    [invocation getReturnValue:&returnValue];
    NSLog(@"(%lu)> return %@", (unsigned long)[self deep], NSStringFromCGPoint(returnValue));
    
    [self decDeep];
    return returnValue;
}

CGSize cgSizeMethodIMP(id self, SEL _cmd, ...)
{
    [self incDeep];
    NSLog(@"(%lu)> start %@ at %@", (unsigned long)[self deep], self, NSStringFromSelector(_cmd));
    
    // 建立 invocation, 並填入變數
    va_list list;
    va_start(list, _cmd);
    NSInvocation *invocation = createInvocation(self, _cmd, list);
    va_end(list);
    
    // 運行
    NSTimeInterval startTime = [[NSDate date] timeIntervalSince1970];
    [invocation invoke];
    NSLog(@"(%lu)> finish %@ at %@, use %fs", (unsigned long)[self deep], self, NSStringFromSelector(_cmd), [[NSDate date] timeIntervalSince1970] - startTime);
    
    // 處理回傳值
    CGSize returnValue;
    [invocation getReturnValue:&returnValue];
    NSLog(@"(%lu)> return %@", (unsigned long)[self deep], NSStringFromCGSize(returnValue));
    
    [self decDeep];
    return returnValue;
}

CGAffineTransform cgAffineTransformMethodIMP(id self, SEL _cmd, ...)
{
    [self incDeep];
    NSLog(@"(%lu)> start %@ at %@", (unsigned long)[self deep], self, NSStringFromSelector(_cmd));
    
    // 建立 invocation, 並填入變數
    va_list list;
    va_start(list, _cmd);
    NSInvocation *invocation = createInvocation(self, _cmd, list);
    va_end(list);
    
    // 運行
    NSTimeInterval startTime = [[NSDate date] timeIntervalSince1970];
    [invocation invoke];
    NSLog(@"(%lu)> finish %@ at %@, use %fs", (unsigned long)[self deep], self, NSStringFromSelector(_cmd), [[NSDate date] timeIntervalSince1970] - startTime);
    
    // 處理回傳值
    CGAffineTransform returnValue;
    [invocation getReturnValue:&returnValue];
    NSLog(@"(%lu)> return %@", (unsigned long)[self deep], NSStringFromCGAffineTransform(returnValue));
    
    [self decDeep];
    return returnValue;
}

UIEdgeInsets uiEdgeInsetsMethodIMP(id self, SEL _cmd, ...)
{
    [self incDeep];
    NSLog(@"(%lu)> start %@ at %@", (unsigned long)[self deep], self, NSStringFromSelector(_cmd));
    
    // 建立 invocation, 並填入變數
    va_list list;
    va_start(list, _cmd);
    NSInvocation *invocation = createInvocation(self, _cmd, list);
    va_end(list);
    
    // 運行
    NSTimeInterval startTime = [[NSDate date] timeIntervalSince1970];
    [invocation invoke];
    NSLog(@"(%lu)> finish %@ at %@, use %fs", (unsigned long)[self deep], self, NSStringFromSelector(_cmd), [[NSDate date] timeIntervalSince1970] - startTime);
    
    // 處理回傳值
    UIEdgeInsets returnValue;
    [invocation getReturnValue:&returnValue];
    NSLog(@"(%lu)> return %@", (unsigned long)[self deep], NSStringFromUIEdgeInsets(returnValue));
    
    [self decDeep];
    return returnValue;
}

UIOffset uiOffsetMethodIMP(id self, SEL _cmd, ...)
{
    [self incDeep];
    NSLog(@"(%lu)> start %@ at %@", (unsigned long)[self deep], self, NSStringFromSelector(_cmd));
    
    // 建立 invocation, 並填入變數
    va_list list;
    va_start(list, _cmd);
    NSInvocation *invocation = createInvocation(self, _cmd, list);
    va_end(list);
    
    // 運行
    NSTimeInterval startTime = [[NSDate date] timeIntervalSince1970];
    [invocation invoke];
    NSLog(@"(%lu)> finish %@ at %@, use %fs", (unsigned long)[self deep], self, NSStringFromSelector(_cmd), [[NSDate date] timeIntervalSince1970] - startTime);
    
    // 處理回傳值
    UIOffset returnValue;
    [invocation getReturnValue:&returnValue];
    NSLog(@"(%lu)> return %@", (unsigned long)[self deep], NSStringFromUIOffset(returnValue));
    
    [self decDeep];
    return returnValue;
}
