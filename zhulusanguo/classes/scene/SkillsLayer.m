//
//  SkillsLayer.m
//  zhulusanguo
//
//  Created by qing on 15/3/30.
//  Copyright 2015年 qing lai. All rights reserved.
//

#import "SkillsLayer.h"


@implementation SkillsLayer

+ (id) contentRect1:(CGRect)left contentRect2:(CGRect)right withCityID:(int)tcid
{
    return [[[self alloc] initcontentRect1:left contentRect2:right withCityID:tcid] autorelease];
}

- (id) initcontentRect1:(CGRect)left contentRect2:(CGRect)right withCityID:(int)tcid
{
    if ((self=[super init])) {
        _cityID = tcid;
        leftContent = left;
        rightContent = right;
        
        leftLayer = [[[CCNode alloc] init] autorelease];
        rightLayer = [[[CCNode alloc] init] autorelease];
        
        [self addChild:leftLayer z:0];
        [self addChild:rightLayer z:0];
        
    }
    return self;
}

-(void) updateLeftChildVisible:(CCNode*)ch
{
    CGRect cb = CGRectApplyAffineTransform(ch.boundingBox, [leftLayer nodeToParentTransform]);
    CGRect cb2 = CGRectApplyAffineTransform(cb, [self nodeToParentTransform]);
    if (CGRectContainsRect(leftContent, cb2)) {
        ch.visible = YES;
    }
    else {
        ch.visible = NO;
    }
}

-(void) updateRightChildVisible:(CCNode*)ch
{
    CGRect cb = CGRectApplyAffineTransform(ch.boundingBox, [rightLayer nodeToParentTransform]);
    CGRect cb2 = CGRectApplyAffineTransform(cb, [self nodeToParentTransform]);
    if (CGRectContainsRect(leftContent, cb2)) {
        ch.visible = YES;
    }
    else {
        ch.visible = NO;
    }
}

-(void) onEnter
{
    [[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
    [super onEnter];
}

-(void) onExit
{
    CCLOG(@"call SkillLayer onExit()....");
    [[[CCDirector sharedDirector] touchDispatcher] removeDelegate:self];
    [super onExit];
}

- (BOOL) ccTouchBegan:(UITouch*)touch withEvent:(UIEvent *)event {
    
    
    return YES;
}

- (void) ccTouchMoved:(UITouch*)touch withEvent:(UIEvent *)event {
    //check _dragging , _moveLeft , _moveRight tag
}

- (void) ccTouchEnded:(UITouch*)touch withEvent:(UIEvent *)event {
    //set all tag == 0
    //set drag image == nil
}



@end
