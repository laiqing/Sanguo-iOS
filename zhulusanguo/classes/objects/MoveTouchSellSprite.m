//
//  MoveTouchSellSprite.m
//  zhulusanguo
//
//  Created by qing on 15/6/1.
//  Copyright 2015年 qing lai. All rights reserved.
//

#import "MoveTouchSellSprite.h"


@implementation MoveTouchSellSprite

-(id)init
{
    if ((self = [super init])) {
        touchID = -1;
    }
    return self;
}

-(void) initTheCallbackFunc:(SEL)cbfunc_ withCaller:(id)caller_ withTouchID:(int)tid
{
    caller = caller_;
    callbackFunc0 = cbfunc_;
    touchID = tid;

}



-(void) dealloc
{
    [super dealloc];
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
    
    //self scale up then scale down
    CCScaleTo *st = [CCScaleTo actionWithDuration:0.2 scale:1.2];
    CCScaleTo *st1 = [CCScaleTo actionWithDuration:0.2 scale:1];
    CCSequence *seq = [CCSequence actions:st,st1, nil];
    [self runAction:seq];
    
    
}

- (void)ccTouchCancelled:(UITouch *)touch withEvent:(UIEvent *)event {
    
}

@end
