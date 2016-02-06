//
//  YCUser.m
//  L45_Answer
//
//  Created by Yaroslav on 02/02/16.
//  Copyright © 2016 Yaroslav Chyzh. All rights reserved.
//

#import "YCUser.h"

@implementation YCUser


- (id)initWithServerResponse:(NSDictionary *)responseObjects {
    
    self = [super init];
    if (self) {
        
        self.firstName = [responseObjects objectForKey:@"first_name"];
        self.lastName = [responseObjects objectForKey:@"last_name"];
        
        self.universityName = [responseObjects objectForKey:@"university_name"];
        
        self.userId = [responseObjects objectForKey:@"id"];
        
        NSString *urlString = [responseObjects objectForKey:@"photo"];
        
        if (urlString) {
            
            self.imageURL = [NSURL URLWithString:urlString];
            
        }
    }
    
    return self;
}

- (id)initWithProfileServerResponse:(NSDictionary *)responseObjects {
    
    self = [super init];
    if (self) {
        
        self.firstName = [responseObjects objectForKey:@"first_name"];
        self.lastName = [responseObjects objectForKey:@"last_name"];
        
        self.userId = [responseObjects objectForKey:@"id"];
        self.cityId = [responseObjects objectForKey:@"city"];
        self.countryId = [responseObjects objectForKey:@"country"];
        
        self.birthday  = [responseObjects objectForKey:@"bdate"];
        
        BOOL isOnline = [[responseObjects objectForKey:@"online"] boolValue];
        
        self.onlineStatus = isOnline ? @"Online" : @"Offline";
        
        
        NSString *urlString = [responseObjects objectForKey:@"photo_medium"];
        
        if (urlString) {
            
            self.imageURL = [NSURL URLWithString:urlString];
        }
    }
    
    return self;
}


@end
