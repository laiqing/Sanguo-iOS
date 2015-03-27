//
//  MapHUDLayer.h
//  zhulusanguo
//
//  Created by qing on 15/3/26.
//  Copyright 2015年 qing lai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

#import "ShareGameManager.h"
#import "TouchableSprite.h"
#import "DiaoDongLayer.h"
#import "FightLayer.h"


@interface MapHUDLayer : CCLayer<MapHUDProtocol> {
    UIView *uvi;
    CCSprite *statusbar;
    
    int year;
    int month;//30*4 = 120 sec 1 month
    int day;
    
    int _gold;
    int _wood;
    int _iron;
    
    CCLabelTTF* ylabel ;
    
    CCLabelTTF* moneyLabel;
    CCLabelTTF* woodLabel;
    CCLabelTTF* ironLabel;
    
    
    //move from maplayer
    CCSprite* citydlg;
    CCSprite* heroIcon;
    CCSprite* heroFrame;
    CCLabelTTF* cityName;
    CCLabelTTF* heroName;
    CCLabelTTF* cityLevel;
    CCLabelTTF* heroCount;
    CCLabelTTF* warriorCount;
    CCLabelTTF* archerCount;
    CCLabelTTF* cavalryCount;
    CCLabelTTF* wizardCount;
    CCLabelTTF* ballistaCount;
    
    TouchableSprite* btn1;
    TouchableSprite* btn2;
    
    TouchableSprite* menu;
    
}

@end
