//
//  ExternCCAction.m
//  zhulusanguo
//
//  Created by qing on 15/3/27.
//  Copyright (c) 2015年 qing lai. All rights reserved.
//

#import "ExternCCAction.h"

//-----------------------
//------ call usage:
//      //create png sprite in this point
//      CCSprite* card = [CCSprite spriteWithFile:@"archer_info.png"];
//      card.position = touchLocation;
//      card.scale = 0.05;
//      [self addChild:card z:2];

//      CGSize wsize = [[CCDirector sharedDirector] winSize];
//      float height = (wsize.width*0.5 - touchLocation.x)*1.5;;
//      float yoff = (wsize.width*0.5 - touchLocation.x);
//      float xoff = wsize.height*0.5 - touchLocation.y;
//      CCXJumpBy* xj = [CCXJumpBy actionWithDuration:0.5 position:ccp(yoff, xoff) height:height jumps:1];
//      CCScaleTo* st = [CCScaleTo actionWithDuration:0.5 scale:1];
//      CCSpawn* sp = [CCSpawn actions:xj,st, nil];
//      [card runAction:sp];
//


@implementation CCXJumpBy
+(id) actionWithDuration: (ccTime) t position: (CGPoint) pos height: (ccTime) h jumps:(NSUInteger)j
{
    return [[[self alloc] initWithDuration: t position: pos height: h jumps:j] autorelease];
}

-(id) initWithDuration: (ccTime) t position: (CGPoint) pos height: (ccTime) h jumps:(NSUInteger)j
{
    if( (self=[super initWithDuration:t]) ) {
        delta_ = pos;
        height_ = h;
        jumps_ = j;
    }
    return self;
}

-(id) copyWithZone: (NSZone*) zone
{
    CCAction *copy = [[[self class] allocWithZone: zone] initWithDuration:[self duration] position:delta_ height:height_ jumps:jumps_];
    return copy;
}

-(void) startWithTarget:(id)aTarget
{
    [super startWithTarget:aTarget];
    startPosition_ = [(CCNode*)_target position];
}

-(void) update: (ccTime) t
{
    // Sin jump. Less realistic
    //	ccTime y = height * fabsf( sinf(t * (CGFloat)M_PI * jumps ) );
    //	y += delta.y * t;
    //	ccTime x = delta.x * t;
    //	[target setPosition: ccp( startPosition.x + x, startPosition.y + y )];
    
    // parabolic jump (since v0.8.2)
    ccTime frac = fmodf( t * jumps_, 1.0f );
    ccTime x = height_ * 4 * frac * (1 - frac);
    x += delta_.x * t;
    ccTime y = delta_.y * t;
    [_target setPosition: ccp( startPosition_.x + x, startPosition_.y + y )];
    
}

-(CCActionInterval*) reverse
{
    return [[self class] actionWithDuration:_duration position: ccp(-delta_.x,-delta_.y) height:height_ jumps:jumps_];
}
@end
