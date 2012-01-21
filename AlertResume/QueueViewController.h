//
//  ViewController.h
//  AlertResume
//
//  Created by Asano Satoshi on 1/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PostTweetViewController.h"
@interface QueueViewController : UIViewController<UIAlertViewDelegate, UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@end
