//
//  DaiMethodTracingLog.m
//  DaiMethodTracing
//
//  Created by DaidoujiChen on 2015/6/16.
//  Copyright (c) 2015年 ChilunChen. All rights reserved.
//

#import "DaiMethodTracingLog.h"
#import <objc/runtime.h>
#import "DaiMethodTracingDefine.h"
#import "DaiMethodTracingType.h"

@implementation DaiMethodTracingLog

#pragma mark - class method

+ (void)tracingLog:(NSString *)log stack:(NSString *)stack logType:(DaiMethodTracingLogType)logType
{
    NSMutableString *emptyString = [NSMutableString string];
    for (int i = 0; i < stack.integerValue / 2; i++) {
        [emptyString appendString:@" "];
    }
    
    switch (logType) {
        case DaiMethodTracingLogStart:
        {
            NSString *threadNumber = [NSString stringWithFormat:@"%td", [[[NSThread currentThread] valueForKeyPath:@"private.seqNum"] integerValue]];
            printf("\n%s(thread:%s) %s\n", [emptyString UTF8String], [threadNumber UTF8String], [log UTF8String]);
            break;
        }
        case DaiMethodTracingLogArgument:
            printf("%s  ⥤ %s\n", [emptyString UTF8String], [log UTF8String]);
            break;
        case DaiMethodTracingLogReturn:
            printf("%s   %s;\n", [emptyString UTF8String], [log UTF8String]);
            break;
        case DaiMethodTracingLogFinish:
            printf("%s%s\n\n", [emptyString UTF8String], [log UTF8String]);
            break;
    }
}

