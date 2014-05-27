//
//  DaiMethodTracing+TypeEncoding.m
//  DaiMethodTracing
//
//  Created by 啟倫 陳 on 2014/5/27.
//  Copyright (c) 2014年 ChilunChen. All rights reserved.
//

#import "DaiMethodTracing+TypeEncoding.h"

@implementation DaiMethodTracing (TypeEncoding)

DaiMethodTracingType typeEncoding(NSString* type) {
    
    if ([type isEqualToString:@"c"]) {
        return DaiMethodTracingTypeChar;
    } else if ([type isEqualToString:@"i"]) {
        return DaiMethodTracingTypeInt;
    } else if ([type isEqualToString:@"s"]) {
        return DaiMethodTracingTypeShort;
    } else if ([type isEqualToString:@"l"]) {
        return DaiMethodTracingTypeLong;
    } else if ([type isEqualToString:@"q"]) {
        return DaiMethodTracingTypeLongLong;
    } else if ([type isEqualToString:@"C"]) {
        return DaiMethodTracingTypeUnsignedChar;
    } else if ([type isEqualToString:@"I"]) {
        return DaiMethodTracingTypeUnsignedInt;
    } else if ([type isEqualToString:@"S"]) {
        return DaiMethodTracingTypeUnsignedShort;
    } else if ([type isEqualToString:@"L"]) {
        return DaiMethodTracingTypeUnsignedLong;
    } else if ([type isEqualToString:@"Q"]) {
        return DaiMethodTracingTypeUnsignedLongLong;
    } else if ([type isEqualToString:@"f"]) {
        return DaiMethodTracingTypeFloat;
    } else if ([type isEqualToString:@"d"]) {
        return DaiMethodTracingTypeDouble;
    } else if ([type isEqualToString:@"B"]) {
        return DaiMethodTracingTypeBool;
    } else if ([type isEqualToString:@"v"]) {
        return DaiMethodTracingTypeVoid;
    } else if ([type isEqualToString:@"*"]) {
        return DaiMethodTracingTypeCharPointer;
    } else if ([type isEqualToString:@"@"]) {
        return DaiMethodTracingTypeObject;
    } else if ([type isEqualToString:@"#"]) {
        return DaiMethodTracingTypeClass;
    } else if ([type isEqualToString:@":"]) {
        return DaiMethodTracingTypeSelector;
    } else if ([type isEqualToString:@"?"]) {
        return DaiMethodTracingTypeUnknow;
    }
    
    return -1;
    
}

@end
