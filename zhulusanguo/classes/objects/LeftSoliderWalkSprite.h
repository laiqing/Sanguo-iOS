//
//  LeftSoliderWalkSprite.h
//  zhulusanguo
//
//  Created by qing on 15/3/29.
//  Copyright 2015年 qing lai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface LeftSoliderWalkSprite : CCSprite {
    float walkRangeX;
    CGPoint startPos;
    CGPoint endPos;
}

-(void) initRange:(float)range_;

@end
