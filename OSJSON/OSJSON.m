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
    if (object == nil) {
        return nil;
    }
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

- (NSData *)dataValueForKey:(NSString *)key {
    NSString *value = [self stringValueForKey:key];
    return [[NSData alloc] initWithBase64EncodedString:value options:0];
}

- (double)doubleValueForKey:(NSString *)key {
    return [[self.rootDictionary objectForKey:key] doubleValue];
}

- (float)floatValueForKey:(NSString *)key {
    return [[self.rootDictionary objectForKey:key] floatValue];
}

- (long)intValueForKey:(NSString *)key {
    return [[self.rootDictionary objectForKey:key] longValue];
}

- (BOOL)boolValueForKey:(NSString *)key {
    return [[self.rootDictionary objectForKey:key] boolValue];
}

- (NSArray *)arrayValueForKey:(NSString *)key {

    return [NSArray os_json_safeCast:[self.rootDictionary objectForKey:key]];
}

- (NSArray<OSJSON *> *)jsonArrayForKey:(NSString *)key {
    NSArray *array = [self arrayValueForKey:key];
    if (array == nil) {
        return nil;
    }
    NSMutableArray *results = [NSMutableArray arrayWithCapacity:array.count];
    [array enumerateObjectsUsingBlock:^(id _Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        [results addObject:[[OSJSON alloc] initWithObject:obj]];
    }];
    return results;
}

- (NSArray<NSNumber *> *)numberArrayForKey:(NSString *)key {
    return [self arrayValueForKey:key];
}

- (NSArray<NSString *> *)stringArrayForKey:(NSString *)key {
    return [self arrayValueForKey:key];
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
