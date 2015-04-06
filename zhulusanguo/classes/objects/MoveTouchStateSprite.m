//
//  MoveTouchStateSprite.m
//  zhulusanguo
//
//  Created by qing on 15/3/28.
//  Copyright 2015年 qing lai. All rights reserved.
//

#import "MoveTouchStateSprite.h"


@implementation MoveTouchStateSprite

-(id)init
{
    if ((self = [super init])) {
        touchID = -1;
    }
    return self;
}

-(void) initTheCallbackFunc0:(SEL)cbfunc0_ withCallbackFunc1:(SEL)cbfunc1_ withCaller:(id)caller_ withTouchID:(int)tid withState:(int)st withImage0:(NSString *)st0 withImage1:(NSString *)st1
{
    caller = caller_;
    callbackFunc0 = cbfunc0_;
    callbackFunc1 = cbfunc1_;
    touchID = tid;
    state = st;
    state0Image = [st0 retain];
    state1Image = [st1 retain];
}

-(void) dealloc
{
    [state0Image release];
    [state1Image release];
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
        //switch state
        if (state==0) {
            state = 1;
            [self setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:state1Image]];
            if ([caller respondsToSelector:callbackFunc0]) {
                [caller performSelector:callbackFunc0];
            }
            
        }
        else {
            state = 0;
            [self setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:state0Image]];
            if ([caller respondsToSelector:callbackFunc1]) {
                [caller performSelector:callbackFunc1];
            }
        }
        
    }
    else
    {
        if (state==0) {
            state = 1;
            [self setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:state1Image]];
            if ([caller respondsToSelector:callbackFunc0]) {
                [caller performSelector:callbackFunc0 withObject:[NSNumber numberWithInt:touchID]];
            }
        }
        else {
            state = 0;
            [self setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:state0Image]];
            if ([caller respondsToSelector:callbackFunc1]) {
                [caller performSelector:callbackFunc1 withObject:[NSNumber numberWithInt:touchID]];
            }
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

-(void) unchecked
{
    [self setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:state0Image]];
}

@end
