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
        
        NSString *errorText = nil;
        BOOL result = [calculation checkCalculateStringOnValid:&errorText];
        
        XCTAssertFalse(result, @"Error check calculate string on valid with not valid string!");
    }
}

- (void)testCalculateStringOnValidCharacterWithValidString {
    
    VMCalculation *calculation = [[VMCalculation alloc] init];
    calculation.calculateString = @"(0+1-2*3/4+5.5-6)+(7-8)*9";
    
    NSString *errorText = nil;
    BOOL result = [calculation checkCalculateStringOnValid:&errorText];
    
    XCTAssertTrue(result, @"Error check calculate string on valid with valid string!");
}

- (void)testCalculateWithNotValidString {
    
    NSArray *array = @[@".1+2", @"1++1", @"()", @"(+1)", @"10.1.1+2", @"((1+1)", @"(1+1))", @"(1+1)(2*2)", @"1+.1", @"2/(5-5)"];
    
    for (NSString *calculateString in array) {
        
        VMCalculation *calculation = [[VMCalculation alloc] init];
        calculation.calculateString = calculateString;
        
        NSString *errorText = nil;
        double result = [calculation calculate:&errorText];
        
        XCTAssertNotNil(errorText, @"Error check calculate with not valid string! Expression: %@. Result: %.2f", calculateString, result);
    }
}

- (void)testCalculateWithValidString {
    
    NSArray *calculateStrings = @[@"(8+2*5)/(1+3*2-4)", @"1+2-3", @"5.5+10*(2+3)", @"567*(25/5+17)/3"];
    NSArray *results = @[@6.0, @0.0, @55.5, @4158.0];
    
    for (NSInteger i = 0; i < calculateStrings.count; i++) {
        
        VMCalculation *calculation = [[VMCalculation alloc] init];
        calculation.calculateString = [calculateStrings objectAtIndex:i];
        
        NSString *errorText = nil;
        double result = [calculation calculate:&errorText];
        
        XCTAssertEqual(result, [(NSNumber *)[results objectAtIndex:i] doubleValue], @"Error check calculate with valid string! Result: %.2f", result);
    }
}

@end
