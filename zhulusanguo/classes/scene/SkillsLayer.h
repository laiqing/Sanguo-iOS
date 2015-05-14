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
//#import "MoveTouchStateSprite.h"  //for info button

//#import "DragableTouchSprite.h"   //for skill icon button
//#import "ReceiveDropSprite.h"     //for hero skill receive button
#import "ArticleDragSprite.h"     //for skill icon drag
#import "SkillDragTouchSprite.h"
#import "SkillInfoMovableSprite.h"
#import "ReceiveSkillDropSprite.h"

//#import "CCLabelTTFWithInfo.h"    //no need


@interface SkillsLayer : CCLayer {
    //int _dragging;
    //int _moveLeftLayer;
    //int _moveRightLayer;
    int _dragItemID;  //for item in left layer id , or in right layer id.
    LayerDragMode layerDragState;
    
    int _cityID;
    int needClose;
    
    CCNode* leftLayer;
    CCNode* rightLayer;
    CGRect leftContent;
    CGRect rightContent;
    
    float bounceDistance;
    
    float minTopLeftY;
    float maxBottomLeftY;
    float minTopRightY;
    float maxBootomRightY;
    
    
    CCArray* receivers;
    //CCArray* heroskills;
    
    
}

+ (id) contentRect1:(CGRect)left contentRect2:(CGRect)right withCityID:(int)tcid;
- (id) initcontentRect1:(CGRect)left contentRect2:(CGRect)right withCityID:(int)tcid;
-(void) updateLeftChildVisible:(CCNode*)ch;
-(void) updateRightChildVisible:(CCNode*)ch;

-(void) updateLeftLayerVisible;
-(void) updateRightLayerVisible;


-(void) showSkillDetail:(NSNumber*)skID;
-(void) hideSkillDetail;
//-(void) refreshLeftLayer;
//-(void) updateArticleItemForHero:(int)hid withArticle:(int)aid articlePos:(int)apid;
-(void) updateHeroSkill:(int)hid skill:(int)skid skillPos:(int)skposID;

-(void) checkReceiveSprite:(ArticleDragSprite*)_drag;


@end
