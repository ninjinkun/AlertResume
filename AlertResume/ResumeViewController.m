//
//  ResumeViewController.m
//  AlertResume
//
//  Created by Asano Satoshi on 1/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ResumeViewController.h"
#import <Accounts/Accounts.h>
#import <Twitter/Twitter.h>
#import "UIAlertView+NSError.h"
#import "PostTweetViewController.h"

@interface ResumeViewController ()
@property (nonatomic, strong) NSString *identifier;
@property (nonatomic, strong) UIViewController *resumeViewController;
@end

@implementation ResumeViewController
@synthesize identifier;
@synthesize resumeViewController;

-(void)postTweet:(PostTweetViewController *)postTweetViewController status:(NSString *)message {
    ACAccountStore *accountStore = [[ACAccountStore alloc] init];
    ACAccount *twitterAccount = [accountStore accountWithIdentifier:identifier];
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:message, @"status", nil];
    TWRequest *req = [[TWRequest alloc] initWithURL:[NSURL URLWithString:@"https://api.twitter.com/1/statuses/update.json"] parameters:param requestMethod:TWRequestMethodPOST];
    req.account = twitterAccount;
    
    self.resumeViewController = postTweetViewController; // レジューム用に保存
    
    [req performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
        if (error) {
            NSError *alertError = [self buildAlertError:error];
            UIAlertView *alert = [[UIAlertView alloc] initWithError:alertError];            
            alert.delegate = self;
            [alert show];
        }
        else {
            self.resumeViewController = nil; // レジューム用に保存
        }
    }];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0:
            // キャンセル            
            break;
        case 1:
            // 再試行            
            [self resumePostViewController];
            self.resumeViewController = nil;
            break;
        default:
            break;
    }
}

// レジューム処理
-(void)resumePostViewController {
    UINavigationController *navViewController = [[UINavigationController alloc] initWithRootViewController:resumeViewController];
    [self presentModalViewController:navViewController animated:YES];
}

-(NSError *)buildAlertError:(NSError *)requestError {
    NSArray *buttons = [NSArray arrayWithObjects:@"キャンセル", @"再試行", nil];
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                              @"ネットワークエラー", NSLocalizedDescriptionKey,
                              requestError.localizedDescription, NSLocalizedFailureReasonErrorKey,
                              @"再試行しますか", NSLocalizedRecoverySuggestionErrorKey,
                              buttons, NSLocalizedRecoveryOptionsErrorKey,
                              nil];
    return [NSError errorWithDomain:@"" code:requestError.code userInfo:userInfo];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    UINavigationController *navViewController = (UINavigationController*)[segue destinationViewController];    
    PostTweetViewController *viewController = (PostTweetViewController *)[navViewController.viewControllers objectAtIndex:0];
    viewController.delegate = self;
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self prepareTwitterAccount];
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

@end
