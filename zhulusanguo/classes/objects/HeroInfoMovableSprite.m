//
//  HeroInfoMovableSprite.m
//  zhulusanguo
//
//  Created by qing on 15/5/14.
//  Copyright 2015年 qing lai. All rights reserved.
//

#import "HeroInfoMovableSprite.h"


@implementation HeroInfoMovableSprite

-(id)init
{
    if ((self = [super init])) {
        touchID = -1;
    }
    return self;
}

-(void) initTheCallbackFunc0:(SEL)cbfunc0_ withCaller:(id)caller_ withTouchID:(int)tid
{
    caller = caller_;
    callbackFunc0 = cbfunc0_;
    touchID = tid;
}

-(void)onEnter {
    [[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
    [super onEnter];
}

-(void)onExit {
    [[[CCDirector sharedDirector] touchDispatcher] removeDelegate:self];
    [super onExit];
}

- (BOOL)containsTouchLocation:(UITouch *)touch
{
    CGPoint location = [touch locationInView:[touch view]];
    location = [[CCDirector sharedDirector] convertToGL:location];
    CGRect cb = CGRectApplyAffineTransform(self.boundingBox, [self.parent nodeToParentTransform]);
    CGRect cb2 = CGRectApplyAffineTransform(cb, [self.parent.parent nodeToParentTransform]);
    return CGRectContainsPoint(cb2, location);
}

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    if ( ![self containsTouchLocation:touch] )
    {
        return NO;
    }
    else {
        return YES;
    }
}


- (void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event {
    
}

- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event {
    
    //now call the caller to perform selector

    if (touchID <= -1 )
    {
        if ([caller respondsToSelector:callbackFunc0]) {
            [caller performSelector:callbackFunc0];
        }
        
    }
    else
    {
        if ([caller respondsToSelector:callbackFunc0]) {
            [caller performSelector:callbackFunc0 withObject:[NSNumber numberWithInt:touchID]];
        }
        
    }
    
    
}

- (void)ccTouchCancelled:(UITouch *)touch withEvent:(UIEvent *)event {
    
}

@end
