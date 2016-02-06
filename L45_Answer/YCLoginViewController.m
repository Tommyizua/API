//
//  YCLoginViewController.m
//  L45
//
//  Created by Yaroslav on 03/02/16.
//  Copyright © 2016 Yaroslav Chyzh. All rights reserved.
//

#import "YCLoginViewController.h"
#import "YCAccessToken.h"

@interface YCLoginViewController () <UIWebViewDelegate>

@property (copy, nonatomic) YCLoginCompletionBlock completionBlock;

@property (weak, nonatomic) UIWebView *webView;

@end

@implementation YCLoginViewController


- (id)initWithCompletionBlock:(YCLoginCompletionBlock)completionBlock {
    
    self = [super init];
    if (self) {
        
        self.completionBlock = completionBlock;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGRect rect = self.view.bounds;
    rect.origin = CGPointZero;
    
    UIWebView *webView = [[UIWebView alloc] initWithFrame:rect];
    
    webView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    webView.delegate = self;
    
    [self.view addSubview:webView];
    
    self.webView = webView;
    
    UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc]
                                   initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                   target:self
                                   action:@selector(actionCancel:)];
    
    
    self.navigationItem.rightBarButtonItem = cancelItem;
    
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    
    self.navigationItem.title = @"Login";
    
    NSString *urlString = @"https://oauth.vk.com/authorize?"
    "client_id=5269874&"
    "scope=9218&"
    "redirect_uri=https://oauth.vk.com/blank.html&"
    "display=touch&"
    "v=5.44&"
    "response_type=token";
    
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    [webView loadRequest:request];
    
}

- (void)dealloc {
    
    self.webView.delegate = nil;
}

#pragma mark - Actions

- (void)actionCancel:(UIBarButtonItem *)sender {
    
    if (self.completionBlock) {
        self.completionBlock(nil);
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

#pragma mark - UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    if ([[[request URL] description] rangeOfString:@"access_token="].location != NSNotFound) {
        
        YCAccessToken *token = [[YCAccessToken alloc] init];
        
        NSString *query = [[request URL] description];
        
        NSArray *array = [query componentsSeparatedByString:@"#"];
        
        if (array.count > 1) {
            
            query = [array lastObject];
        }
        
        NSArray *pairs = [query componentsSeparatedByString:@"&"];
        
        for (NSString *pair in pairs) {
            
            NSArray *values = [pair componentsSeparatedByString:@"="];
            
            if (values.count == 2) {
                
                NSString *key = [values firstObject];
                
                if ([key isEqualToString:@"access_token"]) {
                    
                    token.token = [values lastObject];
                    
                } else if ([key isEqualToString:@"expires_in"]) {
                    
                    NSTimeInterval interval = [[values lastObject] doubleValue];
                    
                    token.expirationDate = [NSDate dateWithTimeIntervalSinceNow:interval];
                    
                } else if ([key isEqualToString:@"user_id"]) {
                    
                    token.userId = [values lastObject];
                }
            }
        }
        
        self.webView.delegate = nil;
        
        if (self.completionBlock) {
            self.completionBlock(token);
        }
        
        [self dismissViewControllerAnimated:YES completion:nil];
        
        return NO;
        
    }
    
    return YES;
}

@end
