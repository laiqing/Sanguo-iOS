//
//  MapLayer.h
//  zhulusanguo
//
//  Created by qing on 15/3/26.
//  Copyright 2015年 qing lai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

#import "ShareGameManager.h"
#import "CityInfoObject.h"
#import "CloudSprite.h"
#import "CitySprite.h"



@interface MapLayer : CCLayer {

    CCSprite* bg;
    //NSMutableArray *citys;  //cityObject
    NSMutableArray *citySprites;
    NSMutableArray *clouds;
    
    CCSpriteBatchNode *bnode;
    
    CitySprite *selUnit;
    
    /*  need to move to hud */
    
    
}

@end
