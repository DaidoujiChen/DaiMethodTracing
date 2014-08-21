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
			[self testFunction:@"aa" test:0 block: ^(bool success) {
                NSLog(@"hello");
            }];
			break;
            
		case 1:
			[self testFunction3];
			break;
            
		case 2:
			[MainViewController testFunction4:@"hello"];
			break;
            
		case 3:
			[MainViewController testFunction5];
			break;
            
		default:
			break;
	}
}

- (IBAction)pushAction:(id)sender
{
	[self.navigationController pushViewController:[MainViewController new] animated:YES];
}

#pragma mark - life cycle

- (void)viewDidLoad
{
	[super viewDidLoad];
	[DaiMethodTracing tracingClass:[self class]];
}

- (void)testFunction:(NSString *)myString test:(char)aChar block:(void (^)(bool success))block
{
	block(YES);
	[self testFunction2];
}

- (NSArray *)testFunction2
{
	return @[@"daidouji", @"chen"];
}

- (char)testFunction3
{
	return 0;
}

+ (void)testFunction4:(NSString *)myString
{
}

+ (CGPoint)testFunction5
{
	return CGPointMake(0, 0);
}

- (void)dealloc
{
	NSLog(@"dealloc %@", self);
}

@end
