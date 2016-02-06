//
//  YCWallObject.m
//  L45_Answer
//
//  Created by Yaroslav on 03/02/16.
//  Copyright © 2016 Yaroslav Chyzh. All rights reserved.
//

#import "YCWallObject.h"

@implementation YCWallObject

- (id)initWithServerResponse:(NSDictionary *)responseObjects {
    
    self = [super init];
    if (self) {
        
        self.message = [responseObjects objectForKey:@"text"];
        
        NSDate *postDate = [NSDate dateWithTimeIntervalSince1970:[[responseObjects objectForKey:@"date"] doubleValue]];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"dd MMM yyyy"];

        self.date = [dateFormatter stringFromDate: postDate];
        
        
        self.fromId = [responseObjects objectForKey:@"from_id"];
        
        
        NSString *urlString = [[[[responseObjects objectForKey:@"attachments"] firstObject]
                                objectForKey:@"photo"] objectForKey:@"photo_75"];
        
        if (urlString) {
            
            self.attachmentImageURL = [NSURL URLWithString:urlString];
        }

    }
    
    return self;
}

@end
