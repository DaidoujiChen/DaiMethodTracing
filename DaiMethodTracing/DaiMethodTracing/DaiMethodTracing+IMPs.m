//
//  DaiMethodTracing+IMPs.m
//  DaiMethodTracing
//
//  Created by 啟倫 陳 on 2014/5/27.
//  Copyright (c) 2014年 ChilunChen. All rights reserved.
//

#import "DaiMethodTracing+IMPs.h"

#import <objc/runtime.h>

#import "DaiMethodTracing+TypeEncoding.h"

#define createInvocation \
NSLog(@"===== start %@ at %@ =====", self, NSStringFromSelector(_cmd));\
NSTimeInterval startTime = [[NSDate date] timeIntervalSince1970];\
NSString *methodName = NSStringFromSelector(_cmd);\
NSMethodSignature *signature = [self methodSignatureForSelector:NSSelectorFromString([NSString stringWithFormat:@"%@%@", swizzlingPrefix, methodName])];\
NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];\
[invocation setTarget:self];\
[invocation setSelector:NSSelectorFromString([NSString stringWithFormat:@"%@%@", swizzlingPrefix, methodName])];

#define setupInvocation \
va_list list;\
va_start(list, _cmd);\
addArguments(invocation, list);\
va_end(list);

#define invocationInvoke \
[invocation invoke];\
NSLog(@"===== finish %@ at %@, use %fs =====", self, NSStringFromSelector(_cmd), [[NSDate date] timeIntervalSince1970] - startTime);

@implementation DaiMethodTracing (IMPs)

char charMethodIMP(id self, SEL _cmd, ...) {
    
    createInvocation
    setupInvocation
    invocationInvoke
    
    char returnValue;
    [invocation getReturnValue:&returnValue];
    return returnValue;
}

int intMethodIMP(id self, SEL _cmd, ...) {
    
    createInvocation
    setupInvocation
    invocationInvoke
    
    int returnValue;
    [invocation getReturnValue:&returnValue];
    return returnValue;
}

short shortMethodIMP(id self, SEL _cmd, ...) {
    
    createInvocation
    setupInvocation
    invocationInvoke
    
    short returnValue;
    [invocation getReturnValue:&returnValue];
    return returnValue;
}

long longMethodIMP(id self, SEL _cmd, ...) {
    
    createInvocation
    setupInvocation
    invocationInvoke
    
    long returnValue;
    [invocation getReturnValue:&returnValue];
    return returnValue;
}

long long longlongMethodIMP(id self, SEL _cmd, ...) {
    
    createInvocation
    setupInvocation
    invocationInvoke
    
    long long returnValue;
    [invocation getReturnValue:&returnValue];
    return returnValue;
}

unsigned char unsignedCharMethodIMP(id self, SEL _cmd, ...) {
    
    createInvocation
    setupInvocation
    invocationInvoke
    
    unsigned char returnValue;
    [invocation getReturnValue:&returnValue];
    return returnValue;
}

unsigned int unsignedIntMethodIMP(id self, SEL _cmd, ...) {
    
    createInvocation
    setupInvocation
    invocationInvoke
    
    unsigned int returnValue;
    [invocation getReturnValue:&returnValue];
    return returnValue;
}

unsigned short unsignedShortMethodIMP(id self, SEL _cmd, ...) {
    
    createInvocation
    setupInvocation
    invocationInvoke
    
    unsigned short returnValue;
    [invocation getReturnValue:&returnValue];
    return returnValue;
}

unsigned long unsignedLongMethodIMP(id self, SEL _cmd, ...) {
    
    createInvocation
    setupInvocation
    invocationInvoke
    
    unsigned long returnValue;
    [invocation getReturnValue:&returnValue];
    return returnValue;
}

unsigned long long unsignedLongLongMethodIMP(id self, SEL _cmd, ...) {
    
    createInvocation
    setupInvocation
    invocationInvoke
    
    unsigned long long returnValue;
    [invocation getReturnValue:&returnValue];
    return returnValue;
}

