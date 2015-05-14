//
//  UnitDragSprite.h
//  zhulusanguo
//
//  Created by qing on 15/5/11.
//  Copyright 2015年 qing lai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface UnitDragSprite : CCSprite {
    int _heroID;
    int _unitTypeID;  //1表示步兵，2弓兵，3骑兵，4策士，5弩车
    int _unitCount;
}

@property (nonatomic,assign) int unitTypeID;
@property (nonatomic,assign) int heroID;
@property (nonatomic,assign) int unitCount;

@end
