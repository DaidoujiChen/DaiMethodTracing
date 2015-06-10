//
//  DaiSugarCoating.m
//  DaiMethodTracing
//
//  Created by DaidoujiChen on 2015/6/9.
//  Copyright (c) 2015年 DaidoujiChen. All rights reserved.
//

// reference https://github.com/mikeash/MABlockForwarding

#import "DaiSugarCoating.h"

#import <objc/runtime.h>
#import <objc/message.h>

#import "DaiMethodTracingType.h"
#import "NSObject+MethodDeep.h"

typedef void (^BlockInterposer)(NSInvocation *invocation, void (^call)(void));

typedef struct {
    unsigned long reserved;
    unsigned long size;
    void *rest[1];
} BlockDescriptor;

typedef struct {
    void *isa;
    int flags;
    int reserved;
    void *invoke;
    BlockDescriptor *descriptor;
} Block;

enum {
    BLOCK_HAS_COPY_DISPOSE =  (1 << 25),
    BLOCK_HAS_CTOR =          (1 << 26),
    BLOCK_IS_GLOBAL =         (1 << 28),
    BLOCK_HAS_STRET =         (1 << 29),
    BLOCK_HAS_SIGNATURE =     (1 << 30),
};

@interface NSInvocation (PrivateAPI)

- (void)invokeUsingIMP:(IMP)imp;

@end

@interface DaiSugarCoating ()

@property (nonatomic, assign) int flags;
@property (nonatomic, assign) int reserved;
@property (nonatomic, assign) IMP invoke;
@property (nonatomic, assign) BlockDescriptor blockDescriptor;
@property (nonatomic, copy) id forwardingBlock;
@property (nonatomic, copy) BlockInterposer interposer;

@end

@implementation DaiSugarCoating

#pragma mark - private inctance method

- (const char *)blockSig:(id)blockObj
{
    Block *block = (__bridge void *)blockObj;
    BlockDescriptor *descriptor = block->descriptor;
    
    assert(block->flags & BLOCK_HAS_SIGNATURE);
    
    int index = 0;
    if (block->flags & BLOCK_HAS_COPY_DISPOSE) {
        index += 2;
    }
    return descriptor->rest[index];
}

