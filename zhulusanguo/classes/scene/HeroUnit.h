//
//  HeroUnit.h
//  zhulusanguo
//
//  Created by qing on 15/4/13.
//  Copyright 2015年 qing lai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

#import "ShareGameManager.h"
#import "HeroObject.h"


//matrixs from top left to bottom right. (2,2) - (19,9)

//state : alive , retreat , dead...

//belong: 1 self, 2 enemy.


@interface HeroUnit : CCSprite {
    CGPoint mapPosition; //(1,1) - (20,1) , (1,10) - (20,10)
}

-(void) showMovableGrids;


@end
