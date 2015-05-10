//
//  ArticleObject.h
//  zhulusanguo
//
//  Created by qing on 15/5/6.
//  Copyright (c) 2015年 qing lai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ArticleObject : NSObject
{
    int _aid;
    NSString* _ename;
    NSString* _cname;
    NSString* _edesc;
    NSString* _cdesc;
    
    int _attack;
    int _hp;
    int _mp;
    int _attackRange;
    int _moveRange;
    int _multiAttack;
    int _doubleAttack;
    
    int _gold;
    int _wood;
    int _iron;
    
    int _requireArmyType;
    int _effectTypeID;
    int _articleType;
}

@property (nonatomic, copy) NSString* ename;
@property (nonatomic, copy) NSString* cname;
@property (nonatomic, copy) NSString* cdesc;
@property (nonatomic, copy) NSString* edesc;

@property (nonatomic, assign) int aid;
@property (nonatomic, assign) int attack;
@property (nonatomic, assign) int hp;
@property (nonatomic, assign) int mp;
@property (nonatomic, assign) int attackRange;
@property (nonatomic, assign) int moveRange;
@property (nonatomic, assign) int multiAttack;
@property (nonatomic, assign) int doubleAttack;
@property (nonatomic, assign) int gold;
@property (nonatomic, assign) int wood;
@property (nonatomic, assign) int iron;

@property (nonatomic, assign) int requireArmyType;
@property (nonatomic, assign) int effectTypeID;
@property (nonatomic, assign) int articleType;



@end
