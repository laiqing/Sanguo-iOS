//
//  DiaoDongLayer.h
//  zhulusanguo
//
//  Created by qing on 15/3/27.
//  Copyright 2015年 qing lai. All rights reserved.
//



#import <Foundation/Foundation.h>
#import "cocos2d.h"

#import "ShareGameManager.h"
#import "TouchableSprite.h"
#import "HeroObject.h"
#import "MoveTouchStateSprite.h"



@interface DiaoDongLayer : CCLayer {
    SlideDirection slideDirection_;
    CGRect contentRect_;
    BounceDirection direction_;
    bool isDragging_;
    CCNode* virtualLayer;
    float lasty;
    float xvel;
    float contentHeight;
    
    float minTopY;
    float maxBottomY;
    
    int _targetCityID;
    
    int _payment;
    
    float bounceDistance;
    
    NSMutableArray* _heroSelected;
}

+ (id) slidingLayer:(SlideDirection) slideDirection contentRect:(CGRect)contentRect withTargetCityID:(int)tcid;
- (id) initSlidingLayer:(SlideDirection) slideDirection contentRect:(CGRect)contentRect withTargetCityID:(int)tcid;
-(void) updateChildVisible:(CCNode*)ch;
-(void) addChildToVirtualNode:(CCNode*)child;

-(void) updateVisibleInLayer;

@end
