//
//  GCDClass.m
//  testARC
//
//  Created by luoxuan-mac on 14/10/25.
//  Copyright (c) 2014年 luoyibu. All rights reserved.
//

#define KEY @"uKey"

#import "GCDClass.h"

@interface GCDClass ()

@property (nonatomic, retain) dispatch_queue_t ioQueue;

@property (nonatomic, retain) NSMutableDictionary *dic;

@end

@implementation GCDClass

- (instancetype)init
{
    if (self = [super init]) {
        self.ioQueue = dispatch_queue_create("ioQueue", DISPATCH_QUEUE_CONCURRENT);
        self.dic = [NSMutableDictionary dictionaryWithCapacity:1];
    }
    return self;
}

- (void)setSafeObject:(id)object forKey:(NSString *)key
{
    key = [key copy];
    dispatch_barrier_async(self.ioQueue, ^{
        if (key && object) {
            [_dic setObject:object forKey:key];
        }
    });
    NSLog(@"set object : %i", [object intValue]);
}

- (id)getSafeObjectForKey:(NSString *)key
{
    __block id result = nil;
    dispatch_sync(self.ioQueue, ^{
        result = [_dic objectForKey:key];
    });
    return result;
}

- (void)test
{
    for (int i = 0; i < 100000; i++) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            //多线程写
            [self setSafeObject:@(i) forKey:KEY];
        });
        //主线程读
        NSLog(@"get int : %i", [[self getSafeObjectForKey:KEY] intValue]);
    }
}

@end
