//
//  CityMainLayer.h
//  zhulusanguo
//
//  Created by qing on 15/3/28.
//  Copyright 2015年 qing lai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

#import "ShareGameManager.h"
#import "CityInfoObject.h"
#import "TouchableSprite.h"
#import "CloudSprite.h"
#import "SoliderWalkSprite.h"
#import "LeftSoliderWalkSprite.h"

@interface CityMainLayer : CCLayer {
    int _cityID;
    CityInfoObject* cio;
    
    int _year;
    int _month;
    int _day;
    
    int _gold;
    int _wood;
    int _iron;
    
    TouchableSprite* hallBuilding;
    TouchableSprite* barrackBuilding;
    TouchableSprite* archerBuilding;
    TouchableSprite* cavalryBuilding;
    TouchableSprite* wizardBuilding;
    TouchableSprite* blacksmithBuilding;
    TouchableSprite* steelmillBuilding;
    TouchableSprite* lumbermillBuilding;
    TouchableSprite* marketBuilding;
    TouchableSprite* magictowerBuilding;
    TouchableSprite* tavernBuilding;
    
    TouchableSprite* menu;
    
    
    CCSprite* tower1Building;
    CCSprite* tower2Building;
    CCSprite* tower3Building;
    CCSprite* tower4Building;
    
    //TouchableSprite* buildBtn;
    TouchableSprite* articleBtn;
    TouchableSprite* recruitBtn;
    TouchableSprite* distributeBtn;
    TouchableSprite* heroBtn;
    TouchableSprite* skillBtn;
    TouchableSprite* forgeBtn;
    TouchableSprite* tradeBtn;
    
    
    CCLabelTTF* ylabel ;
    
    CCLabelTTF* moneyLabel;
    CCLabelTTF* woodLabel;
    CCLabelTTF* ironLabel;
    
}


-(id)initWithCityID:(int)cid;


@end
