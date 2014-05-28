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

#define addMethodUsingIMP(arg1, arg2)\
class_addMethod(arg1,\
NSSelectorFromString(swizzlingMethodName),\
(IMP) arg2,\
method_getTypeEncoding(methodList[i]));

@implementation DaiMethodTracing

+(void) tracingClass : (Class) aClass {
    [self swizzlingClassMethod:aClass];
    [self swizzlingInstanceMethod:aClass];
}

#pragma mark - private

+(void) swizzlingClassMethod : (Class) aClass {
    
    Class metaClass = objc_getMetaClass(class_getName(aClass));
    unsigned int methodCount;
    Method *methodList = class_copyMethodList(metaClass, &methodCount);
    
    for (unsigned int i = 0; i < methodCount; i++) {
        
        char dst[dstLength];
        
        method_getReturnType(methodList[i], dst, dstLength);
        
        DaiMethodTracingType returnType = typeEncoding([NSString stringWithCString:dst encoding:NSUTF8StringEncoding]);
        
        NSString *swizzlingMethodName = [NSString stringWithFormat:@"%@%@", swizzlingPrefix, NSStringFromSelector(method_getName(methodList[i]))];
        
        //add method
        switch (returnType) {
            case DaiMethodTracingTypeChar:
                addMethodUsingIMP(metaClass, charMethodIMP)
                break;
            case DaiMethodTracingTypeInt:
                addMethodUsingIMP(metaClass, intMethodIMP)
                break;
            case DaiMethodTracingTypeShort:
                addMethodUsingIMP(metaClass, shortMethodIMP)
                break;
            case DaiMethodTracingTypeLong:
                addMethodUsingIMP(metaClass, longMethodIMP)
                break;
            case DaiMethodTracingTypeLongLong:
                addMethodUsingIMP(metaClass, longlongMethodIMP)
                break;
            case DaiMethodTracingTypeUnsignedChar:
                addMethodUsingIMP(metaClass, unsignedCharMethodIMP)
                break;
            case DaiMethodTracingTypeUnsignedInt:
                addMethodUsingIMP(metaClass, unsignedIntMethodIMP)
                break;
            case DaiMethodTracingTypeUnsignedShort:
                addMethodUsingIMP(metaClass, unsignedShortMethodIMP)
                break;
            case DaiMethodTracingTypeUnsignedLong:
                addMethodUsingIMP(metaClass, unsignedLongMethodIMP)
                break;
            case DaiMethodTracingTypeUnsignedLongLong:
                addMethodUsingIMP(metaClass, unsignedLongLongMethodIMP)
                break;
            case DaiMethodTracingTypeFloat:
                addMethodUsingIMP(metaClass, floatMethodIMP)
                break;
            case DaiMethodTracingTypeDouble:
                addMethodUsingIMP(metaClass, doubleMethodIMP)
                break;
            case DaiMethodTracingTypeBool:
                addMethodUsingIMP(metaClass, boolMethodIMP)
                break;
            case DaiMethodTracingTypeVoid:
                addMethodUsingIMP(metaClass, voidMethodIMP)
                break;
            case DaiMethodTracingTypeCharPointer:
                addMethodUsingIMP(metaClass, charPointerMethodIMP)
                break;
            case DaiMethodTracingTypeObject:
                addMethodUsingIMP(metaClass, idMethodIMP)
                break;
            case DaiMethodTracingTypeClass:
                addMethodUsingIMP(metaClass, classMethodIMP)
                break;
            case DaiMethodTracingTypeSelector:
                addMethodUsingIMP(metaClass, selMethodIMP)
                break;
            case DaiMethodTracingTypeCGRect:
                addMethodUsingIMP(metaClass, cgRectMethodIMP)
                break;
            case DaiMethodTracingTypeCGPoint:
                addMethodUsingIMP(metaClass, cgPointMethodIMP)
                break;
            case DaiMethodTracingTypeCGSize:
                addMethodUsingIMP(metaClass, cgSizeMethodIMP)
                break;
            case DaiMethodTracingTypeCGAffineTransform:
                addMethodUsingIMP(metaClass, cgAffineTransformMethodIMP)
                break;
            case DaiMethodTracingTypeUIEdgeInsets:
                addMethodUsingIMP(metaClass, uiEdgeInsetsMethodIMP)
                break;
            case DaiMethodTracingTypeUIOffset:
                addMethodUsingIMP(metaClass, uiOffsetMethodIMP)
                break;
            default:
                break;
        }
        
        //swizzling
        [self swizzling:metaClass
                   from:method_getName(methodList[i])
                     to:NSSelectorFromString(swizzlingMethodName)];
    }
    
    free(methodList);
}

