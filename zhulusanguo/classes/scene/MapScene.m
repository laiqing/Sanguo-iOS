//
//  MapScene.m
//  zhulusanguo
//
//  Created by qing on 15/3/26.
//  Copyright 2015年 qing lai. All rights reserved.
//

#import "MapScene.h"


@implementation MapScene

-(id) init
{
    if ((self = [super init])) {
        mlayer = [MapLayer node];
        mlayer.tag = 1;
        [self addChild:mlayer z:0];
        
        hudlayer = [MapHUDLayer node];
        hudlayer.tag = 2;
        [self addChild:hudlayer z:1];
        
    }
    return self;
}

@end
