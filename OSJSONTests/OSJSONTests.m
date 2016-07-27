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

- (void)testItIsPossibleToFetchAFloatValueFromADictionary {
    NSData *fixture = [self jsonDataFromFixture:@"{ \"test\": 2.1 }"];
    OSJSON *json = [[OSJSON alloc] initWithData:fixture];
    XCTAssertEqual([json floatValueForKey:@"test"], 2.1f);
}

- (void)testItIsPossibleToFetchAnIntValueFromADictionary {
    NSData *fixture = [self jsonDataFromFixture:@"{ \"test\": 2 }"];
    OSJSON *json = [[OSJSON alloc] initWithData:fixture];
    XCTAssertEqual([json intValueForKey:@"test"], 2);
}

- (void)testItIsPossibleToFetchABoolValueFromADictionary {
    NSData *fixture = [self jsonDataFromFixture:@"{ \"test\": true }"];
    OSJSON *json = [[OSJSON alloc] initWithData:fixture];
    XCTAssertTrue([json boolValueForKey:@"test"]);
}

- (void)testItIsPossibleToFetchAnArrayValueFromADictionary {
    NSData *fixture = [self jsonDataFromFixture:@"{ \"test\": [ 1, 2, 3 ] }"];
    OSJSON *json = [[OSJSON alloc] initWithData:fixture];
    NSArray *testArray = @[ @1, @2, @3 ];
    XCTAssertEqualObjects([json arrayValueForKey:@"test"], testArray);
}

- (void)testItIsPossibleToFetchAnArrayOfJsonObjects {
    NSData *fixture = [self jsonDataFromFixture:@"{ \"test\": [ {\"key\": \"value\"}, {}, {} ] }"];
    OSJSON *json = [[OSJSON alloc] initWithData:fixture];
    NSArray *receivedArray = [json jsonArrayForKey:@"test"];
    for (id object in receivedArray) {
        XCTAssert([object isKindOfClass:[OSJSON class]]);
    }
    OSJSON *first = receivedArray.firstObject;
    XCTAssertEqualObjects([first stringValueForKey:@"key"], @"value");
}

- (void)testItIsPossibleToFetchAnArrayOfNumbers {
    NSData *fixture = [self jsonDataFromFixture:@"{ \"test\": [ 1, 2, 3 ] }"];
    OSJSON *json = [[OSJSON alloc] initWithData:fixture];
    NSArray *testArray = @[ @1, @2, @3 ];
    XCTAssertEqualObjects([json numberArrayForKey:@"test"], testArray);
}

