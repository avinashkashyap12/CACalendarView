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


@interface CACalendarView : UIView<UICollectionViewDelegate, UICollectionViewDataSource>
{
    NSIndexPath *selectedIndexPath;
    NSInteger selectedIndex;
    CADateComponent *selectedDateComponent;
    UIView *selectedIndicatorView;
}
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UIButton *previousButton;
@property (nonatomic, strong) UIButton *nextButton;
@property (nonatomic, strong) UILabel *currentMonthLabel;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *dataList;
@property (nonatomic, weak) id <CACalendarDelegate> delegate;
-(void) setSetectedDate:(NSDate *)date;
@end
@protocol CACalendarDelegate <NSObject>

-(void) didSelectedDate:(NSDate *)date;

@end
