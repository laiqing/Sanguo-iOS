//
//  CityInfoObject.m
//  sanguo
//
//  Created by lai qing on 15/1/26.
//  Copyright (c) 2015年 qing lai. All rights reserved.
//

#import "CityInfoObject.h"

@implementation CityInfoObject

@synthesize cityID = _cityID;
@synthesize flagID = _flagID;
@synthesize posx = _posx;
@synthesize posy = _posy;
@synthesize cnName = _cnName;
@synthesize enName = _enName;
@synthesize capital = _capital;
@synthesize level = _level;
@synthesize hall = _hall;
@synthesize barrack = _barrack;
@synthesize archer = _archer;
@synthesize wizard = _wizard;
@synthesize blacksmith = _blacksmith;
@synthesize tavern = _tavern;
@synthesize market = _market;
@synthesize lumbermill = _lumbermill;
@synthesize steelmill = _steelmill;
@synthesize magictower = _magictower;
@synthesize tower1 = _tower1;
@synthesize tower2 = _tower2;
@synthesize tower3 = _tower3;
@synthesize tower4 = _tower4;
@synthesize warriorCount = _warriorCount;




-(void) dealloc
{
    if (_cnName) {
        [_cnName release];
    }
    if (_enName) {
        [_enName release];
    }
    [super dealloc];
}

@end
