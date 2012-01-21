//
//  PostTweetViewController.m
//  AlertResume
//
//  Created by Asano Satoshi on 1/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PostTweetViewController.h"

@interface PostTweetViewController ()

@end

@implementation PostTweetViewController
@synthesize tweetTextView;
@synthesize delegate;
@synthesize resumeType;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [self setTweetTextView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)postTweetButtonPushed:(id)sender {
    if ([delegate respondsToSelector:@selector(postTweet:status:)]) {
        [delegate postTweet:self status:tweetTextView.text];
    }
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)cancelButtonPushed:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}
@end
