//
//  DaiMethodTracing+TypeEncoding.h
//  DaiMethodTracing
//
//  Created by 啟倫 陳 on 2014/5/27.
//  Copyright (c) 2014年 ChilunChen. All rights reserved.
//

#import "DaiMethodTracing.h"

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

@interface DaiMethodTracing (TypeEncoding)

DaiMethodTracingType typeEncoding(NSString *type);

@end