- (void *)blockIMP:(id)blockObj
{
    return ((__bridge Block *)blockObj)->invoke;
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector
{
    const char *types = [self blockSig:self.forwardingBlock];
    NSMethodSignature *signature = [NSMethodSignature signatureWithObjCTypes:types];
    while ([signature numberOfArguments] < 2) {
        types = [[NSString stringWithFormat:@"%s%s", types, @encode(void *)] UTF8String];
        signature = [NSMethodSignature signatureWithObjCTypes:types];
    }
    return signature;
}

- (void)forwardInvocation:(NSInvocation *)invocation
{
    [invocation setTarget:self.forwardingBlock];
    NSTimeInterval startTime = [[NSDate date] timeIntervalSince1970];
    NSLog(@"(BLOCK-%p)> start %@ ", self, [self blockFaces:invocation.methodSignature]);
    self.interposer(invocation, ^{
        [invocation invokeUsingIMP:[self blockIMP:self.forwardingBlock]];
    });
    NSLog(@"(BLOCK-%p)> finish %@ , use %fs", self, [self blockFaces:invocation.methodSignature], [[NSDate date] timeIntervalSince1970] - startTime);
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

#pragma mark - private instance method

- (id)initWithBlock:(id)block interposer:(BlockInterposer)interposer
{
    self = [super init];
    if (self) {
        self.forwardingBlock = block;
        self.interposer = interposer;
        self.flags = ((__bridge Block *)block)->flags & ~0xFFFF;
        
        // 設定 BlockDescriptor
        BlockDescriptor newBlockDescriptor;
        newBlockDescriptor.size = class_getInstanceSize([self class]);
        int index = 0;
        if (_flags & BLOCK_HAS_COPY_DISPOSE) {
            index += 2;
        }
        newBlockDescriptor.rest[index] = (void *)[self blockSig:block];
        self.blockDescriptor = newBlockDescriptor;
        
        // 設定 invoke 的 function point
        if (_flags & BLOCK_HAS_STRET) {
            self.invoke = (IMP)_objc_msgForward_stret;
        } else {
            self.invoke = _objc_msgForward;
        }
    }
    return self;
}

// 把 block 的原貌還原出來
- (NSString *)blockFaces:(NSMethodSignature *)signature
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
            [blockFacesString appendString:@"void*"];
            break;
            
        case DaiMethodTracingTypeCharPointer:
            [blockFacesString appendString:@"char*"];
            break;
            
        case DaiMethodTracingTypeObject:
            [blockFacesString appendString:@"id"];
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
    NSMutableArray *argTypes = [NSMutableArray array];
    for (unsigned i = 1; i < signature.numberOfArguments; i++) {
        NSString *argType = [NSString stringWithFormat:@"%s", [signature getArgumentTypeAtIndex:i]];
        switch (tracingType(argType)) {
            case DaiMethodTracingTypeChar:
                [argTypes addObject:@"char"];
                break;
                
            case DaiMethodTracingTypeInt:
                [argTypes addObject:@"int"];
                break;
                
            case DaiMethodTracingTypeShort:
                [argTypes addObject:@"short"];
                break;
                
            case DaiMethodTracingTypeLong:
                [argTypes addObject:@"long"];
                break;
                
            case DaiMethodTracingTypeLongLong:
                [argTypes addObject:@"long long"];
                break;
                
            case DaiMethodTracingTypeUnsignedChar:
                [argTypes addObject:@"unsigened char"];
                break;
                
            case DaiMethodTracingTypeUnsignedInt:
                [argTypes addObject:@"unsigened int"];
                break;
                
            case DaiMethodTracingTypeUnsignedShort:
                [argTypes addObject:@"unsigened short"];
                break;
                
            case DaiMethodTracingTypeUnsignedLong:
                [argTypes addObject:@"unsigened long"];
                break;
                
            case DaiMethodTracingTypeUnsignedLongLong:
                [argTypes addObject:@"unsigened long long"];
                break;
                
            case DaiMethodTracingTypeFloat:
                [argTypes addObject:@"float"];
                break;
                
            case DaiMethodTracingTypeDouble:
                [argTypes addObject:@"double"];
                break;
                
            case DaiMethodTracingTypeBool:
                [argTypes addObject:@"BOOL"];
                break;
                
            case DaiMethodTracingTypeVoidPointer:
                [argTypes addObject:@"void*"];
                break;
                
            case DaiMethodTracingTypeCharPointer:
                [argTypes addObject:@"char*"];
                break;
                
            case DaiMethodTracingTypeObject:
                [argTypes addObject:@"id"];
                break;
                
            case DaiMethodTracingTypeClass:
                [argTypes addObject:@"Class"];
                break;
                
            case DaiMethodTracingTypeSelector:
                [argTypes addObject:@"SEL"];
                break;
                
            case DaiMethodTracingTypeCGRect:
                [argTypes addObject:@"CGRect"];
                break;
                
            case DaiMethodTracingTypeCGPoint:
                [argTypes addObject:@"CGPoint"];
                break;
                
            case DaiMethodTracingTypeCGSize:
                [argTypes addObject:@"CGSize"];
                break;
                
            case DaiMethodTracingTypeCGAffineTransform:
                [argTypes addObject:@"CGAffineTransform"];
                break;
                
            case DaiMethodTracingTypeUIEdgeInsets:
                [argTypes addObject:@"UIEdgeInsets"];
                break;
                
            case DaiMethodTracingTypeUIOffset:
                [argTypes addObject:@"UIOffset"];
                break;
                
            default:
                [argTypes addObject:@"void"];
                break;
        }
    }
    [blockFacesString appendFormat:@"%@", [argTypes componentsJoinedByString:@", "]];
    [blockFacesString appendString:@")"];
    return blockFacesString;
}

#pragma mark - class method

+ (id)wrapBlock:(id)blockObj
{
    return [[DaiSugarCoating alloc] initWithBlock:blockObj interposer: ^(NSInvocation *invocation, void (^call)(void)) {
        NSMethodSignature *signature = invocation.methodSignature;
        
        // 取得所有參數
        for (unsigned i = 1; i < signature.numberOfArguments; i++) {
            NSString *argumentType = [NSString stringWithFormat:@"%s", [signature getArgumentTypeAtIndex:i]];
            
            NSMutableString *argumentLogString = [NSMutableString string];
            [argumentLogString appendString:@"(BLOCK)> "];
            
            switch (tracingType(argumentType)) {
                case DaiMethodTracingTypeChar:
                {
                    char argument;
                    [invocation getArgument:&argument atIndex:i];
                    [argumentLogString appendFormat:@"(char) %c", argument];
                    break;
                }
                    
                case DaiMethodTracingTypeInt:
                {
                    int argument;
                    [invocation getArgument:&argument atIndex:i];
                    [argumentLogString appendFormat:@"(int) %i", argument];
                    break;
                }
                    
                case DaiMethodTracingTypeShort:
                {
                    short argument;
                    [invocation getArgument:&argument atIndex:i];
                    [argumentLogString appendFormat:@"(shot) %i", argument];
                    break;
                }
                    
                case DaiMethodTracingTypeLong:
                {
                    long argument;
                    [invocation getArgument:&argument atIndex:i];
                    [argumentLogString appendFormat:@"(long) %li", argument];
                    break;
                }
                    
                case DaiMethodTracingTypeLongLong:
                {
                    long long argument;
                    [invocation getArgument:&argument atIndex:i];
                    [argumentLogString appendFormat:@"(long long) %lld", argument];
                    break;
                }
                    
                case DaiMethodTracingTypeUnsignedChar:
                {
                    unsigned char argument;
                    [invocation getArgument:&argument atIndex:i];
                    [argumentLogString appendFormat:@"(unsigened char) %c", argument];
                    break;
                }
                    
                case DaiMethodTracingTypeUnsignedInt:
                {
                    unsigned int argument;
                    [invocation getArgument:&argument atIndex:i];
                    [argumentLogString appendFormat:@"(unsigned int) %i", argument];
                    break;
                }
                    
                case DaiMethodTracingTypeUnsignedShort:
                {
                    unsigned short argument;
                    [invocation getArgument:&argument atIndex:i];
                    [argumentLogString appendFormat:@"(unsigned short) %i", argument];
                    break;
                }
                    
                case DaiMethodTracingTypeUnsignedLong:
                {
                    unsigned long argument;
                    [invocation getArgument:&argument atIndex:i];
                    [argumentLogString appendFormat:@"(unsigned long) %lu", argument];
                    break;
                }
                    
                case DaiMethodTracingTypeUnsignedLongLong:
                {
                    unsigned long long argument;
                    [invocation getArgument:&argument atIndex:i];
                    [argumentLogString appendFormat:@"(unsigned long long) %llu", argument];
                    break;
                }
                    
                case DaiMethodTracingTypeFloat:
                {
                    float argument;
                    [invocation getArgument:&argument atIndex:i];
                    [argumentLogString appendFormat:@"(float) %f", argument];
                    break;
                }
                    
                case DaiMethodTracingTypeDouble:
                {
                    double argument;
                    [invocation getArgument:&argument atIndex:i];
                    [argumentLogString appendFormat:@"(double) %f", argument];
                    break;
                }
                    
                case DaiMethodTracingTypeBool:
                {
                    BOOL argument;
                    [invocation getArgument:&argument atIndex:i];
                    [argumentLogString appendFormat:@"(BOOL) %@", argument ? @"YES" : @"NO"];
                    break;
                }
                    
                case DaiMethodTracingTypeVoidPointer:
                {
                    char *argument;
                    [invocation getArgument:&argument atIndex:i];
                    [argumentLogString appendFormat:@"(void*) %s", argument];
                    break;
                }
                    
                case DaiMethodTracingTypeCharPointer:
                {
                    char *argument;
                    [invocation getArgument:&argument atIndex:i];
                    [argumentLogString appendFormat:@"(char*) %s", argument];
                    break;
                }
                    
                case DaiMethodTracingTypeObject:
                {
                    id argument;
                    [invocation getArgument:&argument atIndex:i];
                    if ([argument isKindOfClass:NSClassFromString(@"NSBlock")]) {
                        argument = [DaiSugarCoating wrapBlock:argument];
                        [invocation setArgument:&argument atIndex:i];
                    }
                    [argumentLogString appendFormat:@"(id) %@", argument];
                    break;
                }
                    
                case DaiMethodTracingTypeClass:
                {
                    Class argument;
                    [invocation getArgument:&argument atIndex:i];
                    [argumentLogString appendFormat:@"(Class) %@", argument];
                    break;
                }
                    
                case DaiMethodTracingTypeSelector:
                {
                    SEL argument;
                    [invocation getArgument:&argument atIndex:i];
                    [argumentLogString appendFormat:@"(SEL) %@", NSStringFromSelector(argument)];
                    break;
                }
                    
                case DaiMethodTracingTypeCGRect:
                {
                    CGRect argument;
                    [invocation getArgument:&argument atIndex:i];
                    [argumentLogString appendFormat:@"(CGRect) %@", NSStringFromCGRect(argument)];
                    break;
                }
                    
                case DaiMethodTracingTypeCGPoint:
                {
                    CGPoint argument;
                    [invocation getArgument:&argument atIndex:i];
                    [argumentLogString appendFormat:@"(CGPoint) %@", NSStringFromCGPoint(argument)];
                    break;
                }
                    
                case DaiMethodTracingTypeCGSize:
                {
                    CGSize argument;
                    [invocation getArgument:&argument atIndex:i];
                    [argumentLogString appendFormat:@"(CGSize) %@", NSStringFromCGSize(argument)];
                    break;
                }
                    
                case DaiMethodTracingTypeCGAffineTransform:
                {
                    CGAffineTransform argument;
                    [invocation getArgument:&argument atIndex:i];
                    [argumentLogString appendFormat:@"(CGAffineTransform) %@", NSStringFromCGAffineTransform(argument)];
                    break;
                }
                    
                case DaiMethodTracingTypeUIEdgeInsets:
                {
                    UIEdgeInsets argument;
                    [invocation getArgument:&argument atIndex:i];
                    [argumentLogString appendFormat:@"(UIEdgeInsets) %@", NSStringFromUIEdgeInsets(argument)];
                    break;
                }
                    
                case DaiMethodTracingTypeUIOffset:
                {
                    UIOffset argument;
                    [invocation getArgument:&argument atIndex:i];
                    [argumentLogString appendFormat:@"(UIOffset) %@", NSStringFromUIOffset(argument)];
                    break;
                }
                    
                default:
                    NSLog(@"%@, %@", NSStringFromSelector([invocation selector]), [NSString stringWithCString:[invocation.methodSignature getArgumentTypeAtIndex:i] encoding:NSUTF8StringEncoding]);
                    break;
            }
            NSLog(@"%@", argumentLogString);
        }
        
        // 判別回傳值型別
        NSString *returnType = [NSString stringWithFormat:@"%s", signature.methodReturnType];
        
        call();
        
        // 取得回傳值
        NSMutableString *returnLogString = [NSMutableString string];
        [returnLogString appendString:@"(BLOCK)> return "];
        switch (tracingType(returnType)) {
            case DaiMethodTracingTypeChar:
            {
                char argument;
                [invocation getReturnValue:&argument];
                [returnLogString appendFormat:@"(char) %c", argument];
                break;
            }
                
            case DaiMethodTracingTypeInt:
            {
                int argument;
                [invocation getReturnValue:&argument];
                [returnLogString appendFormat:@"(int) %i", argument];
                break;
            }
                
            case DaiMethodTracingTypeShort:
            {
                short argument;
                [invocation getReturnValue:&argument];
                [returnLogString appendFormat:@"(shot) %i", argument];
                break;
            }
                
            case DaiMethodTracingTypeLong:
            {
                long argument;
                [invocation getReturnValue:&argument];
                [returnLogString appendFormat:@"(long) %li", argument];
                break;
            }
                
            case DaiMethodTracingTypeLongLong:
            {
                long long argument;
                [invocation getReturnValue:&argument];
                [returnLogString appendFormat:@"(long long) %lld", argument];
                break;
            }
                
            case DaiMethodTracingTypeUnsignedChar:
            {
                unsigned char argument;
                [invocation getReturnValue:&argument];
                [returnLogString appendFormat:@"(unsigened char) %c", argument];
                break;
            }
                
            case DaiMethodTracingTypeUnsignedInt:
            {
                unsigned int argument;
                [invocation getReturnValue:&argument];
                [returnLogString appendFormat:@"(unsigned int) %i", argument];
                break;
            }
                
            case DaiMethodTracingTypeUnsignedShort:
            {
                unsigned short argument;
                [invocation getReturnValue:&argument];
                [returnLogString appendFormat:@"(unsigned short) %i", argument];
                break;
            }
                
            case DaiMethodTracingTypeUnsignedLong:
            {
                unsigned long argument;
                [invocation getReturnValue:&argument];
                [returnLogString appendFormat:@"(unsigned long) %lu", argument];
                break;
            }
                
            case DaiMethodTracingTypeUnsignedLongLong:
            {
                unsigned long long argument;
                [invocation getReturnValue:&argument];
                [returnLogString appendFormat:@"(unsigned long long) %llu", argument];
                break;
            }
                
            case DaiMethodTracingTypeFloat:
            {
                float argument;
                [invocation getReturnValue:&argument];
                [returnLogString appendFormat:@"(float) %f", argument];
                break;
            }
                
            case DaiMethodTracingTypeDouble:
            {
                double argument;
                [invocation getReturnValue:&argument];
                [returnLogString appendFormat:@"(double) %f", argument];
                break;
            }
                
            case DaiMethodTracingTypeBool:
            {
                BOOL argument;
                [invocation getReturnValue:&argument];
                [returnLogString appendFormat:@"(BOOL) %@", argument ? @"YES" : @"NO"];
                break;
            }
                
            case DaiMethodTracingTypeVoidPointer:
            {
                char *argument;
                [invocation getReturnValue:&argument];
                [returnLogString appendFormat:@"(void*) %s", argument];
                break;
            }
                
            case DaiMethodTracingTypeCharPointer:
            {
                char *argument;
                [invocation getReturnValue:&argument];
                [returnLogString appendFormat:@"(char*) %s", argument];
                break;
            }
                
            case DaiMethodTracingTypeObject:
            {
                id argument;
                [invocation getReturnValue:&argument];
                [returnLogString appendFormat:@"(id) %@", argument];
                break;
            }
                
            case DaiMethodTracingTypeClass:
            {
                Class argument;
                [invocation getReturnValue:&argument];
                [returnLogString appendFormat:@"(Class) %@", argument];
                break;
            }
                
            case DaiMethodTracingTypeSelector:
            {
                SEL argument;
                [invocation getReturnValue:&argument];
                [returnLogString appendFormat:@"(SEL) %@", NSStringFromSelector(argument)];
                break;
            }
                
            case DaiMethodTracingTypeCGRect:
            {
                CGRect argument;
                [invocation getReturnValue:&argument];
                [returnLogString appendFormat:@"(CGRect) %@", NSStringFromCGRect(argument)];
                break;
            }
                
            case DaiMethodTracingTypeCGPoint:
            {
                CGPoint argument;
                [invocation getReturnValue:&argument];
                [returnLogString appendFormat:@"(CGPoint) %@", NSStringFromCGPoint(argument)];
                break;
            }
                
            case DaiMethodTracingTypeCGSize:
            {
                CGSize argument;
                [invocation getReturnValue:&argument];
                [returnLogString appendFormat:@"(CGSize) %@", NSStringFromCGSize(argument)];
                break;
            }
                
            case DaiMethodTracingTypeCGAffineTransform:
            {
                CGAffineTransform argument;
                [invocation getReturnValue:&argument];
                [returnLogString appendFormat:@"(CGAffineTransform) %@", NSStringFromCGAffineTransform(argument)];
                break;
            }
                
            case DaiMethodTracingTypeUIEdgeInsets:
            {
                UIEdgeInsets argument;
                [invocation getReturnValue:&argument];
                [returnLogString appendFormat:@"(UIEdgeInsets) %@", NSStringFromUIEdgeInsets(argument)];
                break;
            }
                
            case DaiMethodTracingTypeUIOffset:
            {
                UIOffset argument;
                [invocation getReturnValue:&argument];
                [returnLogString appendFormat:@"(UIOffset) %@", NSStringFromUIOffset(argument)];
                break;
            }
                
            case DaiMethodTracingTypeVoid:
                [returnLogString appendString:@"void"];
                
            default:
                break;
        }
        NSLog(@"%@", returnLogString);
    }];
}

@end