+ (NSString *)methodFace:(id)target aSelector:(SEL)aSelector
{
    NSString *methodName = NSStringFromSelector(aSelector);
    SEL swizzlingSelector = NSSelectorFromString([NSString stringWithFormat:@"%@%@", swizzlingPrefix, methodName]);
    NSMethodSignature *signature;
    if ([target respondsToSelector:swizzlingSelector]) {
        signature = [target methodSignatureForSelector:swizzlingSelector];
    } else {
        signature = [target methodSignatureForSelector:aSelector];
    }
    
    NSMutableString *methodFacesString = [NSMutableString string];
    [methodFacesString appendFormat:@"%@ ", [target respondsToSelector:@selector(isSubclassOfClass:)] ? @"+" : @"-"];
    
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

// 把 block 的原貌還原出來
+ (NSString *)blockFaces:(NSMethodSignature *)signature
{
    NSMutableString *blockFacesString = [NSMutableString string];
    [blockFacesString appendString:@"^"];
    
    // 回傳型別
    NSString *returnType = [NSString stringWithFormat:@"%s", signature.methodReturnType];
    switch (tracingType(returnType)) {
        case DaiMethodTracingTypeChar:
            [blockFacesString appendString:@"char"];
            break;
            
        case DaiMethodTracingTypeInt:
            [blockFacesString appendString:@"int"];
            break;
            
        case DaiMethodTracingTypeShort:
            [blockFacesString appendString:@"short"];
            break;
            
        case DaiMethodTracingTypeLong:
            [blockFacesString appendString:@"long"];
            break;
            
        case DaiMethodTracingTypeLongLong:
            [blockFacesString appendString:@"long long"];
            break;
            
        case DaiMethodTracingTypeUnsignedChar:
            [blockFacesString appendString:@"unsigened char"];
            break;
            
        case DaiMethodTracingTypeUnsignedInt:
            [blockFacesString appendString:@"unsigened int"];
            break;
            
        case DaiMethodTracingTypeUnsignedShort:
            [blockFacesString appendString:@"unsigened short"];
            break;
            
        case DaiMethodTracingTypeUnsignedLong:
            [blockFacesString appendString:@"unsigened long"];
            break;
            
        case DaiMethodTracingTypeUnsignedLongLong:
            [blockFacesString appendString:@"unsigened long long"];
            break;
            
        case DaiMethodTracingTypeFloat:
            [blockFacesString appendString:@"float"];
            break;
            
        case DaiMethodTracingTypeDouble:
            [blockFacesString appendString:@"double"];
            break;
            
        case DaiMethodTracingTypeBool:
            [blockFacesString appendString:@"BOOL"];
            break;
            
        case DaiMethodTracingTypeVoidPointer:
            [blockFacesString appendFormat:@"%@", voidPointerAnalyze(returnType)];
            break;
            
        case DaiMethodTracingTypeCharPointer:
            [blockFacesString appendString:@"char*"];
            break;
            
        case DaiMethodTracingTypeObject:
            [blockFacesString appendFormat:@"%@", objectAnalyze(returnType)];
            break;
            
        case DaiMethodTracingTypeClass:
            [blockFacesString appendString:@"Class"];
            break;
            
        case DaiMethodTracingTypeSelector:
            [blockFacesString appendString:@"SEL"];
            break;
            
        case DaiMethodTracingTypeCGRect:
            [blockFacesString appendString:@"CGRect"];
            break;
            
        case DaiMethodTracingTypeCGPoint:
            [blockFacesString appendString:@"CGPoint"];
            break;
            
        case DaiMethodTracingTypeCGSize:
            [blockFacesString appendString:@"CGSize"];
            break;
            
        case DaiMethodTracingTypeCGAffineTransform:
            [blockFacesString appendString:@"CGAffineTransform"];
            break;
            
        case DaiMethodTracingTypeUIEdgeInsets:
            [blockFacesString appendString:@"UIEdgeInsets"];
            break;
            
        case DaiMethodTracingTypeUIOffset:
            [blockFacesString appendString:@"UIOffset"];
            break;
            
        default:
            [blockFacesString appendString:@"void"];
            break;
    }
    
    [blockFacesString appendString:@"("];
    
    // 各參數型別
    NSMutableArray *argumentTypes = [NSMutableArray array];
    for (unsigned i = 1; i < signature.numberOfArguments; i++) {
        NSString *argumentType = [NSString stringWithFormat:@"%s", [signature getArgumentTypeAtIndex:i]];
        switch (tracingType(argumentType)) {
            case DaiMethodTracingTypeChar:
                [argumentTypes addObject:@"char"];
                break;
                
            case DaiMethodTracingTypeInt:
                [argumentTypes addObject:@"int"];
                break;
                
            case DaiMethodTracingTypeShort:
                [argumentTypes addObject:@"short"];
                break;
                
            case DaiMethodTracingTypeLong:
                [argumentTypes addObject:@"long"];
                break;
                
            case DaiMethodTracingTypeLongLong:
                [argumentTypes addObject:@"long long"];
                break;
                
            case DaiMethodTracingTypeUnsignedChar:
                [argumentTypes addObject:@"unsigened char"];
                break;
                
            case DaiMethodTracingTypeUnsignedInt:
                [argumentTypes addObject:@"unsigened int"];
                break;
                
            case DaiMethodTracingTypeUnsignedShort:
                [argumentTypes addObject:@"unsigened short"];
                break;
                
            case DaiMethodTracingTypeUnsignedLong:
                [argumentTypes addObject:@"unsigened long"];
                break;
                
            case DaiMethodTracingTypeUnsignedLongLong:
                [argumentTypes addObject:@"unsigened long long"];
                break;
                
            case DaiMethodTracingTypeFloat:
                [argumentTypes addObject:@"float"];
                break;
                
            case DaiMethodTracingTypeDouble:
                [argumentTypes addObject:@"double"];
                break;
                
            case DaiMethodTracingTypeBool:
                [argumentTypes addObject:@"BOOL"];
                break;
                
            case DaiMethodTracingTypeVoidPointer:
                [argumentTypes addObject:voidPointerAnalyze(argumentType)];
                break;
                
            case DaiMethodTracingTypeCharPointer:
                [argumentTypes addObject:@"char *"];
                break;
                
            case DaiMethodTracingTypeObject:
                [argumentTypes addObject:objectAnalyze(argumentType)];
                break;
                
            case DaiMethodTracingTypeClass:
                [argumentTypes addObject:@"Class"];
                break;
                
            case DaiMethodTracingTypeSelector:
                [argumentTypes addObject:@"SEL"];
                break;
                
            case DaiMethodTracingTypeCGRect:
                [argumentTypes addObject:@"CGRect"];
                break;
                
            case DaiMethodTracingTypeCGPoint:
                [argumentTypes addObject:@"CGPoint"];
                break;
                
            case DaiMethodTracingTypeCGSize:
                [argumentTypes addObject:@"CGSize"];
                break;
                
            case DaiMethodTracingTypeCGAffineTransform:
                [argumentTypes addObject:@"CGAffineTransform"];
                break;
                
            case DaiMethodTracingTypeUIEdgeInsets:
                [argumentTypes addObject:@"UIEdgeInsets"];
                break;
                
            case DaiMethodTracingTypeUIOffset:
                [argumentTypes addObject:@"UIOffset"];
                break;
                
            default:
                [argumentTypes addObject:@"void"];
                break;
        }
    }
    [blockFacesString appendFormat:@"%@", [argumentTypes componentsJoinedByString:@", "]];
    [blockFacesString appendString:@")"];
    return blockFacesString;
}

+ (NSString *)stackSymbol
{
    NSString *stackSymbol = [[NSThread callStackSymbols] lastObject];
    NSArray *splitStackSymbol = [stackSymbol componentsSeparatedByString:@" "];
    return [splitStackSymbol firstObject];
}

+ (NSString *)simpleObject:(id)anObject
{
    NSNumber *simpleMode = objc_getAssociatedObject(self, @selector(simpleMode:));
    if (simpleMode.boolValue) {
        return [NSString stringWithFormat:@"<%@: %p>", NSStringFromClass([anObject class]), anObject];
    } else {
        return [NSString stringWithFormat:@"%@", anObject];
    }
}

+ (void)simpleMode:(BOOL)simpleMode
{
    objc_setAssociatedObject(self, _cmd, @(simpleMode), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
