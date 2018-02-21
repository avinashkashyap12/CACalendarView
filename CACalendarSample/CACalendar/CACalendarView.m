//
//  CACalendarView.m
//  SampleProjectPoc
//
//  Created by Avinash Kashyap on 06/09/17.
//  Copyright © 2017 Avinash Kashyap. All rights reserved.
//

#import "CACalendarView.h"
#import "CACalendarManager.h"
#import "CADateLabel.h"

@implementation CACalendarView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(instancetype) init{
    self = [super init];
    if (self) {
        [self setupUI];
    }
    return self;
}
-(instancetype) initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}
-(void) awakeFromNib{
    [super awakeFromNib];
    [self setupUI];
}
-(void) setupUI{
    [self addUperHeader];
    [self addAllDays];
    if (self.containerView == nil) {
        self.containerView = [[UIView alloc] init];
        self.containerView.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:self.containerView];
    }
    selectedIndex = -1;
    selectedDateComponent = nil;
    
    [self displayMonthCalendar];
    
}
-(void) setIsDisablePreviousDate:(BOOL)isDisablePreviousDate{
    _isDisablePreviousDate = isDisablePreviousDate;
    [self addAllDayViews];
}
-(void) addUperHeader{
    CGFloat x = 10;
    CGFloat y = 0;
    CGFloat width = 35;
    CGFloat height = 35;
    //---
    self.previousButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.previousButton.backgroundColor = [UIColor whiteColor];
    //[self.previousButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    //[self.previousButton setTitle:@"<" forState:UIControlStateNormal];
    [self.previousButton setImage:[UIImage imageNamed:@"arrow_calendar_left"] forState:UIControlStateNormal];
    self.previousButton.frame = CGRectMake(x, y, width, height);
    [self.previousButton addTarget:self action:@selector(previousButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.previousButton];
    //--
    x = x + width;
    self.currentMonthLabel = [[UILabel alloc] initWithFrame:CGRectMake(x, y, self.bounds.size.width - (2 * x), height)];
    self.currentMonthLabel.backgroundColor = [UIColor whiteColor];
    self.currentMonthLabel.font = KDefaultFont;
    self.currentMonthLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.currentMonthLabel];
    //---
    x = self.bounds.size.width - x;
    self.nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.nextButton.backgroundColor = [UIColor whiteColor];
//    [self.nextButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [self.nextButton setTitle:@">" forState:UIControlStateNormal];
    [self.nextButton setImage:[UIImage imageNamed:@"arrow_calendar_right"] forState:UIControlStateNormal];
    self.nextButton.frame = CGRectMake(x, y, 35, height);
    [self.nextButton addTarget:self action:@selector(nextButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.nextButton];
    //-----
}
-(CGFloat) getDatLabelWidth{
    return (self.bounds.size.width-8*KStrokeWidth)/7;
}
-(NSInteger) getNumberOfRows{
    return self.dataList.count/7;
}
-(void) addAllDays{
    UIView *daysbackView = [[UIView alloc] initWithFrame:CGRectMake(0, 35, self.bounds.size.width, 35)];
    daysbackView.backgroundColor = [UIColor whiteColor];
    [self addSubview:daysbackView];
    //set week day lable
    NSArray *weekDays = [[CACalendarManager sharedInstance] updateDayOfWeekLabels];
    CGFloat x = 1;
    CGFloat y = 0;
    CGFloat width = [self getDatLabelWidth];
    for (int i = 0; i < weekDays.count; i++) {
        x = width * i + (i+1)*0.5;
        UILabel *dayTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(x, y, width, 35)];
        dayTextLabel.backgroundColor = [UIColor clearColor];
        dayTextLabel.tag = -1;
        dayTextLabel.textAlignment = NSTextAlignmentCenter;
        dayTextLabel.textColor = [UIColor blackColor];
        dayTextLabel.text = weekDays[i];
        [daysbackView addSubview:dayTextLabel];
    }
}
-(void) addAllDayViews{
    // get number of rows
    NSInteger numberOfRows = [self getNumberOfRows];
    CGFloat x = 1;
    CGFloat y = 1;
    CGFloat width = [self getDatLabelWidth];
    //ad back view
    self.containerView.frame = CGRectMake(0, 70, self.bounds.size.width, (numberOfRows*width)+(numberOfRows+1)*KStrokeWidth);
    //remove all subview
    for (UIView *aView in self.containerView.subviews){
        if (aView.tag >= KDayTagPadding) {
            [aView removeFromSuperview];
        }
    }
    //add all date view
    for (int r = 0; r < numberOfRows; r++) {
        y = width * r + (r+1)* KStrokeWidth;
        for (int c = 0 ; c < 7; c++) {
            x = width * c + (c+1)*KStrokeWidth;
            NSInteger tag = r*7+c;
            CADateLabel *dateLabel = [self.containerView viewWithTag:tag+KDayTagPadding];
            if (dateLabel == nil) {
                dateLabel = [[CADateLabel alloc] initWithFrame:CGRectMake(x, y, width, width) withDateComponenet:self.dataList[tag]];
                dateLabel.font = KDefaultFont;
                dateLabel.tag = tag+KDayTagPadding;
                // add tap gesture on date view
                [dateLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSelectionTapGesture:)]];
            }//end if block null check
            [self.containerView addSubview:dateLabel];
            [dateLabel setDateComponent:self.dataList[tag] withDisablePreviousDate:self.isDisablePreviousDate];
        }//end inner for loop
    }//end outer for loop
    //------
    if(selectedIndex != -1){
        CADateLabel *selectedLabel = [self.containerView viewWithTag:selectedIndex];
        if ([selectedLabel.dateComponent.date compare:selectedDateComponent.date] ==  NSOrderedSame) {
            [selectedLabel setSelectedLayout];
            [selectedLabel addSubview:selectedIndicatorView];
        }
        else{
            [selectedLabel setDefaultLayout];
            [selectedIndicatorView removeFromSuperview];
        }
    }
}
#pragma mark -
-(void) setSetectedDate:(NSDate *)date{
    [[CACalendarManager sharedInstance] setUserDisplayMonth:date];
    [self displayMonthCalendar];
    date = [[CACalendarManager sharedInstance] dateWithOutTime:date];
    for(CADateLabel *dateLabel in self.containerView.subviews){
        if ([dateLabel.dateComponent.date compare:date]== NSOrderedSame) {
            selectedDateComponent = dateLabel.dateComponent;
            selectedIndex = dateLabel.tag;
            [self addSelectedIndicatorView:dateLabel];
            [dateLabel setSelectedLayout];
            [self.containerView bringSubviewToFront:dateLabel];
        }
    }
}
#pragma mark -
// handle tap on date view(Date selection)
-(void) handleSelectionTapGesture:(UITapGestureRecognizer *)tapGesture{
    CADateLabel *label = (CADateLabel *)tapGesture.view;
    if (label.dateComponent.dateType == DisplayDateTypePast && self.isDisablePreviousDate == true) {
        return;
    }
    [self updateSelectedDateView:label];
}
-(void) updateSelectedDateView:(CADateLabel *)selectedLabel{
    if(selectedIndex != -1){
        CADateLabel *previousLabel = [self.containerView viewWithTag:selectedIndex];
        [previousLabel setDefaultLayout];
    }
    selectedDateComponent = selectedLabel.dateComponent;
    selectedIndex = selectedLabel.tag;
    [self addSelectedIndicatorView:selectedLabel];
    [selectedLabel setSelectedLayout];
    [self.containerView bringSubviewToFront:selectedLabel];
    //send delegate message
    [self sendSelectedDate:selectedLabel.dateComponent.date];
}
-(void) addSelectedIndicatorView:(CADateLabel *)selectedLabel{
    if (selectedIndicatorView == nil) {
        selectedIndicatorView = [[UIView alloc] init];
        selectedIndicatorView.backgroundColor = [UIColor blackColor];
    }
    selectedIndicatorView.frame = CGRectMake(0, selectedLabel.frame.size.height-10, selectedLabel.frame.size.width, 10);
    [selectedLabel addSubview:selectedIndicatorView];
}
#pragma mark - 
-(void) previousButtonAction:(UIButton*)sender{
    [[CACalendarManager sharedInstance] setDisplayMonth:DisplayMonthTypePrevious];
    [self displayMonthCalendar];
}
-(void) nextButtonAction:(UIButton*)sender{
    [[CACalendarManager sharedInstance] setDisplayMonth:DisplayMonthTypeNext];
    [self displayMonthCalendar];
}
#pragma mark - 
-(void) displayMonthCalendar{
    self.dataList = [[CACalendarManager sharedInstance] getDaysListForSelectedMonth];
    self.currentMonthLabel.text = [[CACalendarManager sharedInstance] getCurrentMonthText];
    [self addAllDayViews];
}
#pragma mark -
-(void) sendSelectedDate:(NSDate *)date{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectedDate:)]) {
        [self.delegate didSelectedDate:date];
    }
}
@end
