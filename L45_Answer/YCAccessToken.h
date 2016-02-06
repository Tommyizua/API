//
//  YCAccessToken.h
//  L45
//
//  Created by Yaroslav on 03/02/16.
//  Copyright © 2016 Yaroslav Chyzh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YCAccessToken : NSObject

@property (strong, nonatomic) NSString *token;
@property (strong, nonatomic) NSDate *expirationDate;
@property (strong, nonatomic) NSString *userId;


@end
