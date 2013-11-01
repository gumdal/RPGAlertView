//
//  RPGAlertPoolManager.m
//  Snakes
//
//  Created by Raj on 01/11/13.
//  Copyright (c) 2013 Jagli. All rights reserved.
//

#import "RPGAlertPoolManager.h"

@interface RPGAlertPoolManager()
@property (nonatomic, strong) NSMutableArray *alertPool;
@end

@implementation RPGAlertPoolManager
@synthesize alertPool = alertPool_;
-(NSMutableArray*)alertPool
{
    if (nil==alertPool_)
    {
        alertPool_ = [NSMutableArray array];
    }
    return alertPool_;
}

+(RPGAlertPoolManager*)sharedPoolManager
{
    static RPGAlertPoolManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[RPGAlertPoolManager alloc] init];
        // Do any other initialisation stuff here
    });
    return sharedInstance;
}

#pragma mark - Pool operations
-(RPGAlertView*)displayedAlertViewForAlert:(RPGAlertView*)inAlertView
{
    RPGAlertView *displayedAlert = nil;
    for (RPGAlertView *alertInPool in self.alertPool)
    {
        if ([alertInPool isEqual:inAlertView])
        {
            displayedAlert = alertInPool;
            break;
        }
    }
    return displayedAlert;
}

-(void)addAlertIntoDiplayPool:(RPGAlertView*)inAlertView
{
    if (inAlertView)
        [self.alertPool addObject:inAlertView];
}

-(void)removeAlertFromDisplayPool:(RPGAlertView*)inAlertView
{
    if (inAlertView)
        [self.alertPool removeObject:inAlertView];
}

@end
