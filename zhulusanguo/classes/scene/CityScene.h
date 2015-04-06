//
//  CityScene.h
//  zhulusanguo
//
//  Created by qing on 15/3/28.
//  Copyright 2015年 qing lai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "CityMainLayer.h"


@interface CityScene : CCScene {
    CityMainLayer* cmlayer;
}

+(id) nodeWithCityID:(int)cid;

@end
