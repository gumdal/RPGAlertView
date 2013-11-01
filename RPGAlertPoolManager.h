//
//  RPGAlertPoolManager.h
//  Snakes
//
//  Created by Raj on 01/11/13.
//  Copyright (c) 2013 Jagli. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RPGAlertView.h"

@interface RPGAlertPoolManager : NSObject

+(RPGAlertPoolManager*)sharedPoolManager;

#pragma mark - Pool operations
// Will return the alert view which is already displayed for the alert view passed in
-(RPGAlertView*)displayedAlertViewForAlert:(RPGAlertView*)inAlertView;
-(void)addAlertIntoDiplayPool:(RPGAlertView*)inAlertView;
-(void)removeAlertFromDisplayPool:(RPGAlertView*)inAlertView;

@end
