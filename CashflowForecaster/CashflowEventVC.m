//
//  CashflowEventVC.m
//  CashflowForecaster
//
//  Created by Jeremy Lilje on 7/26/16.
//  Copyright © 2016 Detroit Labs. All rights reserved.
//

#import "CashflowEventVC.h"
#import "RecurrenceVC.h"

@interface CashflowEventVC ()

+(void)editCashflowEvent:(CashflowEvent *)selectedCashflowEvent;

@end

CashflowEvent *cashflowEventToBeEdited;

@implementation CashflowEventVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //************************************************************************************************
    // create a selection box for cashflow item type
    // create the array of data
    NSMutableArray* typeArray = [[NSMutableArray alloc] init];
    // add some sample data
    [typeArray addObject:@"Income"];
    [typeArray addObject:@"Bill"];
    [typeArray addObject:@"Continuous Expense"];
    // bind yourTextField to DownPicker
    self.typeDownPicker = [[DownPicker alloc] initWithTextField:self.typeTextField withData:typeArray];
    
    //************************************************************************************************
    // create a selection box for auto-pay indicator
    // create the array of data
    NSMutableArray* autoPaidIndicatorArray = [[NSMutableArray alloc] init];
    // add some sample data
    [autoPaidIndicatorArray addObject:@"Yes"];
    [autoPaidIndicatorArray addObject:@"No"];
    // bind yourTextField to DownPicker
    self.autoPaidIndicatorDownPicker = [[DownPicker alloc] initWithTextField:self.autoPaidIndicatorTextField withData:autoPaidIndicatorArray];
    
    //************************************************************************************************
    // create a selection box for alert time
    // create the array of data
    NSMutableArray* alertTimeArray = [[NSMutableArray alloc] init];
    // add some sample data
    [alertTimeArray addObject:@"None"];
    [alertTimeArray addObject:@"Due Date"];
    [alertTimeArray addObject:@"1 day prior"];
    [alertTimeArray addObject:@"2 days prior"];
    [alertTimeArray addObject:@"3 days prior"];
    // bind yourTextField to DownPicker
    self.alertTimeDownPicker = [[DownPicker alloc] initWithTextField:self.alertTimeTextField withData:alertTimeArray];
    
    //  [[cashEvent initWithType:@"" withName:@"" withAmount:0 withRecurrenceType:@"" withRecurrenceDetail:@"" withRecurrenceStartDate:2016-07-21 withRecurrenceEndDate:2016-07-21 withRecurrenceLabel:@"" withNotes:<#(NSString *)#> withAutoPaidIndicator:@"" withAlertTime:@"" withPaymentSeries:[PaymentSeries alloc] init] ];
    
    if(cashflowEventToBeEdited == NULL)
    {
        //create a new cashflow event
    }
    else
    {
        _typeTextField.text = cashflowEventToBeEdited.type;
        _nameTextField.text = cashflowEventToBeEdited.name;
        _amountTextField.text = [NSString stringWithFormat:@"%.02f", (cashflowEventToBeEdited.amount).floatValue];
        _recurrenceLabel.text = cashflowEventToBeEdited.recurrenceLabel;
        _commentsTextView.text = cashflowEventToBeEdited.notes;
        _autoPaidIndicatorTextField.text = cashflowEventToBeEdited.autoPaidIndicator;
        _alertTimeTextField.text = cashflowEventToBeEdited.alertTime;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSLog(@"sender id is \"%@\"", segue.identifier);
    
    if ([segue.identifier isEqualToString:@"Save"])
    {
        //Save the new or edited payment cashflow event
        cashflowEventToBeEdited.type = _typeTextField.text;
        cashflowEventToBeEdited.name= _nameTextField.text;
        cashflowEventToBeEdited.amount = _amountTextField.text; // = [NSString stringWithFormat:@"%.02f", ().floatValue];
        cashflowEventToBeEdited.recurrenceLabel = _recurrenceLabel.text;
        cashflowEventToBeEdited.notes = _commentsTextView.text;
        cashflowEventToBeEdited.autoPaidIndicator = _autoPaidIndicatorTextField.text;
        cashflowEventToBeEdited.alertTime = _alertTimeTextField.text;
        
        NSLog(@"the new name is %@", cashflowEventToBeEdited.name);
        NSLog(@"the updated object is %@", cashflowEventToBeEdited);
    }
    else if ([segue.identifier isEqualToString:@"Cancel"])
    {
        //Don't do anything -- this will be handled by the unwind to CashflowEventTVC
    }
    else if ([segue.identifier isEqualToString:@"Edit"])
    {
         //Get the new view controller using [segue destinationViewController].
         //Pass the selected object to the new view controller.
        
        RecurrenceVC *vc = [segue destinationViewController];
    
        // Pass any objects to the view controller here, like...
        [vc editCashflowEventRecurrence:cashflowEventToBeEdited];
    }
}

- (void)editCashflowEvent:(CashflowEvent *)selectedCashflowEvent
{
    //NSLog(@"in editCashflowEvent method with the object %@", selectedCashflowEvent);
    NSLog(@"the original object passed in is %@", selectedCashflowEvent);
    
    cashflowEventToBeEdited = selectedCashflowEvent;
}


-(IBAction)unwindToCashflowEventVC:(UIStoryboardSegue *)segue
{
    NSLog(@"unwinding from RecurrenceVC to CashflowEventVC");
}

- (IBAction)SaveCF:(id)sender
{
}


@end
