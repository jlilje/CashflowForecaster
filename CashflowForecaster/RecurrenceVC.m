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

NSDictionary *recurrenceDetailHintDictionary;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    self.helpfulHintLabel.textAlignment =
//    UIControlContentVerticalAlignmentTop;
//    
//    self.helpfulHintLabel.textAlignment =
//    UIControlContentHorizontalAlignmentLeft;
    
    self.initializeRecurrenceTypeDownPicker;
    
    [self initializeTypeDetailDownPicker:cashflowEvent.recurrenceType];
    
    self.initializeHintDictionary;
    
    self.initializeFieldsWithCurrentValues;
    
    self.setDatePickerConstraints;
    
    NSLog(@"running viewDidLoad");
}

- (void)viewDidAppear:(BOOL)animated
{
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)editCashflowEventRecurrence:(CashflowEvent *)cashflowEventToBeEdited
{
    cashflowEvent = cashflowEventToBeEdited;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    {
        NSLog(@"sender id is \"%@\"", segue.identifier);
        
        if ([segue.identifier isEqualToString:@"Save"])
        {
            //Save the new or edited payment cashflow event
            cashflowEvent.recurrenceType = self.recurrenceTextField.text;
            cashflowEvent.recurrenceDetail = self.typeDetailTextField.text;
            cashflowEvent.recurrenceLabel = self.paymentSeriesDescriptionLabel.text;
            cashflowEvent.recurrenceStartDate = self.startDatePicker.date;
            cashflowEvent.recurrenceEndDate = self.endDatePicker.date;
        }
        else if ([segue.identifier isEqualToString:@"Cancel"])
        {
            //Don't do anything -- this will be handled by the unwind to CashflowEventTVC
        }
    }
}


- (void) initializeFieldsWithCurrentValues
{
    self.recurrenceTextField.text = cashflowEvent.recurrenceType;
    self.typeDetailTextField.text = cashflowEvent.recurrenceDetail;
    self.helpfulHintTextView.text = @"";
    self.hintArrow.hidden = YES;
    if(cashflowEvent.recurrenceStartDate != NULL)
    {
        self.startDatePicker.date = cashflowEvent.recurrenceStartDate;
        self.startDateSelectedLabel.text = [NSDateFormatter localizedStringFromDate:_startDatePicker.date
                                                                          dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterNoStyle];
    }
    else
    {
        self.startDateSelectedLabel.text = @"none";
    }
    if(cashflowEvent.recurrenceEndDate != NULL)
    {
        self.endDatePicker.date = cashflowEvent.recurrenceEndDate;
        self.endDateSelectedLabel.text = [NSDateFormatter localizedStringFromDate:_endDatePicker.date
                                                                          dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterNoStyle];
    }
    else
    {
        self.endDateSelectedLabel.text = @"none";
    }
    self.paymentSeriesDescriptionLabel.text = cashflowEvent.recurrenceLabel;
}

- (IBAction)startDateChanged:(UIDatePicker *)sender {
    self.startDateSelectedLabel.text = [NSDateFormatter localizedStringFromDate:_startDatePicker.date
                                   dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterNoStyle];
    [self updatePaymentSeriesDescription];
}

- (IBAction)endDateChanged:(id)sender
{
    self.endDateSelectedLabel.text = [NSDateFormatter localizedStringFromDate:_endDatePicker.date
                                                                      dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterNoStyle];
    [self updatePaymentSeriesDescription];
}

- (void) setDatePickerConstraints
{
    NSDate *currentDate = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:currentDate];
    
    NSDateComponents *futureComponents = [[NSDateComponents alloc] init];
    [futureComponents setDay:[components day]];
    [futureComponents setMonth:[components month]];
    [futureComponents setYear:[components year]+5];
    NSDate *futureDate = [calendar dateFromComponents:futureComponents];
    
    self.startDatePicker.minimumDate = currentDate;
    self.endDatePicker.minimumDate = currentDate;
    
    self.startDatePicker.maximumDate = futureDate;
    self.endDatePicker.maximumDate = futureDate;
}

