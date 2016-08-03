//
//  CashflowEventVC.h
//  CashflowForecaster
//
//  Created by Jeremy Lilje on 7/26/16.
//  Copyright © 2016 Detroit Labs. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CashflowEvent.h"

#import "DownPicker.h"

@interface CashflowEventVC : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *typeTextField;

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;

@property (weak, nonatomic) IBOutlet UITextField *amountTextField;

@property (weak, nonatomic) IBOutlet UILabel *recurrenceLabel;

@property (weak, nonatomic) IBOutlet UITextView *commentsTextView;

@property (weak, nonatomic) IBOutlet UITextField *autoPaidIndicatorTextField;

@property (weak, nonatomic) IBOutlet UITextField *alertTimeTextField;

@property (strong, nonatomic) IBOutlet DownPicker *typeDownPicker;

@property (strong, nonatomic) IBOutlet DownPicker *autoPaidIndicatorDownPicker;

@property (strong, nonatomic) IBOutlet DownPicker *alertTimeDownPicker;

- (IBAction)SaveCF:(id)sender;

- (void) editCashflowEvent:(CashflowEvent *)selectedCashflowEvent;

@end
