//
//  YCServerManager.m
//  L45_Answer
//
//  Created by Yaroslav on 02/02/16.
//  Copyright © 2016 Yaroslav Chyzh. All rights reserved.
//

#import "YCServerManager.h"
#import "AFNetworking.h"
#import "YCLoginViewController.h"
#import "YCUser.h"
#import "YCPage.h"
#import "YCWallObject.h"
#import "YCAccessToken.h"

@interface YCServerManager ()

@property (strong, nonatomic) AFHTTPSessionManager *sessionManager;

@property (strong, nonatomic) YCAccessToken *accessToken;

@end

@implementation YCServerManager

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        NSURL *url = [NSURL URLWithString:@"https://api.vk.com/method/"];
        
        self.sessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:url];
    }
    return self;
}


+ (YCServerManager *)sharedManager {
    
    static YCServerManager *manager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        manager = [[YCServerManager alloc] init];
    });
    
    return manager;
}


- (void)authorizeUser:(void(^)(YCUser *user))completion {
    
    YCLoginViewController *vc = [[YCLoginViewController alloc]initWithCompletionBlock:^(YCAccessToken *token) {
        
        self.accessToken = token;
        
        if (token) {
            
            [self getProfileInfoWithUserId:self.accessToken.userId
             
                                 onSuccess:^(YCUser *userProfile) {
                                     
                                     
                                     if (completion) {
                                         
                                         completion(userProfile);
                                     }
                                     
                                 }
                                 onFailure:^(NSError *error, NSInteger statusCode) {
                                     
                                     if (completion) {
                                         
                                         completion(nil);
                                     }
                                     
                                 }];
            
        } else if (completion) {
            
            completion(nil);
        }
        
    }];
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    
    UIViewController *mainVC = [[UIApplication sharedApplication].windows firstObject].rootViewController;
    
    [mainVC presentViewController:nav animated:YES completion:nil];
}

- (void)getProfileInfoWithUserId:(NSString *)userId
                       onSuccess:(void(^)(YCUser *userProfile))success
                       onFailure:(void(^)(NSError *error, NSInteger statusCode))failure {
    
    NSDictionary *params =
    [NSDictionary dictionaryWithObjectsAndKeys:
     userId,                                                                @"user_id",
     @"photo_medium, city, country, bdate, online",                         @"fields",
     @"nom",                                                                @"name_case",
     @"5.44",                                                               @"v", nil];
    
    [self.sessionManager GET:@"users.get"
                  parameters:params
                    progress:nil
                     success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary * _Nullable responseObject) {
                         
                         NSDictionary *responseDict = [[responseObject objectForKey:@"response"] firstObject];
                         
                         YCUser *userProfile = [[YCUser alloc] initWithProfileServerResponse:responseDict];
                         
                         
                         [self getCityNameWithCityId:userProfile.cityId
                                           onSuccess:^(NSString *cityName) {
                                              
                                               if (cityName) {
                                                   
                                                   userProfile.city = cityName;
                                                   
                                               } else {
                                                   
                                                   userProfile.city = @"";
                                               }
                                               
                                               [self getCountryNameWithCountryId:userProfile.countryId
                                                                       onSuccess:^(NSString *countryName) {
                                                                           
                                                                           if (countryName) {
                                                                               
                                                                               userProfile.country = countryName;
                                                                               
                                                                           } else {
                                                                               
                                                                               userProfile.country = @"";
                                                                           }
                                                                           
                                                                           if (success) {
                                                                               success(userProfile);
                                                                           }
                                                                           
                                                                       } onFailure:^(NSError *error, NSInteger statusCode) {
                                                                           
                                                                           NSLog(@"error: %@, code: %ld", [error localizedDescription], (long)statusCode);
                                                                       }];


                                           }
                                           onFailure:^(NSError *error, NSInteger statusCode) {
                                               
                                               NSLog(@"error: %@, code: %ld", [error localizedDescription], (long)statusCode);
                                           }];
                         
                         
                     }
                     failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                         
                         if (failure) {
                             
                             NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;
                             
                             failure(error, (long)httpResponse.statusCode);
                         }
                         
                     }];
    
}


- (void)getCityNameWithCityId:(NSString *)cityId
                    onSuccess:(void(^)(NSString *cityName))success
                    onFailure:(void(^)(NSError *error, NSInteger statusCode))failure {
    
    NSDictionary *params =
    [NSDictionary dictionaryWithObjectsAndKeys: cityId, @"city_ids", @"5.44", @"v", nil];
    
    [self.sessionManager GET:@"database.getCitiesById"
                  parameters:params
                    progress:nil
                     success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary * _Nullable responseObject) {
                         
                         NSDictionary *responseDict = [[responseObject objectForKey:@"response"] firstObject];
                         
                         NSString *cityName = [responseDict objectForKey:@"title"];
                         
                         if (success) {
                             success(cityName);
                         }
                         
                     }
                     failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                         
                         if (failure) {
                             
                             NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;
                             
                             failure(error, (long)httpResponse.statusCode);
                         }
                         
                     }];
    
}

