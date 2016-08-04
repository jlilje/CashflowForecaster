//
//  CashflowEventListTVC.m
//  CashflowForecaster
//
//  Created by Jeremy Lilje on 7/22/16.
//  Copyright © 2016 Detroit Labs. All rights reserved.
//

#import "CashflowEventListTVC.h"
#import "CashflowEvent.h"
//#import "PaymentSeries.h"
#import "CashflowEventVC.h"

@interface CashflowEventListTVC ()
//@property NSMutableArray *cashflowEventsArray;
//@property CashflowEvent *selectedCashflowEvent;
@end

@implementation CashflowEventListTVC

NSMutableArray *storedCashflowEventsArray;

NSMutableArray *cashflowEventsArray;

CashflowEvent *selectedCashflowEvent;

NSMutableArray *paymentSeries;

- (IBAction)Add:(id)sender {
    NSLog(@"running in \"Add\" method");
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    
    if (storedCashflowEventsArray == NULL)
    {
        //NSLog(@"creating a new stored cashflow event array...");
        storedCashflowEventsArray = [[NSMutableArray alloc] init];
    }
    
    if (cashflowEventsArray == NULL)
    {
        //NSLog(@"creating a new dynaic cashflow event array...");
        cashflowEventsArray = [[NSMutableArray alloc] init];
    }
    
    if ([storedCashflowEventsArray count] == 0 && [cashflowEventsArray count] == 0)
    {
        //if both the persisted and non-persisted CFE arrays are empty, load the test CFEs into the array and continue
        //NSLog (@"loading test CFEs (both CFE arrays are empty)...");
        [self loadCashflowEvents];
    }
    else if ([storedCashflowEventsArray count] == 0)
    {
        //NSLog(@"inside viewDidLoad method, with condition of stored CFE array is the only empty array");
        //if only the stored array is empty, continue using the unpersisted CFE Array and (eventually) persist it
    }
    else
    {
        //if only the unpersisted array is empty, load it to the dynamic CFE Array... this will be the normal startup process
        //NSLog(@"inside viewDidLoad method, with condition of dynamic CFE array is the only empty array");
        cashflowEventsArray = [storedCashflowEventsArray mutableCopy];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [cashflowEventsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"listPrototypeCell" forIndexPath:indexPath];
    
    CashflowEvent *cashflowEvent = [cashflowEventsArray objectAtIndex:indexPath.row];
 
    cell.textLabel.text = cashflowEvent.name;
    
    //NSLog(@"adding CFE %@ to TVC list", cashflowEvent.name);

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSLog(@"sender id is \"%@\"", segue.identifier);
    
    //NSLog(@"the CFE array going out is %@", cashflowEventsArray);
    
    if ([segue.identifier isEqualToString:@"Add..."])
    {
        //initialize new object
        //add object to cashflowEventsArray
        //hand new object off to next VC for editing
        
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        NSDate *currentDate = [NSDate date];
        NSDateComponents *currentDateComponents = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:currentDate];
        
        NSDateComponents *comps = [[NSDateComponents alloc] init];
        [comps setDay:[currentDateComponents day]];
        [comps setMonth:[currentDateComponents month]];
        [comps setYear:[currentDateComponents year]];
        
        NSDate *sdate = [calendar dateFromComponents:comps];
        [comps setMonth:[currentDateComponents month]+2];
        NSDate *edate = [calendar dateFromComponents:comps];
        
        CashflowEvent *newCashflowEvent = [[CashflowEvent alloc] init];
        newCashflowEvent.type = @"";
        newCashflowEvent.name = @"";
        newCashflowEvent.amount = [NSNumber numberWithFloat:0.00];
        newCashflowEvent.recurrenceType = @"";
        newCashflowEvent.recurrenceDetail = @"";
        newCashflowEvent.recurrenceStartDate = sdate;
        newCashflowEvent.recurrenceEndDate = edate;
        newCashflowEvent.recurrenceLabel = @"";
        newCashflowEvent.notes = @"";
        newCashflowEvent.autoPaidIndicator = @"";
        newCashflowEvent.alertTime = @"";
        newCashflowEvent.paymentSeries = [self calculatePaymentSeries:@"Weekly":@"Friday":sdate:edate];
        
        [cashflowEventsArray addObject:newCashflowEvent];
        
        CashflowEventVC *vc = [segue destinationViewController];
        
        [vc editCashflowEvent:newCashflowEvent];
        
    }
    else //if ([segue.identifier isEqualToString:@"Edit"])
    {
        // First, get the selected cashflow event
        // Then, get the destination view controller using [segue destinationViewController].
        // Finally, pass the selected cashflow event to the destination view controller.
        
        selectedCashflowEvent = cashflowEventsArray[[self.tableView indexPathForSelectedRow].row];
        
        CashflowEventVC *vc = [segue destinationViewController];
        
        [vc editCashflowEvent:selectedCashflowEvent];
    }
}

- (void) viewDidAppear:(BOOL)animated
{
    [self.tableView reloadData];
    //NSLog(@"reloading table...");
}

