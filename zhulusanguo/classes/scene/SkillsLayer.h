//
//  SkillsLayer.h
//  zhulusanguo
//
//  Created by qing on 15/3/30.
//  Copyright 2015年 qing lai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

#import "ShareGameManager.h"
#import "TouchableSprite.h"
#import "HeroObject.h"
#import "MoveTouchStateSprite.h"

@interface SkillsLayer : CCLayer {
    int _dragging;
    int _moveLeftLayer;
    int _moveRightLayer;
    int _dragItemID;
    
    int _cityID;
    
    CCNode* leftLayer;
    CCNode* rightLayer;
    CGRect leftContent;
    CGRect rightContent;
}

+ (id) contentRect1:(CGRect)left contentRect2:(CGRect)right withCityID:(int)tcid;
- (id) initcontentRect1:(CGRect)left contentRect2:(CGRect)right withCityID:(int)tcid;
-(void) updateLeftChildVisible:(CCNode*)ch;
-(void) updateRightChildVisible:(CCNode*)ch;


@end
