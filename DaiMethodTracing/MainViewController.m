//
//  MainViewController.m
//  DaiMethodTracing
//
//  Created by 啟倫 陳 on 2014/5/27.
//  Copyright (c) 2014年 ChilunChen. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController


-(void) didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

typedef struct example {
    char *aString;
    int  anInt;
} Example;

#pragma mark - life cycle

-(void) viewDidLoad {
    [super viewDidLoad];
    
    [DaiMethodTracing tracingClass:[self class]];
    
    Example test;

    [self testFunction:@"aa" test:0 block:^(bool success){
        NSLog(@"hello");
    } struct:test];
}

-(void) testFunction : (NSString*) myString test : (char) aChar block : (void(^)(bool success)) block struct : (Example) astruct {
    block(YES);
    
    [self testFunction2];
}

-(NSArray*) testFunction2 {
    return nil;
}

-(char) testFunction3 {
    return 0;
}

@end
