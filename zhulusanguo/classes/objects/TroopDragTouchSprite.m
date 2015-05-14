//
//  TroopDragTouchSprite.m
//  zhulusanguo
//
//  Created by qing on 15/5/14.
//  Copyright 2015年 qing lai. All rights reserved.
//

#import "TroopDragTouchSprite.h"


@implementation TroopDragTouchSprite

@synthesize candrag = dragable;
@synthesize heroID = _heroID;
@synthesize touchID = _touchID;

-(id)init
{
    if ((self = [super init])) {
        _touchID = 1;  //默认拖拉的是步兵
        dragable = NO;
    }
    return self;
}

-(void) initTheCallbackFunc0:(SEL)cbfunc0_ withCaller:(id)caller_ withTouchID:(int)tid withImg:(NSString*)img1 canDrag:(BOOL)_dr
{
    caller = caller_;
    callbackFunc0 = cbfunc0_;
    _touchID = tid;
    state0Image = [img1 retain];
    dragable = _dr;
    if (_touchID == 0) {
        dragable = NO;
    }
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
    if (CGRectContainsPoint(cb2, location)) {
        return dragable;
    }
    else {
        return NO;
    }
    
}

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    if ( ![self containsTouchLocation:touch] )
    {
        return NO;
    }
    else {
        /*
        if (_touchID == 0) {
            //show alert
            CCLOG(@"touch ID is : %d",_touchID);
            [[SimpleAudioEngine sharedEngine] playEffect:@"fail.caf"];
            
            CGSize wszie = [[CCDirector sharedDirector] winSize];
            CCSprite* stbar = [CCSprite spriteWithSpriteFrameName:@"statusbar.png"];
            stbar.position = ccp(wszie.width*0.5, wszie.height*0.5);
            [self.parent addChild:stbar z:5];
            [stbar performSelector:@selector(removeFromParent) withObject:nil afterDelay:1.5];
            
            CCLabelTTF* warn = [CCLabelTTF labelWithString:@"你无法将一个兵力为0的武将的兵力分配给别人！" fontName:@"Arial" fontSize:15];
            warn.color = ccYELLOW;
            warn.position = stbar.position;
            [self.parent addChild:warn z:6];
            [warn performSelector:@selector(removeFromParent) withObject:nil afterDelay:1.5];
            return NO;
        }
         */
        //else {
            HeroObject* ho  = [[ShareGameManager shareGameManager] getHeroInfoFromID:_heroID];
            
            
            //add a new sprite on the location
            if (dragSprite) {
                [dragSprite removeFromParentAndCleanup:YES];
                dragSprite = nil;
            }
            dragSprite = [UnitDragSprite spriteWithSpriteFrameName:state0Image];
            dragSprite.scale = 2;
            
            dragSprite.unitTypeID = ho.troopType;
            dragSprite.heroID = _heroID;
            dragSprite.unitCount = ho.troopCount;
            
            
            CGPoint tlocation = [self.parent.parent convertTouchToNodeSpace:touch];
            dragSprite.position = tlocation;
            [self.parent.parent addChild:dragSprite z:2];
            
            return YES;
        //}
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