- (void)getCountryNameWithCountryId:(NSString *)countryId
                          onSuccess:(void(^)(NSString *countryName))success
                          onFailure:(void(^)(NSError *error, NSInteger statusCode))failure {
    
    NSDictionary *params =
    [NSDictionary dictionaryWithObjectsAndKeys: countryId, @"country_ids", @"5.44", @"v", nil];
    
    [self.sessionManager GET:@"database.getCountriesById"
                  parameters:params
                    progress:nil
                     success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary * _Nullable responseObject) {
                         
                         NSDictionary *responseDict = [[responseObject objectForKey:@"response"] firstObject];
                         
                         NSString *countryName = [responseDict objectForKey:@"title"];
                         
                         if (success) {
                             success(countryName);
                         }
                         
                     }
                     failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                         
                         if (failure) {
                             
                             NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;
                             
                             failure(error, (long)httpResponse.statusCode);
                         }
                         
                     }];
    
}

- (void)getFriendsWithUserId:(NSString *)userId
                      offset:(NSInteger)offset
                       count:(NSInteger)count
                   onSuccess:(void(^)(NSArray *friends))success
                   onFailure:(void(^)(NSError *error, NSInteger statusCode))failure {
    
    NSDictionary *params =
    [NSDictionary dictionaryWithObjectsAndKeys:
     userId,                        @"user_id",
     @"name",                       @"order",
     @(count),                      @"count",
     @(offset),                     @"offset",
     @"photo, education",           @"fields",
     @"nom",                        @"name_case",
     @"5.44",                       @"v", nil];
    
    [self.sessionManager GET:@"friends.get"
                  parameters:params
                    progress:nil
                     success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary * _Nullable responseObject) {
                         
                         NSArray *dictArray = [[responseObject objectForKey:@"response"] objectForKey:@"items"];
                         
                         NSMutableArray *objectsArray = [NSMutableArray array];
                         
                         for (NSDictionary *dict in dictArray) {
                             
                             YCUser *user = [[YCUser alloc] initWithServerResponse:dict];
                             
                             [objectsArray addObject:user];
                         }
                         
                         if (success) {
                             success(objectsArray);
                         }
                         
                     }
                     failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                         
                         if (failure) {
                             
                             NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;
                             
                             failure(error, (long)httpResponse.statusCode);
                         }
                         
                     }];
    
}

- (void)getFollowersWithUserId:(NSString *)userId
                        offset:(NSInteger)offset
                         count:(NSInteger)count
                     onSuccess:(void(^)(NSArray *followers))success
                     onFailure:(void(^)(NSError *error, NSInteger statusCode))failure {
    
    NSDictionary *params =
    [NSDictionary dictionaryWithObjectsAndKeys:
     userId,                @"user_id",
     @"name",               @"order",
     @(count),              @"count",
     @(offset),             @"offset",
     @"photo, education",   @"fields",
     @"nom",                @"name_case",
     @"5.44",               @"v", nil];
    
    [self.sessionManager GET:@"users.getFollowers"
                  parameters:params
                    progress:nil
                     success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary * _Nullable responseObject) {
                         
                         NSArray *dictArray = [[responseObject objectForKey:@"response"] objectForKey:@"items"];
                         
                         NSMutableArray *objectsArray = [NSMutableArray array];
                         
                         for (NSDictionary *dict in dictArray) {
                             
                             YCUser *user = [[YCUser alloc] initWithServerResponse:dict];
                             
                             [objectsArray addObject:user];
                         }
                         
                         if (success) {
                             success(objectsArray);
                         }
                         
                     }
                     failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                         
                         if (failure) {
                             
                             NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;
                             
                             failure(error, (long)httpResponse.statusCode);
                         }
                         
                     }];
    
}

- (void)getSubscriptiosWithUserId:(NSString *)userId
                           offset:(NSInteger)offset
                            count:(NSInteger)count
                        onSuccess:(void(^)(NSArray *subscriptions))success
                        onFailure:(void(^)(NSError *error, NSInteger statusCode))failure {
    
    NSDictionary *params =
    [NSDictionary dictionaryWithObjectsAndKeys:
     userId,            @"user_id",
     @(count),          @"count",
     @(offset),         @"offset",
     @"1",              @"extended",
     @"photo",          @"fields",
     @"5.44",           @"v", nil];
    
    [self.sessionManager GET:@"users.getSubscriptions"
                  parameters:params
                    progress:nil
                     success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary * _Nullable responseObject) {
                         
                         NSArray *dictArray = [[responseObject objectForKey:@"response"] objectForKey:@"items"];
                         
                         NSMutableArray *objectsArray = [NSMutableArray array];
                         
                         for (NSDictionary *dict in dictArray) {
                             
                             YCPage *page = [[YCPage alloc] initWithServerResponse:dict];
                             
                             [objectsArray addObject:page];
                         }
                         
                         if (success) {
                             success(objectsArray);
                         }
                         
                     }
                     failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                         
                         if (failure) {
                             
                             NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;
                             
                             failure(error, (long)httpResponse.statusCode);
                         }
                         
                     }];
    
}

