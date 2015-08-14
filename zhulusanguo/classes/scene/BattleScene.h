//
//  BattleScene.h
//  zhulusanguo
//
//  Created by qing on 15/5/29.
//  Copyright 2015年 qing lai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

#import "BattleMainLayer.h"
//#import "BattleHUDLayer.h"

@interface BattleScene : CCScene {
    BattleMainLayer* mainlayer;
}

+(id)nodeWithTargetCityID:(int)cid fightingType:(int)attackOrDefend heroList:(NSArray*)heroids;

-(id)initWithTargetCityID:(int)cid fightingType:(int)attackOrDefend heroList:(NSArray*)heroids;

@end
