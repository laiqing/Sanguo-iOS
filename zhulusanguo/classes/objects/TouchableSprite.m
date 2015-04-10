//
//  TouchableSprite.m
//  zhulusanguo
//
//  Created by qing on 15/3/24.
//  Copyright 2015年 qing lai. All rights reserved.
//

#import "TouchableSprite.h"


@implementation TouchableSprite

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

-(void) initTheCallbackFunc:(SEL)cbfunc_ withCaller:(id)caller_ withTouchID:(int)tid
{
    caller = caller_;
    callbackFunc = cbfunc_;
    touchID = tid;
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
    else
    {
        if ([caller respondsToSelector:callbackFunc]) {
            [caller performSelector:callbackFunc withObject:[NSNumber numberWithInt:touchID]];
        }
    }
    
    
}

- (void)ccTouchCancelled:(UITouch *)touch withEvent:(UIEvent *)event {
    
}

@end
