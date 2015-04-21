//
//  LeftSoliderWalkSprite.h
//  zhulusanguo
//
//  Created by qing on 15/3/29.
//  Copyright 2015年 qing lai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

#import "ShareGameManager.h"
#import "TipObject.h"

@interface LeftSoliderWalkSprite : CCSprite<CCTouchOneByOneDelegate> {
    float walkRangeX;
    CGPoint startPos;
    CGPoint endPos;
    
    BOOL _touchable;
    UIView* uvi;
}

-(void) initRange:(float)range_;
-(void) cleanupBeforeRelease;

@end
