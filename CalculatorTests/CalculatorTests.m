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

@property (strong, nonatomic) VMCalculation *calculation;

@end

@implementation CalculatorTests

- (void)setUp {
    [super setUp];
    self.calculation = [[VMCalculation alloc] init];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testCalculateStringOnValidCharacterWithNotValidString {
    
    NSArray *array = @[@"", @"Test"];
    
    for (NSString *calculateString in array) {
        
        self.calculation.calculateString = calculateString;
        NSString *result = [self.calculation checkCalculateStringOnValid];
        
        XCTAssertNotEqualObjects(result, @"", @"Error check calculate string on valid with not valid string!");
    }
}

- (void)testCalculateStringOnValidCharacterWithValidString {
    
    self.calculation.calculateString = @"(0+1-2*3/4+5.5-6)+(7-8)*9";
    NSString *result = [self.calculation checkCalculateStringOnValid];
    
    XCTAssertEqualObjects(result, @"", @"Error check calculate string on valid with valid string!");
}

@end