- (void)getWallWithUserId:(NSString *)userId
                   offset:(NSInteger)offset
                    count:(NSInteger)count
                onSuccess:(void(^)(NSArray *wallPosts))success
                onFailure:(void(^)(NSError *error, NSInteger statusCode))failure {
    
    
    NSDictionary *params =
    [NSDictionary dictionaryWithObjectsAndKeys:
     userId,                @"owner_id",
     @(offset),             @"offset",
     @(count),              @"count",
     @"all",                @"filter",
     @"5.44",               @"v", nil];
    
    
    [self.sessionManager GET:@"wall.get"
                  parameters:params
                    progress:nil
                     success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary * _Nullable responseObject) {
                         
                         NSArray *dictArray = [[responseObject objectForKey:@"response"] objectForKey:@"items"];
                         
                         NSMutableArray *objectsArray = [NSMutableArray array];
                         
                         for (NSDictionary *dict in dictArray) {
                             
                             YCWallObject *wallObject = [[YCWallObject alloc] initWithServerResponse:dict];
                             
                             
                             [self getShortProfileInfoWithUserId:wallObject.fromId
                                                  onSuccess:^(YCUser *userProfile) {
                                                      
                                                      wallObject.fullName = [NSString stringWithFormat:@"%@ %@",
                                                                             userProfile.firstName,
                                                                             userProfile.lastName];
                                                      
                                                      wallObject.imageURL = userProfile.imageURL;
                                                      
                                                  } onFailure:^(NSError *error, NSInteger statusCode) {
                                                      
                                                      NSLog(@"error: %@, code: %ld",
                                                            [error localizedDescription], (long)statusCode);
                                                  }];
                             
                             
                             [objectsArray addObject:wallObject];
                         }
                         
                         if (success) {
                             success(objectsArray);
                         }
                         
                     }
                     failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                         
                         if (failure) {
                             
                             NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;
                             
                             failure(error, (long)httpResponse.statusCode);
                         }
                         
                     }];
    
}

- (void)getShortProfileInfoWithUserId:(NSString *)userId
                       onSuccess:(void(^)(YCUser *userProfile))success
                       onFailure:(void(^)(NSError *error, NSInteger statusCode))failure {
    
    NSDictionary *params =
    [NSDictionary dictionaryWithObjectsAndKeys:
     userId,                @"user_id",
     @"photo",              @"fields",
     @"nom",                @"name_case",
     @"5.44",               @"v", nil];
    
    [self.sessionManager GET:@"users.get"
                  parameters:params
                    progress:nil
                     success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary * _Nullable responseObject) {
                         
                         NSDictionary *responseDict = [[responseObject objectForKey:@"response"] firstObject];
                         
                         YCUser *userProfile = [[YCUser alloc] initWithServerResponse:responseDict];
                        
                         if (success) {
                             success(userProfile);
                         }
                         
                     }
                     failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                         
                         if (failure) {
                             
                             NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;
                             
                             failure(error, (long)httpResponse.statusCode);
                         }
                         
                     }];
    
}


- (void)postText:(NSString *)text
         groupID:(NSString *)groupID
       onSuccess:(void(^)(id result))success
       onFailure:(void(^)(NSError *error, NSInteger statusCode))failure {
    
    /*
     
     if (![groupID hasPrefix:@""]) {
     
     groupID = [@"-" stringByAppendingString:groupID];
     }
     
     
     NSDictionary *params =
     [NSDictionary dictionaryWithObjectsAndKeys:
     groupID,                   @"owner_id",
     text,                      @"message",
     self.accessToken.token,    @"access_token",
     @"5.44",                   @"v", nil];
     
     
     [self.sessionManager POST:@"wall.post"
     parameters:params
     constructingBodyWithBlock:nil
     progress:nil
     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
     
     NSLog(@"JSON: %@", responseObject);
     
     NSArray *dictArray = [[responseObject objectForKey:@"response"] objectForKey:@"items"];
     
     NSMutableArray *objectsArray = [NSMutableArray array];
     
     for (NSDictionary *dict in dictArray) {
     
     YCPost *post = [[YCPost alloc] initWithServerResponse:dict];
     
     [objectsArray addObject:post];
     }
     
     if (success) {
     success(objectsArray);
     }
     
     }
     failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
     
     NSLog(@"Error: %@", error);
     
     if (failure) {
     
     NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;
     
     failure(error, (long)httpResponse.statusCode);
     }
     
     
     }];
     
     */
    
}


@end
