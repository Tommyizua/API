//
//  YCPostTableViewCell.m
//  L45_Answer
//
//  Created by Yaroslav on 04/02/16.
//  Copyright © 2016 Yaroslav Chyzh. All rights reserved.
//

#import "YCPostTableViewCell.h"

@implementation YCPostTableViewCell

+ (CGFloat)heightForText:(NSString *)text {
  
    if (text.length > 0) {
        
        CGFloat offset = 8.0;
        
        UIFont *font = [UIFont systemFontOfSize:15.0f];
        
        NSShadow *shadow = [[NSShadow alloc] init];
        shadow.shadowOffset = CGSizeMake(0, -1);
        shadow.shadowBlurRadius = 0.5f;
        
        NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
        paragraph.lineBreakMode = NSLineBreakByWordWrapping;
        paragraph.alignment = NSTextAlignmentLeft;
        
        NSDictionary *attributes =
        [NSDictionary dictionaryWithObjectsAndKeys:
         font,      NSFontAttributeName,
         shadow,    NSShadowAttributeName,
         paragraph, NSParagraphStyleAttributeName, nil];
        
        CGRect rect = [text boundingRectWithSize:CGSizeMake(320 - 2 * offset, CGFLOAT_MAX)
                                         options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                      attributes:attributes
                                         context:nil];
        
        return CGRectGetHeight(rect) + 80;
        
    } else {
        
        return 80.f;
    }
    
}

@end
