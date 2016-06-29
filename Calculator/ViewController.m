//
//  ViewController.m
//  Calculator
//
//  Created by Владимир Микита on 29.06.16.
//  Copyright © 2016 Vladimir Mikita. All rights reserved.
//

#import "ViewController.h"
#import "VMCalculation.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)calculateAction:(UIButton *)sender {
    
    [self.calculateStringTextField resignFirstResponder];
    NSString *calculateString = self.calculateStringTextField.text;
    
    VMCalculation *calculation = [[VMCalculation alloc] init];
    calculation.calculateString = calculateString;
    NSString *errorText = [calculation checkCalculateStringOnValid];
    
    if (![errorText isEqualToString:@""]) {
        [self showErrorAlert:errorText];
        return;
    }
}

- (void)showErrorAlert:(NSString *)errorText {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error" message:errorText preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
    
    [self presentViewController:alertController animated:true completion:nil];
}

@end
