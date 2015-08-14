//
//  HeroUnit.h
//  zhulusanguo
//
//  Created by qing on 15/4/13.
//  Copyright 2015年 qing lai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

#import "ShareGameManager.h"
#import "HeroObject.h"

#import "TroopUnit.h"


//matrixs from top left to bottom right. (2,2) - (19,9)

//state : alive , retreat , dead...

//belong: 1 self, 2 enemy.


@interface HeroUnit : CCSprite {
    CGPoint mapPosition; //(1,1) - (20,1) , (1,10) - (20,10)
    CCArray* historyEffects;
    
    int _heroID;
    int _attackOrDefend; //1 attack , 2 defend
    HeroObject* _ho;  // this object from db.
    
    //effect by magic
    int _attackEffect;
    int _hpEffect;
    int _moveEffect;
    int _attackRangeEffect;
    
    int _heroState;  // 0001 , 0011 , 0111, 1111. 正常，中毒，陷阱，混乱，无双 , 不正常为撤退 , -1 撤退
    
    //multiattack , doubleattack. by the article
    int _multiAttack;
    int _doubleAttack;
    int _articleAttackEffect; //effect from article which can not be removed
    int _articleMoveEffect; //effect from article which can not be removed, for inst: a horse
    int _articleHPEffect;  //
    int _articleMPEffect;  //
    int _articleAttackRangeEffect;
    
    
    int _currentHP;
    int _maxHP;
    int _currentMP;
    int _maxMP;
    int _articleAddHP;
    int _articleAddMP;
    int _articleAddMove;
    int _articleAddAttackRange;
    int _articleAddMultiAttack;
    int _articleAddDoubleAttack;
    //int _experiences;
    
    int _belong; // 1 . 自己 ， 2. 敌人
    int _actionState;  // 1.未移动 2.已移动未攻击 3.已移动和已攻击
    
    
}

-(void) showMovableGrids;
-(void) showHeroInfoDlg;
-(void) showHeroSkillButtons;

-(void) initAll;
-(void) initArticleEffect;

-(TroopUnit*) initTroopUnit:(int)whichside;

-(void) calcCanMoveGrids; //计算可以移动到的格子
-(void) calcCanDefeatBots;  //计算可以杀死的bot，加上图标

-(void) onAssistMagicAttack; //当友方使用技能时，查看是否有被动技能可以协助，在函数内使用 for sk in all skills loop, sk.onAssistMagicAttack()
-(void) onResistMagicAttack; //当敌方使用技能时，查看是否有被动技能可以抵消，例如：扰咒，可以抵消掉对方的速攻等技能
-(void) beforeReceiveMagicAttack;  //当敌人施展一个技能，且目标为自己时，需要检查是否有passive技能来抵消

-(void) onReceivePhyAttack:(BOOL)canFightBack;
-(void) onReceiveMagicAttack;  // -hp , if has the the passive skill , then fight back

-(void) beforeSelfPhyAttack; // for 爆击，if has, then double the attack, and after attack, remove the attack
-(void) afterSelfPhyAttack;  // for 无双，need to remove 无双的标志

-(void) doPhyAttack:(int)targetID heroOrUnit:(int)horu canFightBack:(BOOL)canback; //do phy attack to a role with targetID. horu:1 , hero, horu 2, unit, canback , 如果当前自己有无双，则设置为false

-(void) doMagicAttack:(int)targetID HeroOrUnit:(int)horu  skillID:(int)skID; //

-(void) upgradeLevel; // after battle, upgrade level with experiences

@end
