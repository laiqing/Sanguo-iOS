//
//  SkillObject.h
//  zhulusanguo
//
//  Created by qing on 15/4/13.
//  Copyright (c) 2015年 qing lai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SkillObject : NSObject
{
    int _skillID;  // for skill ID from json
    int _skillType;  // 1.辅助类固定点数对自己用，加攻击、加范围、加hp等固定点数   2.辅助类固定点数对敌人用，减攻击等等  3.辅助类随机点数，如治疗，冥想
                     // 4.攻击类随机点数，如火计等  5.被动类助攻击，如助火    6.被动类反击，如反计    7.被动类辅助，如土豪
    NSArray* _removeSkills;  //针对的目标技能列表，可以解决的目标技能，如沉着，可以解决混乱
    NSArray* _assistSkills;  //可以辅助的目标技能列表，如助火，可以辅助火计，火箭
    int _skillLevel;   //skill 等级，在哪一级的技能塔里可以有
    int _cost;   //使用该技能的消耗mp
    int _passive;  //是否被动
    int _singleOrAll;  //是单体技能还是群体技能
    int _requireArmyType;  //本技能要求装备的目标武将的类型：步兵？弓兵？骑兵？
    int _requireStrength;
    int _requireIntelligence;
    int _targetArmyType; //对自己使用，自己及友军使用，自己及仅己方英雄不包括部队使用，所有友军使用，敌人武将使用，敌人部队使用，敌人武将和部队使用，－1则是被动技能忽略
                         //仅友方步兵可用，仅友方弓兵可用，仅友方骑兵可用，仅友方弩车可用（机甲）
    int _targetPremiseState; //对方部队应在哪个状态
    int _range; //默认都是4格，与弓箭手一样...
    
    int _damage;    //用于随机点数，从caster对象获取。。。。
    int _effect1;   //如残酷，effect1是自己的hp --，effect2是自己的攻击力 ++
    int _effect2;
    
    CGPoint _casterPosition;  // (2,2) - (19,9)
    CGPoint _targetPosition;  //  必须在casterPosition距离为4的范围内
    
    id _caster;
    id _destination;  //dest hero or troop
    
    
    int _skillEffectRange; //如，只对自己用，只对自己及范围内友军用，只对范围内敌军用....
    int _damageRate;  //伤害率，例如火计是1.2，水计是1.5，雷击时1.8
    int _needDragToCast; // 0 , player touch to cast
                         // 1 , player drag to target to cast
    
    
}


//init all var....
-(void) initAllFromSkillID:(int)sid FromHero:(int)hid;
-(void) initAllFromSkillID:(int)sid FromArmy:(int)armyTypeID withHeroLevel:(int)hlev;  //1.

-(void) calcTargetRange;    //获得layer对象里的所有hero 和 troop，计算其是否在自己的攻击范围内，然后让layer给这些hero的z更高等级上加上攻击图标
                            //如果能攻击死，则加上一个骷髅头
-(void) executeSkill;

-(BOOL) checkTargetHeroValid:(int)hid;
-(BOOL) checkTargetArmyValid:(int)armyTypeID;   //检验对方是否合适使用此技能

-(void) removeEffect;       //when call by scene, remove this effect on destination , remove the icon on all possible target unit.


@property (assign,nonatomic) int needDragToCast;

@end
