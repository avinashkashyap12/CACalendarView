//
//  CADateLabel.m
//  SampleProjectPoc
//
//  Created by Avinash Kashyap on 07/09/17.
//  Copyright © 2017 Avinash Kashyap. All rights reserved.
//

#import "CADateLabel.h"

@implementation CADateLabel
@synthesize dateComponent = _dateComponent;

-(instancetype) init{
    self = [super init];
    if(self){
        [self defaultSetup];
    }
    return self;
}
-(instancetype) initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        [self defaultSetup];
    }
    return self;
}
-(instancetype) initWithFrame:(CGRect)frame withDateComponenet:(CADateComponent *)dateComponent{
    self = [super initWithFrame:frame];
    if(self){
        [self defaultSetup];
        self.dateComponent = dateComponent;
    }
    return self;
}
-(void) awakeFromNib{
    [self defaultSetup];
    [super awakeFromNib];
}
-(void) defaultSetup{
    self.userInteractionEnabled = YES;
    self.textAlignment = NSTextAlignmentCenter;
    self.backgroundColor = KDefaultColor;
    self.font = KDefaultFont;
}
-(void) setDateComponent:(CADateComponent *)dateComponent{
    _dateComponent = dateComponent;
    if (dateComponent.dateType == DisplayDateTypePast) {
        self.textColor = [UIColor lightGrayColor];
    }
    else{
        self.textColor = [UIColor blackColor];
    }
    self.text = [self getDayFormDate:dateComponent.date];
    //-------check and set curent date
    self.layer.borderWidth = dateComponent.dateType == DisplayDateTypeCurrent ? 1.0 : 0.0;
    self.font = dateComponent.dateType == DisplayDateTypeCurrent ? KSelectedFont : KDefaultFont;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(NSString *) getDayFormDate:(NSDate *)date{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd"];
    return [formatter stringFromDate:date];
}
#pragma mark - 
-(void) setDefaultLayout{
    self.backgroundColor = KDefaultColor;
    self.transform = CGAffineTransformIdentity;
    self.layer.shadowOffset = CGSizeZero;
    self.layer.shadowOpacity = 0.0;
    self.layer.shadowRadius = 0;
    
}
-(void) setSelectedLayout{
    self.backgroundColor = KSelectedColor;
    self.transform = CGAffineTransformMakeScale(1.05, 1.05);
    self.layer.shadowOffset = CGSizeZero;
    self.layer.shadowOpacity = 0.2;
    self.layer.shadowRadius = 2;
}
@end
