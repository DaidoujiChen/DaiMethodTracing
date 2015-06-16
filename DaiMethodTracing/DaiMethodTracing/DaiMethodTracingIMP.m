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
        
        [argumentLogString appendFormat:@"(StackSymbol %@)> arg%td ", deep, i - 1];
        
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
                [argumentLogString appendFormat:@"(%@) %@", objectAnalyze(argumentType), argument];
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

// 把 method 的原貌還原出來
NSString *methodFace(id self, SEL _cmd)
{
    NSString *methodName = NSStringFromSelector(_cmd);
    SEL swizzlingSelector = NSSelectorFromString([NSString stringWithFormat:@"%@%@", swizzlingPrefix, methodName]);
    NSMethodSignature *signature = [self methodSignatureForSelector:swizzlingSelector];
    
    NSMutableString *methodFacesString = [NSMutableString string];
    [methodFacesString appendFormat:@"%@ ", [self respondsToSelector:@selector(isSubclassOfClass:)] ? @"+" : @"-"];
    
    // 回傳型別
    NSString *returnType = [NSString stringWithFormat:@"%s", signature.methodReturnType];
    switch (tracingType(returnType)) {
        case DaiMethodTracingTypeChar:
            [methodFacesString appendString:@"(char)"];
            break;
            
        case DaiMethodTracingTypeInt:
            [methodFacesString appendString:@"(int)"];
            break;
            
        case DaiMethodTracingTypeShort:
            [methodFacesString appendString:@"(short)"];
            break;
            
        case DaiMethodTracingTypeLong:
            [methodFacesString appendString:@"(long)"];
            break;
            
        case DaiMethodTracingTypeLongLong:
            [methodFacesString appendString:@"(long long)"];
            break;
            
        case DaiMethodTracingTypeUnsignedChar:
            [methodFacesString appendString:@"(unsigened char)"];
            break;
            
        case DaiMethodTracingTypeUnsignedInt:
            [methodFacesString appendString:@"(unsigened int)"];
            break;
            
        case DaiMethodTracingTypeUnsignedShort:
            [methodFacesString appendString:@"(unsigened short)"];
            break;
            
        case DaiMethodTracingTypeUnsignedLong:
            [methodFacesString appendString:@"(unsigened long)"];
            break;
            
        case DaiMethodTracingTypeUnsignedLongLong:
            [methodFacesString appendString:@"(unsigened long long)"];
            break;
            
        case DaiMethodTracingTypeFloat:
            [methodFacesString appendString:@"(float)"];
            break;
            
        case DaiMethodTracingTypeDouble:
            [methodFacesString appendString:@"(double)"];
            break;
            
        case DaiMethodTracingTypeBool:
            [methodFacesString appendString:@"(BOOL)"];
            break;
            
        case DaiMethodTracingTypeVoidPointer:
            [methodFacesString appendFormat:@"(%@)", voidPointerAnalyze(returnType)];
            break;
            
        case DaiMethodTracingTypeCharPointer:
            [methodFacesString appendString:@"(char *)"];
            break;
            
        case DaiMethodTracingTypeObject:
            [methodFacesString appendFormat:@"(%@)", objectAnalyze(returnType)];
            break;
            
        case DaiMethodTracingTypeClass:
            [methodFacesString appendString:@"(Class)"];
            break;
            
        case DaiMethodTracingTypeSelector:
            [methodFacesString appendString:@"(SEL)"];
            break;
            
        case DaiMethodTracingTypeCGRect:
            [methodFacesString appendString:@"(CGRect)"];
            break;
            
        case DaiMethodTracingTypeCGPoint:
            [methodFacesString appendString:@"(CGPoint)"];
            break;
            
        case DaiMethodTracingTypeCGSize:
            [methodFacesString appendString:@"(CGSize)"];
            break;
            
        case DaiMethodTracingTypeCGAffineTransform:
            [methodFacesString appendString:@"(CGAffineTransform)"];
            break;
            
        case DaiMethodTracingTypeUIEdgeInsets:
            [methodFacesString appendString:@"(UIEdgeInsets)"];
            break;
            
        case DaiMethodTracingTypeUIOffset:
            [methodFacesString appendString:@"(UIOffset)"];
            break;
            
        default:
            [methodFacesString appendString:@"(void)"];
            break;
    }
    
    NSArray *splitSelector = [methodName componentsSeparatedByString:@":"];
    for (NSUInteger i = 0; i < splitSelector.count; i++) {
        [methodFacesString appendFormat:@"%@", splitSelector[i]];
        
        NSUInteger argumentIndex = i + 2;
        if (argumentIndex < signature.numberOfArguments) {
            [methodFacesString appendString:@":"];
            NSString *argumentType = [NSString stringWithFormat:@"%s", [signature getArgumentTypeAtIndex:argumentIndex]];
            switch (tracingType(argumentType)) {
                case DaiMethodTracingTypeChar:
                    [methodFacesString appendString:@"(char) "];
                    break;
                    
                case DaiMethodTracingTypeInt:
                    [methodFacesString appendString:@"(int) "];
                    break;
                    
                case DaiMethodTracingTypeShort:
                    [methodFacesString appendString:@"(short) "];
                    break;
                    
                case DaiMethodTracingTypeLong:
                    [methodFacesString appendString:@"(long) "];
                    break;
                    
                case DaiMethodTracingTypeLongLong:
                    [methodFacesString appendString:@"(long long) "];
                    break;
                    
                case DaiMethodTracingTypeUnsignedChar:
                    [methodFacesString appendString:@"(unsigened char) "];
                    break;
                    
                case DaiMethodTracingTypeUnsignedInt:
                    [methodFacesString appendString:@"(unsigened int) "];
                    break;
                    
                case DaiMethodTracingTypeUnsignedShort:
                    [methodFacesString appendString:@"(unsigened short) "];
                    break;
                    
                case DaiMethodTracingTypeUnsignedLong:
                    [methodFacesString appendString:@"(unsigened long) "];
                    break;
                    
                case DaiMethodTracingTypeUnsignedLongLong:
                    [methodFacesString appendString:@"(unsigened long long) "];
                    break;
                    
                case DaiMethodTracingTypeFloat:
                    [methodFacesString appendString:@"(float) "];
                    break;
                    
                case DaiMethodTracingTypeDouble:
                    [methodFacesString appendString:@"(double) "];
                    break;
                    
                case DaiMethodTracingTypeBool:
                    [methodFacesString appendString:@"(BOOL) "];
                    break;
                    
                case DaiMethodTracingTypeVoidPointer:
                    [methodFacesString appendFormat:@"(%@)", voidPointerAnalyze(argumentType)];
                    break;
                    
                case DaiMethodTracingTypeCharPointer:
                    [methodFacesString appendString:@"(char *)"];
                    break;
                    
                case DaiMethodTracingTypeObject:
                    [methodFacesString appendFormat:@"(%@) ", objectAnalyze(argumentType)];
                    break;
                    
                case DaiMethodTracingTypeClass:
                    [methodFacesString appendString:@"(Class) "];
                    break;
                    
                case DaiMethodTracingTypeSelector:
                    [methodFacesString appendString:@"(SEL) "];
                    break;
                    
                case DaiMethodTracingTypeCGRect:
                    [methodFacesString appendString:@"(CGRect) "];
                    break;
                    
                case DaiMethodTracingTypeCGPoint:
                    [methodFacesString appendString:@"(CGPoint) "];
                    break;
                    
                case DaiMethodTracingTypeCGSize:
                    [methodFacesString appendString:@"(CGSize) "];
                    break;
                    
                case DaiMethodTracingTypeCGAffineTransform:
                    [methodFacesString appendString:@"(CGAffineTransform) "];
                    break;
                    
                case DaiMethodTracingTypeUIEdgeInsets:
                    [methodFacesString appendString:@"(UIEdgeInsets) "];
                    break;
                    
                case DaiMethodTracingTypeUIOffset:
                    [methodFacesString appendString:@"(UIOffset) "];
                    break;
                    
                default:
                    [methodFacesString appendString:@"(void) "];
                    break;
            }
        }
    }

    return methodFacesString;
}

