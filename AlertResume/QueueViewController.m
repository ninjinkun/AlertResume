//
//  ViewController.m
//  AlertResume
//
//  Created by Asano Satoshi on 1/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "QueueViewController.h"
#import <Accounts/Accounts.h>
#import <Twitter/Twitter.h>
#import "UIAlertView+NSError.h"
#import "PostTweetViewController.h"
@interface QueueViewController ()
@property (nonatomic, strong) NSString *identifier;
@property (nonatomic, strong) UIViewController *resumeViewController;
@property (nonatomic, strong) NSMutableArray *requestQueue;
@end

@implementation QueueViewController
@synthesize tableView;
@synthesize identifier;
@synthesize resumeViewController;
@synthesize requestQueue;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.requestQueue = [NSMutableArray array];
}

-(void)postTweet:(PostTweetViewController *)postTweetViewController status:(NSString *)message {
    ACAccountStore *accountStore = [[ACAccountStore alloc] init];
    ACAccount *twitterAccount = [accountStore accountWithIdentifier:identifier];
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:message, @"status", nil];
    TWRequest *req = [[TWRequest alloc] initWithURL:[NSURL URLWithString:@"https://api.twitter.com/1/statuses/update.json"] parameters:param requestMethod:TWRequestMethodPOST];
    req.account = twitterAccount;
    
    [requestQueue addObject:req];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];                
    });
    
    [req performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {        
        if ([urlResponse.URL isEqual:req.URL]) {
            [requestQueue removeObject:req];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];                
            });
        }                
    }];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    UINavigationController *navViewController = (UINavigationController*)[segue destinationViewController];    
    PostTweetViewController *viewController = (PostTweetViewController *)[navViewController.viewControllers objectAtIndex:0];
    viewController.delegate = self;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    TWRequest *req = [requestQueue objectAtIndex:indexPath.row];
    ACAccountStore *accountStore = [[ACAccountStore alloc] init];
    ACAccount *twitterAccount = [accountStore accountWithIdentifier:identifier];
    req.account = twitterAccount;
    [req performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
        if ([urlResponse.URL isEqual:req.URL]) {
            [requestQueue removeObject:req];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];                
            });
        }                
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return requestQueue.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"UITableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    TWRequest *req = [requestQueue objectAtIndex:indexPath.row];
    cell.textLabel.text = [req.parameters objectForKey:@"status"];
    return cell;
}

-(void)prepareTwitterAccount {    
    ACAccountStore *accountStore = [[ACAccountStore alloc] init];
    ACAccountType *accountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    [accountStore requestAccessToAccountsWithType:accountType withCompletionHandler:
     ^(BOOL granted, NSError *error) {
         dispatch_async(dispatch_get_main_queue(), ^{
             ACAccount *twAccount;
             if (granted) {
                 NSArray *twitterAccounts = [accountStore accountsWithAccountType:accountType];                 
                 if (twitterAccounts.count > 0)
                 {
                     twAccount = [twitterAccounts objectAtIndex:0];
                     self.identifier = twAccount.identifier;
                     NSLog(@"Twitter account access granted:%@",[twAccount username]);
                 } else {
                     twAccount = nil;
                     NSLog(@"Twitter account nothing");
                 }
             } else {
                 twAccount = nil;
                 NSLog(@"Twitter account access denied");
             }
         });
     }];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self prepareTwitterAccount];
}

- (void)viewDidUnload
{
    [self setTableView:nil];
    [super viewDidUnload];
}

@end
