//
//  ViewController.m
//  PhotoAssets
//
//  Created by yanshu on 15/6/23.
//  Copyright (c) 2015年 yanshu. All rights reserved.
//

#import "ViewController.h"
#import "PhotoViewController.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = (CGRect){CGPointMake(50, 90), CGSizeMake(100, 50)};
    button.backgroundColor = [UIColor blueColor];
    [button setTitle:@"照片" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(push:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}
- (void)push:(UIButton *)button
{
    PhotoViewController *photoVC = [[PhotoViewController alloc] init];
    [self.navigationController pushViewController:photoVC  animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