-(IBAction)unwindToCashflowEventTVC:(UIStoryboardSegue *)segue
{
    NSLog(@"unwinding from CashflowEventVC to CashflowEventTVC...");
    //NSLog(@"the new amount from the CFE veiw controller is %@", selectedCashflowEvent.amount);
}

-(void) loadCashflowEvents
{
    //NSLog(@"IM CREATING NEW CASHFLOW EVENTS!!!!!!!!!!!!!");
    
    CashflowEvent *cashflowEvent1 = [[CashflowEvent alloc] init];
    CashflowEvent *cashflowEvent2 = [[CashflowEvent alloc] init];
    CashflowEvent *cashflowEvent3 = [[CashflowEvent alloc] init];
    
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setDay:1];
    [comps setMonth:8];
    [comps setYear:2016];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate *sdate1 = [gregorian dateFromComponents:comps];
    [comps setMonth:9];
    NSDate *edate1 = [gregorian dateFromComponents:comps];
    //  [comps release];
    
    cashflowEvent1.type = @"Income";
    cashflowEvent1.name = @"my paycheck";
    cashflowEvent1.amount = [NSNumber numberWithFloat:555.00];
    cashflowEvent1.recurrenceType = @"Weekly";
    cashflowEvent1.recurrenceDetail = @"Friday";
    cashflowEvent1.recurrenceStartDate = sdate1;
    cashflowEvent1.recurrenceEndDate = edate1;
    cashflowEvent1.recurrenceLabel = @"Every Friday (8/3/16 - 9/1/16)";
    cashflowEvent1.notes = @"paid by check, hand-delivered on Fridays by the boss... need to deposit myself";
    cashflowEvent1.autoPaidIndicator = @"No";
    cashflowEvent1.alertTime = @"None";
    cashflowEvent1.paymentSeries = [self calculatePaymentSeries:@"Weekly":@"Friday":sdate1:edate1];
    
    cashflowEvent2.type = @"Bill";
    cashflowEvent2.name = @"Rent";
    cashflowEvent2.amount = [NSNumber numberWithFloat:400.00];
    cashflowEvent2.recurrenceType = @"Monthly";
    cashflowEvent2.recurrenceDetail = @"1";
    cashflowEvent2.recurrenceStartDate = sdate1;
    cashflowEvent2.recurrenceEndDate = edate1;
    cashflowEvent2.recurrenceLabel = @"On the 1st of the month (8/3/16 - 9/1/16)";
    cashflowEvent2.notes = @"auto debited from checking account";
    cashflowEvent2.autoPaidIndicator = @"Yes";
    cashflowEvent2.alertTime = @"None";
    cashflowEvent2.paymentSeries = [self calculatePaymentSeries:@"Monthly":@"1":sdate1:edate1];
    
    cashflowEvent3.type = @"Continuous Expense";
    cashflowEvent3.name = @"Food";
    cashflowEvent3.amount = [NSNumber numberWithFloat:8.00];
    cashflowEvent3.recurrenceType = @"Daily";
    cashflowEvent3.recurrenceDetail = @"None";
    cashflowEvent3.recurrenceStartDate = sdate1;
    cashflowEvent3.recurrenceEndDate = edate1;
    cashflowEvent3.recurrenceLabel = @"Daily";
    cashflowEvent3.notes = @"Daily (8/3/16 - 9/1/16)";
    cashflowEvent3.autoPaidIndicator = @"Yes";
    cashflowEvent3.alertTime = @"None";
    cashflowEvent3.paymentSeries = [self calculatePaymentSeries:@"Continous Expense":@"None":sdate1:edate1];
    
    [cashflowEventsArray addObject:cashflowEvent1];
    [cashflowEventsArray addObject:cashflowEvent2];
    [cashflowEventsArray addObject:cashflowEvent3];
}

- (NSMutableArray *) calculatePaymentSeries:(NSString *)recurrenceType :(NSString *)recurrenceDetail :(NSDate *)startDate :(NSDate *)endDate
{
    //NSLog(@"calculating payment series with the following parameters passed in (not yet used): %@, %@, %@, %@", recurrenceType, recurrenceDetail, startDate, endDate);
    
    NSMutableArray *paymentDates = [NSMutableArray array];
    //[paymentSeries alloc];
    //NSLog(@"adding date %@ to payment series array...", [NSDate date]);
    [paymentDates addObject:[NSDate date]];
    //NSLog(@"adding date %@ to payment series array...", [NSDate dateWithTimeIntervalSinceNow:1000000]);
    [paymentDates addObject:[NSDate dateWithTimeIntervalSinceNow:1000000]];
    //NSLog(@"adding date %@ to payment series array...", [NSDate dateWithTimeIntervalSinceNow:2000000]);
    [paymentDates addObject:[NSDate dateWithTimeIntervalSinceNow:2000000]];
    //NSLog(@"payment series inside calcPaySeries is %@, which has %i objects in it!", paymentDates, (unsigned)paymentDates.count);
    return paymentDates;
}

@end
