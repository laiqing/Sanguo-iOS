//
//  CCLabelTTFWithInfo.h
//  zhulusanguo
//
//  Created by qing on 15/5/8.
//  Copyright 2015年 qing lai. All rights reserved.
//
//  这个类用在articleLayer，用于显示每个武将的具体hp , mp等，
//  当武将增加了新的武器，需要刷新，因此需要有id，从而能在array里找到合适的标签
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface CCLabelTTFWithInfo : CCLabelTTF {
    int _asscoiateID;
    int _asscoiatePosID;
}

@property (nonatomic,assign) int asscoiateID;
@property (nonatomic,assign) int asscoiatePosID;

@end
