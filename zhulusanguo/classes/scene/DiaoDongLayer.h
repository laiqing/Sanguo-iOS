//
//  DiaoDongLayer.h
//  zhulusanguo
//
//  Created by qing on 15/3/27.
//  Copyright 2015年 qing lai. All rights reserved.
//

#define FRAME_RATE 60
#define BOUNCE_TIME 0.2f

#import <Foundation/Foundation.h>
#import "cocos2d.h"

#import "ShareGameManager.h"
#import "TouchableSprite.h"
#import "HeroObject.h"

typedef enum{
    Vertically,
    Horizontally
} SlideDirection;

typedef enum{
    BounceDirectionGoingUp = 1,
    BounceDirectionStayingStill = 0,
    BounceDirectionGoingDown = -1,
    BounceDirectionGoingLeft = 2,
    BounceDirectionGoingRight = 3
} BounceDirection;

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
}

+ (id) slidingLayer:(SlideDirection) slideDirection contentRect:(CGRect)contentRect withTargetCityID:(int)tcid;
- (id) initSlidingLayer:(SlideDirection) slideDirection contentRect:(CGRect)contentRect withTargetCityID:(int)tcid;
- (void) update:(ccTime) deltaTime;
-(void) updateChildVisible:(CCNode*)ch;
-(void) addChildToVirtualNode:(CCNode*)child;

@end
