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

@interface DaiMethodTracing ()

+ (void)swizzlingClassMethod:(Class)aClass;
+ (void)swizzlingInstanceMethod:(Class)aClass;
+ (void)swizzlingBaseMethod:(Class)targetClass;
+ (void)swizzling:(Class)aClass from:(SEL)before to:(SEL)after;

@end

#define addMethodUsingIMP(arg1, arg2) \
class_addMethod(arg1, \
NSSelectorFromString(swizzlingMethodName), \
(IMP)arg2, \
method_getTypeEncoding(methodList[i]));

@implementation DaiMethodTracing

+ (void)tracingClass:(Class)aClass
{
	[self swizzlingClassMethod:aClass];
	[self swizzlingInstanceMethod:aClass];
}

#pragma mark - private

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
        
		if ([NSStringFromSelector(method_getName(methodList[i])) isEqualToString:@"dealloc"]) {
			continue;
		}
        
		DaiMethodTracingType returnType = typeEncoding([NSString stringWithCString:dst encoding:NSUTF8StringEncoding]);
        
		NSString *swizzlingMethodName = [NSString stringWithFormat:@"%@%@", swizzlingPrefix, NSStringFromSelector(method_getName(methodList[i]))];
        
		//add method
		switch (returnType) {
			case DaiMethodTracingTypeChar:
				addMethodUsingIMP(targetClass, charMethodIMP)
				break;
                
			case DaiMethodTracingTypeInt:
				addMethodUsingIMP(targetClass, intMethodIMP)
				break;
                
			case DaiMethodTracingTypeShort:
				addMethodUsingIMP(targetClass, shortMethodIMP)
				break;
                
			case DaiMethodTracingTypeLong:
				addMethodUsingIMP(targetClass, longMethodIMP)
				break;
                
			case DaiMethodTracingTypeLongLong:
				addMethodUsingIMP(targetClass, longlongMethodIMP)
				break;
                
			case DaiMethodTracingTypeUnsignedChar:
				addMethodUsingIMP(targetClass, unsignedCharMethodIMP)
				break;
                
			case DaiMethodTracingTypeUnsignedInt:
				addMethodUsingIMP(targetClass, unsignedIntMethodIMP)
				break;
                
			case DaiMethodTracingTypeUnsignedShort:
				addMethodUsingIMP(targetClass, unsignedShortMethodIMP)
				break;
                
			case DaiMethodTracingTypeUnsignedLong:
				addMethodUsingIMP(targetClass, unsignedLongMethodIMP)
				break;
                
			case DaiMethodTracingTypeUnsignedLongLong:
				addMethodUsingIMP(targetClass, unsignedLongLongMethodIMP)
				break;
                
			case DaiMethodTracingTypeFloat:
				addMethodUsingIMP(targetClass, floatMethodIMP)
				break;
                
			case DaiMethodTracingTypeDouble:
				addMethodUsingIMP(targetClass, doubleMethodIMP)
				break;
                
			case DaiMethodTracingTypeBool:
				addMethodUsingIMP(targetClass, boolMethodIMP)
				break;
                
			case DaiMethodTracingTypeVoid:
				addMethodUsingIMP(targetClass, voidMethodIMP)
				break;
                
			case DaiMethodTracingTypeCharPointer:
				addMethodUsingIMP(targetClass, charPointerMethodIMP)
				break;
                
			case DaiMethodTracingTypeObject:
				addMethodUsingIMP(targetClass, idMethodIMP)
				break;
                
			case DaiMethodTracingTypeClass:
				addMethodUsingIMP(targetClass, classMethodIMP)
				break;
                
			case DaiMethodTracingTypeSelector:
				addMethodUsingIMP(targetClass, selMethodIMP)
				break;
                
			case DaiMethodTracingTypeCGRect:
				addMethodUsingIMP(targetClass, cgRectMethodIMP)
				break;
                
			case DaiMethodTracingTypeCGPoint:
				addMethodUsingIMP(targetClass, cgPointMethodIMP)
				break;
                
			case DaiMethodTracingTypeCGSize:
				addMethodUsingIMP(targetClass, cgSizeMethodIMP)
				break;
                
			case DaiMethodTracingTypeCGAffineTransform:
				addMethodUsingIMP(targetClass, cgAffineTransformMethodIMP)
				break;
                
			case DaiMethodTracingTypeUIEdgeInsets:
				addMethodUsingIMP(targetClass, uiEdgeInsetsMethodIMP)
				break;
                
			case DaiMethodTracingTypeUIOffset:
				addMethodUsingIMP(targetClass, uiOffsetMethodIMP)
				break;
                
			default:
				break;
		}
        
		//swizzling
		[self swizzling:targetClass from:method_getName(methodList[i]) to:NSSelectorFromString(swizzlingMethodName)];
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

@end
