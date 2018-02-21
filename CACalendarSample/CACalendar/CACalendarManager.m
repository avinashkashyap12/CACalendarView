//
//  CACalendarManager.m
//  SampleProjectPoc
//
//  Created by Avinash Kashyap on 06/09/17.
//  Copyright © 2017 Avinash Kashyap. All rights reserved.
//

#import "CACalendarManager.h"
static CACalendarManager *sharedInstance;

@implementation CACalendarManager

+(CACalendarManager *)sharedInstance{
    @synchronized (self) {
        if (!sharedInstance) {
            sharedInstance = [[CACalendarManager alloc] init];
            [sharedInstance setupDefault];
        }
    }
    return sharedInstance;
}
-(void) setupDefault{
    self.calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    [self.calendar setLocale:[NSLocale currentLocale]];
    //[self.calendar setTimeZone:[NSTimeZone ]]
    self.dateFormatter = [[NSDateFormatter alloc] init];
    //[dateFormatter setDateFormat:@"yyyy-mm-dd"];
    self.monthShowing = [NSDate date];
    [self.dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    self.dateFormatter.dateFormat = @"dd LLLL yyyy";
}
-(void) setupShowingMonth:(NSDate *)date{
    self.monthShowing = date;
}
#pragma mark -
//return number of days in a week in
//[S, M, T, W, T, F, S]
- (NSArray *)updateDayOfWeekLabels {
    NSArray *weekdays = [self.dateFormatter veryShortWeekdaySymbols];
    // adjust array depending on which weekday should be first
    NSUInteger firstWeekdayIndex = [self.calendar firstWeekday] - 1;
    if (firstWeekdayIndex > 0) {
        weekdays = [[weekdays subarrayWithRange:NSMakeRange(firstWeekdayIndex, 7 - firstWeekdayIndex)]
                    arrayByAddingObjectsFromArray:[weekdays subarrayWithRange:NSMakeRange(0, firstWeekdayIndex)]];
    }
    
//    NSUInteger i = 0;
//    for (NSString *day in weekdays) {
//        NSLog(@"dat = %@", day);
//        i++;
//    }
    return weekdays;
}
#pragma mark -
- (NSDate *) dateAtStartOfMonth
{
    NSDateComponents *comp = [self.calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:[NSDate date]];
    [comp setDay:1];
    return [self.calendar dateFromComponents:comp];
}
-(NSDate *) lastDateofMonth{
    NSDateComponents *comp = [self.calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:[NSDate date]];
    [comp setDay:0];
    [comp setMonth:[comp month]+1];
    return [self.calendar dateFromComponents:comp];
}
- (NSDate *) nextDay:(NSDate *)date {
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setDay:1];
    return [self.calendar dateByAddingComponents:comps toDate:date options:0];
}

- (NSDate *) previousDay:(NSDate *)date {
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setDay:-1];
    return [self.calendar dateByAddingComponents:comps toDate:date options:0];
}