float floatMethodIMP(id self, SEL _cmd, ...) {
    
    createInvocation
    setupInvocation
    invocationInvoke
    
    float returnValue;
    [invocation getReturnValue:&returnValue];
    return returnValue;
}

double doubleMethodIMP(id self, SEL _cmd, ...) {
    
    createInvocation
    setupInvocation
    invocationInvoke
    
    double returnValue;
    [invocation getReturnValue:&returnValue];
    return returnValue;
}

BOOL boolMethodIMP(id self, SEL _cmd, ...) {
    
    createInvocation
    setupInvocation
    invocationInvoke
    
    BOOL returnValue;
    [invocation getReturnValue:&returnValue];
    return returnValue;
}

void voidMethodIMP(id self, SEL _cmd, ...) {
    
    createInvocation
    setupInvocation
    invocationInvoke
}

char* charPointerMethodIMP(id self, SEL _cmd, ...) {
    
    createInvocation
    setupInvocation
    invocationInvoke
    
    char* returnValue;
    [invocation getReturnValue:&returnValue];
    return returnValue;
}

id idMethodIMP(id self, SEL _cmd, ...) {
    
    createInvocation
    setupInvocation
    invocationInvoke
    
    id returnValue;
    [invocation getReturnValue:&returnValue];
    return returnValue;
}

Class classMethodIMP(id self, SEL _cmd, ...) {
    
    createInvocation
    setupInvocation
    invocationInvoke
    
    Class returnValue;
    [invocation getReturnValue:&returnValue];
    return returnValue;
}

SEL selMethodIMP(id self, SEL _cmd, ...) {
    
    createInvocation
    setupInvocation
    invocationInvoke
    
    SEL returnValue;
    [invocation getReturnValue:&returnValue];
    return returnValue;
}

CGRect cgRectMethodIMP(id self, SEL _cmd, ...) {
    
    createInvocation
    setupInvocation
    invocationInvoke
    
    CGRect returnValue;
    [invocation getReturnValue:&returnValue];
    return returnValue;
}

CGPoint cgPointMethodIMP(id self, SEL _cmd, ...) {
    
    createInvocation
    setupInvocation
    invocationInvoke
    
    CGPoint returnValue;
    [invocation getReturnValue:&returnValue];
    return returnValue;
}

CGSize cgSizeMethodIMP(id self, SEL _cmd, ...) {
    
    createInvocation
    setupInvocation
    invocationInvoke
    
    CGSize returnValue;
    [invocation getReturnValue:&returnValue];
    return returnValue;
}

CGAffineTransform cgAffineTransformMethodIMP(id self, SEL _cmd, ...) {
    
    createInvocation
    setupInvocation
    invocationInvoke
    
    CGAffineTransform returnValue;
    [invocation getReturnValue:&returnValue];
    return returnValue;
}

UIEdgeInsets uiEdgeInsetsMethodIMP(id self, SEL _cmd, ...) {
    
    createInvocation
    setupInvocation
    invocationInvoke
    
    UIEdgeInsets returnValue;
    [invocation getReturnValue:&returnValue];
    return returnValue;
}

UIOffset uiOffsetMethodIMP(id self, SEL _cmd, ...) {
    
    createInvocation
    setupInvocation
    invocationInvoke
    
    UIOffset returnValue;
    [invocation getReturnValue:&returnValue];
    return returnValue;
}


#pragma mark - private