- (void) initializeRecurrenceTypeDownPicker
{
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
    self.typeDownPicker = [[DownPicker alloc] initWithTextField:self.recurrenceTextField withData:recurrenceArray];
}

- (void) initializeTypeDetailDownPicker:(NSString *)recurrenceType
{
    NSLog(@"loading typeDetailDownPicker with values for %@", recurrenceType);
    //************************************************************************************************
    // create a selection box for cashflow item interval... daily, weekly, bi-weekly, monthly, bi-monthly, quarterly, semi-annually, annually, one-time, specific number of days, other
    // create the array of data
    
    NSMutableArray* typeDetailArray = [[NSMutableArray alloc] init];
    // add some sample data
    if ([recurrenceType isEqual:@"Weekly"] || [recurrenceType isEqual:@"Bi-weekly"])
    {
        [typeDetailArray addObject:@"Monday"];
        [typeDetailArray addObject:@"Tuesday"];
        [typeDetailArray addObject:@"Wednesday"];
        [typeDetailArray addObject:@"Thursday"];
        [typeDetailArray addObject:@"Friday"];
        [typeDetailArray addObject:@"Saturday"];
        [typeDetailArray addObject:@"Sunday"];
    }
    else if ([recurrenceType isEqual:@"Monthly"] || [recurrenceType isEqual:@"Bi-monthly"] || [recurrenceType isEqual:@"Quarterly"])
    {
        [typeDetailArray addObject:@"1"];
        [typeDetailArray addObject:@"2"];
        [typeDetailArray addObject:@"3"];
        [typeDetailArray addObject:@"4"];
        [typeDetailArray addObject:@"5"];
        [typeDetailArray addObject:@"6"];
        [typeDetailArray addObject:@"7"];
        [typeDetailArray addObject:@"8"];
        [typeDetailArray addObject:@"9"];
        [typeDetailArray addObject:@"10"];
        [typeDetailArray addObject:@"11"];
        [typeDetailArray addObject:@"12"];
        [typeDetailArray addObject:@"13"];
        [typeDetailArray addObject:@"14"];
        [typeDetailArray addObject:@"15"];
        [typeDetailArray addObject:@"16"];
        [typeDetailArray addObject:@"17"];
        [typeDetailArray addObject:@"18"];
        [typeDetailArray addObject:@"19"];
        [typeDetailArray addObject:@"20"];
        [typeDetailArray addObject:@"21"];
        [typeDetailArray addObject:@"22"];
        [typeDetailArray addObject:@"23"];
        [typeDetailArray addObject:@"24"];
        [typeDetailArray addObject:@"25"];
        [typeDetailArray addObject:@"26"];
        [typeDetailArray addObject:@"27"];
        [typeDetailArray addObject:@"28"];
        [typeDetailArray addObject:@"29"];
        [typeDetailArray addObject:@"30"];
        [typeDetailArray addObject:@"31"];
    }
    else if ([recurrenceType isEqual:@"Custom (# days)"])
    {
        [typeDetailArray addObject:@"2"];
        [typeDetailArray addObject:@"3"];
        [typeDetailArray addObject:@"4"];
        [typeDetailArray addObject:@"5"];
        [typeDetailArray addObject:@"6"];
        [typeDetailArray addObject:@"8"];
        [typeDetailArray addObject:@"9"];
        [typeDetailArray addObject:@"10"];
        [typeDetailArray addObject:@"11"];
        [typeDetailArray addObject:@"12"];
        [typeDetailArray addObject:@"13"];
        [typeDetailArray addObject:@"15"];
        [typeDetailArray addObject:@"16"];
        [typeDetailArray addObject:@"17"];
        [typeDetailArray addObject:@"18"];
        [typeDetailArray addObject:@"19"];
        [typeDetailArray addObject:@"21"];
        [typeDetailArray addObject:@"22"];
        [typeDetailArray addObject:@"23"];
        [typeDetailArray addObject:@"24"];
        [typeDetailArray addObject:@"25"];
        [typeDetailArray addObject:@"26"];
        [typeDetailArray addObject:@"27"];
        [typeDetailArray addObject:@"28"];
        [typeDetailArray addObject:@"29"];
        [typeDetailArray addObject:@"30"];
        [typeDetailArray addObject:@"31"];
        [typeDetailArray addObject:@"32"];
        [typeDetailArray addObject:@"45"];
    }
    else
    {
        [typeDetailArray addObject:@"None"];
    }
    // bind yourTextField to DownPicker
    self.typeDetailDownPicker = [[DownPicker alloc] initWithTextField:self.typeDetailTextField withData:typeDetailArray];
    
    NSLog(@"reloading typeDetailArray with the values for %@", self.recurrenceTextField.text);
}

