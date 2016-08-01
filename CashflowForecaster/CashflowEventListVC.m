//
//  CashflowEventListVC.m
//  CashflowForecaster
//
//  Created by Jeremy Lilje on 7/22/16.
//  Copyright © 2016 Detroit Labs. All rights reserved.
//

#import "CashflowEventListVC.h"
#import "CashFlowItem.h"
#import "PaymentSeries.h"

@implementation CashflowEventListVC

//#import "ChoreListTableViewController.h"
//#import "ChoreItem.h"
//#import "AddChoreViewController.h"
//@interface ChoreListTableViewController ()
//
//@property NSMutableArray *choreArray;
//
//@end

//@implementation ChoreListTableViewController

//-(void)loadChores
//{
//    CashFlow *chore1 = [[ChoreItem alloc] init];
//    ChoreItem *chore2 = [[ChoreItem alloc] init];
//    ChoreItem *chore3 = [[ChoreItem alloc] init];
//    
//    chore1.name = @"walk dog";
//    chore1.choreDescription = @"";
//    chore1.status = @"";
//    chore1.dueDate = [[NSDate alloc] init];
//    chore1.assignedTo = @"";
//    chore1.estimatedTimeToComplete = @0;
//    
//    chore2.name = @"do dishes";
//    chore2.choreDescription = @"";
//    chore2.status = @"";
//    chore2.dueDate = [[NSDate alloc] init];
//    chore2.assignedTo = @"";
//    chore2.estimatedTimeToComplete = @0;
//    
//    chore3.name = @"clean room";
//    chore3.choreDescription = @"";
//    chore3.status = @"";
//    chore3.dueDate = [[NSDate alloc] init];
//    chore3.assignedTo = @"";
//    chore3.estimatedTimeToComplete = @0;
//    
//    [self.choreArray addObject:chore1];
//    [self.choreArray addObject:chore2];
//    [self.choreArray addObject:chore3];
//    
//}

//:(NSString *) type
//:(NSString *) name
//:(float) amount
//:(NSString *) recurrenceType
//:(NSString *) recurenceDetail
//:(NSDate *) recurrenceStartDate
//:(NSDate *) recurrenceEndDate
//:(NSString *) recurrenceLabel
//:(NSString *) notes
//:(NSString *) autoPaidIndicator
//:(NSString *) alertTime
//:(NSMutableArray *) paymentSeries;
//

-(void) loadCashflowEvents
{
    CashEvent *cashEvent1 = [[CashEvent alloc] init];
    CashEvent *cashEvent2 = [[CashEvent alloc] init];
    CashEvent *cashEvent3 = [[CashEvent alloc] init];
    
    cashEvent1.type = @"Income";
    cashEvent1.name = @"my paycheck";
    cashEvent1.amount = 400;
    cashEvent1.recurrenceType = @"Weekly";
    cashEvent1.recurrenceDetail = @"Friday";
    
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
    
    
    
    
    cashEvent1.recurrenceStartDate = sdate1;
    cashEvent1.recurrenceEndDate = edate1;
    cashEvent1.recurrenceLabel = @"Weekly, on Friday";
    cashEvent1.notes = @"paid by check, hand-delivered on Fridays by the boss... need to deposit myself";
    cashEvent1.autoPaidIndicator = @"No";
    cashEvent1.alertTime = @"n/a";
    //cashEvent1.paymentSeries = [PaymentSeries ]
    
    NSLog(@"cash flow event 1 is...", cashEvent1);
    
    cashEvent2.type = @"Bill";
    cashEvent2.name = @"Rent";
    cashEvent2.amount = 400;
    cashEvent2.recurrenceType = @"Monthly";
    cashEvent2.recurrenceDetail = @"1";
    cashEvent2.recurrenceStartDate = sdate1;
    cashEvent2.recurrenceEndDate = edate1;
    cashEvent2.recurrenceLabel = @"Montly, due on the 1st";
    cashEvent2.notes = @"auto debited from checking account";
    cashEvent2.autoPaidIndicator = @"Yes";
    cashEvent2.alertTime = @"5";
    //cashEvent2.paymentSeries = [PaymentSeries ]
    
    NSLog(@"cash flow event 2 is...", cashEvent2);
    
    cashEvent3.type = @"Continuous Expense";
    cashEvent3.name = @"Food";
    cashEvent3.amount = 8;
    cashEvent3.recurrenceType = @"Daily";
    cashEvent3.recurrenceDetail = @"n/a";
    cashEvent3.recurrenceStartDate = sdate1;
    cashEvent3.recurrenceEndDate = edate1;
    cashEvent3.recurrenceLabel = @"daily";
    cashEvent3.notes = @"paid continuously via cash on hand";
    cashEvent3.autoPaidIndicator = @"n/a";
    cashEvent3.alertTime = 0;
    //cashEvent3.paymentSeries = [PaymentSeries ]
    
    NSLog(@"cash flow event 3 is...", cashEvent3);
    
}

//- (void)viewDidLoad {
//    [super viewDidLoad];
//    self.choreArray = [[NSMutableArray alloc] init];
//    
//    NSArray * storedChoreArray = [self loadStoredChores];
//    if([storedChoreArray count] > 0) {
//        self.choreArray = [storedChoreArray mutableCopy];
//    }
//    else {
//        [self loadChores];
//    }
//}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.cashflowEventsArray = [[NSMutableArray alloc] init];
    
//    NSArray * c = [self loadStoredChores];
//    if([storedChoreArray count] > 0) {
//        self.choreArray = [storedChoreArray mutableCopy];
//    }
//    else {
        [self loadChores];
    //}

//}
//
//- (void)didReceiveMemoryWarning {
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.choreArray count];
}

-(IBAction)unwindToList:(UIStoryboardSegue *) segue
{
    AddChoreViewController *source = [segue sourceViewController];
    ChoreItem *item = source.choreItem;
    [self.choreArray addObject:item];
    [self.tableView reloadData];
    
    [self saveChores];
}


//-(IBAction)editItemInList:(UIStoryboard * ) segue{
//    _choreArray[pickedItem].name =@"New name";
//}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"listPrototypeCell" forIndexPath:indexPath];
    
    ChoreItem *choreItem = [self.choreArray objectAtIndex:indexPath.row];
    
    cell.textLabel.text = choreItem.name;
    
    
    return cell;
}

-(void)saveChores {
    BOOL isSuccessfulSave = [NSKeyedArchiver archiveRootObject:_choreArray toFile:[ChoreItem getArchiveURL]];
    
    if(isSuccessfulSave == NO) {
        NSLog(@"failed to save chores.");
    }
}

-(NSArray *)loadStoredChores {
    return [NSKeyedUnarchiver unarchiveObjectWithFile:[ChoreItem getArchiveURL]];
}



// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"Test");
    return YES;
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    //prepareForSegue(*cell)
    //NSString *cellText = cell.textLabel.text;
    //NSLog(cellText);
}

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */


// Override to support conditional rearranging of the table view.
//- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
//    // Return NO if you do not want the item to be re-orderable.
//
//    return YES;
//}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    // AddChoreViewController.choreItem.name = chore1.text;
}

@end
