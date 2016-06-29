//
//  VMCalculation.h
//  Calculator
//
//  Created by Владимир Микита on 29.06.16.
//  Copyright © 2016 Vladimir Mikita. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VMCalculation : NSObject

@property (strong, nonatomic) NSString *calculateString;

- (BOOL)checkCalculateStringOnValid:(NSString **)errorText;
- (double)calculate:(NSString **)errorText;

@end
