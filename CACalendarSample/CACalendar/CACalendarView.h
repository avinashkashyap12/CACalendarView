//
//  CACalendarView.h
//  SampleProjectPoc
//
//  Created by Avinash Kashyap on 06/09/17.
//  Copyright © 2017 Avinash Kashyap. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CACalendarManager.h"
#define  KDayTagPadding 100
#define  KStrokeWidth 0.5


@protocol CACalendarDelegate;


@interface CACalendarView : UIView
{
    NSIndexPath *selectedIndexPath;
    NSInteger selectedIndex;
    CADateComponent *selectedDateComponent;
    UIView *selectedIndicatorView;
}
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UIView *containerView;
//button for display previous month
@property (nonatomic, strong) UIButton *previousButton;
//button for display next month
@property (nonatomic, strong) UIButton *nextButton;
//display current month with year
@property (nonatomic, strong) UILabel *currentMonthLabel;
//disable previous date from current date
@property (nonatomic, assign) BOOL isDisablePreviousDate;

@property (nonatomic, strong) NSArray *dataList;
@property (nonatomic, weak) id <CACalendarDelegate> delegate;
//set date on calendar. Default is false
-(void) setSetectedDate:(NSDate *)date;
@end

@protocol CACalendarDelegate <NSObject>
-(void) didSelectedDate:(NSDate *)date;
@end
