//
//  OSJSON.m
//  OSJSON
//
//  Created by Dave Hardiman on 02/03/2016.
//  Copyright © 2016 Ordnance Survey. All rights reserved.
//

#import "OSJSON.h"

@interface NSObject (SafeCast)
+ (instancetype)os_json_safeCast:(id)object;
@end

@interface OSJSON ()
@property (nonatomic, strong) NSObject *root;
@property (nonatomic, readonly) NSDictionary *rootDictionary;
@property (nonatomic, readonly) NSArray *rootArray;
@end

@implementation OSJSON

- (instancetype)initWithObject:(NSObject *)object {
    if ((self = [super init])) {
        _root = object;
    }
    return self;
}

- (instancetype)initWithData:(NSData *)data {
    NSObject *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    return [self initWithObject:json];
}

- (instancetype)initWithData:(NSData *)data initialKeyPath:(NSString *)initialKeyPath {
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    return [self initWithObject:[json valueForKeyPath:initialKeyPath]];
}

- (NSDictionary *)rootDictionary {
    return [NSDictionary os_json_safeCast:self.root];
}

- (NSString *)stringValueForKey:(NSString *)key {
    return [self.rootDictionary objectForKey:key];
}

- (double)doubleValueForKey:(NSString *)key {
    return [[self.rootDictionary objectForKey:key] doubleValue];
}

- (int)intValueForKey:(NSString *)key {
    return [[self.rootDictionary objectForKey:key] intValue];
}

- (NSArray *)arrayValueForKey:(NSString *)key {
    return [self.rootDictionary objectForKey:key];
}

- (OSJSON *)jsonForKey:(NSString *)key {
    NSDictionary *dict = [self.rootDictionary objectForKey:key];
    return dict ? [[OSJSON alloc] initWithObject:dict] : nil;
}

- (NSArray *)rootArray {
    return [NSArray os_json_safeCast:self.root];
}

- (NSArray<OSJSON *> *)array {
    NSArray *root = self.rootArray;
    if (root == nil) {
        return nil;
    }
    NSMutableArray *results = [NSMutableArray array];
    for (NSObject *item in root) {
        OSJSON *jsonItem = [[OSJSON alloc] initWithObject:item];
        [results addObject:jsonItem];
    }
    return results;
}

@end

@implementation NSObject (SafeCast)

+ (instancetype)os_json_safeCast:(id)object {
    if ([object isKindOfClass:self]) {
        return object;
    }
    return nil;
}

@end
