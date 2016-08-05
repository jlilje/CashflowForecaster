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

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.initializeRecurrenceTypeDownPicker;
    
    [self initializeTypeDetailDownPicker:cashflowEvent.recurrenceType];
    
    self.initializeHintDictionary;
    
    self.initializeFieldsWithCurrentValues;
    
    self.setDatePickerConstraints;
    
    [self updatePaymentSeriesDescription];
    
    [self calculatePaymentSeries:self.recurrenceTextField.text :self.typeDetailTextField.text :self.startDatePicker.date :self.endDatePicker.date];
    
    self.startDateSelectedLabel.text = [NSDateFormatter localizedStringFromDate:_startDatePicker.date
                                                                      dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterNoStyle];
    
    self.endDateSelectedLabel.text = [NSDateFormatter localizedStringFromDate:_endDatePicker.date
                                                                      dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterNoStyle];
}

- (NSMutableArray *) calculatePaymentSeries:(NSString *)recurrenceType :(NSString *)recurrenceDetail :(NSDate *)startDate :(NSDate *)endDate
{
    [cashflowEvent.paymentSeries removeAllObjects];
    
    if ([recurrenceType isEqualToString:@"Daily"])
    {
        int i = 0;
        NSDate *iDate = startDate;
        
        for (iDate=startDate; iDate <= endDate; (iDate=[startDate dateByAddingTimeInterval:(86400*i)]))
        {
            [cashflowEvent.paymentSeries addObject:iDate];
            i++;
        }
    }
    else if ([recurrenceType isEqualToString:@"Weekly"])
    {
        int i = 0;
        NSDate *iDate = startDate;
        
        for (iDate=startDate; iDate <= endDate; (iDate=[startDate dateByAddingTimeInterval:(86400*i*7)]))
        {
            [cashflowEvent.paymentSeries addObject:iDate];
            i++;
        }
    }
    else if ([recurrenceType isEqualToString:@"Bi-weekly"])
    {
        int i = 0;
        NSDate *iDate = startDate;
        
        for (iDate=startDate; iDate <= endDate; (iDate=[startDate dateByAddingTimeInterval:(86400*i*14)]))
        {
            [cashflowEvent.paymentSeries addObject:iDate];
            i++;
        }
    }
    else if ([recurrenceType isEqualToString:@"Monthly"])
    {
        NSCalendar *myCalendar = [NSCalendar currentCalendar];
        
        long dayOfMonth = [recurrenceDetail longLongValue];
        
        NSDate *paymentDate;
        
        int currentMonth;
        
        int nextMonthUsing32Days;
        
        float intervalFactor;
        
        NSDateComponents *startDateComponents = [myCalendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:startDate];
        
        NSDateComponents *paymentDateComponents = [myCalendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:startDate];
        if (dayOfMonth == 31 && ([startDateComponents month] == 4 || [startDateComponents month] == 6 || [startDateComponents month] == 9 || [startDateComponents month] == 11))
        {
            [paymentDateComponents setDay:30];
        }
        else if (dayOfMonth > 28 && [startDateComponents month] == 2)
        {
            [paymentDateComponents setDay:28];
        }
        else
        {
            [paymentDateComponents setDay:dayOfMonth];
        }
        [paymentDateComponents setMonth:[startDateComponents month]];
        [paymentDateComponents setYear:[startDateComponents year]];
        paymentDate = [myCalendar dateFromComponents:paymentDateComponents];
        
        while (paymentDate <= endDate)
        {
            if(paymentDate >= startDate)
            {
                [cashflowEvent.paymentSeries addObject:paymentDate];
            }
            paymentDateComponents = [myCalendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:paymentDate];
            currentMonth = [paymentDateComponents month];
            intervalFactor = [self calculateNextMonthSecondsInterval:dayOfMonth:currentMonth];
            paymentDate = [paymentDate dateByAddingTimeInterval:intervalFactor];
            paymentDateComponents = [myCalendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:paymentDate];
            if (dayOfMonth == 31 && ([paymentDateComponents month] == 4 || [paymentDateComponents month] == 6 || [paymentDateComponents month] == 9 || [paymentDateComponents month] == 11))
            {
                [paymentDateComponents setDay:30];
            }
            else if (dayOfMonth > 28 && [paymentDateComponents month] == 2)
            {
                [paymentDateComponents setDay:28];
            }
            else
            {
                [paymentDateComponents setDay:dayOfMonth];
            }
            [paymentDateComponents setMonth:[paymentDateComponents month]];
            [paymentDateComponents setYear:[paymentDateComponents year]];
            paymentDate = [myCalendar dateFromComponents:paymentDateComponents];
        }
    }
    else if ([recurrenceType isEqualToString:@"Bi-monthly"])
    {
        NSCalendar *myCalendar = [NSCalendar currentCalendar];
        
        long dayOfMonth = [recurrenceDetail longLongValue];
        
        NSDate *paymentDate;
        
        int currentMonth;
        
        int nextMonthUsing32Days;
        
        float intervalFactor;
        
        NSDateComponents *startDateComponents = [myCalendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:startDate];
        
        NSDateComponents *paymentDateComponents = [myCalendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:startDate];
        if (dayOfMonth == 31 && ([startDateComponents month] == 4 || [startDateComponents month] == 6 || [startDateComponents month] == 9 || [startDateComponents month] == 11))
        {
            [paymentDateComponents setDay:30];
        }
        else if (dayOfMonth > 28 && [startDateComponents month] == 2)
        {
            [paymentDateComponents setDay:28];
        }
        else
        {
            [paymentDateComponents setDay:dayOfMonth];
        }
        [paymentDateComponents setMonth:[startDateComponents month]];
        [paymentDateComponents setYear:[startDateComponents year]];
        paymentDate = [myCalendar dateFromComponents:paymentDateComponents];

        while (paymentDate <= endDate)
        {
            if(paymentDate >= startDate)
            {
                [cashflowEvent.paymentSeries addObject:paymentDate];
            }
            
            paymentDateComponents = [myCalendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:paymentDate];
            currentMonth = [paymentDateComponents month];
            intervalFactor = [self calculateNextMonthSecondsInterval:dayOfMonth:currentMonth];
            paymentDate = [paymentDate dateByAddingTimeInterval:intervalFactor];
            
            //now repeat this whole process a second time to leap forward 1 month
            int i; //number of times to repeat
            for (i=0; i<1; i++)
            {
                paymentDateComponents = [myCalendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:paymentDate];
                if (dayOfMonth == 31 && ([paymentDateComponents month] == 4 || [paymentDateComponents month] == 6 || [paymentDateComponents month] == 9 || [paymentDateComponents month] == 11))
                {
                    [paymentDateComponents setDay:30];
                }
                else if (dayOfMonth > 28 && [paymentDateComponents month] == 2)
                {
                    [paymentDateComponents setDay:28];
                }
                else
                {
                    [paymentDateComponents setDay:dayOfMonth];
                }
                currentMonth = [paymentDateComponents month];
                intervalFactor = [self calculateNextMonthSecondsInterval:dayOfMonth:currentMonth];
                paymentDate = [paymentDate dateByAddingTimeInterval:intervalFactor];
            }
            
            paymentDateComponents = [myCalendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:paymentDate];
            if (dayOfMonth == 31 && ([paymentDateComponents month] == 4 || [paymentDateComponents month] == 6 || [paymentDateComponents month] == 9 || [paymentDateComponents month] == 11))
            {
                [paymentDateComponents setDay:30];
            }
            else if (dayOfMonth > 28 && [paymentDateComponents month] == 2)
            {
                [paymentDateComponents setDay:28];
            }
            else
            {
                [paymentDateComponents setDay:dayOfMonth];
            }
            [paymentDateComponents setMonth:[paymentDateComponents month]];
            [paymentDateComponents setYear:[paymentDateComponents year]];
            paymentDate = [myCalendar dateFromComponents:paymentDateComponents];
        }
    }
    else if ([recurrenceType isEqualToString:@"Quarterly"])
    {
        NSCalendar *myCalendar = [NSCalendar currentCalendar];
        
        long dayOfMonth = [recurrenceDetail longLongValue];
        
        NSDate *paymentDate;
        
        int currentMonth;
        
        int nextMonthUsing32Days;
        
        float intervalFactor;
        
        NSDateComponents *startDateComponents = [myCalendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:startDate];
        
        NSDateComponents *paymentDateComponents = [myCalendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:startDate];
        if (dayOfMonth == 31 && ([startDateComponents month] == 4 || [startDateComponents month] == 6 || [startDateComponents month] == 9 || [startDateComponents month] == 11))
        {
            [paymentDateComponents setDay:30];
        }
        else if (dayOfMonth > 28 && [startDateComponents month] == 2)
        {
            [paymentDateComponents setDay:28];
        }
        else
        {
            [paymentDateComponents setDay:dayOfMonth];
        }
        [paymentDateComponents setMonth:[startDateComponents month]];
        [paymentDateComponents setYear:[startDateComponents year]];
        paymentDate = [myCalendar dateFromComponents:paymentDateComponents];

        while (paymentDate <= endDate)
        {
            if(paymentDate >= startDate)
            {
                [cashflowEvent.paymentSeries addObject:paymentDate];
            }
            paymentDateComponents = [myCalendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:paymentDate];
            currentMonth = [paymentDateComponents month];
            intervalFactor = [self calculateNextMonthSecondsInterval:dayOfMonth:currentMonth];
            paymentDate = [paymentDate dateByAddingTimeInterval:intervalFactor];
            //now repeat this whole process a second time to leap forward 1 month
            int i; //number of times to repeat
            for (i=0; i<2; i++)
            {
                paymentDateComponents = [myCalendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:paymentDate];
                if (dayOfMonth == 31 && ([paymentDateComponents month] == 4 || [paymentDateComponents month] == 6 || [paymentDateComponents month] == 9 || [paymentDateComponents month] == 11))
                {
                    [paymentDateComponents setDay:30];
                }
                else if (dayOfMonth > 28 && [paymentDateComponents month] == 2)
                {
                    [paymentDateComponents setDay:28];
                }
                else
                {
                    [paymentDateComponents setDay:dayOfMonth];
                }
                currentMonth = [paymentDateComponents month];
                intervalFactor = [self calculateNextMonthSecondsInterval:dayOfMonth:currentMonth];
                paymentDate = [paymentDate dateByAddingTimeInterval:intervalFactor];
            }
            
            paymentDateComponents = [myCalendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:paymentDate];
            if (dayOfMonth == 31 && ([paymentDateComponents month] == 4 || [paymentDateComponents month] == 6 || [paymentDateComponents month] == 9 || [paymentDateComponents month] == 11))
            {
                [paymentDateComponents setDay:30];
            }
            else if (dayOfMonth > 28 && [paymentDateComponents month] == 2)
            {
                [paymentDateComponents setDay:28];
            }
            else
            {
                [paymentDateComponents setDay:dayOfMonth];
            }
            [paymentDateComponents setMonth:[paymentDateComponents month]];
            [paymentDateComponents setYear:[paymentDateComponents year]];
            paymentDate = [myCalendar dateFromComponents:paymentDateComponents];
        }
    }
    else if ([recurrenceType isEqualToString:@"Semi-annually"])
    {
        NSCalendar *myCalendar = [NSCalendar currentCalendar];
        
        long dayOfMonth;
        
        NSDate *paymentDate;
        
        int currentMonth;
        
        int nextMonthUsing32Days;
        
        float intervalFactor;
        
        NSDateComponents *startDateComponents = [myCalendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:startDate];
        
        NSDateComponents *paymentDateComponents = [myCalendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:startDate];
        dayOfMonth = [paymentDateComponents day];
        if (dayOfMonth == 31 && ([startDateComponents month] == 4 || [startDateComponents month] == 6 || [startDateComponents month] == 9 || [startDateComponents month] == 11))
        {
            [paymentDateComponents setDay:30];
        }
        else if (dayOfMonth > 28 && [startDateComponents month] == 2)
        {
            [paymentDateComponents setDay:28];
        }
        else
        {
            [paymentDateComponents setDay:dayOfMonth];
        }
        [paymentDateComponents setMonth:[startDateComponents month]];
        [paymentDateComponents setYear:[startDateComponents year]];
        paymentDate = [myCalendar dateFromComponents:paymentDateComponents];

        while (paymentDate <= endDate)
        {
            if(paymentDate >= startDate)
            {
                [cashflowEvent.paymentSeries addObject:paymentDate];
            }
            
            paymentDateComponents = [myCalendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:paymentDate];
            currentMonth = [paymentDateComponents month];
            intervalFactor = [self calculateNextMonthSecondsInterval:dayOfMonth:currentMonth];
            paymentDate = [paymentDate dateByAddingTimeInterval:intervalFactor];
            
            //now repeat this whole process a second time to leap forward 1 month
            int i; //number of times to repeat
            for (i=0; i<5; i++)
            {
                paymentDateComponents = [myCalendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:paymentDate];
                if (dayOfMonth == 31 && ([paymentDateComponents month] == 4 || [paymentDateComponents month] == 6 || [paymentDateComponents month] == 9 || [paymentDateComponents month] == 11))
                {
                    [paymentDateComponents setDay:30];
                }
                else if (dayOfMonth > 28 && [paymentDateComponents month] == 2)
                {
                    [paymentDateComponents setDay:28];
                }
                else
                {
                    [paymentDateComponents setDay:dayOfMonth];
                }
                currentMonth = [paymentDateComponents month];
                intervalFactor = [self calculateNextMonthSecondsInterval:dayOfMonth:currentMonth];
                paymentDate = [paymentDate dateByAddingTimeInterval:intervalFactor];
            }
            
            paymentDateComponents = [myCalendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:paymentDate];
            if (dayOfMonth == 31 && ([paymentDateComponents month] == 4 || [paymentDateComponents month] == 6 || [paymentDateComponents month] == 9 || [paymentDateComponents month] == 11))
            {
                [paymentDateComponents setDay:30];
            }
            else if (dayOfMonth > 28 && [paymentDateComponents month] == 2)
            {
                [paymentDateComponents setDay:28];
            }
            else
            {
                [paymentDateComponents setDay:dayOfMonth];
            }
            [paymentDateComponents setMonth:[paymentDateComponents month]];
            [paymentDateComponents setYear:[paymentDateComponents year]];
            paymentDate = [myCalendar dateFromComponents:paymentDateComponents];
        }
    }
    else if ([recurrenceType isEqualToString:@"Annually"])
    {
        NSCalendar *myCalendar = [NSCalendar currentCalendar];
        
        long dayOfMonth;
        
        NSDate *paymentDate;
        
        int currentMonth;
        
        int nextMonthUsing32Days;
        
        float intervalFactor;
        
        NSDateComponents *startDateComponents = [myCalendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:startDate];
        
        NSDateComponents *paymentDateComponents = [myCalendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:startDate];
        dayOfMonth = [paymentDateComponents day];
        if (dayOfMonth == 31 && ([startDateComponents month] == 4 || [startDateComponents month] == 6 || [startDateComponents month] == 9 || [startDateComponents month] == 11))
        {
            [paymentDateComponents setDay:30];
        }
        else if (dayOfMonth > 28 && [startDateComponents month] == 2)
        {
            [paymentDateComponents setDay:28];
        }
        else
        {
            [paymentDateComponents setDay:dayOfMonth];
        }
        [paymentDateComponents setMonth:[startDateComponents month]];
        [paymentDateComponents setYear:[startDateComponents year]];
        paymentDate = [myCalendar dateFromComponents:paymentDateComponents];
        while (paymentDate <= endDate)
        {
            if(paymentDate >= startDate)
            {
                [cashflowEvent.paymentSeries addObject:paymentDate];
            }
            paymentDateComponents = [myCalendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:paymentDate];
            currentMonth = [paymentDateComponents month];
            intervalFactor = [self calculateNextMonthSecondsInterval:dayOfMonth:currentMonth];
            paymentDate = [paymentDate dateByAddingTimeInterval:intervalFactor];
            
            //now repeat this whole process a second time to leap forward 1 month
            int i; //number of times to repeat
            for (i=0; i<10; i++)
            {
                paymentDateComponents = [myCalendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:paymentDate];
                if (dayOfMonth == 31 && ([paymentDateComponents month] == 4 || [paymentDateComponents month] == 6 || [paymentDateComponents month] == 9 || [paymentDateComponents month] == 11))
                {
                    [paymentDateComponents setDay:30];
                }
                else if (dayOfMonth > 28 && [paymentDateComponents month] == 2)
                {
                    [paymentDateComponents setDay:28];
                }
                else
                {
                    [paymentDateComponents setDay:dayOfMonth];
                }
                currentMonth = [paymentDateComponents month];
                intervalFactor = [self calculateNextMonthSecondsInterval:dayOfMonth:currentMonth];
                paymentDate = [paymentDate dateByAddingTimeInterval:intervalFactor];
            }
            
            paymentDateComponents = [myCalendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:paymentDate];
            if (dayOfMonth == 31 && ([paymentDateComponents month] == 4 || [paymentDateComponents month] == 6 || [paymentDateComponents month] == 9 || [paymentDateComponents month] == 11))
            {
                [paymentDateComponents setDay:30];
            }
            else if (dayOfMonth > 28 && [paymentDateComponents month] == 2)
            {
                [paymentDateComponents setDay:28];
            }
            else
            {
                [paymentDateComponents setDay:dayOfMonth];
            }
            [paymentDateComponents setMonth:[paymentDateComponents month]];
            [paymentDateComponents setYear:[paymentDateComponents year]];
            paymentDate = [myCalendar dateFromComponents:paymentDateComponents];
        }
    }
    else if ([recurrenceType isEqualToString:@"Custom (# days)"])
    {
        int i = 0;
        int dayInterval = (int)[recurrenceDetail floatValue];
        NSDate *iDate = startDate;
        
        for (iDate=startDate; iDate <= endDate; (iDate=[startDate dateByAddingTimeInterval:(86400*i*dayInterval)]))
        {
            if(iDate >= startDate)
            {
                [cashflowEvent.paymentSeries addObject:iDate];
            }
            i++;
        }
    }
    else if ([recurrenceType isEqualToString:@"One-time"])
    {
        [cashflowEvent.paymentSeries addObject:startDate];
    }
    [self.paymentSeriesTableView reloadData];
    return cashflowEvent.paymentSeries;
}

