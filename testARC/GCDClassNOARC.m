//
//  GCDClassNOARC.m
//  testARC
//
//  Created by luoxuan-mac on 14/10/25.
//  Copyright (c) 2014年 luoyibu. All rights reserved.
//

#define KEY @"uKey"

#import "GCDClassNOARC.h"

@interface GCDClassNOARC ()

@property (nonatomic, retain) dispatch_queue_t ioQueue;
@property (nonatomic, retain) NSMutableDictionary *dic;

@end

@implementation GCDClassNOARC

- (void)dealloc
{
    self.ioQueue = nil;
    self.dic = nil;
    [super dealloc];
}

- (instancetype)init
{
    if (self = [super init]) {
        _ioQueue = dispatch_queue_create("ioQueue", DISPATCH_QUEUE_CONCURRENT);
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
    [key release];
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
    for (int i = 0; i < 1000000; i++) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            //多线程写
            [self setSafeObject:[NSString stringWithFormat:@"86+131633829%i", i] forKey:KEY];
        });
        //主线程读
        NSString *result = [[self getSafeObjectForKey:KEY] retain];
        NSLog(@"get string: %@, length : %lu", result, result.length);
        [result release];
    }
}


@end
