//
//  YCPage.m
//  L45_Answer
//
//  Created by Yaroslav on 02/02/16.
//  Copyright © 2016 Yaroslav Chyzh. All rights reserved.
//

#import "YCPage.h"

@implementation YCPage

- (id)initWithServerResponse:(NSDictionary *)responseObjects {
    
    self = [super init];
    if (self) {
        
        self.pageType = [responseObjects objectForKey:@"type"];

        if ([self.pageType isEqualToString:@"page"]) {
        
            self.name = [responseObjects objectForKey:@"name"];
            
            NSString *urlString = [responseObjects objectForKey:@"photo_50"];
            
            if (urlString) {
                
                self.imageURL = [NSURL URLWithString:urlString];
            }
            
        } else if ([self.pageType isEqualToString:@"profile"]) {
            
            NSString *firstName = [responseObjects objectForKey:@"first_name"];
          
            NSString *lastName = [responseObjects objectForKey:@"last_name"];
            
            self.name = [NSString stringWithFormat:@"%@ %@", firstName, lastName];
            
            NSString *urlString = [responseObjects objectForKey:@"photo"];
            
            if (urlString) {
                
                self.imageURL = [NSURL URLWithString:urlString];
            }
        }


    }
    return self;
}

@end