#pragma mark - public function

NSString *stackSymbol()
{
    NSString *stackSymbol = [[NSThread callStackSymbols] lastObject];
    NSArray *splitStackSymbol = [stackSymbol componentsSeparatedByString:@" "];
    return [splitStackSymbol firstObject];
}

char charMethodIMP(id self, SEL _cmd, ...)
{
    NSString *deep = stackSymbol();
    NSLog(@"(StackSymbol %@)> start %@ at %@", deep, self, methodFace(self, _cmd));
    
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
    NSLog(@"(StackSymbol %@)> return %c", deep, returnValue);
    
    NSLog(@"(StackSymbol %@)> finish %@ at %@, use %fs", deep, self, methodFace(self, _cmd), [[NSDate date] timeIntervalSince1970] - startTime);
    return returnValue;
}

int intMethodIMP(id self, SEL _cmd, ...)
{
    NSString *deep = stackSymbol();
    NSLog(@"(StackSymbol %@)> start %@ at %@", deep, self, methodFace(self, _cmd));
    
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
    NSLog(@"(StackSymbol %@)> return %c", deep, returnValue);
    
    NSLog(@"(StackSymbol %@)> finish %@ at %@, use %fs", deep, self, methodFace(self, _cmd), [[NSDate date] timeIntervalSince1970] - startTime);
    return returnValue;
}

