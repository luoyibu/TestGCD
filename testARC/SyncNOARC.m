//
//  SyncNOARC.m
//  testARC
//
//  Created by luoxuan-mac on 15/1/7.
//  Copyright (c) 2015年 luoyibu. All rights reserved.
//

#import "SyncNOARC.h"

#define KEY @"uKey"

@interface SyncNOARC ()

@property(nonatomic, retain) NSMutableDictionary *dic;

@end

@implementation SyncNOARC

- (instancetype)init
{
    if (self = [super init]) {
        self.dic = [NSMutableDictionary dictionary];
    }
    return self;
}

#pragma mark - 看看锁是否有效

- (void)setSafeObject:(id)object forKey:(NSString *)key
{
    @synchronized(self.dic)
    {
        NSLog(@"set object begin : %@", object);
        [_dic setObject:object forKey:key];
        NSLog(@"set object end : %@", object);
    }
}

- (id)getSafeObjectForKey:(NSString *)key
{
    @synchronized(self.dic)
    {
        NSLog(@"get object : %@", key);
        id result = [self.dic objectForKey:key];
        return [[result retain] autorelease];
    }
}


- (void)test
{
    for (int i = 0; i < 1000000; i++) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            //多线程写
            [self setSafeObject:[NSString stringWithFormat:@"8613163123143829%i", i] forKey:KEY];
        });
        //主线程读
        NSString *result = [self getSafeObjectForKey:KEY];
        NSLog(@"get string: %@, length : %lu", result, result.length);
    }
    
}

#pragma mark - 看看锁的范围

- (void)priviteSet:(id)object forKey:(NSString *)key
{
    NSLog(@"set object begin : %@", object);
    [_dic setObject:object forKey:key];
//    sleep(3);
    NSLog(@"set object end : %@", object);

}

- (void)setSafeObject1:(id)object forKey:(NSString *)key
{
    @synchronized(self.dic)
    {
        [self priviteSet:object forKey:key];
    }
}

- (void)test1
{
    for (int i = 0; i < 1000000; i++) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            //多线程写
            [self setSafeObject1:[NSString stringWithFormat:@"8613163123143829%i", i] forKey:KEY];
        });
        //主线程读
        NSString *result = [self getSafeObjectForKey:KEY];
        NSLog(@"get string: %@, length : %lu", result, result.length);

    }
}

- (void)dealloc
{
    self.dic = nil;
    [super dealloc];
}


@end
