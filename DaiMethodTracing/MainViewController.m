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

#pragma mark - life cycle

-(void) viewDidLoad {
    [super viewDidLoad];
    
    [DaiMethodTracing tracingClass:[self class]];

    [self testFunction:@"aa" test:0 block:^(bool success){
        NSLog(@"hello");
    }];
    
    [MainViewController testFunction4:@"hello"];
}

-(void) testFunction : (NSString*) myString test : (char) aChar block : (void(^)(bool success)) block {
    block(YES);
    
    NSLog(@"%@", [self testFunction2]);
}

-(NSArray*) testFunction2 {
    return @[@"daidouji", @"chen"];
}

-(char) testFunction3 {
    return 0;
}

+(void) testFunction4 : (NSString*) myString {
}

@end