-(float) calculateNextMonthSecondsInterval:(long)dayOfMonth :(int)currentMonth
{
    //there are 86,400 (86400) seconds in a day
    //months with 31 days include january-1, march-3, may-5, july-7, august-8, october-10 and december-12 = 2,678,400 (2678400) seconds
    //months with 30 days include april-4, june-6, september-9 and november-11 = 2,592,000 (2592000) seconds
    //months with less than 30 days include february-2 (28) = 2,419,200 (2419200) seconds
    //NOTES:
    //  when the payment day of the month is in the first half of the month, we want to jump to the next month using 35 days to ensure we get all the way into the next month in all cases
    //      - an extreme case includes payments due on the 1st
    //      - another extreme case includes when Feb can be corrected back as much as 3 days (from 31 to 28) to account for "last day of month" due dates... 30 day months as well
    //      ** use 34 days or 2,937,600 (2937600) seconds
    //  when the payment day of the month is in the last half of the month, we want to jump to the next month using 18 days to ensure we get all the way into the next month in all cases
    //      - an extreme case is when the payment is due on last day of the month as well as the 16th day of the month
    //      ** use 18 days or 1,555,200 (1555200) seconds
    
    float intervalFactor;
    
    if (dayOfMonth <= 15) //use the max
    {
        intervalFactor = 2937600;
    }
    else //else use the min
    {
        intervalFactor = 1555200;
    }
    return intervalFactor;
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return cashflowEvent.paymentSeries.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *paymentSeriesTableIdentifier = @"PaymentSeriesIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:paymentSeriesTableIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:paymentSeriesTableIdentifier];
    }
    
    NSString *dateString =
    [NSDateFormatter localizedStringFromDate:[cashflowEvent.paymentSeries objectAtIndex:indexPath.row]
                                   dateStyle:NSDateFormatterShortStyle
                                   timeStyle:NSDateFormatterNoStyle];
    cell.textLabel.text = dateString;
    return cell;
}

