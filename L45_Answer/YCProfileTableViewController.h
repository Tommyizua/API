//
//  YCProfileTableViewController.h
//  L45_Answer
//
//  Created by Yaroslav on 02/02/16.
//  Copyright © 2016 Yaroslav Chyzh. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YCUser;

@interface YCProfileTableViewController : UITableViewController

@property (strong, nonatomic) NSString *userId;

@property (assign, nonatomic) BOOL firstTimeAppear;


@end
