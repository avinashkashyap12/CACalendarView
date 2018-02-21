//
//  CACalendarCollectionViewCell.h
//  SampleProjectPoc
//
//  Created by Avinash Kashyap on 07/09/17.
//  Copyright © 2017 Avinash Kashyap. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CADateLabel.h"

@interface CACalendarCollectionViewCell : UICollectionViewCell
@property (nonatomic, weak) IBOutlet  CADateLabel *dateLabel;
@end
