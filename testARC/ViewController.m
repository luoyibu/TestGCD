//
//  ViewController.m
//  testARC
//
//  Created by luoxuan-mac on 14/10/25.
//  Copyright (c) 2014年 luoyibu. All rights reserved.
//

#import "ViewController.h"
#import "GCDClass.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    GCDClass *object = [[GCDClass alloc] init];
    [object test];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
