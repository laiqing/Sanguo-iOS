//
//  ArticleLayer.h
//  zhulusanguo
//
//  Created by qing on 15/4/6.
//  Copyright 2015年 qing lai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

#import "ShareGameManager.h"
#import "TouchableSprite.h"
#import "HeroObject.h"
//#import "MoveTouchStateSprite.h"
#import "ArticleObject.h"
#import "DragableTouchSprite.h"
#import "ReceiveDropSprite.h"
#import "ArticleDragSprite.h"
#import "CCLabelTTFWithInfo.h"

@interface ArticleLayer : CCLayer {
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
    

    CCArray* receivers;
    CCArray* hplabels;
    CCArray* mplabels;
    CCArray* attacklabels;
    CCArray* desclabels;
    
}

+ (id) contentRect1:(CGRect)left contentRect2:(CGRect)right withCityID:(int)tcid;
- (id) initcontentRect1:(CGRect)left contentRect2:(CGRect)right withCityID:(int)tcid;
-(void) updateLeftChildVisible:(CCNode*)ch;
-(void) updateRightChildVisible:(CCNode*)ch;

-(void) updateLeftLayerVisible;
-(void) updateRightLayerVisible;

-(void) refreshLeftLayer;
-(void) updateArticleItemForHero:(int)hid withArticle:(int)aid articlePos:(int)apid;

-(void) checkReceiveSprite:(ArticleDragSprite*)_drag;

@end
