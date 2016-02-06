//
//  ViewController.m
//  L45_Answer
//
//  Created by Yaroslav on 02/02/16.
//  Copyright © 2016 Yaroslav Chyzh. All rights reserved.
//

#import "YCFriendsListViewController.h"
#import "YCServerManager.h"
#import "UIImageView+AFNetworking.h"
#import "YCUser.h"
#import "YCProfileTableViewController.h"

@interface YCFriendsListViewController ()

@property (strong, nonatomic) NSMutableArray *usersArray;

@property (assign, nonatomic) BOOL loadingCell;

@end

@implementation YCFriendsListViewController


static NSInteger countInRequest = 15;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.usersArray = [NSMutableArray array];

    self.loadingCell = YES;
    
    if (self.listType == YCListTypeFriends) {
        
        [self getFriendsromServerWithUserId:self.userId offset:self.usersArray.count];
        
    } else if (self.listType == YCListTypeFollowers) {
        
        [self getFollowersFromServerWithUserId:self.userId offset:self.usersArray.count];
    }
    
}

#pragma mark - API

- (void)getFriendsromServerWithUserId:(NSString *)userId offset:(NSInteger)offset {
    
    [[YCServerManager sharedManager]
     getFriendsWithUserId:userId
     offset:offset
     count:countInRequest
     onSuccess:^(NSArray *friends) {
         
         [self.usersArray addObjectsFromArray:friends];
         
         NSMutableArray *indexPathsArray = [NSMutableArray array];
         
         for (NSInteger i = self.usersArray.count - friends.count; i < self.usersArray.count; i++) {
             
             [indexPathsArray addObject:[NSIndexPath indexPathForRow:i inSection:0]];
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

- (void)getFollowersFromServerWithUserId:(NSString *)userId offset:(NSInteger)offset {
    
    [[YCServerManager sharedManager]
     getFollowersWithUserId:userId
     offset:offset
     count:countInRequest
     onSuccess:^(NSArray *followers) {
         
         [self.usersArray addObjectsFromArray:followers];
         
         NSMutableArray *indexPathsArray = [NSMutableArray array];
         
         for (NSInteger i = self.usersArray.count - followers.count; i < self.usersArray.count; i++) {
             
             [indexPathsArray addObject:[NSIndexPath indexPathForRow:i inSection:0]];
         }
         
         [self.tableView beginUpdates];
         
         [self.tableView insertRowsAtIndexPaths:indexPathsArray withRowAnimation:UITableViewRowAnimationBottom];
         
         [self.tableView endUpdates];
         
     }
     onFailure:^(NSError *error, NSInteger statusCode) {
         
         NSLog(@"error: %@, code: %ld", [error localizedDescription], (long)statusCode);
     }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.usersArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    YCUser *user = [self.usersArray objectAtIndex:indexPath.row];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", user.firstName, user.lastName];
    
    cell.detailTextLabel.text = user.universityName;
    
    cell.imageView.image = nil;
    
    NSURLRequest *request = [NSURLRequest requestWithURL:user.imageURL];
    
    __weak UITableViewCell *weekCell = cell;
    
    UIImage *placeholderImage = [UIImage imageNamed:@"empty_image.png"];
    
    [cell.imageView setImageWithURLRequest:request
                          placeholderImage:placeholderImage
                                   success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
                                       
                                       weekCell.imageView.image = image;
                                       [weekCell layoutSubviews];
                                       
                                   } failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
                                       
                                   }];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    YCUser *user = [self.usersArray objectAtIndex:indexPath.row];
    
    YCProfileTableViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"YCProfileTableViewController"];
    
    vc.userId = user.userId;
    vc.firstTimeAppear = YES;
    
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if ((scrollView.contentOffset.y + scrollView.frame.size.height) >= scrollView.contentSize.height) {
    
        if (!self.loadingCell) {
            
            if (self.listType == YCListTypeFriends) {
                
                [self getFriendsromServerWithUserId:self.userId offset:self.usersArray.count];
                
            } else {
                
                [self getFollowersFromServerWithUserId:self.userId offset:self.usersArray.count];
            }

            self.loadingCell = YES;
        }
    }
}

@end
