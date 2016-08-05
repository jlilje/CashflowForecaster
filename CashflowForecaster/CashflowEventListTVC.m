//
//  CashflowEventListTVC.m
//  CashflowForecaster
//
//  Created by Jeremy Lilje on 7/22/16.
//  Copyright © 2016 Detroit Labs. All rights reserved.
//

#import "CashflowEventListTVC.h"
#import "CashflowEvent.h"
#import "CashflowEventVC.h"
#import "SharedCashflowEventsArray.h"

@interface CashflowEventListTVC ()
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
    //SharedCashflowEventsArray *sharedCashflowEventsArray = cashflowEventsArray;//[NSMutableArray arrayWithArray:cashflowEventsArray];
    [SharedCashflowEventsArray singleton].sharedCashflowEventsArray = cashflowEventsArray;
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
        newCashflowEvent.paymentSeries = [self calculatePaymentSeries1:@"Weekly":@"Friday":sdate:edate];
        
        [cashflowEventsArray addObject:newCashflowEvent];
        
        CashflowEventVC *vc = [segue destinationViewController];
        
        [vc editCashflowEvent:newCashflowEvent];
        
    }
    else
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
    CashflowEvent *cashflowEvent1 = [[CashflowEvent alloc] init];
    CashflowEvent *cashflowEvent2 = [[CashflowEvent alloc] init];
    CashflowEvent *cashflowEvent3 = [[CashflowEvent alloc] init];
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSDateComponents *comps1 = [[NSDateComponents alloc] init];
    [comps1 setDay:5];
    [comps1 setMonth:8];
    [comps1 setYear:2016];
    NSDate *sdate1 = [gregorian dateFromComponents:comps1];
    [comps1 setMonth:9];
    NSDate *edate1 = [gregorian dateFromComponents:comps1];
    
    NSDateComponents *comps2 = [[NSDateComponents alloc] init];
    [comps2 setDay:5];
    [comps2 setMonth:8];
    [comps2 setYear:2016];
    NSDate *sdate2 = [gregorian dateFromComponents:comps2];
    [comps2 setYear:2017];
    NSDate *edate2 = [gregorian dateFromComponents:comps2];
    
    NSDateComponents *comps3 = [[NSDateComponents alloc] init];
    [comps3 setDay:5];
    [comps3 setMonth:8];
    [comps3 setYear:2016];
    NSDate *sdate3 = [gregorian dateFromComponents:comps3];
    [comps3 setMonth:9];
    NSDate *edate3 = [gregorian dateFromComponents:comps3];
    
    cashflowEvent1.type = @"Income";
    cashflowEvent1.name = @"Paycheck";
    cashflowEvent1.amount = [NSNumber numberWithFloat:555.00];
    cashflowEvent1.recurrenceType = @"Weekly";
    cashflowEvent1.recurrenceDetail = @"Friday";
    cashflowEvent1.recurrenceStartDate = sdate1;
    cashflowEvent1.recurrenceEndDate = edate1;
    cashflowEvent1.recurrenceLabel = @"Every Friday (8/5/16 - 9/5/16)";
    cashflowEvent1.notes = @"paid by check, hand-delivered on Fridays by the boss... need to deposit myself";
    cashflowEvent1.autoPaidIndicator = @"No";
    cashflowEvent1.alertTime = @"None";
    cashflowEvent1.paymentSeries = [self calculatePaymentSeries1:@"Weekly":@"Friday":sdate1:edate1];
    
    cashflowEvent2.type = @"Bill";
    cashflowEvent2.name = @"Rent";
    cashflowEvent2.amount = [NSNumber numberWithFloat:400.00];
    cashflowEvent2.recurrenceType = @"Monthly";
    cashflowEvent2.recurrenceDetail = @"1";
    cashflowEvent2.recurrenceStartDate = sdate2;
    cashflowEvent2.recurrenceEndDate = edate2;
    cashflowEvent2.recurrenceLabel = @"On the 1st of the month (8/5/16 - 8/5/17)";
    cashflowEvent2.notes = @"auto debited from checking account";
    cashflowEvent2.autoPaidIndicator = @"Yes";
    cashflowEvent2.alertTime = @"None";
    cashflowEvent2.paymentSeries = [self calculatePaymentSeries2:@"Monthly":@"1":sdate2:edate2];
    
    cashflowEvent3.type = @"Continuous Expense";
    cashflowEvent3.name = @"Food";
    cashflowEvent3.amount = [NSNumber numberWithFloat:8.00];
    cashflowEvent3.recurrenceType = @"Daily";
    cashflowEvent3.recurrenceDetail = @"None";
    cashflowEvent3.recurrenceStartDate = sdate3;
    cashflowEvent3.recurrenceEndDate = edate3;
    cashflowEvent3.recurrenceLabel = @"Daily";
    cashflowEvent3.notes = @"Daily (8/5/16 - 9/5/16)";
    cashflowEvent3.autoPaidIndicator = @"Yes";
    cashflowEvent3.alertTime = @"None";
    cashflowEvent3.paymentSeries = [self calculatePaymentSeries3:@"Continous Expense":@"None":sdate3:edate3];
    
    [cashflowEventsArray addObject:cashflowEvent1];
    [cashflowEventsArray addObject:cashflowEvent2];
    [cashflowEventsArray addObject:cashflowEvent3];
}

