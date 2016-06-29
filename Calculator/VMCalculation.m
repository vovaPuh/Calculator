//
//  VMCalculation.m
//  Calculator
//
//  Created by Владимир Микита on 29.06.16.
//  Copyright © 2016 Vladimir Mikita. All rights reserved.
//

#import "VMCalculation.h"

@implementation VMCalculation

- (NSString *)checkCalculateStringOnValid {
    
    if ([self.calculateString isEqualToString:@""]) {
        return @"Calculate string is empty!";
    }
    
    NSCharacterSet *validationSet = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789-+*/()."] invertedSet];
    NSArray *components = [self.calculateString componentsSeparatedByCharactersInSet:validationSet];
    
    if (components.count > 1) {
        return @"Not correct expression in calculate string";
    }
    
    return @"";
}

@end
