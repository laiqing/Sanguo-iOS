//
//  ForgeLayer.h
//  zhulusanguo
//
//  Created by qing on 15/4/10.
//  Copyright 2015年 qing lai. All rights reserved.
//
//  购买宝物的界面
//  只显示前几样，每个月会更换好的宝物
//  no need to drag in layer
//  touch outside then close layer




#import <Foundation/Foundation.h>
#import "cocos2d.h"

#import "ShareGameManager.h"
#import "TouchableBuySprite.h"
#import "ArticleObject.h"

@interface ForgeLayer : CCLayer<MoneyEffectProtocol> {
    int _dragItemID;  //for item in left layer id , or in right layer id.
    int _scrollType;  //1 left scroll , 2 right scroll, 3 touch on the item icon, 4 touch outside -- close.
    LayerDragMode layerDragState;
    
    int _cityID;
    int needClose;
    
    CCNode* leftLayer;
    CCNode* rightLayer;
    CGRect leftContent;
    CGRect rightContent;
    
    float minTopLeftY;
    float maxBottomLeftY;
    float minTopRightY;
    float maxBootomRightY;
    
    float bounceDistance;
    
    CGPoint stPosi[8];
    
}

//only rect1 have value

+ (id) contentRect1:(CGRect)left contentRect2:(CGRect)right withCityID:(int)tcid;
- (id) initcontentRect1:(CGRect)left contentRect2:(CGRect)right withCityID:(int)tcid;
//-(void) updateLeftChildVisible:(CCNode*)ch;
//-(void) updateRightChildVisible:(CCNode*)ch;

//-(void) updateLeftLayerVisible;
//-(void) updateRightLayerVisible;


-(void) buyArticleWithItem:(NSNumber*)arID withPosID:(NSNumber*)poID;

-(void) refreshLayer;  //after buying some article , remove the article info from the layer

//-(void) updateArticleItemForHero:(int)hid withArticle:(int)aid articlePos:(int)apid;

//-(void) checkReceiveSprite:(ArticleDragSprite*)_drag;

@end