void addArguments(NSInvocation *invocation, va_list list) {
    
    for (NSUInteger i=2; i<[[invocation methodSignature] numberOfArguments]; i++) {

        switch (typeEncoding([NSString stringWithCString:[[invocation methodSignature] getArgumentTypeAtIndex:i]
                                                encoding:NSUTF8StringEncoding])) {
            case DaiMethodTracingTypeChar:
            {
                char argument = va_arg(list, int);
                [invocation setArgument:&argument atIndex:i];
                break;
            }
            case DaiMethodTracingTypeInt:
            {
                int argument = va_arg(list, int);
                [invocation setArgument:&argument atIndex:i];
                break;
            }
            case DaiMethodTracingTypeShort:
            {
                short argument = va_arg(list, int);
                [invocation setArgument:&argument atIndex:i];
                break;
            }
            case DaiMethodTracingTypeLong:
            {
                long argument = va_arg(list, long);
                [invocation setArgument:&argument atIndex:i];
                break;
            }
            case DaiMethodTracingTypeLongLong:
            {
                long long argument = va_arg(list, long long);
                [invocation setArgument:&argument atIndex:i];
                break;
            }
            case DaiMethodTracingTypeUnsignedChar:
            {
                unsigned char argument = va_arg(list, int);
                [invocation setArgument:&argument atIndex:i];
                break;
            }
            case DaiMethodTracingTypeUnsignedInt:
            {
                unsigned int argument = va_arg(list, unsigned int);
                [invocation setArgument:&argument atIndex:i];
                break;
            }
            case DaiMethodTracingTypeUnsignedShort:
            {
                unsigned short argument = va_arg(list, int);
                [invocation setArgument:&argument atIndex:i];
                break;
            }
            case DaiMethodTracingTypeUnsignedLong:
            {
                unsigned long argument = va_arg(list, unsigned long);
                [invocation setArgument:&argument atIndex:i];
                break;
            }
            case DaiMethodTracingTypeUnsignedLongLong:
            {
                unsigned long long argument = va_arg(list, unsigned long long);
                [invocation setArgument:&argument atIndex:i];
                break;
            }
            case DaiMethodTracingTypeFloat:
            {
                float argument = va_arg(list, double);
                [invocation setArgument:&argument atIndex:i];
                break;
            }
            case DaiMethodTracingTypeDouble:
            {
                double argument = va_arg(list, double);
                [invocation setArgument:&argument atIndex:i];
                break;
            }
            case DaiMethodTracingTypeBool:
            {
                BOOL argument = va_arg(list, int);
                [invocation setArgument:&argument atIndex:i];
                break;
            }
            case DaiMethodTracingTypeCharPointer:
            {
                char* argument = va_arg(list, char*);
                [invocation setArgument:&argument atIndex:i];
                break;
            }
            case DaiMethodTracingTypeObject:
            {
                id argument = va_arg(list, id);
                [invocation setArgument:&argument atIndex:i];
                break;
            }
            case DaiMethodTracingTypeClass:
            {
                Class argument = va_arg(list, Class);
                [invocation setArgument:&argument atIndex:i];
                break;
            }
            case DaiMethodTracingTypeSelector:
            {
                SEL argument = va_arg(list, SEL);
                [invocation setArgument:&argument atIndex:i];
                break;
            }
            case DaiMethodTracingTypeCGRect:
            {
                CGRect argument = va_arg(list, CGRect);
                [invocation setArgument:&argument atIndex:i];
                break;
            }
            case DaiMethodTracingTypeCGPoint:
            {
                CGPoint argument = va_arg(list, CGPoint);
                [invocation setArgument:&argument atIndex:i];
                break;
            }
            case DaiMethodTracingTypeCGSize:
            {
                CGSize argument = va_arg(list, CGSize);
                [invocation setArgument:&argument atIndex:i];
                break;
            }
            case DaiMethodTracingTypeCGAffineTransform:
            {
                CGAffineTransform argument = va_arg(list, CGAffineTransform);
                [invocation setArgument:&argument atIndex:i];
                break;
            }
            case DaiMethodTracingTypeUIEdgeInsets:
            {
                UIEdgeInsets argument = va_arg(list, UIEdgeInsets);
                [invocation setArgument:&argument atIndex:i];
                break;
            }
            case DaiMethodTracingTypeUIOffset:
            {
                UIOffset argument = va_arg(list, UIOffset);
                [invocation setArgument:&argument atIndex:i];
                break;
            }

            default:
                NSLog(@"%@, %@", NSStringFromSelector([invocation selector]), [NSString stringWithCString:[[invocation methodSignature] getArgumentTypeAtIndex:i]
                                                                                                 encoding:NSUTF8StringEncoding]);
                break;
        }
        
        
    }
    
}

@end
