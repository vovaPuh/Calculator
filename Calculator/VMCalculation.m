//
//  VMCalculation.m
//  Calculator
//
//  Created by Владимир Микита on 29.06.16.
//  Copyright © 2016 Vladimir Mikita. All rights reserved.
//

#import "VMCalculation.h"

static NSString *specialSymbol = @"⍊";
static NSString *notCorrectExpression = @"Not correct expression in calculate string";

@interface VMCalculation ()

@property (strong, nonatomic) NSDictionary *operations;
@property (strong, nonatomic) NSDictionary *operationsPriority;
@property (strong, nonatomic) NSMutableArray *components;

@end

@implementation VMCalculation

- (instancetype)init {
    
    self = [super init];
    
    if (self) {
        
        self.components = [[NSMutableArray alloc] init];
        self.operations = @{@"-":^double (double firstOperand, double secondOperand, NSString *errorText) { return firstOperand - secondOperand; },
                            @"+":^double (double firstOperand, double secondOperand, NSString *errorText) { return firstOperand + secondOperand; },
                            @"*":^double (double firstOperand, double secondOperand, NSString *errorText) { return firstOperand * secondOperand; },
                            @"/":^double (double firstOperand, double secondOperand, NSString *errorText) {
                                if (secondOperand == 0.0) {
                                    errorText = @"Not correct expression in calculate string";
                                    return 0.0;
                                }
                                return firstOperand / secondOperand;
                            }};
        self.operationsPriority = @{specialSymbol:@{specialSymbol:@4, @"+":@2, @"-":@2, @"*":@2, @"/":@2, @"(":@5},
                                    @"+":@{specialSymbol:@1, @"+":@2, @"-":@2, @"*":@2, @"/":@2, @"(":@1},
                                    @"-":@{specialSymbol:@1, @"+":@2, @"-":@2, @"*":@2, @"/":@2, @"(":@1},
                                    @"*":@{specialSymbol:@1, @"+":@1, @"-":@1, @"*":@2, @"/":@2, @"(":@1},
                                    @"/":@{specialSymbol:@1, @"+":@2, @"-":@2, @"*":@2, @"/":@2, @"(":@1},
                                    @"(":@{specialSymbol:@1, @"+":@1, @"-":@1, @"*":@1, @"/":@1, @"(":@1},
                                    @")":@{specialSymbol:@5, @"+":@2, @"-":@2, @"*":@2, @"/":@2, @"(":@3}};
    }
    
    return self;
}

- (void)setCalculateString:(NSString *)calculateString {
    _calculateString = [calculateString stringByReplacingOccurrencesOfString:@" " withString:@""];
}

- (NSString *)checkCalculateStringOnValid {
    
    if ([self.calculateString isEqualToString:@""]) {
        return @"Calculate string is empty!";
    }
    
    NSCharacterSet *validationSet = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789-+*/()."] invertedSet];
    NSArray *components = [self.calculateString componentsSeparatedByCharactersInSet:validationSet];
    
    if (components.count > 1) {
        return notCorrectExpression;
    }
    
    return @"";
}

- (BOOL)addNumberInComponents:(NSString *)number {
    
    if ([number isEqualToString:@""]) {
        return true;
    }
    
    if ([number containsString:@"."]) {
        
        NSArray *components = [number componentsSeparatedByString:@"."];
        
        if (components.count != 2 || [components.firstObject isEqualToString:@""] || [components.lastObject isEqualToString:@""]) {
            return false;
        }
    }
    
    [self.components addObject:[NSNumber numberWithDouble:number.doubleValue]];
    
    return true;
}

- (BOOL)parseCalculateString {
    
    NSString *calculateString = [self.calculateString stringByAppendingString:specialSymbol];
    NSMutableArray *waitOperations = [NSMutableArray arrayWithArray:@[specialSymbol]];
    NSString *number = @"";
    NSString *curCharacter = @"";
    NSString *prevCharacter = @"";
    
    for (NSInteger i = 0; i < calculateString.length; i++) {
        
        NSRange range;
        range.location = i;
        range.length = 1;
        
        prevCharacter = curCharacter;
        curCharacter = [calculateString substringWithRange:range];
        
        if ([self.operations objectForKey:curCharacter] != nil) {
            
            if ([self.operations objectForKey:prevCharacter] != nil || [prevCharacter isEqualToString:@"("]) {
                return false;
            }
            
        } else if ([curCharacter isEqualToString:@"("]) {
            
            if (![prevCharacter isEqualToString:@""] && [self.operations objectForKey:prevCharacter] == nil) {
                return false;
            }
        }
        
        NSDictionary *operationPriority = [self.operationsPriority objectForKey:curCharacter];
        
        if (operationPriority != nil) {
            
            if (![self addNumberInComponents:number]) {
                return false;
            }
            
            number = @"";
            BOOL next = false;
            
            while (!next) {
                
                NSNumber *priority = [operationPriority objectForKey:waitOperations.lastObject];
                
                switch (priority.integerValue) {
                    case 1:
                        [waitOperations addObject:curCharacter];
                        next = true;
                        break;
                        
                    case 2:
                        [self.components addObject:waitOperations.lastObject];
                        [waitOperations removeLastObject];
                        break;
                        
                    case 3:
                        [waitOperations removeLastObject];
                        next = true;
                        break;
                    
                    case 4:
                        return true;
                        
                    case 5:
                        return false;
                        
                    default:
                        break;
                }
            }
            
        } else {
            number = [number stringByAppendingString:curCharacter];
        }
    }
    
    if (![self addNumberInComponents:number]) {
        return false;
    }

    return true;
}

- (NSString *)calculate {
    
    if (![self parseCalculateString] || self.components.count == 0) {
        return notCorrectExpression;
    }
    
    return @"";
}

@end
