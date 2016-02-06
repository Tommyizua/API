//
//  YCFollowersTableViewCell.m
//  L45_Answer
//
//  Created by Yaroslav on 02/02/16.
//  Copyright © 2016 Yaroslav Chyzh. All rights reserved.
//

#import "YCSubscriptionsTableViewController.h"
#import "YCServerManager.h"
#import "UIImageView+AFNetworking.h"
#import "YCPage.h"


@interface YCSubscriptionsTableViewController ()

@property (strong, nonatomic) NSMutableArray *pagesArray;

@property (assign, nonatomic) BOOL loadingCell;

@end

@implementation YCSubscriptionsTableViewController


static NSInteger countInRequest = 15;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.loadingCell = YES;
    
    self.pagesArray = [NSMutableArray array];
    
    [self getSubscriptiosWithUserId:self.userId offset:self.pagesArray.count];
}

#pragma mark - API

- (void)getSubscriptiosWithUserId:(NSString *)userId offset:(NSInteger)offset {
    
    [[YCServerManager sharedManager]
     getSubscriptiosWithUserId:userId
     offset:offset
     count:countInRequest
     onSuccess:^(NSArray *subscriptions) {
         
         [self.pagesArray addObjectsFromArray:subscriptions];
         
         NSMutableArray *indexPathsArray = [NSMutableArray array];
         
         for (NSInteger i = self.pagesArray.count - subscriptions.count; i < self.pagesArray.count; i++) {
             
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

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.pagesArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    YCPage *page = [self.pagesArray objectAtIndex:indexPath.row];
    
    cell.textLabel.text = page.name;
    
    cell.detailTextLabel.text = page.pageType;
    
    cell.imageView.image = nil;
    
    NSURLRequest *request = [NSURLRequest requestWithURL:page.imageURL];
    
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
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if ((scrollView.contentOffset.y + scrollView.frame.size.height) >= scrollView.contentSize.height) {
        
        if (!self.loadingCell) {
            
                [self getSubscriptiosWithUserId:self.userId offset:self.pagesArray.count];
            
            self.loadingCell = YES;
        }
    }
}



@end
