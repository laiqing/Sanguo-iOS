//
//  DistributeLayer.h
//  zhulusanguo
//
//  Created by qing on 15/4/10.
//  Copyright 2015年 qing lai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

#import "ShareGameManager.h"
#import "TouchableSprite.h"    //最后点击确认调整部队时要用到的按钮
#import "HeroObject.h"

#import "UnitDragSprite.h"
//#import "RecruitDragTouchSprite.h"
#import "TroopDragTouchSprite.h"
#import "UnitReceiveDropSprite.h"

#import "CCLabelTTFWithInfo.h"
#import "CCControlExtension.h"


@interface DistributeLayer : CCLayer {
    int _dragItemID;  //for item in left layer id , or in right layer id.
    LayerDragMode layerDragState;
    
    int _cityID;
    int needClose;
    int needClosePayment;
    int showPaymentDialog; //当出现调整slider窗口时，该值==1
    
    int currentTroopType;
    int currentLeftTroopCount;
    int currentRightTroopCount;
    int currentLeftHeroID;
    int currentRightHeroID;
    int maxTroopCount;
    //int recruitTroopCount; //in the pay dialog must use
    
    CCNode* leftLayer;
    CCNode* rightLayer;
    CGRect leftContent;
    CGRect rightContent;
    
    CCNode* paymentLayer;   //用于显示调整兵力的窗口
    CCLabelTTF* leftCountLabel;  //调整兵力窗口，左边英雄的兵力
    CCLabelTTF* rightCountLabel; //右边的
    //CCLabelTTF* recuritLabel;
    //CCLabelTTF* rgLabel;
    //CCLabelTTF* rwLabel;
    //CCLabelTTF* riLabel;
    
    
    float bounceDistance;
    
    float minTopLeftY;
    float maxBottomLeftY;
    float minTopRightY;
    float maxBootomRightY;
    
    CCArray* senders;
    CCArray* receivers;
    CCArray* troopCountLabels;
}

+ (id) contentRect1:(CGRect)left contentRect2:(CGRect)right withCityID:(int)tcid;
- (id) initcontentRect1:(CGRect)left contentRect2:(CGRect)right withCityID:(int)tcid;
-(void) updateLeftChildVisible:(CCNode*)ch;
-(void) updateRightChildVisible:(CCNode*)ch;
-(void) updateLeftLayerVisible;
-(void) updateRightLayerVisible;


-(void) changeHeroTroop;
-(void) closeChangeDialog;


-(void) checkReceiveSprite:(UnitDragSprite*)_drag;

@end
