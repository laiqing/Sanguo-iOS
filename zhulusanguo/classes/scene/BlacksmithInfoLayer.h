//
//  BlacksmithInfoLayer.h
//  zhulusanguo
//
//  Created by qing on 15/4/10.
//  Copyright 2015年 qing lai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

#import "ShareGameManager.h"
#import "CityInfoObject.h"

#import "TouchableSprite.h"

@interface BlacksmithInfoLayer : CCLayer {
    int _cityID;
    int _currentLevel;
    
    CCSprite* bg;
    CCLabelTTF* title;
    //CCLabelTTF* desc;
    CCSprite* desc;
    CCSprite* building;
    CCLabelTTF* currentProvide;
    CCLabelTTF* nextProvide;
    CCSprite* nextgold;
    CCLabelTTF* nextGoldCost;
    CCSprite* nextwood;
    CCLabelTTF* nextWoodCost;
    CCSprite* nextiron;
    CCLabelTTF* nextIronCost;
    
    TouchableSprite* upgradeBtn;
    TouchableSprite* otherBtn;  //trade , recruit, hire, forge, skill, trade

}
-(void) setCityID:(int)cid;
@end
