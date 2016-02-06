//
//  YCInfoCellTableViewCell.h
//  L45_Answer
//
//  Created by Yaroslav on 02/02/16.
//  Copyright © 2016 Yaroslav Chyzh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YCInfoCellTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;

@property (weak, nonatomic) IBOutlet UILabel *onlineLabel;

@property (weak, nonatomic) IBOutlet UILabel *fullNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *birthdayLabel;

@property (weak, nonatomic) IBOutlet UILabel *cityLabel;

@end
