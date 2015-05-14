//
//  UnitReceiveDropSprite.h
//  zhulusanguo
//
//  Created by qing on 15/5/11.
//  Copyright 2015年 qing lai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface UnitReceiveDropSprite : CCSprite {
    int _heroID;
    int _count;
    int _unitTypeID;
}

@property (nonatomic,assign) int heroID;
@property (nonatomic,assign) int count;
@property (nonatomic,assign) int unitTypeID;

@end