- (void) initializeHintDictionary
{
    NSArray *detailKeyArray = @[@"Daily", @"Weekly", @"Bi-weekly", @"Monthly", @"Bi-monthly", @"Quarterly", @"Semi-annually", @"Annually", @"Custom (# days)", @"One-time"];
    
    NSString *hintNone = @"N/A - no additional detail required.";
    NSString *hintWeekday = @"Add the day of the week this is paid. [Monday - Sunday]";
    NSString *hintMonthday = @"Add the day of the month this is paid. [1 - 31] NOTE: if the day selected is not valid for a month in the series, the payment will be set to the last valid day in the month.";
    NSString *hintCustom = @"Specify an integer representing the number of days between payments (see options available).";
    
    NSArray *detailHintArray = @[hintNone, hintWeekday, hintWeekday, hintMonthday, hintMonthday, hintMonthday, hintNone, hintNone, hintCustom, hintNone];
    
    recurrenceDetailHintDictionary = [[NSDictionary alloc] initWithObjects:detailHintArray forKeys:detailKeyArray];
    {
        //NSLog(@"Detail Hint Dictionary is %@, %@", recurrenceDetailHintDictionary.allKeys, recurrenceDetailHintDictionary.allValues);
    }
}

- (IBAction)recurrenceTypeChanged:(DownPicker *)sender
{
    //NSLog(@"reloading type detail downpicker with values for %@", self.recurrenceTextField.text);
    [self initializeTypeDetailDownPicker:self.recurrenceTextField.text];
    self.helpfulHintTextView.text = [recurrenceDetailHintDictionary objectForKey:self.recurrenceTextField.text];
    self.typeDetailTextField.text = @"";
    self.paymentSeriesDescriptionLabel.text = @"";
    self.hintArrow.hidden = NO;
    if ([self.recurrenceTextField.text isEqualToString:@"Daily"] || [self.recurrenceTextField.text isEqualToString:@"Semi-annually"] || [self.recurrenceTextField.text isEqualToString:@"Annually"] || [self.recurrenceTextField.text isEqualToString:@"One-time"])
    {
        self.typeDetailTextField.text = @"None";
        [self updatePaymentSeriesDescription];
    }
    self.reloadInputViews;
}

- (IBAction)typeDetailChanged:(id)sender
{
    self.helpfulHintTextView.text = @"";
    self.hintArrow.hidden = YES;
    [self updatePaymentSeriesDescription];
}

