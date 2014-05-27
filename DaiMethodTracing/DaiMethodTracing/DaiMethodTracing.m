//
//  DaiMethodTracing.m
//  DaiMethodTracing
//
//  Created by 啟倫 陳 on 2014/5/27.
//  Copyright (c) 2014年 ChilunChen. All rights reserved.
//

#import "DaiMethodTracing.h"

#import <objc/runtime.h>

#import "DaiMethodTracing+IMPs.h"
#import "DaiMethodTracing+TypeEncoding.h"

@implementation DaiMethodTracing

+(void) tracingClass : (Class) aClass {
    
    unsigned int methodCount;
    Method *methodList = class_copyMethodList(aClass, &methodCount);
    
    for (unsigned int i = 0; i < methodCount; i++) {
        
        NSMutableString *encodeString = [NSMutableString string];
        
        char dst[dstLength];
        
        method_getReturnType(methodList[i], dst, dstLength);
        
        [encodeString appendFormat:@"%@", [NSString stringWithCString:dst encoding:NSUTF8StringEncoding]];
        
        DaiMethodTracingType returnType = typeEncoding(encodeString);

        for (unsigned int j=0; j<method_getNumberOfArguments(methodList[i]); j++) {
            method_getArgumentType(methodList[i], j, dst, dstLength);
            [encodeString appendFormat:@"%@", [NSString stringWithCString:dst encoding:NSUTF8StringEncoding]];
        }
        
        //add method
        switch (returnType) {
            case DaiMethodTracingTypeChar:
                class_addMethod(aClass,
                                NSSelectorFromString([NSString stringWithFormat:@"%@%@", swizzlingPrefix, NSStringFromSelector(method_getName(methodList[i]))]),
                                (IMP) charMethodIMP,
                                [encodeString UTF8String]);
                break;
            case DaiMethodTracingTypeInt:
                class_addMethod(aClass,
                                NSSelectorFromString([NSString stringWithFormat:@"%@%@", swizzlingPrefix, NSStringFromSelector(method_getName(methodList[i]))]),
                                (IMP) intMethodIMP,
                                [encodeString UTF8String]);
                break;
            case DaiMethodTracingTypeShort:
                class_addMethod(aClass,
                                NSSelectorFromString([NSString stringWithFormat:@"%@%@", swizzlingPrefix, NSStringFromSelector(method_getName(methodList[i]))]),
                                (IMP) shortMethodIMP,
                                [encodeString UTF8String]);
                break;
            case DaiMethodTracingTypeLong:
                class_addMethod(aClass,
                                NSSelectorFromString([NSString stringWithFormat:@"%@%@", swizzlingPrefix, NSStringFromSelector(method_getName(methodList[i]))]),
                                (IMP) longMethodIMP,
                                [encodeString UTF8String]);
                break;
            case DaiMethodTracingTypeLongLong:
                class_addMethod(aClass,
                                NSSelectorFromString([NSString stringWithFormat:@"%@%@", swizzlingPrefix, NSStringFromSelector(method_getName(methodList[i]))]),
                                (IMP) longlongMethodIMP,
                                [encodeString UTF8String]);
                break;
            case DaiMethodTracingTypeUnsignedChar:
                class_addMethod(aClass,
                                NSSelectorFromString([NSString stringWithFormat:@"%@%@", swizzlingPrefix, NSStringFromSelector(method_getName(methodList[i]))]),
                                (IMP) unsignedCharMethodIMP,
                                [encodeString UTF8String]);
                break;
            case DaiMethodTracingTypeUnsignedInt:
                class_addMethod(aClass,
                                NSSelectorFromString([NSString stringWithFormat:@"%@%@", swizzlingPrefix, NSStringFromSelector(method_getName(methodList[i]))]),
                                (IMP) unsignedIntMethodIMP,
                                [encodeString UTF8String]);
                break;
            case DaiMethodTracingTypeUnsignedShort:
                class_addMethod(aClass,
                                NSSelectorFromString([NSString stringWithFormat:@"%@%@", swizzlingPrefix, NSStringFromSelector(method_getName(methodList[i]))]),
                                (IMP) unsignedShortMethodIMP,
                                [encodeString UTF8String]);
                break;
            case DaiMethodTracingTypeUnsignedLong:
                class_addMethod(aClass,
                                NSSelectorFromString([NSString stringWithFormat:@"%@%@", swizzlingPrefix, NSStringFromSelector(method_getName(methodList[i]))]),
                                (IMP) unsignedLongMethodIMP,
                                [encodeString UTF8String]);
                break;
            case DaiMethodTracingTypeUnsignedLongLong:
                class_addMethod(aClass,
                                NSSelectorFromString([NSString stringWithFormat:@"%@%@", swizzlingPrefix, NSStringFromSelector(method_getName(methodList[i]))]),
                                (IMP) unsignedLongLongMethodIMP,
                                [encodeString UTF8String]);
                break;
            case DaiMethodTracingTypeFloat:
                class_addMethod(aClass,
                                NSSelectorFromString([NSString stringWithFormat:@"%@%@", swizzlingPrefix, NSStringFromSelector(method_getName(methodList[i]))]),
                                (IMP) floatMethodIMP,
                                [encodeString UTF8String]);
                break;
            case DaiMethodTracingTypeDouble:
                class_addMethod(aClass,
                                NSSelectorFromString([NSString stringWithFormat:@"%@%@", swizzlingPrefix, NSStringFromSelector(method_getName(methodList[i]))]),
                                (IMP) doubleMethodIMP,
                                [encodeString UTF8String]);
                break;
            case DaiMethodTracingTypeBool:
                class_addMethod(aClass,
                                NSSelectorFromString([NSString stringWithFormat:@"%@%@", swizzlingPrefix, NSStringFromSelector(method_getName(methodList[i]))]),
                                (IMP) boolMethodIMP,
                                [encodeString UTF8String]);
                break;
            case DaiMethodTracingTypeVoid:
                class_addMethod(aClass,
                                NSSelectorFromString([NSString stringWithFormat:@"%@%@", swizzlingPrefix, NSStringFromSelector(method_getName(methodList[i]))]),
                                (IMP) voidMethodIMP,
                                [encodeString UTF8String]);
                break;
            case DaiMethodTracingTypeCharPointer:
                class_addMethod(aClass,
                                NSSelectorFromString([NSString stringWithFormat:@"%@%@", swizzlingPrefix, NSStringFromSelector(method_getName(methodList[i]))]),
                                (IMP) charPointerMethodIMP,
                                [encodeString UTF8String]);
                break;
            case DaiMethodTracingTypeObject:
                class_addMethod(aClass,
                                NSSelectorFromString([NSString stringWithFormat:@"%@%@", swizzlingPrefix, NSStringFromSelector(method_getName(methodList[i]))]),
                                (IMP) idMethodIMP,
                                [encodeString UTF8String]);
                break;
            case DaiMethodTracingTypeClass:
                class_addMethod(aClass,
                                NSSelectorFromString([NSString stringWithFormat:@"%@%@", swizzlingPrefix, NSStringFromSelector(method_getName(methodList[i]))]),
                                (IMP) classMethodIMP,
                                [encodeString UTF8String]);
                break;
            case DaiMethodTracingTypeSelector:
                class_addMethod(aClass,
                                NSSelectorFromString([NSString stringWithFormat:@"%@%@", swizzlingPrefix, NSStringFromSelector(method_getName(methodList[i]))]),
                                (IMP) selMethodIMP,
                                [encodeString UTF8String]);
                break;
            default:
                break;
        }
        
        NSLog(@"--- %@", encodeString);
        
        //swizzling
        [self swizzling:aClass
                   from:method_getName(methodList[i])
                     to:NSSelectorFromString([NSString stringWithFormat:@"%@%@", swizzlingPrefix, NSStringFromSelector(method_getName(methodList[i]))])];
    }
    
    free(methodList);

}

#pragma mark - private

+(void) swizzling : (Class) aClass from : (SEL) before to : (SEL) after {
    
    SEL originalSelector = before;
    SEL swizzledSelector = after;
    
    Method originalMethod = class_getInstanceMethod(aClass, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(aClass, swizzledSelector);
    
    BOOL didAddMethod =
    class_addMethod(aClass,
                    originalSelector,
                    method_getImplementation(swizzledMethod),
                    method_getTypeEncoding(swizzledMethod));
    
    if (didAddMethod) {
        class_replaceMethod(aClass,
                            swizzledSelector,
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
    
}

@end
