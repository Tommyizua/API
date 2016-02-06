//
//  YCPage.h
//  L45_Answer
//
//  Created by Yaroslav on 02/02/16.
//  Copyright © 2016 Yaroslav Chyzh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YCPage : NSObject

@property (strong, nonatomic) NSString *pageType;

@property (strong, nonatomic) NSString *name;

@property (strong, nonatomic) NSURL *imageURL;



- (id)initWithServerResponse:(NSDictionary *)responseObjects;

@end
