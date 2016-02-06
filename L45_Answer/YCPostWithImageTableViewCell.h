//
//  YCPostWithImageTableViewCell.h
//  L45_Answer
//
//  Created by Yaroslav on 05/02/16.
//  Copyright © 2016 Yaroslav Chyzh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YCPostWithImageTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *postImageView;

@property (weak, nonatomic) IBOutlet UILabel *fullNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *messageLabel;

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@property (weak, nonatomic) IBOutlet UIImageView *attachmentImage;

+ (CGFloat)heightForText:(NSString *)text;

@end
