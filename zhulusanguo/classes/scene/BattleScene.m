//
//  BattleScene.m
//  zhulusanguo
//
//  Created by qing on 15/5/29.
//  Copyright 2015年 qing lai. All rights reserved.
//

#import "BattleScene.h"


@implementation BattleScene

+(id)nodeWithTargetCityID:(int)cid fightingType:(int)attackOrDefend heroList:(NSArray *)heroids
{
    return [[[self alloc] initWithTargetCityID:cid fightingType:attackOrDefend heroList:heroids] autorelease];
}

-(id)initWithTargetCityID:(int)cid fightingType:(int)attackOrDefend heroList:(NSArray *)heroids
{
    if ((self = [super init])) {
        BattleMainLayer* bmlayer = [BattleMainLayer nodeWithTargetCityID:cid fightingType:attackOrDefend heroList:heroids];
        bmlayer.tag = 1;
        [self addChild:bmlayer z:1];
    }
    return self;
}

@end
