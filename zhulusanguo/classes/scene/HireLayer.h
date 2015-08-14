//
//  HireLayer.h
//  zhulusanguo
//
//  Created by qing on 15/4/10.
//  Copyright 2015年 qing lai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

#import "ShareGameManager.h"
#import "HeroObject.h"
#import "HeroInfoMovableSprite.h"

#import "TouchableSprite.h"  //for the skill icon , to see skill detail
                             //for the hire button , to hire this hero

@interface HireLayer : CCLayer {
    int _dragItemID;  //for item in left layer id , or in right layer id.
    LayerDragMode layerDragState;
    
    int _cityID;
    int needClose;
    
    CCSprite *herobg;
    CCSprite *itembg;
    
    CCNode* leftLayer;
    CCNode* rightLayer;
    CGRect leftContent;
    CGRect rightContent;
    
    CGPoint effpos;
    int hirecost;
    
    float bounceDistance;
    
    float minTopLeftY;
    float maxBottomLeftY;
    float minTopRightY;
    float maxBootomRightY;
}

+ (id) contentRect1:(CGRect)left contentRect2:(CGRect)right withCityID:(int)tcid;
- (id) initcontentRect1:(CGRect)left contentRect2:(CGRect)right withCityID:(int)tcid;
-(void) updateLeftChildVisible:(CCNode*)ch;
-(void) updateRightChildVisible:(CCNode*)ch;
-(void) updateLeftLayerVisible;
-(void) updateRightLayerVisible;

-(void) showHeroDetail:(NSNumber*)hid;
-(void) showSkillDetail:(NSNumber*)skid;

-(void) closeSkillDetailIfOpened;
-(void) hireHeroForID:(NSNumber*)hid;
-(void) refreshLeftLayer;

@end
