//
//  DaiMethodTracing.m
//  DaiMethodTracing
//
//  Created by 啟倫 陳 on 2014/5/27.
//  Copyright (c) 2014年 ChilunChen. All rights reserved.
//

#import "DaiMethodTracing.h"

#import <objc/runtime.h>

#import "DaiMethodTracingDefine.h"
#import "DaiMethodTracingIMP.h"
#import "DaiMethodTracingType.h"

@implementation DaiMethodTracing

#pragma mark - class method

+ (void)tracingClass:(Class)aClass
{
    if ([self isSwizzleAble:aClass]) {
        [self swizzlingClassMethod:aClass];
        [self swizzlingInstanceMethod:aClass];
    } else {
        NSLog(@"this class already in tracing");
    }
}

#pragma mark - private class method

+ (void)swizzlingClassMethod:(Class)aClass
{
	Class metaClass = objc_getMetaClass(class_getName(aClass));
    [self swizzlingBaseMethod:metaClass];
}

+ (void)swizzlingInstanceMethod:(Class)aClass
{
    [self swizzlingBaseMethod:aClass];
}

+ (void)swizzlingBaseMethod:(Class)targetClass
{
    unsigned int methodCount;
	Method *methodList = class_copyMethodList(targetClass, &methodCount);
    
	for (unsigned int i = 0; i < methodCount; i++) {
		char dst[dstLength];
		method_getReturnType(methodList[i], dst, dstLength);
        
        // do not swizzling some method
        if ([self isNeedAvoid:NSStringFromSelector(method_getName(methodList[i]))]) {
            continue;
        }
        
        // prepare required arguments
		DaiMethodTracingType returnType = tracingType([NSString stringWithCString:dst encoding:NSUTF8StringEncoding]);
		NSString *swizzlingMethodName = [NSString stringWithFormat:@"%@%@", swizzlingPrefix, NSStringFromSelector(method_getName(methodList[i]))];
        SEL swizzlingMethodSelector = NSSelectorFromString(swizzlingMethodName);
        const char *typeEncoding = method_getTypeEncoding(methodList[i]);
        
		//add method
		switch (returnType) {
			case DaiMethodTracingTypeChar:
                class_addMethod(targetClass, swizzlingMethodSelector, (IMP)charMethodIMP, typeEncoding);
				break;
                
			case DaiMethodTracingTypeInt:
                class_addMethod(targetClass, swizzlingMethodSelector, (IMP)intMethodIMP, typeEncoding);
				break;
                
			case DaiMethodTracingTypeShort:
                class_addMethod(targetClass, swizzlingMethodSelector, (IMP)shortMethodIMP, typeEncoding);
				break;
                
			case DaiMethodTracingTypeLong:
                class_addMethod(targetClass, swizzlingMethodSelector, (IMP)longMethodIMP, typeEncoding);
				break;
                
			case DaiMethodTracingTypeLongLong:
                class_addMethod(targetClass, swizzlingMethodSelector, (IMP)longlongMethodIMP, typeEncoding);
				break;
                
			case DaiMethodTracingTypeUnsignedChar:
                class_addMethod(targetClass, swizzlingMethodSelector, (IMP)unsignedCharMethodIMP, typeEncoding);
				break;
                
			case DaiMethodTracingTypeUnsignedInt:
                class_addMethod(targetClass, swizzlingMethodSelector, (IMP)unsignedIntMethodIMP, typeEncoding);
				break;
                
			case DaiMethodTracingTypeUnsignedShort:
                class_addMethod(targetClass, swizzlingMethodSelector, (IMP)unsignedShortMethodIMP, typeEncoding);
				break;
                
			case DaiMethodTracingTypeUnsignedLong:
                class_addMethod(targetClass, swizzlingMethodSelector, (IMP)unsignedLongMethodIMP, typeEncoding);
				break;
                
			case DaiMethodTracingTypeUnsignedLongLong:
                class_addMethod(targetClass, swizzlingMethodSelector, (IMP)unsignedLongLongMethodIMP, typeEncoding);
				break;
                
			case DaiMethodTracingTypeFloat:
                class_addMethod(targetClass, swizzlingMethodSelector, (IMP)floatMethodIMP, typeEncoding);
				break;
                
			case DaiMethodTracingTypeDouble:
                class_addMethod(targetClass, swizzlingMethodSelector, (IMP)doubleMethodIMP, typeEncoding);
				break;
                
			case DaiMethodTracingTypeBool:
                class_addMethod(targetClass, swizzlingMethodSelector, (IMP)boolMethodIMP, typeEncoding);
				break;
                
			case DaiMethodTracingTypeVoid:
                class_addMethod(targetClass, swizzlingMethodSelector, (IMP)voidMethodIMP, typeEncoding);
				break;
            
            case DaiMethodTracingTypeVoidPointer:
                class_addMethod(targetClass, swizzlingMethodSelector, (IMP)voidPointerMethodIMP, typeEncoding);
                break;
                
			case DaiMethodTracingTypeCharPointer:
                class_addMethod(targetClass, swizzlingMethodSelector, (IMP)charPointerMethodIMP, typeEncoding);
				break;
                
			case DaiMethodTracingTypeObject:
                class_addMethod(targetClass, swizzlingMethodSelector, (IMP)objectMethodIMP, typeEncoding);
				break;
                
			case DaiMethodTracingTypeClass:
                class_addMethod(targetClass, swizzlingMethodSelector, (IMP)classMethodIMP, typeEncoding);
				break;
                
			case DaiMethodTracingTypeSelector:
                class_addMethod(targetClass, swizzlingMethodSelector, (IMP)selectorMethodIMP, typeEncoding);
				break;
                
			case DaiMethodTracingTypeCGRect:
                class_addMethod(targetClass, swizzlingMethodSelector, (IMP)cgRectMethodIMP, typeEncoding);
				break;
                
			case DaiMethodTracingTypeCGPoint:
                class_addMethod(targetClass, swizzlingMethodSelector, (IMP)cgPointMethodIMP, typeEncoding);
				break;
                
			case DaiMethodTracingTypeCGSize:
                class_addMethod(targetClass, swizzlingMethodSelector, (IMP)cgSizeMethodIMP, typeEncoding);
				break;
                
			case DaiMethodTracingTypeCGAffineTransform:
                class_addMethod(targetClass, swizzlingMethodSelector, (IMP)cgAffineTransformMethodIMP, typeEncoding);
				break;
                
			case DaiMethodTracingTypeUIEdgeInsets:
                class_addMethod(targetClass, swizzlingMethodSelector, (IMP)uiEdgeInsetsMethodIMP, typeEncoding);
				break;
                
			case DaiMethodTracingTypeUIOffset:
                class_addMethod(targetClass, swizzlingMethodSelector, (IMP)uiOffsetMethodIMP, typeEncoding);
				break;
                
			default:
				break;
		}
        
		//swizzling
		[self swizzling:targetClass from:method_getName(methodList[i]) to:swizzlingMethodSelector];
	}
    
	free(methodList);
}

