//
//  BattleMainLayer.m
//  zhulusanguo
//
//  Created by qing on 15/5/29.
//  Copyright 2015年 qing lai. All rights reserved.
//

#import "BattleMainLayer.h"


@implementation BattleMainLayer

+(id)nodeWithTargetCityID:(int)cid fightingType:(int)attackOrDefend heroList:(NSArray *)heroids
{
    return [[[self alloc] initWithTargetCityID:cid fightingType:attackOrDefend heroList:heroids] autorelease];
}

-(id)initWithTargetCityID:(int)cid fightingType:(int)attackOrDefend heroList:(NSArray *)heroids
{
    if ((self = [super init])) {
        //load the battle green png in 0
        //load the mask in 1
        
        //role move square in 2
        //every role in 3 , role state : poison, chaos in 4
        //every effect in 4 , -- show card 5 , animation 4, bullet 4, speech 5
        //drag icon 4
        
        
        
    }
    return self;
}

@end