short shortMethodIMP(id self, SEL _cmd, ...)
{
    NSString *deep = stackSymbol();
    NSLog(@"(StackSymbol %@)> start %@ at %@", deep, self, methodFace(self, _cmd));
    
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
    NSLog(@"(StackSymbol %@)> return %c", deep, returnValue);
    
    NSLog(@"(StackSymbol %@)> finish %@ at %@, use %fs", deep, self, methodFace(self, _cmd), [[NSDate date] timeIntervalSince1970] - startTime);
    return returnValue;
}

long longMethodIMP(id self, SEL _cmd, ...)
{
    NSString *deep = stackSymbol();
    NSLog(@"(StackSymbol %@)> start %@ at %@", deep, self, methodFace(self, _cmd));
    
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
    NSLog(@"(StackSymbol %@)> return %ld", deep, returnValue);
    
    NSLog(@"(StackSymbol %@)> finish %@ at %@, use %fs", deep, self, methodFace(self, _cmd), [[NSDate date] timeIntervalSince1970] - startTime);
    return returnValue;
}

long long longlongMethodIMP(id self, SEL _cmd, ...)
{
    NSString *deep = stackSymbol();
    NSLog(@"(StackSymbol %@)> start %@ at %@", deep, self, methodFace(self, _cmd));
    
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
    NSLog(@"(StackSymbol %@)> return %lld", deep, returnValue);
    
    NSLog(@"(StackSymbol %@)> finish %@ at %@, use %fs", deep, self, methodFace(self, _cmd), [[NSDate date] timeIntervalSince1970] - startTime);
    return returnValue;
}

unsigned char unsignedCharMethodIMP(id self, SEL _cmd, ...)
{
    NSString *deep = stackSymbol();
    NSLog(@"(StackSymbol %@)> start %@ at %@", deep, self, methodFace(self, _cmd));
    
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
    NSLog(@"(StackSymbol %@)> return %c", deep, returnValue);
    
    NSLog(@"(StackSymbol %@)> finish %@ at %@, use %fs", deep, self, methodFace(self, _cmd), [[NSDate date] timeIntervalSince1970] - startTime);
    return returnValue;
}

unsigned int unsignedIntMethodIMP(id self, SEL _cmd, ...)
{
    NSString *deep = stackSymbol();
    NSLog(@"(StackSymbol %@)> start %@ at %@", deep, self, methodFace(self, _cmd));
    
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
    NSLog(@"(StackSymbol %@)> return %c", deep, returnValue);
    
    NSLog(@"(StackSymbol %@)> finish %@ at %@, use %fs", deep, self, methodFace(self, _cmd), [[NSDate date] timeIntervalSince1970] - startTime);
    return returnValue;
}

unsigned short unsignedShortMethodIMP(id self, SEL _cmd, ...)
{
    NSString *deep = stackSymbol();
    NSLog(@"(StackSymbol %@)> start %@ at %@", deep, self, methodFace(self, _cmd));
    
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
    NSLog(@"(StackSymbol %@)> return %c", deep, returnValue);
    
    NSLog(@"(StackSymbol %@)> finish %@ at %@, use %fs", deep, self, methodFace(self, _cmd), [[NSDate date] timeIntervalSince1970] - startTime);
    return returnValue;
}

unsigned long unsignedLongMethodIMP(id self, SEL _cmd, ...)
{
    NSString *deep = stackSymbol();
    NSLog(@"(StackSymbol %@)> start %@ at %@", deep, self, methodFace(self, _cmd));
    
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
    NSLog(@"(StackSymbol %@)> return %lu", deep, returnValue);
    
    NSLog(@"(StackSymbol %@)> finish %@ at %@, use %fs", deep, self, methodFace(self, _cmd), [[NSDate date] timeIntervalSince1970] - startTime);
    return returnValue;
}

