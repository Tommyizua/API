//
//  YCProfileTableViewController.m
//  L45_Answer
//
//  Created by Yaroslav on 02/02/16.
//  Copyright © 2016 Yaroslav Chyzh. All rights reserved.
//

#import "YCProfileTableViewController.h"

#import "YCServerManager.h"
#import "UIImageView+AFNetworking.h"
#import "YCFriendsListViewController.h"
#import "YCSubscriptionsTableViewController.h"

#import "YCInfoCellTableViewCell.h"
#import "YCCentralLabelTableViewCell.h"
#import "YCPostTableViewCell.h"
#import "YCPostWithImageTableViewCell.h"

#import "YCUser.h"
#import "YCWallObject.h"


@interface YCProfileTableViewController ()

@property (strong, nonatomic) YCUser *userProfile;

@property (assign, nonatomic) BOOL loadingCell;

@property (strong, nonatomic) NSMutableArray *postsArray;

@end

@implementation YCProfileTableViewController

static NSInteger countInRequest = 15;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.navigationItem.title = @"Profile";
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    self.loadingCell = YES;
    
    self.postsArray = [NSMutableArray array];
    
    if (self.userId) {
        
        [self getProfileInfoFromServerWithUserId:self.userId];
    }
    
    UIRefreshControl *refresh = [[UIRefreshControl alloc] init];
    
    [refresh addTarget:self action:@selector(refreshProfile) forControlEvents:UIControlEventValueChanged];
    
    self.refreshControl = refresh;
    
}

-(void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    if (!self.userId && !self.firstTimeAppear) {
        
        self.firstTimeAppear = YES;
        [[YCServerManager sharedManager] authorizeUser:^(YCUser *user) {
            
            self.userId = user.userId;
            self.userProfile = user;
            
            [self updateFirstRowAtTableViewInMainQueue];
            
            [self getWallromServerWithUserId:self.userId offset:self.postsArray.count];
            
        }];
    }
}

#pragma mark - API

- (void)refreshProfile {
    
    [[YCServerManager sharedManager]
     getProfileInfoWithUserId:self.userId
     onSuccess:^(YCUser *userProfile) {
         
         self.userProfile = userProfile;
         
         [self.postsArray removeAllObjects];
         
         [self getWallromServerWithUserId:self.userProfile.userId offset:self.postsArray.count];
         
         [self.refreshControl endRefreshing];
         
         [self.tableView reloadData];
         
         
     }
     onFailure:^(NSError *error, NSInteger statusCode) {
         
         NSLog(@"error: %@, code: %ld", [error localizedDescription], (long)statusCode);
         [self.refreshControl endRefreshing];
         
     }];
}

- (void)getProfileInfoFromServerWithUserId:(NSString *)userId {
    
    [[YCServerManager sharedManager]
     getProfileInfoWithUserId:userId
     onSuccess:^(YCUser *userProfile) {
         
         self.userProfile = userProfile;
         
         [self updateFirstRowAtTableViewInMainQueue];
         
         [self getWallromServerWithUserId:self.userId offset:self.postsArray.count];
         
     }
     onFailure:^(NSError *error, NSInteger statusCode) {
         
         NSLog(@"error: %@, code: %ld", [error localizedDescription], (long)statusCode);
     }];
}

- (void)getWallromServerWithUserId:(NSString *)userId offset:(NSInteger)offset {
    
    [[YCServerManager sharedManager]
     getWallWithUserId:userId
     offset:offset
     count:countInRequest
     onSuccess:^(NSArray *wallPosts) {
         
         [self.postsArray addObjectsFromArray:wallPosts];
         
         NSMutableArray *indexPathsArray = [NSMutableArray array];
         
         for (NSInteger i = self.postsArray.count - wallPosts.count; i < self.postsArray.count; i++) {
             
             [indexPathsArray addObject:[NSIndexPath indexPathForRow:i + 4 inSection:0]];
         }
         
         [self.tableView beginUpdates];
         
         [self.tableView insertRowsAtIndexPaths:indexPathsArray withRowAnimation:UITableViewRowAnimationBottom];
         
         [self.tableView endUpdates];
         
         self.loadingCell = NO;
         
     }
     onFailure:^(NSError *error, NSInteger statusCode) {
         
         NSLog(@"error: %@, code: %ld", [error localizedDescription], (long)statusCode);
     }];
    
}

#pragma mark - Help Methods

