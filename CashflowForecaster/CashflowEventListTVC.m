//
//  CashflowEventListTVC.m
//  CashflowForecaster
//
//  Created by Jeremy Lilje on 7/22/16.
//  Copyright © 2016 Detroit Labs. All rights reserved.
//

#import "CashflowEventListTVC.h"
#import "CashflowEvent.h"
#import "PaymentSeries.h"
#import "CashflowEventVC.h"

@interface CashflowEventListTVC ()
@property NSMutableArray *cashflowEventsArray;
@property CashflowEvent *selectedCashflowEvent;
@end

@implementation CashflowEventListTVC

NSArray *storedCashflowEventsArray;

NSArray *cashflowEventsArray;

-(void) loadCashflowEvents
{
    NSLog(@"IM CREATING NEW CASHFLOW EVENTS!!!!!!!!!!!!!");
    CashflowEvent *cashflowEvent1 = [[CashflowEvent alloc] init];
    CashflowEvent *cashflowEvent2 = [[CashflowEvent alloc] init];
    CashflowEvent *cashflowEvent3 = [[CashflowEvent alloc] init];
    
    cashflowEvent1.type = @"Income";
    cashflowEvent1.name = @"my paycheck";
    cashflowEvent1.amount = [NSNumber numberWithFloat:555.00];
    cashflowEvent1.recurrenceType = @"Weekly";
    cashflowEvent1.recurrenceDetail = @"Friday";
    
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setDay:1];
    [comps setMonth:6];
    [comps setYear:2016];
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate *sdate1 = [gregorian dateFromComponents:comps];
    [comps setMonth:9];
    NSDate *edate1 = [gregorian dateFromComponents:comps];
    //  [comps release];
    
    cashflowEvent1.recurrenceStartDate = sdate1;
    cashflowEvent1.recurrenceEndDate = edate1;
    cashflowEvent1.recurrenceLabel = @"Weekly, on Friday";
    cashflowEvent1.notes = @"paid by check, hand-delivered on Fridays by the boss... need to deposit myself";
    cashflowEvent1.autoPaidIndicator = @"No";
    cashflowEvent1.alertTime = @"None";
    //cashflowEvent1.paymentSeries = [PaymentSeries ]
    
    cashflowEvent2.type = @"Bill";
    cashflowEvent2.name = @"Rent";
    cashflowEvent2.amount = [NSNumber numberWithFloat:400.00];
    cashflowEvent2.recurrenceType = @"Monthly";
    cashflowEvent2.recurrenceDetail = @"1";
    cashflowEvent2.recurrenceStartDate = sdate1;
    cashflowEvent2.recurrenceEndDate = edate1;
    cashflowEvent2.recurrenceLabel = @"Montly, due on the 1st";
    cashflowEvent2.notes = @"auto debited from checking account";
    cashflowEvent2.autoPaidIndicator = @"Yes";
    cashflowEvent2.alertTime = @"None";
    //cashflowEvent2.paymentSeries = [PaymentSeries ]
    
    cashflowEvent3.type = @"Continuous Expense";
    cashflowEvent3.name = @"Food";
    cashflowEvent3.amount = [NSNumber numberWithFloat:8.00];
    cashflowEvent3.recurrenceType = @"Daily";
    cashflowEvent3.recurrenceDetail = @"n/a";
    cashflowEvent3.recurrenceStartDate = sdate1;
    cashflowEvent3.recurrenceEndDate = edate1;
    cashflowEvent3.recurrenceLabel = @"daily";
    cashflowEvent3.notes = @"paid continuously via cash on hand";
    cashflowEvent3.autoPaidIndicator = @"Yes";
    cashflowEvent3.alertTime = @"None";
    //cashflowEvent3.paymentSeries = [PaymentSeries ]
    
    [self.cashflowEventsArray addObject:cashflowEvent1];
    [self.cashflowEventsArray addObject:cashflowEvent2];
    [self.cashflowEventsArray addObject:cashflowEvent3];
}

