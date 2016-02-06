//
//  ViewController.h
//  L45_Answer
//
//  Created by Yaroslav on 02/02/16.
//  Copyright © 2016 Yaroslav Chyzh. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    YCListTypeFriends,
    YCListTypeFollowers
}YCListType;

@class YCUser;

@interface YCFriendsListViewController : UITableViewController

@property (strong, nonatomic) NSString *userId;

@property (assign, nonatomic) YCListType listType;

@end

