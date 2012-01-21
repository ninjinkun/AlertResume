//
//  PostTweetViewController.h
//  AlertResume
//
//  Created by Asano Satoshi on 1/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum ResumeType {
    Resume,
    Queue,
} ResumeType;

@interface PostTweetViewController : UIViewController
- (IBAction)postTweetButtonPushed:(id)sender;
- (IBAction)cancelButtonPushed:(id)sender;
@property (strong, nonatomic) IBOutlet UITextView *tweetTextView;
@property (nonatomic, weak) id delegate;
@property (nonatomic) ResumeType resumeType;
@end

@interface NSObject (PostTweetViewControllerDelegate)
-(void)postTweet:(PostTweetViewController *)postTweetViewController status:(NSString *)message;
@end
