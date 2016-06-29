//
//  CalculatorTests.m
//  CalculatorTests
//
//  Created by Владимир Микита on 29.06.16.
//  Copyright © 2016 Vladimir Mikita. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "VMCalculation.h"

@interface CalculatorTests : XCTestCase

@end

@implementation CalculatorTests

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testCalculateStringOnValidCharacterWithNotValidString {
    
    NSArray *array = @[@"", @"Test"];
    
    for (NSString *calculateString in array) {
        
        VMCalculation *calculation = [[VMCalculation alloc] init];
        calculation.calculateString = calculateString;
        
        NSString *result = [calculation checkCalculateStringOnValid];
        XCTAssertNotEqualObjects(result, @"", @"Error check calculate string on valid with not valid string!");
    }
}

- (void)testCalculateStringOnValidCharacterWithValidString {
    
    VMCalculation *calculation = [[VMCalculation alloc] init];
    calculation.calculateString = @"(0+1-2*3/4+5.5-6)+(7-8)*9";
    
    NSString *result = [calculation checkCalculateStringOnValid];
    XCTAssertEqualObjects(result, @"", @"Error check calculate string on valid with valid string!");
}

- (void)testCalculateWithNotValidString {
    
    NSArray *array = @[@".1+2", @"1++1", @"()", @"(+1)", @"10.1.1+2", @"((1+1)", @"(1+1))", @"(1+1)(2*2)", @"1+.1"];
    
    for (NSString *calculateString in array) {
        
        VMCalculation *calculation = [[VMCalculation alloc] init];
        calculation.calculateString = calculateString;
        
        NSString *result = [calculation calculate];
        XCTAssertNotEqualObjects(result, @"", @"Error check calculate with not valid string! Expression: %@", calculateString);
    }
}

- (void)testCalculateWithValidString {
    
    VMCalculation *calculation = [[VMCalculation alloc] init];
    calculation.calculateString = @"(8+2*5)/(1+3*2-4)";
    
    NSString *result = [calculation calculate];
    XCTAssertEqualObjects(result, @"", @"Error check calculate with valid string!");
}

@end
