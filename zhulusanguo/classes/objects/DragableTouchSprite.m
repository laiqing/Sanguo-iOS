//
//  DragableTouchSprite.m
//  zhulusanguo
//
//  Created by qing on 15/5/6.
//  Copyright 2015年 qing lai. All rights reserved.
//

#import "DragableTouchSprite.h"


@implementation DragableTouchSprite

-(id)init
{
    if ((self = [super init])) {
        touchID = -1;
    }
    return self;
}

-(void) initTheCallbackFunc0:(SEL)cbfunc0_ withCaller:(id)caller_  withTouchID:(int)tid needChangeImg:(BOOL)changeImg withImage0:(NSString *)st0 withImage1:(NSString *)st1
{
    caller = caller_;
    callbackFunc0 = cbfunc0_;
    //callbackFunc1 = cbfunc1_;
    touchID = tid;
    needChangeImg = changeImg;
    //state = st;
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
        //add a new sprite on the location
        if (dragSprite) {
            [dragSprite removeFromParentAndCleanup:YES];
            dragSprite = nil;
        }
        
        if (needChangeImg) {
            //[self setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:state1Image]];
            dragSprite = [ArticleDragSprite spriteWithSpriteFrameName:state1Image];
        }
        else {
            dragSprite = [ArticleDragSprite spriteWithSpriteFrameName:state0Image];
            dragSprite.scale = 1.5;
        }
        
        dragSprite.articleID = touchID;
        
        
        CGPoint tlocation = [self.parent.parent convertTouchToNodeSpace:touch];
        dragSprite.position = tlocation;
        [self.parent.parent addChild:dragSprite z:2];
        
        return YES;
    }
}


- (void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event {
    //move image
    CGPoint tlocation = [self.parent.parent convertTouchToNodeSpace:touch];
    dragSprite.position = tlocation;
}

- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event {
    
    //call the caller to check the release position available
    if ([caller respondsToSelector:callbackFunc0]) {
        [caller performSelector:callbackFunc0 withObject:dragSprite];
    }
    
    //remove the drag sprite
    if (dragSprite) {
        [dragSprite removeFromParentAndCleanup:YES];
        dragSprite = nil;
    }
    
    //now call the caller to perform selector
    /*
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
     */
    
    
    
}

- (void)ccTouchCancelled:(UITouch *)touch withEvent:(UIEvent *)event {
    
}

-(void) unchecked
{
    [self setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:state0Image]];
}



@end