- (IBAction)Add:(id)sender {
    NSLog(@" in new add action");
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
        storedCashflowEventsArray = [[NSMutableArray alloc] init];
    }
    
    if (cashflowEventsArray == NULL)
    {
        cashflowEventsArray = [[NSMutableArray alloc] init];
    }
    
    if ([storedCashflowEventsArray count] == 0 && [self.cashflowEventsArray count] == 0)
    {
        //if both the persisted and non-persisted CFE arrays are empty, load the test CFEs into the array and continue
        NSLog (@"both CFE arrays are empty, will load test CFEs");
        [self loadCashflowEvents];
    }
    else if ([storedCashflowEventsArray count] == 0)
    {
        //if only the stored array is empty, continue using the unpersisted CFE Array and (eventually) persist it
    }
    else
    {
        //if only the unpersisted array is empty, load it to the dynamic CFE Array... this will be the normal startup process
        self.cashflowEventsArray = [storedCashflowEventsArray mutableCopy];
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
    return [self.cashflowEventsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"listPrototypeCell" forIndexPath:indexPath];
    
    CashflowEvent *cashflowEvent = [self.cashflowEventsArray objectAtIndex:indexPath.row];
 
    cell.textLabel.text = cashflowEvent.name;

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//    NSString *cellText = cell.textLabel.text;
//    NSLog(@"cell selected is index # %lu, %@", [self.tableView indexPathForSelectedRow].row, cellText);
//    _selectedCashflowEvent = _cashflowEventsArray[[self.tableView indexPathForSelectedRow].row];
//    NSLog(@"in didSelectRowAtIndex method, the _selectedCashflowEvent is %@", _selectedCashflowEvent);
//    
//    SharedCashEvent *selectedTruck = [SharedTruck makeTruck];
//    selectedTruck->truckName = truckToPass.truckName;
//    selectedTruck->andTruckMenu = truckToPass.truckMenu;
//    selectedTruck->andTruckBlurb = truckToPass.truckBlurb;
//    selectedTruck->andTruckSchedule.scheduleStartTime = truckToPass.truckSchedule.scheduleStartTime;
//    selectedTruck->andTruckSchedule.scheduleEndTime = truckToPass.truckSchedule.scheduleEndTime;
//    selectedTruck->andTruckSchedule.scheduleLocation = truckToPass.truckSchedule.scheduleLocation;
//    
//    _checkedCell = indexPath;
//    [tableView reloadData];
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
    
    NSLog(@"the CFE array going out is %@", self.cashflowEventsArray);
    
    if ([segue.identifier isEqualToString:@"Add..."])
    {
        _selectedCashflowEvent = [[CashflowEvent alloc] init];
        
        [self.cashflowEventsArray addObject:_selectedCashflowEvent];
        
        CashflowEventVC *vc = [segue destinationViewController];
        
        [vc editCashflowEvent:_selectedCashflowEvent];
    }
    else //if ([segue.identifier isEqualToString:@"Edit"])
    {
        // First, get the selected cashflow event
        // Then, get the destination view controller using [segue destinationViewController].
        // Finally, pass the selected cashflow event to the destination view controller.
        
        _selectedCashflowEvent = _cashflowEventsArray[[self.tableView indexPathForSelectedRow].row];
        
        CashflowEventVC *vc = [segue destinationViewController];
        
        [vc editCashflowEvent:_selectedCashflowEvent];
    }
}

- (void) viewDidAppear:(BOOL)animated
{
    //[self.tableView reloadData];
    NSLog(@"table has reloaded");
}

-(IBAction)unwindToCashflowEventTVC:(UIStoryboardSegue *)segue
{
    NSLog(@"unwinding from CashflowEventVC to CashflowEventTVC");
    NSLog(@"the new amount from the CFE veiw controller is %@", _selectedCashflowEvent.amount);
}

@end
