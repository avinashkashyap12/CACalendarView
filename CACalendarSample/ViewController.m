//
//  ViewController.m
//  CACalendarSample
//
//  Created by Avinash Kashyap on 21/02/18.
//  Copyright © 2018 Avinash Kashyap. All rights reserved.
//

#import "ViewController.h"
#import "CACalendarView.h"

@interface ViewController ()<CACalendarDelegate>
{
    CACalendarView *calendarView;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self addCalendarView];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -
-(void) addCalendarView{
    CGSize size = [UIScreen mainScreen].bounds.size;
    calendarView = [[CACalendarView alloc] initWithFrame:CGRectMake(0, 70, size.width, size.height-200)];
    //remove comment if want to disable previous date
    calendarView.isDisablePreviousDate = true;
    calendarView.backgroundColor  = [UIColor whiteColor];
    calendarView.delegate = self;
    //set selected date
    [calendarView setSetectedDate:[NSDate date]];
    [self.view insertSubview:calendarView atIndex:0];
}
-(void) didSelectedDate:(NSDate *)date{
    //date format 2017-09-13
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSLog(@"selected date = %@  and string = %@", date, [formatter stringFromDate:date]);
}

@end
