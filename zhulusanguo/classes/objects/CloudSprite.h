//
//  CloudSprite.h
//  sanguo
//
//  Created by lai qing on 15/1/27.
//  Copyright 2015年 qing lai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface CloudSprite : CCSprite {
    float _maxX;
    float _moveOff;
}

-(void) initBoundary:(float)maxX  withYPos:(float)posy;

@end
