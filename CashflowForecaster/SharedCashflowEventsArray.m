//
//  SharedCashflowEventsArray.m
//  CashflowForecaster
//
//  Created by Jeremy Lilje on 8/4/16.
//  Copyright © 2016 Detroit Labs. All rights reserved.
//

#import "SharedCashflowEventsArray.h"

@implementation SharedCashflowEventsArray
@synthesize sharedCashflowEventsArray;
+(SharedCashflowEventsArray *)singleton
{
    static dispatch_once_t pred;
    static SharedCashflowEventsArray *shared = nil;
    dispatch_once(&pred, ^{
        shared = [[SharedCashflowEventsArray alloc] init];
        shared.sharedCashflowEventsArray = [[NSMutableArray alloc]init];
    });
    return shared;
}

- (id)init
{
    if ( (self = [super init]) )
    {
        //not sure what needs to be done here
    }
    return self;
}

- (void)customMethod {
    // implement your custom code here
}

// singleton methods
//+ (id)allocWithZone:(NSZone *)zone {
//    return [[self sharedTruck] retain];
//}
//
//- (id)copyWithZone:(NSZone *)zone {
//    return self;
//}
//
//- (id)retain {
//    return self;
//}
//
//- (NSUInteger)retainCount {
//    return NSUIntegerMax;  // denotes an object that cannot be released
//}
//
//- (void)release {
//    // do nothing - we aren't releasing the singleton object.
//}
//
//- (id)autorelease {
//    return self;
//}
//
//-(void)dealloc {
//    [super dealloc];
//}


@end
