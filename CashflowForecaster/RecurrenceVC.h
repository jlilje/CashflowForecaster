//
//  RecurrenceVC.h
//  CashflowForecaster
//
//  Created by Jeremy Lilje on 7/18/16.
//  Copyright © 2016 Detroit Labs. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DownPicker.h"
#import "CashflowEvent.h"

@interface RecurrenceVC : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *recurrenceTextField;
@property (weak, nonatomic) IBOutlet UITextField *typeDetailTextField;
@property (weak, nonatomic) IBOutlet UILabel *helpfulHintLabel;

@property (strong, nonatomic) DownPicker *downPicker;

@property (weak, nonatomic) IBOutlet DownPicker *recurrenceDownPicker;

- (void) editCashflowEventRecurrence:(CashflowEvent *)cashflowEventToBeEdited;

@end