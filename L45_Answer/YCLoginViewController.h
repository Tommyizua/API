//
//  YCLoginViewController.h
//  L45
//
//  Created by Yaroslav on 03/02/16.
//  Copyright © 2016 Yaroslav Chyzh. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YCAccessToken;

typedef void(^YCLoginCompletionBlock)(YCAccessToken *token);

@interface YCLoginViewController : UIViewController

- (id)initWithCompletionBlock:(YCLoginCompletionBlock)completionBlock;

@end