- (void)testItIsPossibleToFetchAStringArray {
    NSData *fixture = [self jsonDataFromFixture:@"{ \"test\": [ \"1\", \"2\", \"3\" ] }"];
    OSJSON *json = [[OSJSON alloc] initWithData:fixture];
    NSArray *testArray = @[ @"1", @"2", @"3" ];
    XCTAssertEqualObjects([json stringArrayForKey:@"test"], testArray);
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

- (void)testInitWithInvalidJsonDataReturnsANilOSJSON {
    NSData *badJsonData = [self jsonDataFromFixture:@"<!:@"];
    OSJSON *json = [[OSJSON alloc] initWithData:badJsonData];
    XCTAssertNil(json);
}

- (void)testArrayForKeyReturnsNilIfNoArrayPresent {
    NSData *fixture = [self jsonDataFromFixture:@"{ \"test\": { \"key\": \"value\" }}"];
    OSJSON *json = [[OSJSON alloc] initWithData:fixture];
    XCTAssertNil([json arrayValueForKey:@"test"]);
}

- (void)testJsonArrayForKeyReturnsNilIfNoArrayPresent {
    NSData *fixture = [self jsonDataFromFixture:@"{ \"test\": { \"key\": \"value\" }}"];
    OSJSON *json = [[OSJSON alloc] initWithData:fixture];
    XCTAssertNil([json jsonArrayForKey:@"test"]);
}

- (void)testItIsPossibleToDecodeADataBlob {
    NSData *testData = [@"test string" dataUsingEncoding:NSUTF8StringEncoding];
    NSString *base64 = [testData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    NSData *fixture = [self jsonDataFromFixture:[NSString stringWithFormat:@"{ \"test\": \"%@\" }", base64]];
    OSJSON *json = [[OSJSON alloc] initWithData:fixture];
    NSData *receivedData = [json dataValueForKey:@"test"];
    NSString *receivedString = [[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding];
    XCTAssertEqualObjects(@"test string", receivedString);
}

- (void)testItIsPossibleToDecodeSomeLovelyBase64 {
    NSString *base64String = @"MIIT6AYJKoZIhvcNAQcCoIIT2TCCE9UCAQExCzAJBgUrDgMCGgUAMIIDiQYJKoZI\\nhvcNAQcBoIIDegSCA3YxggNyMAoCAQgCAQEEAhYAMAoCARQCAQEEAgwAMAsCAQEC\\nAQEEAwIBADALAgELAgEBBAMCAQAwCwIBDgIBAQQDAgF5MAsCAQ8CAQEEAwIBADAL\\nAgEQAgEBBAMCAQAwCwIBGQIBAQQDAgEDMAwCAQoCAQEEBBYCNCswDQIBDQIBAQQF\\nAgMBX5IwDQIBEwIBAQQFDAMxLjAwDgIBAwIBAQQGDAQxMTczMA4CAQkCAQEEBgIE\\nUDI0NDAYAgEEAgECBBDvLttDWXKhy6naym1SW4lmMBsCAQACAQEEEwwRUHJvZHVj\\ndGlvblNhbmRib3gwHAIBBQIBAQQU8DIfkmEzZV2DTZ4Xg9NGtC4RV3gwHgIBDAIB\\nAQQWFhQyMDE2LTA2LTE3VDA5OjA5OjQyWjAeAgESAgEBBBYWFDIwMTMtMDgtMDFU\\nMDc6MDA6MDBaMCUCAQICAQEEHQwbdWsuY28ub3JkbmFuY2VzdXJ2ZXkub3NtYXBz\\nMEACAQYCAQEEOPr9Td1wZWr4uLtvwB+BRWKIyVtTrGyFJPTkTcus/ZkUD67L9gyC\\ndYTbQEzkJ93r4o3lEt8J/qxXMFUCAQcCAQEETbV+gGCml5zttwJJsjtTwJPu6rjR\\n0VzBNUGHqkWe+YfjynGfmdunnHHEIb0Oy0W0LQHuJ9ZARk/HhSl03uHms8ZgcFIy\\novbd3OLdc5zGMIIBZwIBEQIBAQSCAV0xggFZMAsCAgasAgEBBAIWADALAgIGrQIB\\nAQQCDAAwCwICBrACAQEEAhYAMAsCAgayAgEBBAIMADALAgIGswIBAQQCDAAwCwIC\\nBrQCAQEEAgwAMAsCAga1AgEBBAIMADALAgIGtgIBAQQCDAAwDAICBqUCAQEEAwIB\\nATAMAgIGqwIBAQQDAgECMAwCAgauAgEBBAMCAQAwDAICBq8CAQEEAwIBADAMAgIG\\nsQIBAQQDAgEAMBsCAganAgEBBBIMEDEwMDAwMDAyMTgyMzQyNTEwGwICBqkCAQEE\\nEgwQMTAwMDAwMDIxODIzNDI1MTAfAgIGqAIBAQQWFhQyMDE2LTA2LTE3VDA5OjA5\\nOjQyWjAfAgIGqgIBAQQWFhQyMDE2LTA2LTE3VDA5OjA5OjQyWjAtAgIGpgIBAQQk\\nDCJ1ay5jby5vcmRuYW5jZXN1cnZleS5vc21hcHMuMW1vbnRooIIOZTCCBXwwggRk\\noAMCAQICCA7rV4fnngmNMA0GCSqGSIb3DQEBBQUAMIGWMQswCQYDVQQGEwJVUzET\\nMBEGA1UECgwKQXBwbGUgSW5jLjEsMCoGA1UECwwjQXBwbGUgV29ybGR3aWRlIERl\\ndmVsb3BlciBSZWxhdGlvbnMxRDBCBgNVBAMMO0FwcGxlIFdvcmxkd2lkZSBEZXZl\\nbG9wZXIgUmVsYXRpb25zIENlcnRpZmljYXRpb24gQXV0aG9yaXR5MB4XDTE1MTEx\\nMzAyMTUwOVoXDTIzMDIwNzIxNDg0N1owgYkxNzA1BgNVBAMMLk1hYyBBcHAgU3Rv";
    NSData *fixture = [self jsonDataFromFixture:[NSString stringWithFormat:@"{ \"test\": \"%@\" }", base64String]];
    OSJSON *json = [[OSJSON alloc] initWithData:fixture];
    NSData *receivedData = [json dataValueForKey:@"test"];
    XCTAssertNotNil(receivedData);
}

- (void)testNSNullIsReturnedAsNil {
    NSData *fixture = [self jsonDataFromFixture:@"{ \"test\": null }"];
    OSJSON *json = [[OSJSON alloc] initWithData:fixture];
    XCTAssertNil([json stringValueForKey:@"test"]);
}

@end
