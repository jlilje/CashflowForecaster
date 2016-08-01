//
//  PaymentSeries.h
//  CashflowForecaster
//
//  Created by Jeremy Lilje on 7/21/16.
//  Copyright © 2016 Detroit Labs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PaymentSeries : NSObject

@property (nonatomic, strong) NSDate *dueDate; //

@property (nonatomic, strong) NSString *paymentStatus; //

@end