+(void) swizzlingInstanceMethod : (Class) aClass {
    unsigned int methodCount;
    Method *methodList = class_copyMethodList(aClass, &methodCount);
    
    for (unsigned int i = 0; i < methodCount; i++) {
        
        char dst[dstLength];
        
        method_getReturnType(methodList[i], dst, dstLength);
        
        DaiMethodTracingType returnType = typeEncoding([NSString stringWithCString:dst encoding:NSUTF8StringEncoding]);
        
        NSString *swizzlingMethodName = [NSString stringWithFormat:@"%@%@", swizzlingPrefix, NSStringFromSelector(method_getName(methodList[i]))];
        
        //add method
        switch (returnType) {
            case DaiMethodTracingTypeChar:
                addMethodUsingIMP(aClass, charMethodIMP)
                break;
            case DaiMethodTracingTypeInt:
                addMethodUsingIMP(aClass, intMethodIMP)
                break;
            case DaiMethodTracingTypeShort:
                addMethodUsingIMP(aClass, shortMethodIMP)
                break;
            case DaiMethodTracingTypeLong:
                addMethodUsingIMP(aClass, longMethodIMP)
                break;
            case DaiMethodTracingTypeLongLong:
                addMethodUsingIMP(aClass, longlongMethodIMP)
                break;
            case DaiMethodTracingTypeUnsignedChar:
                addMethodUsingIMP(aClass, unsignedCharMethodIMP)
                break;
            case DaiMethodTracingTypeUnsignedInt:
                addMethodUsingIMP(aClass, unsignedIntMethodIMP)
                break;
            case DaiMethodTracingTypeUnsignedShort:
                addMethodUsingIMP(aClass, unsignedShortMethodIMP)
                break;
            case DaiMethodTracingTypeUnsignedLong:
                addMethodUsingIMP(aClass, unsignedLongMethodIMP)
                break;
            case DaiMethodTracingTypeUnsignedLongLong:
                addMethodUsingIMP(aClass, unsignedLongLongMethodIMP)
                break;
            case DaiMethodTracingTypeFloat:
                addMethodUsingIMP(aClass, floatMethodIMP)
                break;
            case DaiMethodTracingTypeDouble:
                addMethodUsingIMP(aClass, doubleMethodIMP)
                break;
            case DaiMethodTracingTypeBool:
                addMethodUsingIMP(aClass, boolMethodIMP)
                break;
            case DaiMethodTracingTypeVoid:
                addMethodUsingIMP(aClass, voidMethodIMP)
                break;
            case DaiMethodTracingTypeCharPointer:
                addMethodUsingIMP(aClass, charPointerMethodIMP)
                break;
            case DaiMethodTracingTypeObject:
                addMethodUsingIMP(aClass, idMethodIMP)
                break;
            case DaiMethodTracingTypeClass:
                addMethodUsingIMP(aClass, classMethodIMP)
                break;
            case DaiMethodTracingTypeSelector:
                addMethodUsingIMP(aClass, selMethodIMP)
                break;
            case DaiMethodTracingTypeCGRect:
                addMethodUsingIMP(aClass, cgRectMethodIMP)
                break;
            case DaiMethodTracingTypeCGPoint:
                addMethodUsingIMP(aClass, cgPointMethodIMP)
                break;
            case DaiMethodTracingTypeCGSize:
                addMethodUsingIMP(aClass, cgSizeMethodIMP)
                break;
            case DaiMethodTracingTypeCGAffineTransform:
                addMethodUsingIMP(aClass, cgAffineTransformMethodIMP)
                break;
            case DaiMethodTracingTypeUIEdgeInsets:
                addMethodUsingIMP(aClass, uiEdgeInsetsMethodIMP)
                break;
            case DaiMethodTracingTypeUIOffset:
                addMethodUsingIMP(aClass, uiOffsetMethodIMP)
                break;
            default:
                break;
        }
        
        //swizzling
        [self swizzling:aClass
                   from:method_getName(methodList[i])
                     to:NSSelectorFromString(swizzlingMethodName)];
    }
    
    free(methodList);
}

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
