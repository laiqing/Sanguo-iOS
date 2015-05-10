//
//  NPC1WalkerSprite.h
//  zhulusanguo
//
//  Created by qing on 15/5/4.
//  Copyright 2015年 qing lai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "ShareGameManager.h"

@interface NPC1WalkerSprite : CCSprite {
    float walkRangeX;
    CGPoint startPos;
    CGPoint leftDownPos;
    CGPoint rightDownPos;
    CGPoint endPos;
    
    BOOL _touchable;
    UIView* uvi;
}

-(void) initRange:(float)range_ range2:(float)r2_;
-(void) cleanupBeforeRelease;

@end
