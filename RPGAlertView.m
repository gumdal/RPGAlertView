//
//  RPGAlertView.m
//  Snakes
//
//  Created by Raj on 01/11/13.
//  Copyright (c) 2013 Jagli. All rights reserved.
//

#import "RPGAlertView.h"
#import "RPGAlertPoolManager.h"

@interface RPGAlertView()
// We consume the delegate here since we need it for housekeeping stuff. We take a backup of original delegate to inform it about all callbacks
@property (nonatomic, weak) id<UIAlertViewDelegate> originalDelegate;
@end

@implementation RPGAlertView

-(void)setDelegate:(id)delegate
{
    [self setOriginalDelegate:delegate];
    [super setDelegate:self];   // Setting ourself as the delegate
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

#pragma mark - Equality Test
// Eqality test is by:
// 1. Title
// 2. Message
// 3. Button titles

-(NSUInteger)hash
{
    // http://stackoverflow.com/a/254380/260665
    NSUInteger prime = 31;
    NSUInteger result = 1;

    result = prime * result + [[self message] hash];
    result = prime * result + [[self title] hash];
    int buttonCount = [self numberOfButtons];
    for (int i=0; i<buttonCount; i++)
    {
        NSString *buttonTitle = [self buttonTitleAtIndex:i];
        result = prime * result + [buttonTitle hash];
    }
    
    return result;
}

-(BOOL)isEqual:(id)inObject
{
    BOOL objectsAreEqual = YES;
    if (self!=inObject)
    {
        if ([inObject isKindOfClass:[self class]])
        {
            RPGAlertView *comparingObject = (RPGAlertView*)inObject;

            // 1. Title
            if (objectsAreEqual)
            {
                if (![self.title isEqual:[comparingObject title]])
                    objectsAreEqual = NO;
            }
            
            // 2. Message
            if (objectsAreEqual)
            {
                if (![self.message isEqual:[comparingObject message]])
                    objectsAreEqual = NO;
            }
            
            // 3. Buttons
            int buttonCount = [self numberOfButtons];
            int buttonCountComparingObject =  [comparingObject numberOfButtons];
            if (buttonCount == buttonCountComparingObject)
            {
                for (int i=0; i<buttonCount; i++)
                {
                    if (objectsAreEqual)
                    {
                        if (![[self buttonTitleAtIndex:i] isEqual:[comparingObject buttonTitleAtIndex:i]])
                            objectsAreEqual = NO;
                    }
                }
            }
            else
                objectsAreEqual = NO;
        }
    }
    return objectsAreEqual;
}

#pragma mark - Overridden
-(void)show
{
    RPGAlertView *theAlertView = [[RPGAlertPoolManager sharedPoolManager] displayedAlertViewForAlert:self];
    if (nil==theAlertView)
    {
        [[RPGAlertPoolManager sharedPoolManager] addAlertIntoDiplayPool:self];
        [super show];
    }
}

#pragma mark - UIAlertView delegates
// Called when a button is clicked. The view will be automatically dismissed after this call returns
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([self.originalDelegate respondsToSelector:@selector(alertView:clickedButtonAtIndex:)])
    {
        [self.originalDelegate alertView:alertView
                    clickedButtonAtIndex:buttonIndex];
    }
    
    [[RPGAlertPoolManager sharedPoolManager] removeAlertFromDisplayPool:self];
}

// Called when we cancel a view (eg. the user clicks the Home button). This is not called when the user clicks the cancel button.
// If not defined in the delegate, we simulate a click in the cancel button
- (void)alertViewCancel:(UIAlertView *)alertView
{
    if ([self.originalDelegate respondsToSelector:@selector(alertViewCancel:)])
    {
        [self.originalDelegate alertViewCancel:alertView];
    }
    
    [[RPGAlertPoolManager sharedPoolManager] removeAlertFromDisplayPool:self];
}

- (void)willPresentAlertView:(UIAlertView *)alertView  // before animation and showing view
{
    if ([self.originalDelegate respondsToSelector:@selector(willPresentAlertView:)])
    {
        [self.originalDelegate willPresentAlertView:alertView];
    }
}
- (void)didPresentAlertView:(UIAlertView *)alertView  // after animation
{
    if ([self.originalDelegate respondsToSelector:@selector(didPresentAlertView:)])
    {
        [self.originalDelegate didPresentAlertView:alertView];
    }
}

- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex // before animation and hiding view
{
    if ([self.originalDelegate respondsToSelector:@selector(alertView:willDismissWithButtonIndex:)])
    {
        [self.originalDelegate alertView:alertView
              willDismissWithButtonIndex:buttonIndex];
    }
}
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex  // after animation
{
    if ([self.originalDelegate respondsToSelector:@selector(alertView:didDismissWithButtonIndex:)])
    {
        [self.originalDelegate alertView:alertView
               didDismissWithButtonIndex:buttonIndex];
    }
}

// Called after edits in any of the default fields added by the style
- (BOOL)alertViewShouldEnableFirstOtherButton:(UIAlertView *)alertView
{
    BOOL notSureWhatTheDefaultIs = YES;
    if ([self.originalDelegate respondsToSelector:@selector(alertViewShouldEnableFirstOtherButton:)])
    {
        notSureWhatTheDefaultIs = [self.originalDelegate alertViewShouldEnableFirstOtherButton:alertView];
    }
    return notSureWhatTheDefaultIs;
}


@end
