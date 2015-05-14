//
//  AllRecruitLayer.h
//  zhulusanguo
//
//  Created by qing on 15/4/10.
//  Copyright 2015年 qing lai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

#import "ShareGameManager.h"
#import "TouchableSprite.h"    //最后点击招募时要用到的按钮
#import "HeroObject.h"

//#import "ReceiveDropSprite.h"     //看看是否合适，不合适就要改写一个新类，用于接收左边的兵种拖拉
//#import "ArticleDragSprite.h"     //兵种在拖拉中动态创建的图像，需要重写，其中要包含兵种的类型
//#import "SkillDragTouchSprite.h"  //兵种在leftlayer上创建的图像，包含兵种类型，费用等

#import "UnitDragSprite.h"
#import "RecruitDragTouchSprite.h"
#import "UnitReceiveDropSprite.h"

#import "CCLabelTTFWithInfo.h"
#import "CCControlExtension.h"

//#import "SkillInfoMovableSprite.h"



@interface AllRecruitLayer : CCLayer {
    int _dragItemID;  //for item in left layer id , or in right layer id.
    LayerDragMode layerDragState;
    
    int _cityID;
    int needClose;
    int needClosePayment;
    int showPaymentDialog; //当出现调整slider窗口时，该值==1
    
    int currentTroopType;
    int currentTroopCount;
    int currentHeroID;
    int maxTroopCount;
    int recruitTroopCount; //in the pay dialog must use
    
    CCNode* leftLayer;
    CCNode* rightLayer;
    CGRect leftContent;
    CGRect rightContent;
    
    CCNode* paymentLayer;
    CCLabelTTF* recuritLabel;
    CCLabelTTF* rgLabel;
    CCLabelTTF* rwLabel;
    CCLabelTTF* riLabel;
    
    
    float bounceDistance;
    
    float minTopLeftY;
    float maxBottomLeftY;
    float minTopRightY;
    float maxBootomRightY;
    
    
    CCArray* receivers;
    CCArray* troopCountLabels;
    
    
    
    
}

+ (id) contentRect1:(CGRect)left contentRect2:(CGRect)right withCityID:(int)tcid;
- (id) initcontentRect1:(CGRect)left contentRect2:(CGRect)right withCityID:(int)tcid;
-(void) updateLeftChildVisible:(CCNode*)ch;
-(void) updateRightChildVisible:(CCNode*)ch;

-(void) updateLeftLayerVisible;
-(void) updateRightLayerVisible;


-(void) recruitTroopForHero;
-(void) closePaymentDialog;



-(void) checkReceiveSprite:(UnitDragSprite*)_drag;


@end
