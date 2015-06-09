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

#pragma mark - ibaction

- (IBAction)testAction:(id)sender
{
    switch (arc4random() % 4) {
        case 0:
            [self testMethod:@"aa" char:0 block: ^NSString *(bool success, void (^blockInBlock)(BOOL finish)) {
                NSLog(@"hello");
                blockInBlock(NO);
                return @"daidouji";
            }];
            break;
            
        case 1:
            [self testMethod3];
            break;
            
        case 2:
            [MainViewController testMethod4:@"hello"];
            break;
            
        case 3:
            [MainViewController testMethod5];
            break;
            
        default:
            break;
    }
}

- (IBAction)pushAction:(id)sender
{
    [self.navigationController pushViewController:[MainViewController new] animated:YES];
}

#pragma mark - private instance method

- (void)testMethod:(NSString *)myString char :(char)aChar block:(NSString * (^)(bool success, void (^blockInBlock)(BOOL finish)))block
{
    NSLog(@"%@", block(YES, ^(BOOL finish) {
        NSLog(@"ok finish");
    }));
    [self testMethod2];
}

- (NSArray *)testMethod2
{
    return @[@"daidouji", @"chen"];
}

- (char)testMethod3 {
    return 0;
}

+ (void)testMethod4:(NSString *)myString
{
}

+ (CGPoint)testMethod5 {
    return CGPointMake(0, 0);
}

#pragma mark - life cycle

+ (void)load
{
    [DaiMethodTracing tracingClass:[MainViewController class]];
}

- (void)dealloc
{
    NSLog(@"dealloc %@", self);
}

@end
