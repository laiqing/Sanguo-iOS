//
//  CityInfoObject.h
//  sanguo
//
//  Created by lai qing on 15/1/26.
//  Copyright (c) 2015年 qing lai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CityInfoObject : NSObject
{
    int _cityID;
    NSString *_enName;
    NSString *_cnName;
    int _posx;
    int _posy;
    int _flagID;
    int _capital;
    int _level;
    int _hall;
    int _barrack;
    int _archer;
    int _cavalry;
    int _wizard;
    int _blacksmith;
    int _tavern;
    int _market;
    int _lumbermill;
    int _steelmill;
    int _magictower;
    int _tower1;
    int _tower2;
    int _tower3;
    int _tower4;
    int _warriorCount;
    int _archerCount;
    int _cavalryCount;
    int _wizardCount;
    int _ballistaCount;
}

@property (nonatomic, copy) NSString* enName;
@property (nonatomic, copy) NSString* cnName;
@property (nonatomic, assign) int cityID;
@property (nonatomic, assign) int posx;
@property (nonatomic, assign) int posy;
@property (nonatomic, assign) int flagID;
@property (nonatomic, assign) int capital;
@property (nonatomic, assign) int level;
@property (nonatomic, assign) int hall;
@property (nonatomic, assign) int barrack;
@property (nonatomic, assign) int archer;
@property (nonatomic, assign) int cavalry;
@property (nonatomic, assign) int wizard;
@property (nonatomic, assign) int blacksmith;
@property (nonatomic, assign) int tavern;
@property (nonatomic, assign) int market;
@property (nonatomic, assign) int lumbermill;
@property (nonatomic, assign) int steelmill;
@property (nonatomic, assign) int magictower;
@property (nonatomic, assign) int tower1;
@property (nonatomic, assign) int tower2;
@property (nonatomic, assign) int tower3;
@property (nonatomic, assign) int tower4;
@property (nonatomic, assign) int warriorCount;
@property (nonatomic, assign) int archerCount;
@property (nonatomic, assign) int cavalryCount;
@property (nonatomic, assign) int wizardCount;
@property (nonatomic, assign) int ballistaCount;


@end
