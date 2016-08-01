//
//  CashflowEvent.h
//  CashflowForecaster
//
//  Created by Jeremy Lilje on 7/18/16.
//  Copyright © 2016 Detroit Labs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CashflowEvent : NSObject

@property (nonatomic, strong) NSString *type; //income, bill, continuous expense

@property (nonatomic, strong) NSString *name; //

@property (nonatomic, strong) NSNumber *amount; //

@property (nonatomic, strong) NSString *recurrenceType; // daily, weekly, bi-weekly, monthly, bi-monthly, quarterly, semi-annually, annually, one-time, specific number of days, other

@property (nonatomic, strong) NSString *recurrenceDetail; // day of week (Monday - Sunday) or day of month (1 - 31)

@property (nonatomic, strong) NSDate *recurrenceStartDate; //

@property (nonatomic, strong) NSDate *recurrenceEndDate; //

@property (nonatomic, strong) NSString *recurrenceLabel; // describes the recurrence for display purposes

@property (nonatomic, strong) NSString *notes; //

@property (nonatomic, strong) NSString *autoPaidIndicator; //

@property (nonatomic, strong) NSString *alertTime; // # of days prior to the due date you want to be notified (1 - 30 or "n/a")

@property (nonatomic) NSMutableArray *paymentSeries;

-(id)       initWithType:(NSString *) type
                withName:(NSString *) name
              withAmount:(float) amount
      withRecurrenceType:(NSString *) recurrenceType
    withRecurrenceDetail:(NSString *) recurenceDetail
 withRecurrenceStartDate:(NSDate *) recurrenceStartDate
   withRecurrenceEndDate:(NSDate *) recurrenceEndDate
     withRecurrenceLabel:(NSString *) recurrenceLabel
               withNotes:(NSString *) notes
   withAutoPaidIndicator:(NSString *) autoPaidIndicator
           withAlertTime:(NSString *) alertTime
       withPaymentSeries:(NSMutableArray *) paymentSeries;

//-(void) calculatePaymentStream

//+ (void) editCashflowEvent:(CashflowEvent *)selectedCashEvent;

@end
