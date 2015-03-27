//
//  SelectKingLayer.h
//  zhulusanguo
//
//  Created by qing on 15/3/24.
//  Copyright 2015年 qing lai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

#import "ShareGameManager.h"
#import "TouchableSprite.h"

@interface SelectKingLayer : CCLayer {
    CCSprite* selectFlag;
    CGPoint heropos[12];
    CGPoint checkboxPos[4];
    CCSprite* tick;
}

+(CCScene *) scene;

@end
