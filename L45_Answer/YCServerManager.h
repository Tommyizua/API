//
//  YCServerManager.h
//  L45_Answer
//
//  Created by Yaroslav on 02/02/16.
//  Copyright © 2016 Yaroslav Chyzh. All rights reserved.
//

#import <Foundation/Foundation.h>

@class YCUser;

@interface YCServerManager : NSObject


+ (YCServerManager *)sharedManager;


- (void)authorizeUser:(void(^)(YCUser *user))completion;



- (void)getFriendsWithUserId:(NSString *)userId
                          offset:(NSInteger)offset
                           count:(NSInteger)count
                       onSuccess:(void(^)(NSArray *friends))success
                       onFailure:(void(^)(NSError *error, NSInteger statusCode))failure;

- (void)getProfileInfoWithUserId:(NSString *)userId
                       onSuccess:(void(^)(YCUser *userProfile))success
                       onFailure:(void(^)(NSError *error, NSInteger statusCode))failure;

- (void)getFollowersWithUserId:(NSString *)userId
                        offset:(NSInteger)offset
                         count:(NSInteger)count
                     onSuccess:(void(^)(NSArray *followers))success
                     onFailure:(void(^)(NSError *error, NSInteger statusCode))failure;


- (void)getSubscriptiosWithUserId:(NSString *)userId
                      offset:(NSInteger)offset
                       count:(NSInteger)count
                   onSuccess:(void(^)(NSArray *subscriptions))success
                   onFailure:(void(^)(NSError *error, NSInteger statusCode))failure;


- (void)getCityNameWithCityId:(NSString *)cityId
                    onSuccess:(void(^)(NSString *cityName))success
                    onFailure:(void(^)(NSError *error, NSInteger statusCode))failure;

- (void)getCountryNameWithCountryId:(NSString *)countryId
                    onSuccess:(void(^)(NSString *countryName))success
                    onFailure:(void(^)(NSError *error, NSInteger statusCode))failure;


- (void)getWallWithUserId:(NSString *)userId
                      offset:(NSInteger)offset
                       count:(NSInteger)count
                   onSuccess:(void(^)(NSArray *wallPosts))success
                   onFailure:(void(^)(NSError *error, NSInteger statusCode))failure;

- (void)postText:(NSString *)text
         groupID:(NSString *)groupID
       onSuccess:(void(^)(id result))success
       onFailure:(void(^)(NSError *error, NSInteger statusCode))failure;


@end
