//
//  HeroObject.h
//  zhulusanguo
//
//  Created by qing on 15/3/25.
//  Copyright (c) 2015年 qing lai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HeroObject : NSObject
{
    int _heroID;
    NSString* _cname;
    NSString* _ename;
    int _ownerID;
    int _headImageID;
    int _skill1;
    int _skill2;
    int _skill3;
    int _armyAttackImageID;
    int _armyDefendImageID;
    int _cityID;
    int _strength;
    int _intelligence;
    int _level;
    int _move;
    int _attackRange;
    int _article1;
    int _article2;
    int _experience;
    int _alive;
    int _troopAttack;
    int _troopMental;
    int _troopType;
    int _troopCount;
}


@property (nonatomic,assign) int heroID;
@property (nonatomic,copy) NSString* cname;
@property (nonatomic,copy) NSString* ename;
@property (nonatomic,assign) int ownerID;
@property (nonatomic,assign) int headImageID;
@property (nonatomic,assign) int skill1;
@property (nonatomic,assign) int skill2;
@property (nonatomic,assign) int skill3;
@property (nonatomic,assign) int armyAttackImageID;
@property (nonatomic,assign) int armyDefendImageID;
@property (nonatomic,assign) int cityID;
@property (nonatomic,assign) int strength;
@property (nonatomic,assign) int intelligence;
@property (nonatomic,assign) int level;
@property (nonatomic,assign) int move;
@property (nonatomic,assign) int attackRange;
@property (nonatomic,assign) int article1;
@property (nonatomic,assign) int article2;
@property (nonatomic,assign) int experience;
@property (nonatomic,assign) int alive;
@property (nonatomic,assign) int troopAttack;
@property (nonatomic,assign) int troopMental;
@property (nonatomic,assign) int troopType;
@property (nonatomic,assign) int troopCount;


@end