unsigned long long unsignedLongLongMethodIMP(id self, SEL _cmd, ...)
{
    NSString *deep = stackSymbol();
    NSLog(@"(StackSymbol %@)> start %@ at %@", deep, self, methodFace(self, _cmd));
    
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
    NSLog(@"(StackSymbol %@)> return %llu", deep, returnValue);
    
    NSLog(@"(StackSymbol %@)> finish %@ at %@, use %fs", deep, self, methodFace(self, _cmd), [[NSDate date] timeIntervalSince1970] - startTime);
    return returnValue;
}

float floatMethodIMP(id self, SEL _cmd, ...)
{
    NSString *deep = stackSymbol();
    NSLog(@"(StackSymbol %@)> start %@ at %@", deep, self, methodFace(self, _cmd));
    
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
    NSLog(@"(StackSymbol %@)> return %f", deep, returnValue);
    
    NSLog(@"(StackSymbol %@)> finish %@ at %@, use %fs", deep, self, methodFace(self, _cmd), [[NSDate date] timeIntervalSince1970] - startTime);
    return returnValue;
}

double doubleMethodIMP(id self, SEL _cmd, ...)
{
    NSString *deep = stackSymbol();
    NSLog(@"(StackSymbol %@)> start %@ at %@", deep, self, methodFace(self, _cmd));
    
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
    NSLog(@"(StackSymbol %@)> return %f", deep, returnValue);
    
    NSLog(@"(StackSymbol %@)> finish %@ at %@, use %fs", deep, self, methodFace(self, _cmd), [[NSDate date] timeIntervalSince1970] - startTime);
    return returnValue;
}

BOOL boolMethodIMP(id self, SEL _cmd, ...)
{
    NSString *deep = stackSymbol();
    NSLog(@"(StackSymbol %@)> start %@ at %@", deep, self, methodFace(self, _cmd));
    
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
    NSLog(@"(StackSymbol %@)> return %@", deep, returnValue ? @"YES" : @"NO");
    
    NSLog(@"(StackSymbol %@)> finish %@ at %@, use %fs", deep, self, methodFace(self, _cmd), [[NSDate date] timeIntervalSince1970] - startTime);
    return returnValue;
}

void voidMethodIMP(id self, SEL _cmd, ...)
{
    NSString *deep = stackSymbol();
    NSLog(@"(StackSymbol %@)> start %@ at %@", deep, self, methodFace(self, _cmd));
    
    // 建立 invocation, 並填入變數
    va_list list;
    va_start(list, _cmd);
    NSInvocation *invocation = createInvocation(self, _cmd, list, deep);
    va_end(list);
    
    // 運行
    NSTimeInterval startTime = [[NSDate date] timeIntervalSince1970];
    [invocation invoke];
    
    NSLog(@"(StackSymbol %@)> return void", deep);
    NSLog(@"(StackSymbol %@)> finish %@ at %@, use %fs", deep, self, methodFace(self, _cmd), [[NSDate date] timeIntervalSince1970] - startTime);
}

void *voidPointerMethodIMP(id self, SEL _cmd, ...)
{
    NSString *deep = stackSymbol();
    NSLog(@"(StackSymbol %@)> start %@ at %@", deep, self, methodFace(self, _cmd));
    
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
    NSLog(@"(StackSymbol %@)> return %s", deep, returnValue);
    
    NSLog(@"(StackSymbol %@)> finish %@ at %@, use %fs", deep, self, methodFace(self, _cmd), [[NSDate date] timeIntervalSince1970] - startTime);
    return returnValue;
}

char *charPointerMethodIMP(id self, SEL _cmd, ...)
{
    NSString *deep = stackSymbol();
    NSLog(@"(StackSymbol %@)> start %@ at %@", deep, self, methodFace(self, _cmd));
    
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
    NSLog(@"(StackSymbol %@)> return %s", deep, returnValue);
    
    NSLog(@"(StackSymbol %@)> finish %@ at %@, use %fs", deep, self, methodFace(self, _cmd), [[NSDate date] timeIntervalSince1970] - startTime);
    return returnValue;
}

id objectMethodIMP(id self, SEL _cmd, ...)
{
    NSString *deep = stackSymbol();
    NSLog(@"(StackSymbol %@)> start %@ at %@", deep, self, methodFace(self, _cmd));
    
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
    NSLog(@"(StackSymbol %@)> return %@", deep, returnValue);
    
    NSLog(@"(StackSymbol %@)> finish %@ at %@, use %fs", deep, self, methodFace(self, _cmd), [[NSDate date] timeIntervalSince1970] - startTime);
    return returnValue;
}

