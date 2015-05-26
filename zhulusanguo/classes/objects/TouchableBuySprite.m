//
//  TouchableBuySprite.m
//  zhulusanguo
//
//  Created by qing on 15/5/25.
//  Copyright 2015年 qing lai. All rights reserved.
//

#import "TouchableBuySprite.h"


@implementation TouchableBuySprite

-(id)init
{
    if ((self = [super init])) {
        touchID = -1;
        _touchable = YES;
    }
    return self;
}

-(id)initWithSpriteFrame:(CCSpriteFrame *)spriteFrame
{
    if((self=[super initWithSpriteFrame:spriteFrame])) {
        touchID = -1;
        _touchable = YES;
    }
    return self;
}

-(void) initTheCallbackFunc:(SEL)cbfunc_ withCaller:(id)caller_ withTouchID:(int)tid withPosID:(int)pID
{
    caller = caller_;
    callbackFunc = cbfunc_;
    touchID = tid;
    posID = pID;
    _touchable = YES;
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

-(void) setTouchable:(BOOL)t
{
    _touchable = t;
}

- (BOOL)containsTouchLocation:(UITouch *)touch
{
    CGPoint location = [touch locationInView:[touch view]];
    location = [[CCDirector sharedDirector] convertToGL:location];
    return CGRectContainsPoint([self boundingBox], location);
}

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    if (self.visible == NO) {
        return NO;
    }
    
    if ( ![self containsTouchLocation:touch] )
    {
        return NO;
    }
    else {
        return _touchable;
    }
}


- (void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event {
    
}

- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event {
    
    //self scale up then scale down
    CCScaleTo *st = [CCScaleTo actionWithDuration:0.2 scale:1.2];
    CCScaleTo *st1 = [CCScaleTo actionWithDuration:0.2 scale:1];
    CCSequence *seq = [CCSequence actions:st,st1, nil];
    [self runAction:seq];
    
    //now call the caller to perform selector
    
    if (touchID <= -1 )
    {
        if ([caller respondsToSelector:callbackFunc]) {
            [caller performSelector:callbackFunc];
        }
    }
    //article is the normal 9 item
    else
    {
        if ([caller respondsToSelector:callbackFunc]) {
            [caller performSelector:callbackFunc withObject:[NSNumber numberWithInt:touchID] withObject:[NSNumber numberWithInt:posID]];
        }
        //[caller playMoneyEffectAtPos:self.position];
        
    }
    
    
}

- (void)ccTouchCancelled:(UITouch *)touch withEvent:(UIEvent *)event {
    
}

@end