+ (void)swizzling:(Class)aClass from:(SEL)before to:(SEL)after
{
	SEL originalSelector = before;
	SEL swizzledSelector = after;
    
	Method originalMethod = class_getInstanceMethod(aClass, originalSelector);
	Method swizzledMethod = class_getInstanceMethod(aClass, swizzledSelector);
    
	BOOL didAddMethod = class_addMethod(aClass, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
    
	if (didAddMethod) {
		class_replaceMethod(aClass, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
	} else {
		method_exchangeImplementations(originalMethod, swizzledMethod);
	}
}

+ (BOOL)isSwizzleAble:(Class)aClass
{
    NSString *className = NSStringFromClass(aClass);
    if ([self swizzleTable][className]) {
        return NO;
    } else {
        [self swizzleTable][className] = [NSNull null];
        return YES;
    }
}

+ (NSMutableDictionary *)swizzleTable
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        objc_setAssociatedObject(self, _cmd, [NSMutableDictionary dictionary], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    });
    return objc_getAssociatedObject(self, _cmd);
}

+ (BOOL)isNeedAvoid:(NSString *)methodName {
    static NSArray *avoids = nil;
    if (!avoids) {
        avoids = @[@"dealloc", @"retain", @"release", @"Retain"];
    }
    
    for (NSString *avoid in avoids) {
        if ([methodName rangeOfString:avoid].location != NSNotFound) {
            return YES;
        }
    }
    return NO;
}

@end
