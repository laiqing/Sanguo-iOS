//
//  ReceiveSkillDropSprite.m
//  zhulusanguo
//
//  Created by qing on 15/5/11.
//  Copyright 2015年 qing lai. All rights reserved.
//

#import "ReceiveSkillDropSprite.h"


@implementation ReceiveSkillDropSprite

@synthesize skillID = _skillID;
@synthesize heroID = _heroID;
@synthesize skillPosID = _skillPosID;
@synthesize articlePosID = _articlePosID;
@synthesize purpose = _purpose;

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
        if (_skillID == 99) {
            return NO;
        }
        else {
            return YES;
        }
    }
}


- (void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event {
    
}

- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event {
    
    
    
    //show the skill info card
    CCLayer *layer = (CCLayer*)(self.parent.parent);
    NSString* skfile = [NSString stringWithFormat:@"skillinfo%d.png",_skillID];
    CCSprite* skcard = (CCSprite*)[layer getChildByTag:SKILL_DETAIL_CARD_TAG];
    if (skcard) {
        [skcard setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:skfile]];
        skcard.scale = 1.2;
        skcard.visible = YES;
    }
    else {
        skcard = [CCSprite spriteWithSpriteFrameName:skfile];
        CGSize wsize = [[CCDirector sharedDirector] winSize];
        skcard.visible = YES;
        skcard.scale = 1.2;
        skcard.position = ccp(wsize.width*0.5, wsize.height*0.5);
        skcard.tag = SKILL_DETAIL_CARD_TAG;
        [layer addChild:skcard z:4];
    }
    
}

- (void)ccTouchCancelled:(UITouch *)touch withEvent:(UIEvent *)event {
    
}

@end
