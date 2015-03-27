//
//  MapScene.h
//  zhulusanguo
//
//  Created by qing on 15/3/26.
//  Copyright 2015年 qing lai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "MapLayer.h"
#import "MapHUDLayer.h"

@interface MapScene : CCScene {
    MapLayer *mlayer;
    MapHUDLayer *hudlayer;
}



@end
