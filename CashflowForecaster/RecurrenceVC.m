//
//  RecurrenceVC.m
//  CashflowForecaster
//
//  Created by Jeremy Lilje on 7/18/16.
//  Copyright © 2016 Detroit Labs. All rights reserved.
//

#import "RecurrenceVC.h"
#import "CashflowEvent.h"

@interface RecurrenceVC ()

@end

@implementation RecurrenceVC

CashflowEvent *cashflowEvent;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //************************************************************************************************
    // create a selection box for cashflow item interval... daily, weekly, bi-weekly, monthly, bi-monthly, quarterly, semi-annually, annually, one-time, specific number of days, other
    // create the array of data
    NSMutableArray* recurrenceArray = [[NSMutableArray alloc] init];
    // add some sample data
    [recurrenceArray addObject:@"Daily"];
    [recurrenceArray addObject:@"Weekly"];
    [recurrenceArray addObject:@"Bi-weekly"];
    [recurrenceArray addObject:@"Monthly"];
    [recurrenceArray addObject:@"Bi-monthly"];
    [recurrenceArray addObject:@"Quarterly"];
    [recurrenceArray addObject:@"Semi-annually"];
    [recurrenceArray addObject:@"Annually"];
    [recurrenceArray addObject:@"Custom (# days)"];
    [recurrenceArray addObject:@"One-time"];
    // bind yourTextField to DownPicker
    self.downPicker = [[DownPicker alloc] initWithTextField:self.recurrenceTextField withData:recurrenceArray];
    
    NSArray *detailKeyArray = @[@"Daily", @"Weekly", @"Bi-weekly", @"Monthly", @"Bi-monthly", @"Quarterly", @"Semi-annually", @"Annually", @"Custom (# days)", @"One-time"];
    
    NSArray *detailHintArray = @[@"No additional detail required.", @"Add the day of the week this is paid.", @"Add the day of the week this is paid.", @"Add the day of the month this is paid (1 - 31, NOTE: if day selected not valid for a particular month, the day will be move back to the last valid day of the month).", @"dd the day of the month this is paid (1 - 31, NOTE: if day selected not valid for a particular month, the day will be move back to the last valid day of the month).", @"dd the day of the month this is paid (1 - 31, NOTE: if day selected not valid for a particular month, the day will be move back to the last valid day of the month).", @"Add the day of the month this is paid (1 - 31, NOTE: if day selected not valid for a particular month, the day will be move back to the last valid day of the month).", @"Add the date this is due each year.", @"Specify an integer representing the number of days between payments.", @"Add the date this payment is due."];
    
    NSDictionary *recurrenceDetailHintDictionary = [[NSDictionary alloc] initWithObjects:detailHintArray forKeys:detailKeyArray];
    {
        NSLog(@"Detail Hint Dictionary is %@, %@", recurrenceDetailHintDictionary.allKeys, recurrenceDetailHintDictionary.allValues);
    }
    
    self.recurrenceTextField.text = cashflowEvent.recurrenceType;
    
    self.helpfulHintLabel.text = [recurrenceDetailHintDictionary objectForKey:cashflowEvent.recurrenceType];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)editCashflowEventRecurrence:(CashflowEvent *)cashflowEventToBeEdited
{
    //NSLog(@"in editCashflowEvent method with the object %@", selectedCashflowEvent);
    
    cashflowEvent = cashflowEventToBeEdited;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