- (NSMutableArray *) calculatePaymentSeries1:(NSString *)recurrenceType :(NSString *)recurrenceDetail :(NSDate *)startDate :(NSDate *)endDate
{
    //Weekly
    NSMutableArray *paymentDates = [NSMutableArray array];
    [paymentDates addObject:[NSDate date]];
    [paymentDates addObject:[NSDate dateWithTimeIntervalSinceNow:86400*7*1]];
    [paymentDates addObject:[NSDate dateWithTimeIntervalSinceNow:86400*7*2]];
    [paymentDates addObject:[NSDate dateWithTimeIntervalSinceNow:86400*7*3]];
    [paymentDates addObject:[NSDate dateWithTimeIntervalSinceNow:86400*7*4]];
    return paymentDates;
}

- (NSMutableArray *) calculatePaymentSeries2:(NSString *)recurrenceType :(NSString *)recurrenceDetail :(NSDate *)startDate :(NSDate *)endDate
{
    //Monthly
    NSMutableArray *paymentDates = [NSMutableArray array];
    [paymentDates addObject:[NSDate date]];
    [paymentDates addObject:[NSDate dateWithTimeIntervalSinceNow:86400*30*1]];
    [paymentDates addObject:[NSDate dateWithTimeIntervalSinceNow:86400*30*2]];
    [paymentDates addObject:[NSDate dateWithTimeIntervalSinceNow:86400*30*3]];
    [paymentDates addObject:[NSDate dateWithTimeIntervalSinceNow:86400*30*4]];
    [paymentDates addObject:[NSDate dateWithTimeIntervalSinceNow:86400*30*5]];
    [paymentDates addObject:[NSDate dateWithTimeIntervalSinceNow:86400*30*6]];
    [paymentDates addObject:[NSDate dateWithTimeIntervalSinceNow:86400*30*7]];
    [paymentDates addObject:[NSDate dateWithTimeIntervalSinceNow:86400*30*8]];
    [paymentDates addObject:[NSDate dateWithTimeIntervalSinceNow:86400*30*9]];
    [paymentDates addObject:[NSDate dateWithTimeIntervalSinceNow:86400*30*10]];
    [paymentDates addObject:[NSDate dateWithTimeIntervalSinceNow:86400*30*11]];
    return paymentDates;
}

- (NSMutableArray *) calculatePaymentSeries3:(NSString *)recurrenceType :(NSString *)recurrenceDetail :(NSDate *)startDate :(NSDate *)endDate
{
    //Daily
    NSMutableArray *paymentDates = [NSMutableArray array];
    [paymentDates addObject:[NSDate date]];
    [paymentDates addObject:[NSDate dateWithTimeIntervalSinceNow:86400*1]];
    [paymentDates addObject:[NSDate dateWithTimeIntervalSinceNow:86400*2]];
    [paymentDates addObject:[NSDate dateWithTimeIntervalSinceNow:86400*3]];
    [paymentDates addObject:[NSDate dateWithTimeIntervalSinceNow:86400*4]];
    [paymentDates addObject:[NSDate dateWithTimeIntervalSinceNow:86400*5]];
    [paymentDates addObject:[NSDate dateWithTimeIntervalSinceNow:86400*6]];
    [paymentDates addObject:[NSDate dateWithTimeIntervalSinceNow:86400*7]];
    [paymentDates addObject:[NSDate dateWithTimeIntervalSinceNow:86400*8]];
    [paymentDates addObject:[NSDate dateWithTimeIntervalSinceNow:86400*9]];
    [paymentDates addObject:[NSDate dateWithTimeIntervalSinceNow:86400*10]];
    [paymentDates addObject:[NSDate dateWithTimeIntervalSinceNow:86400*11]];
    [paymentDates addObject:[NSDate dateWithTimeIntervalSinceNow:86400*12]];
    [paymentDates addObject:[NSDate dateWithTimeIntervalSinceNow:86400*13]];
    [paymentDates addObject:[NSDate dateWithTimeIntervalSinceNow:86400*14]];
    [paymentDates addObject:[NSDate dateWithTimeIntervalSinceNow:86400*15]];
    [paymentDates addObject:[NSDate dateWithTimeIntervalSinceNow:86400*16]];
    [paymentDates addObject:[NSDate dateWithTimeIntervalSinceNow:86400*17]];
    [paymentDates addObject:[NSDate dateWithTimeIntervalSinceNow:86400*18]];
    [paymentDates addObject:[NSDate dateWithTimeIntervalSinceNow:86400*19]];
    [paymentDates addObject:[NSDate dateWithTimeIntervalSinceNow:86400*20]];
    [paymentDates addObject:[NSDate dateWithTimeIntervalSinceNow:86400*21]];
    [paymentDates addObject:[NSDate dateWithTimeIntervalSinceNow:86400*22]];
    [paymentDates addObject:[NSDate dateWithTimeIntervalSinceNow:86400*23]];
    [paymentDates addObject:[NSDate dateWithTimeIntervalSinceNow:86400*24]];
    [paymentDates addObject:[NSDate dateWithTimeIntervalSinceNow:86400*25]];
    [paymentDates addObject:[NSDate dateWithTimeIntervalSinceNow:86400*26]];
    [paymentDates addObject:[NSDate dateWithTimeIntervalSinceNow:86400*27]];
    [paymentDates addObject:[NSDate dateWithTimeIntervalSinceNow:86400*28]];
    [paymentDates addObject:[NSDate dateWithTimeIntervalSinceNow:86400*29]];
    [paymentDates addObject:[NSDate dateWithTimeIntervalSinceNow:86400*30]];
    return paymentDates;
}

@end
