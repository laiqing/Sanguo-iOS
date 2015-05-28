//
//  TradeLayer.h
//  zhulusanguo
//
//  Created by qing on 15/4/10.
//  Copyright 2015年 qing lai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

#import "ShareGameManager.h"
#import "TouchableSprite.h"    //最后点击交易时要用到的按钮

//#import "ReceiveDropSprite.h"     //看看是否合适，不合适就要改写一个新类，用于接收左边的兵种拖拉
//#import "ArticleDragSprite.h"     //兵种在拖拉中动态创建的图像，需要重写，其中要包含兵种的类型
//#import "SkillDragTouchSprite.h"  //兵种在leftlayer上创建的图像，包含兵种类型，费用等

#import "ResourceDragSprite.h"
#import "ResourceReceiveDropSprite.h"
#import "ResourceDragTouchSprite.h"

#import "CityInfoObject.h"

//#import "CCLabelTTFWithInfo.h"
#import "CCControlExtension.h"

@interface TradeLayer : CCLayer {
    int _dragItemID;  //for item in left layer id , or in right layer id.
    LayerDragMode layerDragState;
    
    int _cityID;
    int needClose;
    int needClosePayment;
    int showPaymentDialog; //当出现调整slider窗口时，该值==1
        
    int currentResForOutType;  //要卖出的resource
    int currentResForInType;   //要买入的resource
    int currentResOutCount;    //当前已经卖出的resource数量
    int currentResInCount;     //当前已经买入的resource数量
    int maxResInCount;         //可以买入的resource最大数目
    int currentRate;           //当前兑换的汇率
    //int recruitTroopCount; //in the pay dialog must use
    
    CCNode* leftLayer;
    CCNode* rightLayer;
    CGRect leftContent;
    CGRect rightContent;
    
    CCNode* paymentLayer;
    CCLabelTTF* resourceOutLabel;
    CCLabelTTF* resourceInLabel;
    
    CCLabelTTF* goldLabel;
    CCLabelTTF* woodLabel;
    CCLabelTTF* ironLabel;
    
    ResourceDragTouchSprite* goldtouch;
    ResourceDragTouchSprite* woodtouch;
    ResourceDragTouchSprite* irontouch;
    
    float bounceDistance;
    
    float minTopLeftY;
    float maxBottomLeftY;
    float minTopRightY;
    float maxBootomRightY;
    
    
    CCArray* receivers;
}

+ (id) contentRect1:(CGRect)left contentRect2:(CGRect)right withCityID:(int)tcid;
- (id) initcontentRect1:(CGRect)left contentRect2:(CGRect)right withCityID:(int)tcid;
//-(void) updateLeftChildVisible:(CCNode*)ch;
//-(void) updateRightChildVisible:(CCNode*)ch;
//-(void) updateLeftLayerVisible;
//-(void) updateRightLayerVisible;

-(void) tradeResource;
-(void) closePaymentDialog;
-(void) checkReceiveSprite:(ResourceDragSprite*)_drag;

@end
