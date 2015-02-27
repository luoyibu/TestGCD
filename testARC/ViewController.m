//
//  ViewController.m
//  testARC
//
//  Created by luoxuan-mac on 14/10/25.
//  Copyright (c) 2014年 luoyibu. All rights reserved.
//

#import "ViewController.h"
#import "GCDClass.h"
#import "GCDClassNOARC.h"
#import "SyncNOARC.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    GCDClass *object = [[GCDClass alloc] init];
//    [object test];
//    [object release];

//    GCDClassNOARC *noArcObject = [[GCDClassNOARC alloc] init];
//    [noArcObject test1];
//    [noArcObject release];

    SyncNOARC *noArcObject = [[SyncNOARC alloc] init];
    [noArcObject test1];
    
    NSLog(@"done");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
