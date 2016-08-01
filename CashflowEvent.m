//
//  CashflowEvent.m
//  CashflowForecaster
//
//  Created by Jeremy Lilje on 7/18/16.
//  Copyright © 2016 Detroit Labs. All rights reserved.
//

#import "CashflowEvent.h"

@implementation CashflowEvent

-(id)       initWithType:(NSString *)type
                withName:(NSString *)name
              withAmount:(NSNumber *)amount
      withRecurrenceType:(NSString *)recurrenceType
    withRecurrenceDetail:(NSString *)recurrenceDetail
 withRecurrenceStartDate:(NSDate *)recurrenceStartDate
   withRecurrenceEndDate:(NSDate *)recurrenceEndDate
     withRecurrenceLabel:(NSString *)recurrenceLabel
               withNotes:(NSString *)notes
   withAutoPaidIndicator:(NSString *)autoPaidIndicator
           withAlertTime:(NSString *)alertTime
       withPaymentSeries:(NSMutableArray *)paymentSeries

{
    self = [self init];
    
    self.type = type;
    self.name = name;
    self.amount = amount;
    self.recurrenceType = recurrenceType;
    self.recurrenceDetail = recurrenceDetail;
    self.recurrenceStartDate = recurrenceStartDate;
    self.recurrenceEndDate = recurrenceEndDate;
    self.recurrenceLabel = recurrenceLabel;
    self.notes = notes;
    self.autoPaidIndicator = autoPaidIndicator;
    self.alertTime = alertTime;
    self.paymentSeries = paymentSeries;
    
    return self;
}

//+ (void) editCashflowEvent:(CashflowEvent *)selectedCashEvent
//{
//    NSLog(@"the passed cashflow event is named: %@", selectedCashEvent.name);
//};

@end