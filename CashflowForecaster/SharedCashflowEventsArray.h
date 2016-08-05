//
//  SharedCashflowEventsArray.h
//  CashflowForecaster
//
//  Created by Jeremy Lilje on 8/4/16.
//  Copyright © 2016 Detroit Labs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CashflowEvent.h"

@interface SharedCashflowEventsArray : NSObject
@property (nonatomic, retain) NSMutableArray *sharedCashflowEventsArray;
+ (SharedCashflowEventsArray *)singleton;
@end