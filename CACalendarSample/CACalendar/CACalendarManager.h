//
//  CACalendarManager.h
//  SampleProjectPoc
//
//  Created by Avinash Kashyap on 06/09/17.
//  Copyright © 2017 Avinash Kashyap. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, DisplayMonthType){
    DisplayMonthTypeCurrent = 0,
    DisplayMonthTypeNext,
    DisplayMonthTypePrevious
};

typedef NS_ENUM(NSInteger, DisplayDateType) {
    DisplayDateTypeCurrent = 0,
    DisplayDateTypePast,
    DisplayDateTypeFuture,
    DisplayDateTypeLastMonthDay,
    DisplayDateTypeNextMonthDay
};

@interface CACalendarManager : NSObject
@property (nonatomic, strong) NSCalendar *calendar;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@property (nonatomic, strong) NSDate* monthShowing;
//------
+(CACalendarManager *)sharedInstance;
- (NSArray *)updateDayOfWeekLabels;
-(NSArray *)getDaysListForSelectedMonth;
-(NSArray *) getCalendarMonthDaysForDate:(NSDate *)resultantMonth;
-(void) setUserDisplayMonth:(NSDate *)date;
-(void) setDisplayMonth:(DisplayMonthType)type;
-(NSString *) getCurrentMonthText;
-(NSString *) getMonthTextForDate:(NSDate *)date;
-(NSDate *)dateWithOutTime:(NSDate *)datDate;
@end
//---
@interface CADateComponent : NSObject{
    
}
@property (nonatomic, strong) NSDate *date;
@property (nonatomic, assign) DisplayDateType dateType;

@end
