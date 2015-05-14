//
//  SkillDragTouchSprite.m
//  zhulusanguo
//
//  Created by qing on 15/5/10.
//  Copyright 2015年 qing lai. All rights reserved.
//

#import "SkillDragTouchSprite.h"


@implementation SkillDragTouchSprite

-(id)init
{
    if ((self = [super init])) {
        touchID = -1;
    }
    return self;
}

-(void) initTheCallbackFunc0:(SEL)cbfunc0_ withBeforeCallback:(SEL)cbfunc1_ withCaller:(id)caller_ withTouchID:(int)tid withImg:(NSString *)img1
{
    caller = caller_;
    callbackFunc0 = cbfunc0_;
    beforeMoveCallbackFunc = cbfunc1_;
    //callbackFunc1 = cbfunc1_;
    touchID = tid;
    state0Image = [img1 retain];
}

-(void) dealloc
{
    [state0Image release];
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
        //call the before callback
        if (caller) {
            if ([caller respondsToSelector:beforeMoveCallbackFunc]) {
                [caller performSelector:beforeMoveCallbackFunc];
            }
        }
        
        //add a new sprite on the location
        if (dragSprite) {
            [dragSprite removeFromParentAndCleanup:YES];
            dragSprite = nil;
        }
        dragSprite = [ArticleDragSprite spriteWithSpriteFrameName:state0Image];
        dragSprite.scale = 2;
        
        dragSprite.skillID = touchID;
        
        
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
    
    
    
}

- (void)ccTouchCancelled:(UITouch *)touch withEvent:(UIEvent *)event {
    
}



@end
