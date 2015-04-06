//
//  CityScene.m
//  zhulusanguo
//
//  Created by qing on 15/3/28.
//  Copyright 2015年 qing lai. All rights reserved.
//

#import "CityScene.h"


@implementation CityScene

+(id)nodeWithCityID:(int)cid
{
    return [[[self alloc] initWithCityID:cid] autorelease];
}

-(id)initWithCityID:(int)cid
{
    if ((self = [super init])) {
        cmlayer = [[[CityMainLayer alloc] initWithCityID:cid] autorelease] ;
        cmlayer.tag = 1;
        [self addChild:cmlayer z:0];
    }
    return self;
}

@end
