//
//  YCUser.h
//  L45_Answer
//
//  Created by Yaroslav on 02/02/16.
//  Copyright © 2016 Yaroslav Chyzh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YCUser : NSObject

@property (strong, nonatomic) NSString *firstName;
@property (strong, nonatomic) NSString *lastName;
@property (strong, nonatomic) NSString *userId;

@property (strong, nonatomic) NSString *cityId;
@property (strong, nonatomic) NSString *city;
@property (strong, nonatomic) NSString *countryId;
@property (strong, nonatomic) NSString *country;

@property (strong, nonatomic) NSString *birthday;

@property (strong, nonatomic) NSString *onlineStatus;

@property (strong, nonatomic) NSString *universityName;

@property (strong, nonatomic) NSURL *imageURL;

- (id)initWithServerResponse:(NSDictionary *)responseObjects;

- (id)initWithProfileServerResponse:(NSDictionary *)responseObjects;

@end
