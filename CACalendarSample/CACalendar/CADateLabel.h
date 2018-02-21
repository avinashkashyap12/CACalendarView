//
//  CADateLabel.h
//  SampleProjectPoc
//
//  Created by Avinash Kashyap on 07/09/17.
//  Copyright © 2017 Avinash Kashyap. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CACalendarManager.h"
#define KDefaultColor [UIColor colorWithRed:(CGFloat)234/255 green:(CGFloat)237/255 blue:(CGFloat)244/255 alpha:1]
#define KSelectedColor [UIColor whiteColor]
#define KDefaultFont [UIFont fontWithName:@"Roboto-Light" size:15]
#define KSelectedFont [UIFont fontWithName:@"Roboto-Medium" size:15]

@interface CADateLabel : UILabel

@property (nonatomic, strong) CADateComponent *dateComponent;
-(instancetype) initWithFrame:(CGRect)frame withDateComponenet:(CADateComponent *)dateComponent;
-(void) setDefaultLayout;
-(void) setSelectedLayout;
@end
