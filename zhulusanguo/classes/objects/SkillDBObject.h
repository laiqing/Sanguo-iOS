//
//  SkillDBObject.h
//  zhulusanguo
//
//  Created by qing on 15/5/9.
//  Copyright (c) 2015年 qing lai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface SkillDBObject : NSObject
{
    int _skillID;
    NSString *_cname;
    NSString *_ename;
    NSString *_cdesc;
    NSString *_edesc;
    int _passive;
    int _canLearn;
    int _skillLevel;
    int _strengthRequire;
    int _intelligenceRequire;
    int _requireWeather;
    int _cost;
    int _cityID;
}

@property (nonatomic,assign) int skillID;
@property (nonatomic,retain) NSString* cname;
@property (nonatomic,retain) NSString* ename;
@property (nonatomic,retain) NSString* cdesc;
@property (nonatomic,retain) NSString* edesc;
@property (nonatomic,assign) int passive;
@property (nonatomic,assign) int canLearn;
@property (nonatomic,assign) int skillLevel;
@property (nonatomic,assign) int strengthRequire;
@property (nonatomic,assign) int intelligenceRequire;
@property (nonatomic,assign) int requireWeather;
@property (nonatomic,assign) int cost;
@property (nonatomic,assign) int cityID;

@end
