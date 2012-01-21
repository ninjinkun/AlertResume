//
//  UIAlertView+NSError.h
//  AlertResume
//
//  Created by Asano Satoshi on 1/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIAlertView (NSErrorAddition)
-(id)initWithError:(NSError *)error;
@end
