//
//  NPC1WalkerSprite.m
//  zhulusanguo
//
//  Created by qing on 15/5/4.
//  Copyright 2015年 qing lai. All rights reserved.
//

#import "NPC1WalkerSprite.h"


@implementation NPC1WalkerSprite

//startpos in the right
-(void) initRange:(float)range_ range2:(float)r2_
{
    self.flipX = YES;
    
    walkRangeX = range_;
    startPos = self.position;
    endPos = ccp(self.position.x-range_, self.position.y);
    //get the animation from cache
    //Repeat animation , walk to left , idle, turn back , repeat animation, walk to right, idle, turn back. again
    //range 160, 40*4 = 2.4 second
    CCAnimation *walk = [[CCAnimationCache sharedAnimationCache] animationByName:@"npc1"];
    walk.restoreOriginalFrame = YES;
    CCAnimate *wa = [CCAnimate actionWithAnimation:walk];
    CCRepeat *rwa = [CCRepeat actionWithAction:wa times:8];
    CCMoveTo *mt = [CCMoveTo actionWithDuration:6.4 position:endPos];
    CCSpawn *sp = [CCSpawn actions:rwa,mt, nil];
    CCDelayTime *dt = [CCDelayTime actionWithDuration:0.5];
    //CCCallFunc* cf1 = [CCCallFunc actionWithTarget:self selector:@selector(turnLeft)];
    
    leftDownPos = ccp(endPos.x, endPos.y - r2_);
    CCAnimation *walk2 = [[CCAnimationCache sharedAnimationCache] animationByName:@"npc1"];
    walk2.restoreOriginalFrame = YES;
    CCAnimate *wa2 = [CCAnimate actionWithAnimation:walk2];
    CCRepeat *rwa2 = [CCRepeat actionWithAction:wa2 times:8];
    CCMoveTo *mt2 = [CCMoveTo actionWithDuration:6.4 position:leftDownPos];
    CCSpawn *sp2 = [CCSpawn actions:rwa2,mt2, nil];
    CCDelayTime *dt2 = [CCDelayTime actionWithDuration:0.5];
    CCCallFunc* cf3 = [CCCallFunc actionWithTarget:self selector:@selector(turnLeft)];
    
    
    rightDownPos = ccp(leftDownPos.x + range_, leftDownPos.y);
    CCAnimation *walk3 = [[CCAnimationCache sharedAnimationCache] animationByName:@"npc1"];
    walk3.restoreOriginalFrame = YES;
    CCAnimate *wa3 = [CCAnimate actionWithAnimation:walk3];
    CCRepeat *rwa3 = [CCRepeat actionWithAction:wa3 times:8];
    CCMoveTo *mt3 = [CCMoveTo actionWithDuration:6.4 position:rightDownPos];
    CCSpawn *sp3 = [CCSpawn actions:rwa3,mt3, nil];
    CCDelayTime *dt3 = [CCDelayTime actionWithDuration:0.5];
    
    
    
    CCAnimation *walk1 = [[CCAnimationCache sharedAnimationCache] animationByName:@"npc1"];
    walk1.restoreOriginalFrame = YES;
    CCAnimate *wa1 = [CCAnimate actionWithAnimation:walk1];
    CCRepeat *rwa1 = [CCRepeat actionWithAction:wa1 times:8];
    CCMoveTo *mt1 = [CCMoveTo actionWithDuration:6.4 position:startPos];
    CCSpawn *sp1 = [CCSpawn actions:rwa1,mt1, nil];
    CCDelayTime *dt1 = [CCDelayTime actionWithDuration:0.5];
    CCCallFunc* cf2 = [CCCallFunc actionWithTarget:self selector:@selector(turnRight)];
    
    CCSequence* seq = [CCSequence actions:sp,dt,sp2,dt2,cf3, sp3, dt3, sp1,dt1,cf2, nil];
    CCRepeatForever* rfe = [CCRepeatForever actionWithAction:seq];
    [self runAction:rfe];
    
    
    _touchable = YES;
    uvi = nil;
}

