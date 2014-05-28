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
                class_addMethod(metaClass,
                                NSSelectorFromString(swizzlingMethodName),
                                (IMP) charMethodIMP,
                                method_getTypeEncoding(methodList[i]));
                break;
            case DaiMethodTracingTypeInt:
                class_addMethod(metaClass,
                                NSSelectorFromString(swizzlingMethodName),
                                (IMP) intMethodIMP,
                                method_getTypeEncoding(methodList[i]));
                break;
            case DaiMethodTracingTypeShort:
                class_addMethod(metaClass,
                                NSSelectorFromString(swizzlingMethodName),
                                (IMP) shortMethodIMP,
                                method_getTypeEncoding(methodList[i]));
                break;
            case DaiMethodTracingTypeLong:
                class_addMethod(metaClass,
                                NSSelectorFromString(swizzlingMethodName),
                                (IMP) longMethodIMP,
                                method_getTypeEncoding(methodList[i]));
                break;
            case DaiMethodTracingTypeLongLong:
                class_addMethod(metaClass,
                                NSSelectorFromString(swizzlingMethodName),
                                (IMP) longlongMethodIMP,
                                method_getTypeEncoding(methodList[i]));
                break;
            case DaiMethodTracingTypeUnsignedChar:
                class_addMethod(metaClass,
                                NSSelectorFromString(swizzlingMethodName),
                                (IMP) unsignedCharMethodIMP,
                                method_getTypeEncoding(methodList[i]));
                break;
            case DaiMethodTracingTypeUnsignedInt:
                class_addMethod(metaClass,
                                NSSelectorFromString(swizzlingMethodName),
                                (IMP) unsignedIntMethodIMP,
                                method_getTypeEncoding(methodList[i]));
                break;
            case DaiMethodTracingTypeUnsignedShort:
                class_addMethod(metaClass,
                                NSSelectorFromString(swizzlingMethodName),
                                (IMP) unsignedShortMethodIMP,
                                method_getTypeEncoding(methodList[i]));
                break;
            case DaiMethodTracingTypeUnsignedLong:
                class_addMethod(metaClass,
                                NSSelectorFromString(swizzlingMethodName),
                                (IMP) unsignedLongMethodIMP,
                                method_getTypeEncoding(methodList[i]));
                break;
            case DaiMethodTracingTypeUnsignedLongLong:
                class_addMethod(metaClass,
                                NSSelectorFromString(swizzlingMethodName),
                                (IMP) unsignedLongLongMethodIMP,
                                method_getTypeEncoding(methodList[i]));
                break;
            case DaiMethodTracingTypeFloat:
                class_addMethod(metaClass,
                                NSSelectorFromString(swizzlingMethodName),
                                (IMP) floatMethodIMP,
                                method_getTypeEncoding(methodList[i]));
                break;
            case DaiMethodTracingTypeDouble:
                class_addMethod(metaClass,
                                NSSelectorFromString(swizzlingMethodName),
                                (IMP) doubleMethodIMP,
                                method_getTypeEncoding(methodList[i]));
                break;
            case DaiMethodTracingTypeBool:
                class_addMethod(metaClass,
                                NSSelectorFromString(swizzlingMethodName),
                                (IMP) boolMethodIMP,
                                method_getTypeEncoding(methodList[i]));
                break;
            case DaiMethodTracingTypeVoid:
                class_addMethod(metaClass,
                                NSSelectorFromString(swizzlingMethodName),
                                (IMP) voidMethodIMP,
                                method_getTypeEncoding(methodList[i]));
                break;
            case DaiMethodTracingTypeCharPointer:
                class_addMethod(metaClass,
                                NSSelectorFromString(swizzlingMethodName),
                                (IMP) charPointerMethodIMP,
                                method_getTypeEncoding(methodList[i]));
                break;
            case DaiMethodTracingTypeObject:
                class_addMethod(metaClass,
                                NSSelectorFromString(swizzlingMethodName),
                                (IMP) idMethodIMP,
                                method_getTypeEncoding(methodList[i]));
                break;
            case DaiMethodTracingTypeClass:
                class_addMethod(metaClass,
                                NSSelectorFromString(swizzlingMethodName),
                                (IMP) classMethodIMP,
                                method_getTypeEncoding(methodList[i]));
                break;
            case DaiMethodTracingTypeSelector:
                class_addMethod(metaClass,
                                NSSelectorFromString(swizzlingMethodName),
                                (IMP) selMethodIMP,
                                method_getTypeEncoding(methodList[i]));
                break;
            case DaiMethodTracingTypeCGRect:
                class_addMethod(metaClass,
                                NSSelectorFromString(swizzlingMethodName),
                                (IMP) cgRectMethodIMP,
                                method_getTypeEncoding(methodList[i]));
                break;
            case DaiMethodTracingTypeCGPoint:
                class_addMethod(metaClass,
                                NSSelectorFromString(swizzlingMethodName),
                                (IMP) cgPointMethodIMP,
                                method_getTypeEncoding(methodList[i]));
                break;
            case DaiMethodTracingTypeCGSize:
                class_addMethod(metaClass,
                                NSSelectorFromString(swizzlingMethodName),
                                (IMP) cgSizeMethodIMP,
                                method_getTypeEncoding(methodList[i]));
                break;
            case DaiMethodTracingTypeCGAffineTransform:
                class_addMethod(metaClass,
                                NSSelectorFromString(swizzlingMethodName),
                                (IMP) cgAffineTransformMethodIMP,
                                method_getTypeEncoding(methodList[i]));
                break;
            case DaiMethodTracingTypeUIEdgeInsets:
                class_addMethod(metaClass,
                                NSSelectorFromString(swizzlingMethodName),
                                (IMP) uiEdgeInsetsMethodIMP,
                                method_getTypeEncoding(methodList[i]));
                break;
            case DaiMethodTracingTypeUIOffset:
                class_addMethod(metaClass,
                                NSSelectorFromString(swizzlingMethodName),
                                (IMP) uiOffsetMethodIMP,
                                method_getTypeEncoding(methodList[i]));
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
                class_addMethod(aClass,
                                NSSelectorFromString(swizzlingMethodName),
                                (IMP) charMethodIMP,
                                method_getTypeEncoding(methodList[i]));
                break;
            case DaiMethodTracingTypeInt:
                class_addMethod(aClass,
                                NSSelectorFromString(swizzlingMethodName),
                                (IMP) intMethodIMP,
                                method_getTypeEncoding(methodList[i]));
                break;
            case DaiMethodTracingTypeShort:
                class_addMethod(aClass,
                                NSSelectorFromString(swizzlingMethodName),
                                (IMP) shortMethodIMP,
                                method_getTypeEncoding(methodList[i]));
                break;
            case DaiMethodTracingTypeLong:
                class_addMethod(aClass,
                                NSSelectorFromString(swizzlingMethodName),
                                (IMP) longMethodIMP,
                                method_getTypeEncoding(methodList[i]));
                break;
            case DaiMethodTracingTypeLongLong:
                class_addMethod(aClass,
                                NSSelectorFromString(swizzlingMethodName),
                                (IMP) longlongMethodIMP,
                                method_getTypeEncoding(methodList[i]));
                break;
            case DaiMethodTracingTypeUnsignedChar:
                class_addMethod(aClass,
                                NSSelectorFromString(swizzlingMethodName),
                                (IMP) unsignedCharMethodIMP,
                                method_getTypeEncoding(methodList[i]));
                break;
            case DaiMethodTracingTypeUnsignedInt:
                class_addMethod(aClass,
                                NSSelectorFromString(swizzlingMethodName),
                                (IMP) unsignedIntMethodIMP,
                                method_getTypeEncoding(methodList[i]));
                break;
            case DaiMethodTracingTypeUnsignedShort:
                class_addMethod(aClass,
                                NSSelectorFromString(swizzlingMethodName),
                                (IMP) unsignedShortMethodIMP,
                                method_getTypeEncoding(methodList[i]));
                break;
            case DaiMethodTracingTypeUnsignedLong:
                class_addMethod(aClass,
                                NSSelectorFromString(swizzlingMethodName),
                                (IMP) unsignedLongMethodIMP,
                                method_getTypeEncoding(methodList[i]));
                break;
            case DaiMethodTracingTypeUnsignedLongLong:
                class_addMethod(aClass,
                                NSSelectorFromString(swizzlingMethodName),
                                (IMP) unsignedLongLongMethodIMP,
                                method_getTypeEncoding(methodList[i]));
                break;
            case DaiMethodTracingTypeFloat:
                class_addMethod(aClass,
                                NSSelectorFromString(swizzlingMethodName),
                                (IMP) floatMethodIMP,
                                method_getTypeEncoding(methodList[i]));
                break;
            case DaiMethodTracingTypeDouble:
                class_addMethod(aClass,
                                NSSelectorFromString(swizzlingMethodName),
                                (IMP) doubleMethodIMP,
                                method_getTypeEncoding(methodList[i]));
                break;
            case DaiMethodTracingTypeBool:
                class_addMethod(aClass,
                                NSSelectorFromString(swizzlingMethodName),
                                (IMP) boolMethodIMP,
                                method_getTypeEncoding(methodList[i]));
                break;
            case DaiMethodTracingTypeVoid:
                class_addMethod(aClass,
                                NSSelectorFromString(swizzlingMethodName),
                                (IMP) voidMethodIMP,
                                method_getTypeEncoding(methodList[i]));
                break;
            case DaiMethodTracingTypeCharPointer:
                class_addMethod(aClass,
                                NSSelectorFromString(swizzlingMethodName),
                                (IMP) charPointerMethodIMP,
                                method_getTypeEncoding(methodList[i]));
                break;
            case DaiMethodTracingTypeObject:
                class_addMethod(aClass,
                                NSSelectorFromString(swizzlingMethodName),
                                (IMP) idMethodIMP,
                                method_getTypeEncoding(methodList[i]));
                break;
            case DaiMethodTracingTypeClass:
                class_addMethod(aClass,
                                NSSelectorFromString(swizzlingMethodName),
                                (IMP) classMethodIMP,
                                method_getTypeEncoding(methodList[i]));
                break;
            case DaiMethodTracingTypeSelector:
                class_addMethod(aClass,
                                NSSelectorFromString(swizzlingMethodName),
                                (IMP) selMethodIMP,
                                method_getTypeEncoding(methodList[i]));
                break;
            case DaiMethodTracingTypeCGRect:
                class_addMethod(aClass,
                                NSSelectorFromString(swizzlingMethodName),
                                (IMP) cgRectMethodIMP,
                                method_getTypeEncoding(methodList[i]));
                break;
            case DaiMethodTracingTypeCGPoint:
                class_addMethod(aClass,
                                NSSelectorFromString(swizzlingMethodName),
                                (IMP) cgPointMethodIMP,
                                method_getTypeEncoding(methodList[i]));
                break;
            case DaiMethodTracingTypeCGSize:
                class_addMethod(aClass,
                                NSSelectorFromString(swizzlingMethodName),
                                (IMP) cgSizeMethodIMP,
                                method_getTypeEncoding(methodList[i]));
                break;
            case DaiMethodTracingTypeCGAffineTransform:
                class_addMethod(aClass,
                                NSSelectorFromString(swizzlingMethodName),
                                (IMP) cgAffineTransformMethodIMP,
                                method_getTypeEncoding(methodList[i]));
                break;
            case DaiMethodTracingTypeUIEdgeInsets:
                class_addMethod(aClass,
                                NSSelectorFromString(swizzlingMethodName),
                                (IMP) uiEdgeInsetsMethodIMP,
                                method_getTypeEncoding(methodList[i]));
                break;
            case DaiMethodTracingTypeUIOffset:
                class_addMethod(aClass,
                                NSSelectorFromString(swizzlingMethodName),
                                (IMP) uiOffsetMethodIMP,
                                method_getTypeEncoding(methodList[i]));
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