- (void) updatePaymentSeriesDescription
{
    NSString *newDescription;
    NSDate *startDate;
    NSDate *endDate;
    NSString *startDateString;
    NSString *endDateString;
    
    //start date must be in the future... will use the greater of today or startdate from the date picker
    if (self.startDatePicker.date > [NSDate date])
    {
        startDate = self.startDatePicker.date;
    }
    else
    {
        startDate = [NSDate date];
    }
    NSLog(@"startDate is now %@", startDate);
    
    //end date must be equal to or greater than the start date but NO MORE THAN 5 YEARS into the future...
    //      if nothing selected, I'll use 5 years from now
    //      if selected end date is greater than selected start date, I'll use the date from the end date picker
    //      if the selected end date is equal to or less than the selected start date, I'll use the selected start date
    if (self.startDatePicker.date == NULL)
    {
        endDate = self.endDatePicker.maximumDate;
    }
    else if (self.endDatePicker.date > self.startDatePicker.date)
    {
        endDate = self.endDatePicker.date;
    }
    else
    {
        endDate = self.startDatePicker.date;
    }
    startDateString = [NSDateFormatter localizedStringFromDate:startDate
                                                         dateStyle:NSDateFormatterShortStyle
                                                         timeStyle:NSDateFormatterNoStyle];
    endDateString = [NSDateFormatter localizedStringFromDate:endDate
                                                     dateStyle:NSDateFormatterShortStyle
                                                     timeStyle:NSDateFormatterNoStyle];
    if(false)
    {
        //cashflowEvent.recurrenceLabel = @"this is my test update";
        self.paymentSeriesDescriptionLabel.text = @"Parameters not valid to calculate payment series, please correct...";
    }
    else if ([self.recurrenceTextField.text isEqualToString:@"Daily"])
    {
        newDescription = @"Daily (";
        newDescription = [newDescription stringByAppendingString:startDateString];
        newDescription = [newDescription stringByAppendingString:@" - "];
        newDescription = [newDescription stringByAppendingString:endDateString];
        newDescription = [newDescription stringByAppendingString:@")"];
    }
    else if ([self.recurrenceTextField.text isEqualToString:@"Weekly"])
    {
        newDescription = @"Every ";
        newDescription = [newDescription stringByAppendingString:self.typeDetailTextField.text];
        newDescription = [newDescription stringByAppendingString:@" ("];
        newDescription = [newDescription stringByAppendingString:startDateString];
        newDescription = [newDescription stringByAppendingString:@" - "];
        newDescription = [newDescription stringByAppendingString:endDateString];
        newDescription = [newDescription stringByAppendingString:@")"];
    }
    else if ([self.recurrenceTextField.text isEqualToString:@"Bi-weekly"])
    {
        newDescription = @"Every other ";
        newDescription = [newDescription stringByAppendingString:self.typeDetailTextField.text];
        newDescription = [newDescription stringByAppendingString:@" ("];
        newDescription = [newDescription stringByAppendingString:startDateString];
        newDescription = [newDescription stringByAppendingString:@" - "];
        newDescription = [newDescription stringByAppendingString:endDateString];
        newDescription = [newDescription stringByAppendingString:@")"];
    }
    else if ([self.recurrenceTextField.text isEqualToString:@"Monthly"])
    {
        newDescription = @"On the ";
        newDescription = [newDescription stringByAppendingString:self.typeDetailTextField.text];
        newDescription = [newDescription stringByAppendingString:[self getNumberModifier:self.typeDetailTextField.text]];
        newDescription = [newDescription stringByAppendingString:@" of the month "];
        newDescription = [newDescription stringByAppendingString:@" ("];
        newDescription = [newDescription stringByAppendingString:startDateString];
        newDescription = [newDescription stringByAppendingString:@" - "];
        newDescription = [newDescription stringByAppendingString:endDateString];
        newDescription = [newDescription stringByAppendingString:@")"];
    }
    else if ([self.recurrenceTextField.text isEqualToString:@"Bi-monthly"])
    {
        newDescription = @"On the ";
        newDescription = [newDescription stringByAppendingString:self.typeDetailTextField.text];
        newDescription = [newDescription stringByAppendingString:[self getNumberModifier:self.typeDetailTextField.text]];
        newDescription = [newDescription stringByAppendingString:@" of every other month "];
        newDescription = [newDescription stringByAppendingString:@" ("];
        newDescription = [newDescription stringByAppendingString:startDateString];
        newDescription = [newDescription stringByAppendingString:@" - "];
        newDescription = [newDescription stringByAppendingString:endDateString];
        newDescription = [newDescription stringByAppendingString:@")"];
    }
    else if ([self.recurrenceTextField.text isEqualToString:@"Quarterly"])
    {
        newDescription = @"On the ";
        newDescription = [newDescription stringByAppendingString:self.typeDetailTextField.text];
        newDescription = [newDescription stringByAppendingString:[self getNumberModifier:self.typeDetailTextField.text]];
        newDescription = [newDescription stringByAppendingString:@" of every three months "];
        newDescription = [newDescription stringByAppendingString:@" ("];
        newDescription = [newDescription stringByAppendingString:startDateString];
        newDescription = [newDescription stringByAppendingString:@" - "];
        newDescription = [newDescription stringByAppendingString:endDateString];
        newDescription = [newDescription stringByAppendingString:@")"];
    }
    else if ([self.recurrenceTextField.text isEqualToString:@"Semi-annually"])
    {
        newDescription = @"Every six months ";
        newDescription = [newDescription stringByAppendingString:@" ("];
        newDescription = [newDescription stringByAppendingString:startDateString];
        newDescription = [newDescription stringByAppendingString:@" - "];
        newDescription = [newDescription stringByAppendingString:endDateString];
        newDescription = [newDescription stringByAppendingString:@")"];
    }
    else if ([self.recurrenceTextField.text isEqualToString:@"Annually"])
    {
        newDescription = @"Once a year ";
        newDescription = [newDescription stringByAppendingString:@" ("];
        newDescription = [newDescription stringByAppendingString:startDateString];
        newDescription = [newDescription stringByAppendingString:@" - "];
        newDescription = [newDescription stringByAppendingString:endDateString];
        newDescription = [newDescription stringByAppendingString:@")"];
    }
    else if ([self.recurrenceTextField.text isEqualToString:@"Custom (# days)"])
    {
        newDescription = @"Every ";
        newDescription = [newDescription stringByAppendingString:self.typeDetailTextField.text];
        newDescription = [newDescription stringByAppendingString:@" days ("];
        newDescription = [newDescription stringByAppendingString:startDateString];
        newDescription = [newDescription stringByAppendingString:@" - "];
        newDescription = [newDescription stringByAppendingString:endDateString];
        newDescription = [newDescription stringByAppendingString:@")"];
    }
    else if ([self.recurrenceTextField.text isEqualToString:@"One-time"])
    {
        newDescription = @"Once (on ";
        newDescription = [newDescription stringByAppendingString:startDateString];
        newDescription = [newDescription stringByAppendingString:@")"];
    }
    else
    {
        newDescription = @"Error describing payment series";
    }
    
    
    self.paymentSeriesDescriptionLabel.text = newDescription;
}

- (NSString *) getNumberModifier:(NSString *)number
{
    if ([number isEqualToString:@"1"]|| [number isEqualToString:@"21"]|| [number isEqualToString:@"31"])
    {
        return @"st";
    }
    else if ([number isEqualToString:@"2"]|| [number isEqualToString:@"22"])
    {
        return @"nd";
    }
    else if ([number isEqualToString:@"3"]|| [number isEqualToString:@"23"])
    {
        return @"rd";
    }
    else
    {
        return @"th";
    }
}

//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    if (self.dataArray.count < 10)
//        return(10);
//    else
//        return(self.dataArray.count);
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SimpleCell"];
//    
//    if (indexPath.row % 2 == 0)
//        cell.backgroundColor = [UIColor orangeColor];
//    else
//        cell.backgroundColor = [UIColor redColor];
//    
//    if (indexPath.row < self.dataArray.count)
//        cell.textLabel.text = self.dataArray[indexPath.row];
//    else
//        cell.textLabel.text = nil;
//    
//    return cell;
//}

@end
