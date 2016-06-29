//
//  VMCalculation.m
//  Calculator
//
//  Created by Владимир Микита on 29.06.16.
//  Copyright © 2016 Vladimir Mikita. All rights reserved.
//

#import "VMCalculation.h"

typedef double (^Operation)(double, double, NSString **);

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
        self.operations = @{@"-":^double (double firstOperand, double secondOperand, NSString **errorText) { return firstOperand - secondOperand; },
                            @"+":^double (double firstOperand, double secondOperand, NSString **errorText) { return firstOperand + secondOperand; },
                            @"*":^double (double firstOperand, double secondOperand, NSString **errorText) { return firstOperand * secondOperand; },
                            @"/":^double (double firstOperand, double secondOperand, NSString **errorText) {
                                if (secondOperand == 0.0) {
                                    *errorText = notCorrectExpression;
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

- (BOOL)checkCalculateStringOnValid:(NSString **)errorText {
    
    if ([self.calculateString isEqualToString:@""]) {
        *errorText = @"Calculate string is empty!";
        return false;
    }
    
    NSCharacterSet *validationSet = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789-+*/()."] invertedSet];
    NSArray *components = [self.calculateString componentsSeparatedByCharactersInSet:validationSet];
    
    if (components.count > 1) {
        *errorText = notCorrectExpression;
        return false;
    }
    
    return true;
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

- (double)calculate:(NSString **)errorText {
    
    if (![self parseCalculateString] || self.components.count == 0) {
        *errorText = notCorrectExpression;
        return 0.0;
    }
    
    while (self.components.count > 1) {
        
        [self calculateExpression:errorText];
        
        if (*errorText != nil) {
            return 0.0;
        }
    }
    
    NSNumber *result = self.components.lastObject;
    return result.doubleValue;
}

- (void)calculateExpression:(NSString **)errorText {
    
    if (self.components.count < 3) {
        *errorText = notCorrectExpression;
        return;
    }
    
    double result = 0.0;
    double firstOperand = 0.0;
    double secondOperand = 0.0;
    NSInteger i;
    
    for (i = 0; i < self.components.count; i++) {
        
        id arrayObject = [self.components objectAtIndex:i];
        
        if ([arrayObject isKindOfClass:[NSNumber class]]) {
            firstOperand = secondOperand;
            secondOperand = [(NSNumber *)arrayObject doubleValue];
        } else {
            Operation operation = [self.operations objectForKey:(NSString *)arrayObject];
            result = operation(firstOperand, secondOperand, errorText);
            break;
        }
    }
    
    NSRange range;
    range.location = i - 2;
    range.length = 3;
    
    [self.components removeObjectsInRange:range];
    [self.components insertObject:[NSNumber numberWithDouble:result] atIndex:i-2];
}

@end