#pragma mark -
-(void) setDisplayMonth:(DisplayMonthType)type{
    switch (type) {
        case 1:{
            NSDate *nextMonthStartDay = [self firstDayOfNextMonthContainingDate:self.monthShowing];
            self.monthShowing = nextMonthStartDay;
        }
            break;
        case 2:{
            NSDate *previousMonthStartDay = [self firstDayOfPreviousMonthContainingDate:self.monthShowing];
            self.monthShowing = previousMonthStartDay;
            break;
        }
        default:
            self.monthShowing = [NSDate date];
            break;
    }
}
-(void) setUserDisplayMonth:(NSDate *)date{
    self.monthShowing = date;
}
//return all date for current month
-(NSArray *)getDaysListForSelectedMonth{
    return [self getCalendarMonthDaysForDate:self.monthShowing];
}
-(NSArray *) getCalendarMonthDaysForDate:(NSDate *)resultantMonth{
    NSDate *firstDay = [self firstDayOfMonthContainingDate:resultantMonth];
    //get previous date
    while ([self placeInWeekForDate:firstDay] != 0) {
        firstDay = [self previousDay:firstDay];
        // NSLog(@"date---- = %@", date);
    }
    //get last day of month
    NSDate *lastDay = [self lastDayOfTheMonthContainingDate:resultantMonth];
    while ([self placeInWeekForDate:lastDay] != 0) {
        lastDay = [self nextDay:lastDay];
        NSLog(@"date---- = %@", lastDay);
    }
    //--
    NSTimeInterval secondsBetween = [lastDay timeIntervalSinceDate:firstDay];
    int numberOfDays = secondsBetween / 86400;
    NSLog(@"number of days = %zd", numberOfDays);
    //---------
    NSDate *tempDate = firstDay;
    NSMutableArray *dateList = [NSMutableArray arrayWithCapacity:numberOfDays];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd"];
    for (int i = 0; i<numberOfDays; i++) {
        CADateComponent *dateComponent = [[CADateComponent alloc] init];
        dateComponent.date = tempDate;
        dateComponent.dateType = [self date:tempDate compareWithDate:[NSDate date]];
        //NSLog(@"Count = %d ----- And Date=%@" , i, [self.dateFormatter stringFromDate:tempDate]);
        //[dateList addObject:[formatter stringFromDate:tempDate]];
        [dateList addObject:dateComponent];
        //[tempArray addObject:tempDate];
        tempDate = [self nextDay:tempDate];
    }
    return dateList;
}
#pragma mark -
- (NSDate *)firstDayOfMonthContainingDate:(NSDate *)date {
    NSDateComponents *comps = [self.calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    comps.day = 1;
    return [self.calendar dateFromComponents:comps];
}
- (NSDate *)firstDayOfNextMonthContainingDate:(NSDate *)date {
    NSDateComponents *comps = [self.calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    comps.day = 1;
    comps.month = comps.month + 1;
    return [self.calendar dateFromComponents:comps];
}
-(NSDate *) firstDayOfPreviousMonthContainingDate:(NSDate *)date{
    NSDateComponents *comps = [self.calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    comps.day = 1;
    comps.month = comps.month - 1;
    return [self.calendar dateFromComponents:comps];
}
-(NSDate *) lastDayOfTheMonthContainingDate:(NSDate *)date{
    NSDateComponents* comps = [self.calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitWeekday fromDate:date]; // Get necessary date components
    // set last of month
    [comps setMonth:[comps month]+1];
    [comps setDay:0];
    return [self.calendar dateFromComponents:comps];
}
-(NSDate *) getLastDayOfTheMonthContainingDate:(NSDate *)date{
    NSDateComponents* comps = [self.calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitWeekday fromDate:date]; // Get necessary date components
    
    // set last of month
    [comps setMonth:[comps month]+1];
    [comps setDay:0];
    //NSDate *tDateMonth = [self.calendar dateFromComponents:comps];
    return [self.calendar dateFromComponents:comps];
}
- (NSInteger)placeInWeekForDate:(NSDate *)date {
    NSDateComponents *compsFirstDayInMonth = [self.calendar components:NSCalendarUnitWeekday fromDate:date];
    NSLog(@"place - %zd", (compsFirstDayInMonth.weekday - 1 - self.calendar.firstWeekday + 8) % 7);
    return (compsFirstDayInMonth.weekday - 1 - self.calendar.firstWeekday + 8) % 7;
}
#pragma mark -
-(NSString *) getCurrentMonthText{
    return [self getMonthTextForDate:self.monthShowing];
}
-(NSString *) getMonthTextForDate:(NSDate *)date{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"LLLL yyyy"];
    return [formatter stringFromDate:date];
}
#pragma mark - Date comparision
-(DisplayDateType) date:(NSDate *)date1 compareWithDate:(NSDate *)date2{
    NSComparisonResult result;
    DisplayDateType type;
    result = [[self dateWithOutTime:date1] compare:[self dateWithOutTime:date2]]; // comparing two dates
    if(result == NSOrderedSame){
        NSLog(@"Both dates are same");
        type = DisplayDateTypeCurrent;
    }
    else if(result == NSOrderedDescending){
        NSLog(@"newDate is less");
        type = DisplayDateTypeFuture;
    }
    else {
        NSLog(@"today is less");
        type = DisplayDateTypePast;
    };
    return type;
}
-(NSDate *)dateWithOutTime:(NSDate *)datDate {
    if( datDate == nil ) {
        datDate = [NSDate date];
    }
    NSDateComponents* comps = [[NSCalendar currentCalendar] components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:datDate];
    return [[NSCalendar currentCalendar] dateFromComponents:comps];
}
@end
@implementation CADateComponent



@end
