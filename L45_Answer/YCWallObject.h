//
//  YCWallObject.h
//  L45_Answer
//
//  Created by Yaroslav on 03/02/16.
//  Copyright © 2016 Yaroslav Chyzh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YCWallObject : NSObject

@property (strong, nonatomic) NSString *message;

@property (strong, nonatomic) NSString *fullName;

@property (strong, nonatomic) NSString *date;

@property (strong, nonatomic) NSString *fromId;

@property (strong, nonatomic) NSURL *attachmentImageURL;

@property (strong, nonatomic) NSURL *imageURL;

- (id)initWithServerResponse:(NSDictionary *)responseObjects;


@end
