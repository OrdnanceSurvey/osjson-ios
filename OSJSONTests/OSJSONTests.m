//
//  OSJSONTests.m
//  OSJSONTests
//
//  Created by Dave Hardiman on 10/03/2016.
//  Copyright © 2016 Ordnance Survey. All rights reserved.
//

#import <XCTest/XCTest.h>
@import OSJSON;

@interface OSJSONTests : XCTestCase

@end

@implementation OSJSONTests

- (NSData *)jsonDataFromFixture:(NSString *)fixtureString {
    return [fixtureString dataUsingEncoding:NSUTF8StringEncoding];
}

- (void)testItIsPossibleToFetchAStringValueFromADictionary {
    NSData *fixture = [self jsonDataFromFixture:@"{ \"test\": \"value\" }"];
    OSJSON *json = [[OSJSON alloc] initWithData:fixture];
    XCTAssertEqualObjects([json stringValueForKey:@"test"], @"value");
}

- (void)testItIsPossibleToSetAnInitialKeyPath {
    NSData *fixture = [self jsonDataFromFixture:@"{ \"subObject\": { \"test\": \"value\" } }"];
    OSJSON *json = [[OSJSON alloc] initWithData:fixture initialKeyPath:@"subObject"];
    XCTAssertEqualObjects([json stringValueForKey:@"test"], @"value");
}

- (void)testItIsPossibleToFetchADoubleValueFromADictionary {
    NSData *fixture = [self jsonDataFromFixture:@"{ \"test\": 2.1 }"];
    OSJSON *json = [[OSJSON alloc] initWithData:fixture];
    XCTAssertEqual([json doubleValueForKey:@"test"], 2.1);
}

- (void)testItIsPossibleToFetchAnIntValueFromADictionary {
    NSData *fixture = [self jsonDataFromFixture:@"{ \"test\": 2 }"];
    OSJSON *json = [[OSJSON alloc] initWithData:fixture];
    XCTAssertEqual([json intValueForKey:@"test"], 2);
}

- (void)testItIsPossibleToFetchAnArrayValueFromADictionary {
    NSData *fixture = [self jsonDataFromFixture:@"{ \"test\": [ 1, 2, 3 ] }"];
    OSJSON *json = [[OSJSON alloc] initWithData:fixture];
    NSArray *testArray = @[ @1, @2, @3 ];
    XCTAssertEqualObjects([json arrayValueForKey:@"test"], testArray);
}

- (void)testItIsPossibleToFetchAJSONValueFromADictionary {
    NSData *fixture = [self jsonDataFromFixture:@"{ \"test\": { \"key\": \"value\" }}"];
    OSJSON *json = [[OSJSON alloc] initWithData:fixture];
    OSJSON *subJson = [json jsonForKey:@"test"];
    XCTAssertEqualObjects([subJson stringValueForKey:@"key"], @"value");
}

- (void)testItIsPossibleToUseAnObjectWithARootArray {
    NSData *fixture = [self jsonDataFromFixture:@"[ { \"key\": \"value\" } ]"];
    OSJSON *json = [[OSJSON alloc] initWithData:fixture];
    OSJSON *first = json.array.firstObject;
    XCTAssertEqualObjects([first stringValueForKey:@"key"], @"value");
}

- (void)testTheRootArrayIsNilIfTheRootObjectIsADictionary {
    NSData *fixture = [self jsonDataFromFixture:@"{ \"key\": \"value\" }"];
    OSJSON *json = [[OSJSON alloc] initWithData:fixture];
    XCTAssertNil(json.array);
}

- (void)testAMissingValueIsReturnedAsNilOrZero {
    NSData *fixture = [self jsonDataFromFixture:@"{}"];
    OSJSON *json = [[OSJSON alloc] initWithData:fixture];
    XCTAssertNil([json stringValueForKey:@"test"]);
    XCTAssertNil([json jsonForKey:@"test"]);
    XCTAssertNil([json arrayValueForKey:@"test"]);
    XCTAssertEqual([json intValueForKey:@"test"], 0);
    XCTAssertEqual([json doubleValueForKey:@"test"], 0);
}

@end