Class classMethodIMP(id self, SEL _cmd, ...)
{
    NSString *deep = stackSymbol();
    NSLog(@"(StackSymbol %@)> start %@ at %@", deep, self, methodFace(self, _cmd));
    
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
    NSLog(@"(StackSymbol %@)> return %@", deep, returnValue);
    
    NSLog(@"(StackSymbol %@)> finish %@ at %@, use %fs", deep, self, methodFace(self, _cmd), [[NSDate date] timeIntervalSince1970] - startTime);
    return returnValue;
}

SEL selectorMethodIMP(id self, SEL _cmd, ...)
{
    NSString *deep = stackSymbol();
    NSLog(@"(StackSymbol %@)> start %@ at %@", deep, self, methodFace(self, _cmd));
    
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
    NSLog(@"(StackSymbol %@)> return %@", deep, NSStringFromSelector(returnValue));
    
    NSLog(@"(StackSymbol %@)> finish %@ at %@, use %fs", deep, self, methodFace(self, _cmd), [[NSDate date] timeIntervalSince1970] - startTime);
    return returnValue;
}

CGRect cgRectMethodIMP(id self, SEL _cmd, ...)
{
    NSString *deep = stackSymbol();
    NSLog(@"(StackSymbol %@)> start %@ at %@", deep, self, methodFace(self, _cmd));
    
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
    NSLog(@"(StackSymbol %@)> return %@", deep, NSStringFromCGRect(returnValue));
    
    NSLog(@"(StackSymbol %@)> finish %@ at %@, use %fs", deep, self, methodFace(self, _cmd), [[NSDate date] timeIntervalSince1970] - startTime);
    return returnValue;
}

CGPoint cgPointMethodIMP(id self, SEL _cmd, ...)
{
    NSString *deep = stackSymbol();
    NSLog(@"(StackSymbol %@)> start %@ at %@", deep, self, methodFace(self, _cmd));
    
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
    NSLog(@"(StackSymbol %@)> return %@", deep, NSStringFromCGPoint(returnValue));
    
    NSLog(@"(StackSymbol %@)> finish %@ at %@, use %fs", deep, self, methodFace(self, _cmd), [[NSDate date] timeIntervalSince1970] - startTime);
    return returnValue;
}

CGSize cgSizeMethodIMP(id self, SEL _cmd, ...)
{
    NSString *deep = stackSymbol();
    NSLog(@"(StackSymbol %@)> start %@ at %@", deep, self, methodFace(self, _cmd));
    
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
    NSLog(@"(StackSymbol %@)> return %@", deep, NSStringFromCGSize(returnValue));
    
    NSLog(@"(StackSymbol %@)> finish %@ at %@, use %fs", deep, self, methodFace(self, _cmd), [[NSDate date] timeIntervalSince1970] - startTime);
    return returnValue;
}

CGAffineTransform cgAffineTransformMethodIMP(id self, SEL _cmd, ...)
{
    NSString *deep = stackSymbol();
    NSLog(@"(StackSymbol %@)> start %@ at %@", deep, self, methodFace(self, _cmd));
    
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
    NSLog(@"(StackSymbol %@)> return %@", deep, NSStringFromCGAffineTransform(returnValue));
    
    NSLog(@"(StackSymbol %@)> finish %@ at %@, use %fs", deep, self, methodFace(self, _cmd), [[NSDate date] timeIntervalSince1970] - startTime);
    return returnValue;
}

UIEdgeInsets uiEdgeInsetsMethodIMP(id self, SEL _cmd, ...)
{
    NSString *deep = stackSymbol();
    NSLog(@"(StackSymbol %@)> start %@ at %@", deep, self, methodFace(self, _cmd));
    
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
    NSLog(@"(StackSymbol %@)> return %@", deep, NSStringFromUIEdgeInsets(returnValue));
    
    NSLog(@"(StackSymbol %@)> finish %@ at %@, use %fs", deep, self, methodFace(self, _cmd), [[NSDate date] timeIntervalSince1970] - startTime);
    return returnValue;
}

UIOffset uiOffsetMethodIMP(id self, SEL _cmd, ...)
{
    NSString *deep = stackSymbol();
    NSLog(@"(StackSymbol %@)> start %@ at %@", deep, self, methodFace(self, _cmd));
    
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
    NSLog(@"(StackSymbol %@)> return %@", deep, NSStringFromUIOffset(returnValue));
    
    NSLog(@"(StackSymbol %@)> finish %@ at %@, use %fs", deep, self, methodFace(self, _cmd), [[NSDate date] timeIntervalSince1970] - startTime);
    return returnValue;
}
