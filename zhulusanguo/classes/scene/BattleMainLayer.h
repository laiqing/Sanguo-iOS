//
//  BattleMainLayer.h
//  zhulusanguo
//
//  Created by qing on 15/5/29.
//  Copyright 2015年 qing lai. All rights reserved.
//
//  battle layer need attack info , 6 hero info, defend info, 6 enemy info.
//


#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface BattleMainLayer : CCLayer {
    //NSMutableArray* mapInfo;  // every grid has a corresponding CGPoint [0,0] = 0 , [0,1] = 1, ... , and occupied by herio id.
    NSMutableDictionary* mapInfo; // posID , CGPoint [0,0] -- NSValue  heroUnitID.
    //6 object for 6 attack unit.
    //6 object for 6 army unit.
    //6 object for 6 defend unit.
    //6 object for 6 defend army unit.
    //4 object for 4 tower.
    NSMutableArray* traps;
    NSMutableArray* barriers;
    
    NSMutableArray* allies;
    NSMutableArray* bots;
    //1 object for camp.
    
    int _turnNumber;
    int _weather;
    int _cityID;
    int _attackOrDefend;  //player is attack or defend. 1, attack , 2 defend.
    int _playerLostHP;
    int _enemyLostHP;     //for calculate the experiences which player can earn.
    
    CCNode* main;  //z: -1
    CCNode* hud;  //hud is the operation layer , z:1
    CCSprite* map; //belong to main z:0
    CCSprite* mapMask; //belong to main z:2
    
    
}

+(id)nodeWithTargetCityID:(int)cid fightingType:(int)attackOrDefend heroList:(NSArray*)heroids;

-(id)initWithTargetCityID:(int)cid fightingType:(int)attackOrDefend heroList:(NSArray*)heroids;

-(void) updateMapInfoAfterUnitMove:(id)unit;
-(void) updateMapinfoAfterHeroMove:(id)hero;
-(void) addTrap:(CGPoint)tpos;
-(void) removeTrap:(CGPoint)tpos;




@end