-(void) turnLeft
{
    //self.flipX = YES;
    self.flipX = NO;
}

-(void) turnRight
{
    //self.flipX = NO;
    self.flipX = YES;
}

/*
-(void)onEnter {
    [[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:2 swallowsTouches:NO];
    [super onEnter];
}

-(void)onExit {
    [[[CCDirector sharedDirector] touchDispatcher] removeDelegate:self];
    [super onExit];
}

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint location = [touch locationInView:[touch view]];
    location = [[CCDirector sharedDirector] convertToGL:location];
    BOOL c = CGRectContainsPoint([self boundingBox], location);
    if (c) {
        return _touchable;
    }
    else {
        return NO;
    }
}

- (void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
    
}

- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    //show the dialog , then close the dialog after a while , then resume move , reset Touch
    CCLOG(@"right solider touched....");
    [self showTip];
}

- (void)ccTouchCancelled:(UITouch *)touch withEvent:(UIEvent *)event
{
    
}

*/

-(void) showTip
{
    /*
    _touchable = NO;
    [self pauseSchedulerAndActions];
    
    
    CGSize wsize = [[CCDirector sharedDirector] winSize];
    CCSprite* tipbg = [CCSprite spriteWithSpriteFrameName:@"speech4.png"];
    tipbg.position = ccp(wsize.width*0.5, self.position.y + 50);
    tipbg.tag = TIP_SOLIDER_SPEECH_BG_TAG;
    
    
    
    CCLayer* cmlayer = (CCLayer*)[[[CCDirector sharedDirector] runningScene] getChildByTag:1];
    if (cmlayer) {
        [cmlayer addChild:tipbg z:4];
    }
    
    float topx = tipbg.boundingBox.origin.x + 28;
    float topy = wsize.height - tipbg.boundingBox.origin.y - tipbg.boundingBox.size.height + 32;
    float rwidth = tipbg.boundingBox.size.width - 60;
    float rheight = tipbg.boundingBox.size.height -5;
    CGRect cr = CGRectMake(topx, topy, rwidth, rheight);
    
    //select for the db , get the tip desc
    TipObject* to = [[ShareGameManager shareGameManager] getRandomTip];
    
    uvi = [[UIView alloc] initWithFrame:cr ];
    
    UILabel* label = [[ShareGameManager shareGameManager] addLabelWithString:to.ctip dimension:cr normalColor:[UIColor blackColor] highColor:[UIColor redColor] nrange:to.nrange hrange:to.hrange];
    
    [uvi addSubview:label];
    [[[CCDirector sharedDirector] view] addSubview:uvi];
    
    [self performSelector:@selector(closeTip) withObject:nil afterDelay:5];
    */
}

-(void) closeTip
{
    /*
    [self resumeSchedulerAndActions];
    
    CCLayer* cmlayer = (CCLayer*)[[[CCDirector sharedDirector] runningScene] getChildByTag:1];
    if (cmlayer) {
        CCNode* speech = [cmlayer getChildByTag:TIP_SOLIDER_SPEECH_BG_TAG];
        if (speech) {
            [cmlayer removeChildByTag:TIP_SOLIDER_SPEECH_BG_TAG];
        }
    }
    if (uvi) {
        [uvi removeFromSuperview];
        uvi = nil;
    }
    
    _touchable = YES;
     */
}

-(void) cleanupBeforeRelease
{
    //[NSObject cancelPreviousPerformRequestsWithTarget:self];
}


-(void) dealloc
{
    
    
    [self stopAllActions];
    
    /*
    //remove the tip
    CCLayer* cmlayer = (CCLayer*)[[[CCDirector sharedDirector] runningScene] getChildByTag:1];
    if (cmlayer) {
        CCNode* speech = [cmlayer getChildByTag:TIP_SOLIDER_SPEECH_BG_TAG];
        if (speech) {
            [cmlayer removeChildByTag:TIP_SOLIDER_SPEECH_BG_TAG];
        }
    }
    if (uvi) {
        [uvi removeFromSuperview];
        uvi = nil;
    }
    */
    
    [super dealloc];
}

@end
