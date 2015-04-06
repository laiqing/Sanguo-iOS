//
//  LeftSoliderWalkSprite.m
//  zhulusanguo
//
//  Created by qing on 15/3/29.
//  Copyright 2015年 qing lai. All rights reserved.
//

#import "LeftSoliderWalkSprite.h"


@implementation LeftSoliderWalkSprite

//startpos in the right
-(void) initRange:(float)range_
{
    self.flipX = YES;
    walkRangeX = range_;
    startPos = self.position;
    endPos = ccp(self.position.x+range_, self.position.y);
    //get the animation from cache
    //Repeat animation , walk to left , idle, turn back , repeat animation, walk to right, idle, turn back. again
    //range 160, 40*4 = 2.4 second
    CCAnimation *walk = [[CCAnimationCache sharedAnimationCache] animationByName:@"solider"];
    walk.restoreOriginalFrame = YES;
    CCAnimate *wa = [CCAnimate actionWithAnimation:walk];
    CCRepeat *rwa = [CCRepeat actionWithAction:wa times:8];
    CCMoveTo *mt = [CCMoveTo actionWithDuration:6.4 position:endPos];
    CCSpawn *sp = [CCSpawn actions:rwa,mt, nil];
    CCDelayTime *dt = [CCDelayTime actionWithDuration:0.5];
    CCCallFunc* cf1 = [CCCallFunc actionWithTarget:self selector:@selector(turnRight)];
    
    CCAnimation *walk1 = [[CCAnimationCache sharedAnimationCache] animationByName:@"solider"];
    walk1.restoreOriginalFrame = YES;
    CCAnimate *wa1 = [CCAnimate actionWithAnimation:walk1];
    CCRepeat *rwa1 = [CCRepeat actionWithAction:wa1 times:8];
    CCMoveTo *mt1 = [CCMoveTo actionWithDuration:6.4 position:startPos];
    CCSpawn *sp1 = [CCSpawn actions:rwa1,mt1, nil];
    CCDelayTime *dt1 = [CCDelayTime actionWithDuration:0.5];
    CCCallFunc* cf2 = [CCCallFunc actionWithTarget:self selector:@selector(turnLeft)];
    
    CCSequence* seq = [CCSequence actions:sp,dt,cf1,sp1,dt1,cf2, nil];
    CCRepeatForever* rfe = [CCRepeatForever actionWithAction:seq];
    [self runAction:rfe];
    
}

-(void) turnLeft
{
    self.flipX = YES;
}

-(void) turnRight
{
    self.flipX = NO;
}

-(void) dealloc
{
    [self stopAllActions];
    [super dealloc];
}

@end
