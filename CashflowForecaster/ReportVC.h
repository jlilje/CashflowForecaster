//
//  ReportVC.h
//  CashflowForecaster
//
//  Created by Jeremy Lilje on 8/4/16.
//  Copyright © 2016 Detroit Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import <Charts.h>
#import "PNChartDelegate.h"
#import "PNChart.h"
#import "SharedCashflowEventsArray.h"

@interface ReportVC : UIViewController<PNChartDelegate>//<ChartViewDelegate>

@property (nonatomic) PNLineChart * lineChart;
@property (nonatomic) PNBarChart * barChart;
@property (nonatomic) PNCircleChart * circleChart;
@property (nonatomic) PNPieChart *pieChart;
@property (nonatomic) PNScatterChart *scatterChart;
@property (nonatomic) PNRadarChart *radarChart;
@property (weak, nonatomic) IBOutlet UILabel *centerSwitchLabel;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

- (IBAction)changeValue:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *changeValueButton;

@property (weak, nonatomic) IBOutlet UISwitch *animationsSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *leftSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *centerSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *rightSwitch;
@property (weak, nonatomic) IBOutlet UILabel *leftLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightLabel;

- (IBAction)rightSwitchChanged:(id)sender;
- (IBAction)leftSwitchChanged:(id)sender;

@property SharedCashflowEventsArray *sharedCashflowEventsArray;

@end