- (IBAction)startDateChanged:(UIDatePicker *)sender {
    self.startDateSelectedLabel.text = [NSDateFormatter localizedStringFromDate:_startDatePicker.date
                                   dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterNoStyle];
    [self updatePaymentSeriesDescription];
    [self calculatePaymentSeries:self.recurrenceTextField.text :self.typeDetailTextField.text :self.startDatePicker.date :self.endDatePicker.date];
}

- (IBAction)endDateChanged:(id)sender
{
    self.endDateSelectedLabel.text = [NSDateFormatter localizedStringFromDate:_endDatePicker.date
                                                                      dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterNoStyle];
    [self updatePaymentSeriesDescription];
    [self calculatePaymentSeries:self.recurrenceTextField.text :self.typeDetailTextField.text :self.startDatePicker.date :self.endDatePicker.date];
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
    //NSLog(@"loading typeDetailDownPicker with values for %@", recurrenceType);
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
    
    //NSLog(@"reloading typeDetailArray with the values for %@", self.recurrenceTextField.text);
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
}

- (IBAction)recurrenceTypeChanged:(DownPicker *)sender
{
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
    else if ([self.recurrenceTextField.text isEqualToString:@"Weekly"] || [self.recurrenceTextField.text isEqualToString:@"Bi-weekly"])
    {
        self.typeDetailTextField.text = @"Monday";
        [self updatePaymentSeriesDescription];
    }
    else if ([self.recurrenceTextField.text isEqualToString:@"Monthly"] || [self.recurrenceTextField.text isEqualToString:@"Bi-monthly"] || [self.recurrenceTextField.text isEqualToString:@"Quarterly"])
    {
        self.typeDetailTextField.text = @"1";
        [self updatePaymentSeriesDescription];
    }
    else if ([self.recurrenceTextField.text isEqualToString:@"Custom (# days)"])
    {
        self.typeDetailTextField.text = @"30";
        [self updatePaymentSeriesDescription];
    }
    [self calculatePaymentSeries:self.recurrenceTextField.text :self.typeDetailTextField.text :self.startDatePicker.date :self.endDatePicker.date];
    self.reloadInputViews;
}

- (IBAction)typeDetailChanged:(id)sender
{
    self.helpfulHintTextView.text = @"";
    self.hintArrow.hidden = YES;
    [self updatePaymentSeriesDescription];
    [self calculatePaymentSeries:self.recurrenceTextField.text :self.typeDetailTextField.text :self.startDatePicker.date :self.endDatePicker.date];
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
@end
