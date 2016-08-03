//
//  RecurrenceVC.h
//  CashflowForecaster
//
//  Created by Jeremy Lilje on 7/18/16.
//  Copyright © 2016 Detroit Labs. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CashflowEvent.h"

#import "DownPicker.h"

@interface RecurrenceVC : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *recurrenceTextField;

@property (weak, nonatomic) IBOutlet UITextField *typeDetailTextField;

@property (weak, nonatomic) IBOutlet UILabel *helpfulHintLabel;

@property (strong, nonatomic) DownPicker *downPicker;

@property (strong, nonatomic) IBOutlet DownPicker *typeDownPicker;

@property (strong, nonatomic) IBOutlet DownPicker *typeDetailDownPicker;

@property (strong, nonatomic) IBOutlet UILabel *endDateSelectedLabel;

@property (strong, nonatomic) IBOutlet UILabel *startDateSelectedLabel;

@property (strong, nonatomic) IBOutlet UIDatePicker *startDatePicker;

@property (strong, nonatomic) IBOutlet UIDatePicker *endDatePicker;

- (void) editCashflowEventRecurrence:(CashflowEvent *)cashflowEventToBeEdited;
@property (strong, nonatomic) IBOutlet UITableView *paymentSeriesTableView;

@property (strong, nonatomic) IBOutlet UITextView *helpfulHintTextView;

@property (strong, nonatomic) IBOutlet UILabel *paymentSeriesDescriptionLabel;

@property (strong, nonatomic) IBOutlet UIImageView *hintArrow;

//- (void) initializeDownPickers;
//
//- (void) initializeHintDictionary;
//
@end