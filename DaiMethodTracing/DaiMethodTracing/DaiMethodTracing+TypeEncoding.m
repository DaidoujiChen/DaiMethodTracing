//
//  DaiMethodTracing+TypeEncoding.m
//  DaiMethodTracing
//
//  Created by 啟倫 陳 on 2014/5/27.
//  Copyright (c) 2014年 ChilunChen. All rights reserved.
//

#import "DaiMethodTracing+TypeEncoding.h"

@implementation DaiMethodTracing (TypeEncoding)

DaiMethodTracingType typeEncoding(NSString *type) {
    if (strncmp([type UTF8String], "c", 1) == 0) {
        return DaiMethodTracingTypeChar;
    } else if (strncmp([type UTF8String], "i", 1) == 0) {
        return DaiMethodTracingTypeInt;
    } else if (strncmp([type UTF8String], "s", 1) == 0) {
        return DaiMethodTracingTypeShort;
    } else if (strncmp([type UTF8String], "l", 1) == 0) {
        return DaiMethodTracingTypeLong;
    } else if (strncmp([type UTF8String], "q", 1) == 0) {
        return DaiMethodTracingTypeLongLong;
    } else if (strncmp([type UTF8String], "C", 1) == 0) {
        return DaiMethodTracingTypeUnsignedChar;
    } else if (strncmp([type UTF8String], "I", 1) == 0) {
        return DaiMethodTracingTypeUnsignedInt;
    } else if (strncmp([type UTF8String], "S", 1) == 0) {
        return DaiMethodTracingTypeUnsignedShort;
    } else if (strncmp([type UTF8String], "L", 1) == 0) {
        return DaiMethodTracingTypeUnsignedLong;
    } else if (strncmp([type UTF8String], "Q", 1) == 0) {
        return DaiMethodTracingTypeUnsignedLongLong;
    } else if (strncmp([type UTF8String], "f", 1) == 0) {
        return DaiMethodTracingTypeFloat;
    } else if (strncmp([type UTF8String], "d", 1) == 0) {
        return DaiMethodTracingTypeDouble;
    } else if (strncmp([type UTF8String], "B", 1) == 0) {
        return DaiMethodTracingTypeBool;
    } else if (strncmp([type UTF8String], "v", 1) == 0) {
        return DaiMethodTracingTypeVoid;
    } else if (strncmp([type UTF8String], "^", 1) == 0) {
        return DaiMethodTracingTypeVoidPointer;
    } else if (strncmp([type UTF8String], "*", 1) == 0) {
        return DaiMethodTracingTypeCharPointer;
    } else if (strncmp([type UTF8String], "@", 1) == 0) {
        return DaiMethodTracingTypeObject;
    } else if (strncmp([type UTF8String], "#", 1) == 0) {
        return DaiMethodTracingTypeClass;
    } else if (strncmp([type UTF8String], ":", 1) == 0) {
        return DaiMethodTracingTypeSelector;
    } else if (strncmp([type UTF8String], "?", 1) == 0) {
        return DaiMethodTracingTypeUnknow;
    }
    //上面是比較基本的部分, 下面這些結構參考從 https://github.com/johnno1962/Xtrace
    else if (strncmp([type UTF8String], "{CGRect=", 8) == 0) {
        return DaiMethodTracingTypeCGRect;
    } else if (strncmp([type UTF8String], "{CGPoint=", 9) == 0) {
        return DaiMethodTracingTypeCGPoint;
    } else if (strncmp([type UTF8String], "{CGSize=", 8) == 0) {
        return DaiMethodTracingTypeCGSize;
    } else if (strncmp([type UTF8String], "{CGAffineTransform=", 19) == 0) {
        return DaiMethodTracingTypeCGAffineTransform;
    } else if (strncmp([type UTF8String], "{UIEdgeInsets=", 14) == 0) {
        return DaiMethodTracingTypeUIEdgeInsets;
    } else if (strncmp([type UTF8String], "{UIOffset=", 10) == 0) {
        return DaiMethodTracingTypeUIOffset;
    }
    
	return -1;
}

@end