- (void)updateFirstRowAtTableViewInMainQueue {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        
        [self.tableView beginUpdates];
        
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        
        [self.tableView endUpdates];
        
    });
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.postsArray.count + 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        
        YCInfoCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InfoCell"];
        
        cell.fullNameLabel.text = [NSString stringWithFormat:@"%@ %@", self.userProfile.firstName, self.userProfile.lastName];
        
        cell.cityLabel.text = [NSString stringWithFormat:@"%@ %@", self.userProfile.city, self.userProfile.country];
        
        cell.birthdayLabel.text = self.userProfile.birthday;
        
        cell.onlineLabel.text = self.userProfile.onlineStatus;
        
        CALayer *imageLayer = cell.photoImageView.layer;
        [imageLayer setCornerRadius:20];
        [imageLayer setBorderWidth:1];
        [imageLayer setBorderColor:[[UIColor grayColor] CGColor]];
        [imageLayer setMasksToBounds:YES];
        
        NSURLRequest *request = [NSURLRequest requestWithURL:self.userProfile.imageURL];
        
        __weak YCInfoCellTableViewCell *weekCell = cell;
        
        [cell.imageView setImageWithURLRequest:request
                              placeholderImage:nil
                                       success:^(NSURLRequest * _Nonnull request,
                                                 NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
                                           
                                           weekCell.photoImageView.image = image;
                                           
                                       } failure:^(NSURLRequest * _Nonnull request,
                                                   NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
                                           
                                       }];
        return cell;
        
    } else if (indexPath.row == 1) {
        
        YCCentralLabelTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FriendsCell"];
        
        cell.centralLabel.text = @"Friends";
        
        return cell;
        
    } else if (indexPath.row == 2) {
        
        YCCentralLabelTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FollowersCell"];
        
        cell.centralLabel.text = @"Followers";
        
        return cell;
        
    } else if (indexPath.row == 3) {
        
        YCCentralLabelTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SubscriptionsCell"];
        
        cell.centralLabel.text = @"Subscriptions";
        
        return cell;
        
    } else {
        
        YCWallObject *wallObject = [self.postsArray objectAtIndex:indexPath.row-4];
        
        if (wallObject.attachmentImageURL) {
            
            YCPostWithImageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PostImageCell"];
            
            cell.messageLabel.text = wallObject.message;
            
            cell.fullNameLabel.text = wallObject.fullName;
            
            cell.dateLabel.text = wallObject.date;
            
            NSURLRequest *request = [NSURLRequest requestWithURL:wallObject.imageURL];
            
            cell.postImageView.image = [UIImage imageNamed:@"empty_image.png"];
            
            __weak YCPostWithImageTableViewCell *weekCell = cell;
            
            [cell.imageView setImageWithURLRequest:request
                                  placeholderImage:nil
                                           success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
                                               
                                               weekCell.postImageView.image = image;
                                               
                                           } failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
                                               
                                           }];
            
            
            NSURLRequest *requestAttachment = [NSURLRequest requestWithURL:wallObject.attachmentImageURL];
            
            [cell.imageView setImageWithURLRequest:requestAttachment
                                  placeholderImage:nil
                                           success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
                                               
                                               weekCell.attachmentImage.image = image;
                                               
                                           } failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
                                               
                                           }];
            
            return cell;
            
        } else {
            
            YCPostTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PostCell"];
            
            cell.messageLabel.text = wallObject.message;
            
            cell.fullNameLabel.text = wallObject.fullName;
            
            cell.dateLabel.text = wallObject.date;
            
            NSURLRequest *request = [NSURLRequest requestWithURL:wallObject.imageURL];
            
            cell.postImageView.image = [UIImage imageNamed:@"empty_image.png"];
            
            __weak YCPostTableViewCell *weekCell = cell;
            
            [cell.imageView setImageWithURLRequest:request
                                  placeholderImage:nil
                                           success:^(NSURLRequest * _Nonnull request,
                                                     NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
                                               
                                               weekCell.postImageView.image = image;
                                               
                                           } failure:^(NSURLRequest * _Nonnull request,
                                                       NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
                                               
                                           }];
            
            return cell;
            
        }
        
    }
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 1) {
        
        YCFriendsListViewController *vc = [self.storyboard
                                           instantiateViewControllerWithIdentifier:@"YCFriendsListViewController"];
        
        vc.userId = self.userProfile.userId;
        
        vc.listType = YCListTypeFriends;
        
        [self.navigationController pushViewController:vc animated:YES];
        
    } else if (indexPath.row == 2) {
        
        YCFriendsListViewController *vc = [self.storyboard
                                           instantiateViewControllerWithIdentifier:@"YCFriendsListViewController"];
        
        vc.userId = self.userProfile.userId;
        
        vc.listType = YCListTypeFollowers;
        
        vc.title = @"Followers";
        
        [self.navigationController pushViewController:vc animated:YES];
        
    } else if (indexPath.row == 3) {
        
        YCSubscriptionsTableViewController *vc = [self.storyboard
                                                  instantiateViewControllerWithIdentifier:@"YCSubscriptionsTableViewController"];
        
        vc.userId = self.userProfile.userId;
        
        vc.title = @"Subscriptions";
        
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        
        return 130.f;
        
    } else if (indexPath.row >= 1 && indexPath.row <= 3) {
        
        return 44.f;
        
    } else {
        
        YCWallObject *wallObject = [self.postsArray objectAtIndex:indexPath.row-4];
        
        if (wallObject.attachmentImageURL) {
            
            return [YCPostWithImageTableViewCell heightForText: wallObject.message];
            
        } else {
            
            return [YCPostTableViewCell heightForText: wallObject.message];
            
        }
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if ((scrollView.contentOffset.y + scrollView.frame.size.height) >= scrollView.contentSize.height) {
        
        if (!self.loadingCell) {
            
            [self getWallromServerWithUserId:self.userProfile.userId offset:self.postsArray.count];
            self.loadingCell = YES;
        }
    }
}

@end
