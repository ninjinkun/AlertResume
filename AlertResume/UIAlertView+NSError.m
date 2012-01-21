//
//  UIAlertView+NSError.m
//  AlertResume
//
//  Created by Asano Satoshi on 1/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "UIAlertView+NSError.h"

@implementation UIAlertView (NSErrorAddition)
-(id)initWithError:(NSError *)error {
    self = [super init];
    if (self) {
        self.title = [error localizedDescription];
        self.message = [[NSArray arrayWithObjects:[error localizedFailureReason], [error localizedRecoverySuggestion], nil] componentsJoinedByString:@"\n"];
        NSArray* optionTitles = [error localizedRecoveryOptions];
        for (NSString *title in optionTitles) {
            [self addButtonWithTitle:title];
        }
    }
    return self;
}
@end
