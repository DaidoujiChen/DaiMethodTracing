//
//  DaiMethodTracingType.h
//  DaiMethodTracing
//
//  Created by DaidoujiChen on 2015/6/10.
//  Copyright (c) 2015年 ChilunChen. All rights reserved.
//

typedef enum {
    DaiMethodTracingTypeChar,
    DaiMethodTracingTypeInt,
    DaiMethodTracingTypeShort,
    DaiMethodTracingTypeLong,
    DaiMethodTracingTypeLongLong,
    DaiMethodTracingTypeUnsignedChar,
    DaiMethodTracingTypeUnsignedInt,
    DaiMethodTracingTypeUnsignedShort,
    DaiMethodTracingTypeUnsignedLong,
    DaiMethodTracingTypeUnsignedLongLong,
    DaiMethodTracingTypeFloat,
    DaiMethodTracingTypeDouble,
    DaiMethodTracingTypeBool,
    DaiMethodTracingTypeVoid,
    DaiMethodTracingTypeVoidPointer,
    DaiMethodTracingTypeCharPointer,
    DaiMethodTracingTypeObject,
    DaiMethodTracingTypeClass,
    DaiMethodTracingTypeSelector,
    DaiMethodTracingTypeUnknow,
    
    DaiMethodTracingTypeCGRect,
    DaiMethodTracingTypeCGPoint,
    DaiMethodTracingTypeCGSize,
    DaiMethodTracingTypeCGAffineTransform,
    DaiMethodTracingTypeUIEdgeInsets,
    DaiMethodTracingTypeUIOffset
} DaiMethodTracingType;

DaiMethodTracingType tracingType(NSString *type);