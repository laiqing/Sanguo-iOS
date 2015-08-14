//
//  AllRecruitLayer.m
//  zhulusanguo
//
//  Created by qing on 15/4/10.
//  Copyright 2015年 qing lai. All rights reserved.
//

#import "AllRecruitLayer.h"


@implementation AllRecruitLayer

+ (id) contentRect1:(CGRect)left contentRect2:(CGRect)right withCityID:(int)tcid
{
    return [[[self alloc] initcontentRect1:left contentRect2:right withCityID:tcid] autorelease];
}

- (id) initcontentRect1:(CGRect)left contentRect2:(CGRect)right withCityID:(int)tcid
{
    if ((self=[super init])) {
        
        currentHeroID = -1;
        currentTroopCount = 0;
        currentTroopType = 0;
        maxTroopCount = 0;
        recruitTroopCount = 0;
        
        _cityID = tcid;
        leftContent = left;
        rightContent = right;
        
        currentHeroID = -1;
        currentTroopType = -1;
        currentTroopCount = -1;
        needClosePayment = 0;
        showPaymentDialog = 0;
        
        leftLayer = [[[CCNode alloc] init] autorelease];
        rightLayer = [[[CCNode alloc] init] autorelease];
        
        [self addChild:leftLayer z:1];
        [self addChild:rightLayer z:1];
        
        bounceDistance = 0;
        needClose = 0;
        
        receivers = [[CCArray alloc] init];
        troopCountLabels = [[CCArray alloc] init];
        
        minTopLeftY = leftLayer.position.y;
        minTopRightY = rightLayer.position.y;
        
        //两个背景
        
        //now add item bg , hero select bg to the layer children
        CCSprite* itembg = [CCSprite spriteWithSpriteFrameName:@"itemlist.png"];
        CGSize wsize = [[CCDirector sharedDirector] winSize];
        itembg.position = ccp(wsize.width*0.5-168, wsize.height*0.5);
        [self addChild:itembg z:0];
        
        CCLabelTTF* itemtitle = [CCLabelTTF labelWithString:@"可招募兵种" fontName:@"Arial" fontSize:12];
        itemtitle.color = ccYELLOW;
        itemtitle.position = ccp(itembg.position.x, itembg.position.y + itembg.boundingBox.size.height*0.5 - 10);
        [self addChild:itemtitle z:1];
        
        
        CGFloat ibgheight = itembg.boundingBox.size.height;
        
        CCSprite* herobg = [CCSprite spriteWithSpriteFrameName:@"heroselectbg2.png"];
        herobg.position = ccp(wsize.width*0.5+80, wsize.height*0.5);
        [self addChild:herobg z:0];
        
        
        
        CGFloat hfheight;
        
        CityInfoObject* cio = [[ShareGameManager shareGameManager] getCityInfoForCityScene:_cityID];
        
        
        //5个item，显示可以拖拉的recruit unit
        CCSprite* hf = [CCSprite spriteWithSpriteFrameName:@"itemframe2.png"];
        hfheight = hf.boundingBox.size.height;
        hf.position = ccp(wsize.width*0.5-168, wsize.height*0.5+ibgheight*0.5 - 25 - hfheight*0.5);
        [leftLayer addChild:hf z:1];
        
        //add barrack , if not ready , show gray image , title (not built), hp, mp, attack , mental, move , attack range 6 label
        if (cio.barrack == 1) {
            CCLabelTTF* title = [CCLabelTTF labelWithString:@"步兵" fontName:@"Arial" fontSize:10];
            title.anchorPoint = ccp(0, 0.5);
            title.position = ccp(hf.position.x - hf.boundingBox.size.width*0.4, hf.position.y + hf.boundingBox.size.height*0.35);
            [leftLayer addChild:title z:2];
            
            RecruitDragTouchSprite* ba = [RecruitDragTouchSprite spriteWithSpriteFrameName:@"troop1_right_01.png"];
            ba.position = ccp(title.position.x + 10, title.position.y - 30);
            [leftLayer addChild:ba z:2];
            [ba initTheCallbackFunc0:@selector(checkReceiveSprite:) withCaller:self withTouchID:1 withImg:@"troop1_right_01.png" canDrag:YES];
            
            CCSprite* gold = [CCSprite spriteWithSpriteFrameName:@"gold.png"];
            gold.scale = 0.3;
            gold.anchorPoint = ccp(0, 0.5);
            gold.position = ccp(title.position.x, ba.position.y - 30);
            [leftLayer addChild:gold z:2];
            
            
            int money = TROOP_FOOTMAN_COST_GOLD ;
            NSString *mstr = [NSString stringWithFormat:@"%d",money];
            CCLabelTTF* goldlabel = [CCLabelTTF labelWithString:mstr fontName:@"Arial" fontSize:9];
            goldlabel.anchorPoint = ccp(0, 0.5);
            goldlabel.color = ccWHITE;
            goldlabel.position = ccp(gold.position.x + 20, gold.position.y);
            [leftLayer addChild:goldlabel z:2];
            
            CCSprite* wood = [CCSprite spriteWithSpriteFrameName:@"wood.png"];
            wood.scale = 0.3;
            wood.anchorPoint = ccp(0, 0.5);
            wood.position = ccp(title.position.x, ba.position.y - 42);
            [leftLayer addChild:wood z:2];
            
            
            int woodcost = TROOP_FOOTMAN_COST_WOOD ;
            NSString *wstr = [NSString stringWithFormat:@"%d",woodcost];
            CCLabelTTF* woodlabel = [CCLabelTTF labelWithString:wstr fontName:@"Arial" fontSize:9];
            woodlabel.anchorPoint = ccp(0, 0.5);
            woodlabel.color = ccWHITE;
            woodlabel.position = ccp(wood.position.x + 20, wood.position.y);
            [leftLayer addChild:woodlabel z:2];
            
            CCSprite* iron = [CCSprite spriteWithSpriteFrameName:@"iron.png"];
            iron.scale = 0.3;
            iron.anchorPoint = ccp(0, 0.5);
            iron.position = ccp(title.position.x, ba.position.y - 54);
            [leftLayer addChild:iron z:2];
            
            
            int ironcost = TROOP_FOOTMAN_COST_IRON ;
            NSString *istr = [NSString stringWithFormat:@"%d",ironcost];
            CCLabelTTF* ironlabel = [CCLabelTTF labelWithString:istr fontName:@"Arial" fontSize:9];
            ironlabel.anchorPoint = ccp(0, 0.5);
            ironlabel.color = ccWHITE;
            ironlabel.position = ccp(iron.position.x + 20, iron.position.y);
            [leftLayer addChild:ironlabel z:2];
            
            //hp , mp , attack , mental , move , attack range
            NSString *hpstr = [NSString stringWithFormat:@"HP: %d",TROOP_FOOTMAN_HP];
            CCLabelTTF* hplabel = [CCLabelTTF labelWithString:hpstr fontName:@"Arial" fontSize:9];
            hplabel.anchorPoint = ccp(0, 0.5);
            hplabel.position = ccp(hf.position.x, title.position.y - 10);
            [leftLayer addChild:hplabel z:2];
            
            NSString *mpstr = [NSString stringWithFormat:@"MP: %d",TROOP_FOOTMAN_MP];
            CCLabelTTF* mplabel = [CCLabelTTF labelWithString:mpstr fontName:@"Arial" fontSize:9];
            mplabel.anchorPoint = ccp(0, 0.5);
            mplabel.position = ccp(hf.position.x, title.position.y - 22);
            [leftLayer addChild:mplabel z:2];
            
            NSString *attstr = [NSString stringWithFormat:@"攻击力: %d",TROOP_FOOTMAN_ATTACK];
            CCLabelTTF* attlabel = [CCLabelTTF labelWithString:attstr fontName:@"Arial" fontSize:9];
            attlabel.anchorPoint = ccp(0, 0.5);
            attlabel.position = ccp(hf.position.x, title.position.y - 34);
            [leftLayer addChild:attlabel z:2];
            
            NSString *menstr = [NSString stringWithFormat:@"精神力: %d",TROOP_FOOTMAN_MENTAL];
            CCLabelTTF* menlabel = [CCLabelTTF labelWithString:menstr fontName:@"Arial" fontSize:9];
            menlabel.anchorPoint = ccp(0, 0.5);
            menlabel.position = ccp(hf.position.x, title.position.y - 46);
            [leftLayer addChild:menlabel z:2];
            
            NSString *movestr = [NSString stringWithFormat:@"移动力: %d",TROOP_FOOTMAN_MOVE];
            CCLabelTTF* movelabel = [CCLabelTTF labelWithString:movestr fontName:@"Arial" fontSize:9];
            movelabel.anchorPoint = ccp(0, 0.5);
            movelabel.position = ccp(hf.position.x, title.position.y - 58);
            [leftLayer addChild:movelabel z:2];
            
            NSString *arstr = [NSString stringWithFormat:@"攻击范围:%d",TROOP_FOOTMAN_ATTACK_RANGE];
            CCLabelTTF* arlabel = [CCLabelTTF labelWithString:arstr fontName:@"Arial" fontSize:9];
            arlabel.anchorPoint = ccp(0, 0.5);
            arlabel.position = ccp(hf.position.x, title.position.y - 70);
            [leftLayer addChild:arlabel z:2];
            
            
            
            
            
            
        }
        else {
            CCLabelTTF* title = [CCLabelTTF labelWithString:@"步兵营未造" fontName:@"Arial" fontSize:10];
            title.anchorPoint = ccp(0, 0.5);
            title.position = ccp(hf.position.x - hf.boundingBox.size.width*0.4, hf.position.y + hf.boundingBox.size.height*0.35);
            [leftLayer addChild:title z:2];
            
            RecruitDragTouchSprite* ba = [RecruitDragTouchSprite spriteWithSpriteFrameName:@"troop1_gray_right_01.png"];
            ba.position = ccp(title.position.x + 10, title.position.y - 30);
            [leftLayer addChild:ba z:2];
            [ba initTheCallbackFunc0:@selector(checkReceiveSprite:) withCaller:self withTouchID:1 withImg:@"troop1_gray_right_01.png" canDrag:NO];
            
            CCSprite* gold = [CCSprite spriteWithSpriteFrameName:@"gold.png"];
            gold.scale = 0.3;
            gold.anchorPoint = ccp(0, 0.5);
            gold.position = ccp(title.position.x, ba.position.y - 30);
            [leftLayer addChild:gold z:2];
            
            
            int money = TROOP_FOOTMAN_COST_GOLD ;
            NSString *mstr = [NSString stringWithFormat:@"%d",money];
            CCLabelTTF* goldlabel = [CCLabelTTF labelWithString:mstr fontName:@"Arial" fontSize:9];
            goldlabel.anchorPoint = ccp(0, 0.5);
            goldlabel.color = ccWHITE;
            goldlabel.position = ccp(gold.position.x + 20, gold.position.y);
            [leftLayer addChild:goldlabel z:2];
            
            CCSprite* wood = [CCSprite spriteWithSpriteFrameName:@"wood.png"];
            wood.scale = 0.3;
            wood.anchorPoint = ccp(0, 0.5);
            wood.position = ccp(title.position.x, ba.position.y - 42);
            [leftLayer addChild:wood z:2];
            
            
            int woodcost = TROOP_FOOTMAN_COST_WOOD ;
            NSString *wstr = [NSString stringWithFormat:@"%d",woodcost];
            CCLabelTTF* woodlabel = [CCLabelTTF labelWithString:wstr fontName:@"Arial" fontSize:9];
            woodlabel.anchorPoint = ccp(0, 0.5);
            woodlabel.color = ccWHITE;
            woodlabel.position = ccp(wood.position.x + 20, wood.position.y);
            [leftLayer addChild:woodlabel z:2];
            
            CCSprite* iron = [CCSprite spriteWithSpriteFrameName:@"iron.png"];
            iron.scale = 0.3;
            iron.anchorPoint = ccp(0, 0.5);
            iron.position = ccp(title.position.x, ba.position.y - 54);
            [leftLayer addChild:iron z:2];
            
            
            int ironcost = TROOP_FOOTMAN_COST_IRON ;
            NSString *istr = [NSString stringWithFormat:@"%d",ironcost];
            CCLabelTTF* ironlabel = [CCLabelTTF labelWithString:istr fontName:@"Arial" fontSize:9];
            ironlabel.anchorPoint = ccp(0, 0.5);
            ironlabel.color = ccWHITE;
            ironlabel.position = ccp(iron.position.x + 20, iron.position.y);
            [leftLayer addChild:ironlabel z:2];
            
            //hp , mp , attack , mental , move , attack range
            NSString *hpstr = [NSString stringWithFormat:@"HP: %d",TROOP_FOOTMAN_HP];
            CCLabelTTF* hplabel = [CCLabelTTF labelWithString:hpstr fontName:@"Arial" fontSize:9];
            hplabel.anchorPoint = ccp(0, 0.5);
            hplabel.position = ccp(hf.position.x, title.position.y - 10);
            [leftLayer addChild:hplabel z:2];
            
            NSString *mpstr = [NSString stringWithFormat:@"MP: %d",TROOP_FOOTMAN_MP];
            CCLabelTTF* mplabel = [CCLabelTTF labelWithString:mpstr fontName:@"Arial" fontSize:9];
            mplabel.anchorPoint = ccp(0, 0.5);
            mplabel.position = ccp(hf.position.x, title.position.y - 22);
            [leftLayer addChild:mplabel z:2];
            
            NSString *attstr = [NSString stringWithFormat:@"攻击力: %d",TROOP_FOOTMAN_ATTACK];
            CCLabelTTF* attlabel = [CCLabelTTF labelWithString:attstr fontName:@"Arial" fontSize:9];
            attlabel.anchorPoint = ccp(0, 0.5);
            attlabel.position = ccp(hf.position.x, title.position.y - 34);
            [leftLayer addChild:attlabel z:2];
            
            NSString *menstr = [NSString stringWithFormat:@"精神力: %d",TROOP_FOOTMAN_MENTAL];
            CCLabelTTF* menlabel = [CCLabelTTF labelWithString:menstr fontName:@"Arial" fontSize:9];
            menlabel.anchorPoint = ccp(0, 0.5);
            menlabel.position = ccp(hf.position.x, title.position.y - 46);
            [leftLayer addChild:menlabel z:2];
            
            NSString *movestr = [NSString stringWithFormat:@"移动力: %d",TROOP_FOOTMAN_MOVE];
            CCLabelTTF* movelabel = [CCLabelTTF labelWithString:movestr fontName:@"Arial" fontSize:9];
            movelabel.anchorPoint = ccp(0, 0.5);
            movelabel.position = ccp(hf.position.x, title.position.y - 58);
            [leftLayer addChild:movelabel z:2];
            
            NSString *arstr = [NSString stringWithFormat:@"攻击范围:%d",TROOP_FOOTMAN_ATTACK_RANGE];
            CCLabelTTF* arlabel = [CCLabelTTF labelWithString:arstr fontName:@"Arial" fontSize:9];
            arlabel.anchorPoint = ccp(0, 0.5);
            arlabel.position = ccp(hf.position.x, title.position.y - 70);
            [leftLayer addChild:arlabel z:2];
        }
        
        
        CCSprite* hf1 = [CCSprite spriteWithSpriteFrameName:@"itemframe2.png"];
        hf1.position = ccp(wsize.width*0.5-168, wsize.height*0.5+ibgheight*0.5 - 25 - hfheight*0.5 -(hfheight+5));
        [leftLayer addChild:hf1 z:1];
        
        if (cio.archer == 1) {
            CCLabelTTF* title = [CCLabelTTF labelWithString:@"弓兵" fontName:@"Arial" fontSize:10];
            title.anchorPoint = ccp(0, 0.5);
            title.position = ccp(hf1.position.x - hf1.boundingBox.size.width*0.4, hf1.position.y + hf1.boundingBox.size.height*0.35);
            [leftLayer addChild:title z:2];
            
            RecruitDragTouchSprite* ba = [RecruitDragTouchSprite spriteWithSpriteFrameName:@"troop3_right_01.png"];
            ba.position = ccp(title.position.x + 10, title.position.y - 30);
            [leftLayer addChild:ba z:2];
            [ba initTheCallbackFunc0:@selector(checkReceiveSprite:) withCaller:self withTouchID:2 withImg:@"troop3_right_01.png" canDrag:YES];
            
            CCSprite* gold = [CCSprite spriteWithSpriteFrameName:@"gold.png"];
            gold.scale = 0.3;
            gold.anchorPoint = ccp(0, 0.5);
            gold.position = ccp(title.position.x, ba.position.y - 30);
            [leftLayer addChild:gold z:2];
            
            
            int money = TROOP_ARCHER_COST_GOLD ;
            NSString *mstr = [NSString stringWithFormat:@"%d",money];
            CCLabelTTF* goldlabel = [CCLabelTTF labelWithString:mstr fontName:@"Arial" fontSize:9];
            goldlabel.anchorPoint = ccp(0, 0.5);
            goldlabel.color = ccWHITE;
            goldlabel.position = ccp(gold.position.x + 20, gold.position.y);
            [leftLayer addChild:goldlabel z:2];
            
            CCSprite* wood = [CCSprite spriteWithSpriteFrameName:@"wood.png"];
            wood.scale = 0.3;
            wood.anchorPoint = ccp(0, 0.5);
            wood.position = ccp(title.position.x, ba.position.y - 42);
            [leftLayer addChild:wood z:2];
            
            
            int woodcost = TROOP_ARCHER_COST_WOOD ;
            NSString *wstr = [NSString stringWithFormat:@"%d",woodcost];
            CCLabelTTF* woodlabel = [CCLabelTTF labelWithString:wstr fontName:@"Arial" fontSize:9];
            woodlabel.anchorPoint = ccp(0, 0.5);
            woodlabel.color = ccWHITE;
            woodlabel.position = ccp(wood.position.x + 20, wood.position.y);
            [leftLayer addChild:woodlabel z:2];
            
            CCSprite* iron = [CCSprite spriteWithSpriteFrameName:@"iron.png"];
            iron.scale = 0.3;
            iron.anchorPoint = ccp(0, 0.5);
            iron.position = ccp(title.position.x, ba.position.y - 54);
            [leftLayer addChild:iron z:2];
            
            
            int ironcost = TROOP_ARCHER_COST_IRON ;
            NSString *istr = [NSString stringWithFormat:@"%d",ironcost];
            CCLabelTTF* ironlabel = [CCLabelTTF labelWithString:istr fontName:@"Arial" fontSize:9];
            ironlabel.anchorPoint = ccp(0, 0.5);
            ironlabel.color = ccWHITE;
            ironlabel.position = ccp(iron.position.x + 20, iron.position.y);
            [leftLayer addChild:ironlabel z:2];
            
            //hp , mp , attack , mental , move , attack range
            NSString *hpstr = [NSString stringWithFormat:@"HP: %d",TROOP_ARCHER_HP];
            CCLabelTTF* hplabel = [CCLabelTTF labelWithString:hpstr fontName:@"Arial" fontSize:9];
            hplabel.anchorPoint = ccp(0, 0.5);
            hplabel.position = ccp(hf.position.x, title.position.y - 10);
            [leftLayer addChild:hplabel z:2];
            
            NSString *mpstr = [NSString stringWithFormat:@"MP: %d",TROOP_ARCHER_MP];
            CCLabelTTF* mplabel = [CCLabelTTF labelWithString:mpstr fontName:@"Arial" fontSize:9];
            mplabel.anchorPoint = ccp(0, 0.5);
            mplabel.position = ccp(hf.position.x, title.position.y - 22);
            [leftLayer addChild:mplabel z:2];
            
            NSString *attstr = [NSString stringWithFormat:@"攻击力: %d",TROOP_ARCHER_ATTACK];
            CCLabelTTF* attlabel = [CCLabelTTF labelWithString:attstr fontName:@"Arial" fontSize:9];
            attlabel.anchorPoint = ccp(0, 0.5);
            attlabel.position = ccp(hf.position.x, title.position.y - 34);
            [leftLayer addChild:attlabel z:2];
            
            NSString *menstr = [NSString stringWithFormat:@"精神力: %d",TROOP_ARCHER_MENTAL];
            CCLabelTTF* menlabel = [CCLabelTTF labelWithString:menstr fontName:@"Arial" fontSize:9];
            menlabel.anchorPoint = ccp(0, 0.5);
            menlabel.position = ccp(hf.position.x, title.position.y - 46);
            [leftLayer addChild:menlabel z:2];
            
            NSString *movestr = [NSString stringWithFormat:@"移动力: %d",TROOP_ARCHER_MOVE];
            CCLabelTTF* movelabel = [CCLabelTTF labelWithString:movestr fontName:@"Arial" fontSize:9];
            movelabel.anchorPoint = ccp(0, 0.5);
            movelabel.position = ccp(hf.position.x, title.position.y - 58);
            [leftLayer addChild:movelabel z:2];
            
            NSString *arstr = [NSString stringWithFormat:@"攻击范围:%d",TROOP_ARCHER_ATTACK_RANGE];
            CCLabelTTF* arlabel = [CCLabelTTF labelWithString:arstr fontName:@"Arial" fontSize:9];
            arlabel.anchorPoint = ccp(0, 0.5);
            arlabel.position = ccp(hf.position.x, title.position.y - 70);
            [leftLayer addChild:arlabel z:2];
            
            
            
            
            
            
        }
        else {
            CCLabelTTF* title = [CCLabelTTF labelWithString:@"弓兵营未造" fontName:@"Arial" fontSize:10];
            title.anchorPoint = ccp(0, 0.5);
            title.position = ccp(hf1.position.x - hf1.boundingBox.size.width*0.4, hf1.position.y + hf1.boundingBox.size.height*0.35);
            [leftLayer addChild:title z:2];
            
            RecruitDragTouchSprite* ba = [RecruitDragTouchSprite spriteWithSpriteFrameName:@"troop3_gray_right_01.png"];
            ba.position = ccp(title.position.x + 10, title.position.y - 30);
            [leftLayer addChild:ba z:2];
            [ba initTheCallbackFunc0:@selector(checkReceiveSprite:) withCaller:self withTouchID:2 withImg:@"troop3_gray_right_01.png" canDrag:NO];
            
            CCSprite* gold = [CCSprite spriteWithSpriteFrameName:@"gold.png"];
            gold.scale = 0.3;
            gold.anchorPoint = ccp(0, 0.5);
            gold.position = ccp(title.position.x, ba.position.y - 30);
            [leftLayer addChild:gold z:2];
            
            
            int money = TROOP_ARCHER_COST_GOLD ;
            NSString *mstr = [NSString stringWithFormat:@"%d",money];
            CCLabelTTF* goldlabel = [CCLabelTTF labelWithString:mstr fontName:@"Arial" fontSize:9];
            goldlabel.anchorPoint = ccp(0, 0.5);
            goldlabel.color = ccWHITE;
            goldlabel.position = ccp(gold.position.x + 20, gold.position.y);
            [leftLayer addChild:goldlabel z:2];
            
            CCSprite* wood = [CCSprite spriteWithSpriteFrameName:@"wood.png"];
            wood.scale = 0.3;
            wood.anchorPoint = ccp(0, 0.5);
            wood.position = ccp(title.position.x, ba.position.y - 42);
            [leftLayer addChild:wood z:2];
            
            
            int woodcost = TROOP_ARCHER_COST_WOOD ;
            NSString *wstr = [NSString stringWithFormat:@"%d",woodcost];
            CCLabelTTF* woodlabel = [CCLabelTTF labelWithString:wstr fontName:@"Arial" fontSize:9];
            woodlabel.anchorPoint = ccp(0, 0.5);
            woodlabel.color = ccWHITE;
            woodlabel.position = ccp(wood.position.x + 20, wood.position.y);
            [leftLayer addChild:woodlabel z:2];
            
            CCSprite* iron = [CCSprite spriteWithSpriteFrameName:@"iron.png"];
            iron.scale = 0.3;
            iron.anchorPoint = ccp(0, 0.5);
            iron.position = ccp(title.position.x, ba.position.y - 54);
            [leftLayer addChild:iron z:2];
            
            
            int ironcost = TROOP_ARCHER_COST_IRON ;
            NSString *istr = [NSString stringWithFormat:@"%d",ironcost];
            CCLabelTTF* ironlabel = [CCLabelTTF labelWithString:istr fontName:@"Arial" fontSize:9];
            ironlabel.anchorPoint = ccp(0, 0.5);
            ironlabel.color = ccWHITE;
            ironlabel.position = ccp(iron.position.x + 20, iron.position.y);
            [leftLayer addChild:ironlabel z:2];
            
            //hp , mp , attack , mental , move , attack range
            NSString *hpstr = [NSString stringWithFormat:@"HP: %d",TROOP_ARCHER_HP];
            CCLabelTTF* hplabel = [CCLabelTTF labelWithString:hpstr fontName:@"Arial" fontSize:9];
            hplabel.anchorPoint = ccp(0, 0.5);
            hplabel.position = ccp(hf.position.x, title.position.y - 10);
            [leftLayer addChild:hplabel z:2];
            
            NSString *mpstr = [NSString stringWithFormat:@"MP: %d",TROOP_ARCHER_MP];
            CCLabelTTF* mplabel = [CCLabelTTF labelWithString:mpstr fontName:@"Arial" fontSize:9];
            mplabel.anchorPoint = ccp(0, 0.5);
            mplabel.position = ccp(hf.position.x, title.position.y - 22);
            [leftLayer addChild:mplabel z:2];
            
            NSString *attstr = [NSString stringWithFormat:@"攻击力: %d",TROOP_ARCHER_ATTACK];
            CCLabelTTF* attlabel = [CCLabelTTF labelWithString:attstr fontName:@"Arial" fontSize:9];
            attlabel.anchorPoint = ccp(0, 0.5);
            attlabel.position = ccp(hf.position.x, title.position.y - 34);
            [leftLayer addChild:attlabel z:2];
            
            NSString *menstr = [NSString stringWithFormat:@"精神力: %d",TROOP_ARCHER_MENTAL];
            CCLabelTTF* menlabel = [CCLabelTTF labelWithString:menstr fontName:@"Arial" fontSize:9];
            menlabel.anchorPoint = ccp(0, 0.5);
            menlabel.position = ccp(hf.position.x, title.position.y - 46);
            [leftLayer addChild:menlabel z:2];
            
            NSString *movestr = [NSString stringWithFormat:@"移动力: %d",TROOP_ARCHER_MOVE];
            CCLabelTTF* movelabel = [CCLabelTTF labelWithString:movestr fontName:@"Arial" fontSize:9];
            movelabel.anchorPoint = ccp(0, 0.5);
            movelabel.position = ccp(hf.position.x, title.position.y - 58);
            [leftLayer addChild:movelabel z:2];
            
            NSString *arstr = [NSString stringWithFormat:@"攻击范围:%d",TROOP_ARCHER_ATTACK_RANGE];
            CCLabelTTF* arlabel = [CCLabelTTF labelWithString:arstr fontName:@"Arial" fontSize:9];
            arlabel.anchorPoint = ccp(0, 0.5);
            arlabel.position = ccp(hf.position.x, title.position.y - 70);
            [leftLayer addChild:arlabel z:2];
        }
        
        
        
        CCSprite* hf2 = [CCSprite spriteWithSpriteFrameName:@"itemframe2.png"];
        hf2.position = ccp(wsize.width*0.5-168, wsize.height*0.5+ibgheight*0.5 - 25 - hfheight*0.5 -(hfheight+5)*2);
        [leftLayer addChild:hf2 z:1];
        
        if (cio.cavalry == 1) {
            CCLabelTTF* title = [CCLabelTTF labelWithString:@"骑兵" fontName:@"Arial" fontSize:10];
            title.anchorPoint = ccp(0, 0.5);
            title.position = ccp(hf2.position.x - hf2.boundingBox.size.width*0.4, hf2.position.y + hf2.boundingBox.size.height*0.35);
            [leftLayer addChild:title z:2];
            
            RecruitDragTouchSprite* ba = [RecruitDragTouchSprite spriteWithSpriteFrameName:@"troop5_right_01.png"];
            ba.position = ccp(title.position.x + 10, title.position.y - 30);
            [leftLayer addChild:ba z:2];
            [ba initTheCallbackFunc0:@selector(checkReceiveSprite:) withCaller:self withTouchID:3 withImg:@"troop5_right_01.png" canDrag:YES];
            
            CCSprite* gold = [CCSprite spriteWithSpriteFrameName:@"gold.png"];
            gold.scale = 0.3;
            gold.anchorPoint = ccp(0, 0.5);
            gold.position = ccp(title.position.x, ba.position.y - 30);
            [leftLayer addChild:gold z:2];
            
            
            int money = TROOP_CAVALRY_COST_GOLD ;
            NSString *mstr = [NSString stringWithFormat:@"%d",money];
            CCLabelTTF* goldlabel = [CCLabelTTF labelWithString:mstr fontName:@"Arial" fontSize:9];
            goldlabel.anchorPoint = ccp(0, 0.5);
            goldlabel.color = ccWHITE;
            goldlabel.position = ccp(gold.position.x + 20, gold.position.y);
            [leftLayer addChild:goldlabel z:2];
            
            CCSprite* wood = [CCSprite spriteWithSpriteFrameName:@"wood.png"];
            wood.scale = 0.3;
            wood.anchorPoint = ccp(0, 0.5);
            wood.position = ccp(title.position.x, ba.position.y - 42);
            [leftLayer addChild:wood z:2];
            
            
            int woodcost = TROOP_CAVALRY_COST_WOOD ;
            NSString *wstr = [NSString stringWithFormat:@"%d",woodcost];
            CCLabelTTF* woodlabel = [CCLabelTTF labelWithString:wstr fontName:@"Arial" fontSize:9];
            woodlabel.anchorPoint = ccp(0, 0.5);
            woodlabel.color = ccWHITE;
            woodlabel.position = ccp(wood.position.x + 20, wood.position.y);
            [leftLayer addChild:woodlabel z:2];
            
            CCSprite* iron = [CCSprite spriteWithSpriteFrameName:@"iron.png"];
            iron.scale = 0.3;
            iron.anchorPoint = ccp(0, 0.5);
            iron.position = ccp(title.position.x, ba.position.y - 54);
            [leftLayer addChild:iron z:2];
            
            
            int ironcost = TROOP_CAVALRY_COST_IRON ;
            NSString *istr = [NSString stringWithFormat:@"%d",ironcost];
            CCLabelTTF* ironlabel = [CCLabelTTF labelWithString:istr fontName:@"Arial" fontSize:9];
            ironlabel.anchorPoint = ccp(0, 0.5);
            ironlabel.color = ccWHITE;
            ironlabel.position = ccp(iron.position.x + 20, iron.position.y);
            [leftLayer addChild:ironlabel z:2];
            
            //hp , mp , attack , mental , move , attack range
            NSString *hpstr = [NSString stringWithFormat:@"HP: %d",TROOP_CAVALRY_HP];
            CCLabelTTF* hplabel = [CCLabelTTF labelWithString:hpstr fontName:@"Arial" fontSize:9];
            hplabel.anchorPoint = ccp(0, 0.5);
            hplabel.position = ccp(hf.position.x, title.position.y - 10);
            [leftLayer addChild:hplabel z:2];
            
            NSString *mpstr = [NSString stringWithFormat:@"MP: %d",TROOP_CAVALRY_MP];
            CCLabelTTF* mplabel = [CCLabelTTF labelWithString:mpstr fontName:@"Arial" fontSize:9];
            mplabel.anchorPoint = ccp(0, 0.5);
            mplabel.position = ccp(hf.position.x, title.position.y - 22);
            [leftLayer addChild:mplabel z:2];
            
            NSString *attstr = [NSString stringWithFormat:@"攻击力: %d",TROOP_CAVALRY_ATTACK];
            CCLabelTTF* attlabel = [CCLabelTTF labelWithString:attstr fontName:@"Arial" fontSize:9];
            attlabel.anchorPoint = ccp(0, 0.5);
            attlabel.position = ccp(hf.position.x, title.position.y - 34);
            [leftLayer addChild:attlabel z:2];
            
            NSString *menstr = [NSString stringWithFormat:@"精神力: %d",TROOP_CAVALRY_MENTAL];
            CCLabelTTF* menlabel = [CCLabelTTF labelWithString:menstr fontName:@"Arial" fontSize:9];
            menlabel.anchorPoint = ccp(0, 0.5);
            menlabel.position = ccp(hf.position.x, title.position.y - 46);
            [leftLayer addChild:menlabel z:2];
            
            NSString *movestr = [NSString stringWithFormat:@"移动力: %d",TROOP_CAVALRY_MOVE];
            CCLabelTTF* movelabel = [CCLabelTTF labelWithString:movestr fontName:@"Arial" fontSize:9];
            movelabel.anchorPoint = ccp(0, 0.5);
            movelabel.position = ccp(hf.position.x, title.position.y - 58);
            [leftLayer addChild:movelabel z:2];
            
            NSString *arstr = [NSString stringWithFormat:@"攻击范围:%d",TROOP_CAVALRY_ATTACK_RANGE];
            CCLabelTTF* arlabel = [CCLabelTTF labelWithString:arstr fontName:@"Arial" fontSize:9];
            arlabel.anchorPoint = ccp(0, 0.5);
            arlabel.position = ccp(hf.position.x, title.position.y - 70);
            [leftLayer addChild:arlabel z:2];
            
            
            
            
            
            
        }
        else {
            CCLabelTTF* title = [CCLabelTTF labelWithString:@"骑兵营未造" fontName:@"Arial" fontSize:10];
            title.anchorPoint = ccp(0, 0.5);
            title.position = ccp(hf2.position.x - hf2.boundingBox.size.width*0.4, hf2.position.y + hf2.boundingBox.size.height*0.35);
            [leftLayer addChild:title z:2];
            
            RecruitDragTouchSprite* ba = [RecruitDragTouchSprite spriteWithSpriteFrameName:@"troop5_gray_right_01.png"];
            ba.position = ccp(title.position.x + 10, title.position.y - 30);
            [leftLayer addChild:ba z:2];
            [ba initTheCallbackFunc0:@selector(checkReceiveSprite:) withCaller:self withTouchID:3 withImg:@"troop5_gray_right_01.png" canDrag:NO];
            
            CCSprite* gold = [CCSprite spriteWithSpriteFrameName:@"gold.png"];
            gold.scale = 0.3;
            gold.anchorPoint = ccp(0, 0.5);
            gold.position = ccp(title.position.x, ba.position.y - 30);
            [leftLayer addChild:gold z:2];
            
            
            int money = TROOP_CAVALRY_COST_GOLD ;
            NSString *mstr = [NSString stringWithFormat:@"%d",money];
            CCLabelTTF* goldlabel = [CCLabelTTF labelWithString:mstr fontName:@"Arial" fontSize:9];
            goldlabel.anchorPoint = ccp(0, 0.5);
            goldlabel.color = ccWHITE;
            goldlabel.position = ccp(gold.position.x + 20, gold.position.y);
            [leftLayer addChild:goldlabel z:2];
            
            CCSprite* wood = [CCSprite spriteWithSpriteFrameName:@"wood.png"];
            wood.scale = 0.3;
            wood.anchorPoint = ccp(0, 0.5);
            wood.position = ccp(title.position.x, ba.position.y - 42);
            [leftLayer addChild:wood z:2];
            
            
            int woodcost = TROOP_CAVALRY_COST_WOOD ;
            NSString *wstr = [NSString stringWithFormat:@"%d",woodcost];
            CCLabelTTF* woodlabel = [CCLabelTTF labelWithString:wstr fontName:@"Arial" fontSize:9];
            woodlabel.anchorPoint = ccp(0, 0.5);
            woodlabel.color = ccWHITE;
            woodlabel.position = ccp(wood.position.x + 20, wood.position.y);
            [leftLayer addChild:woodlabel z:2];
            
            CCSprite* iron = [CCSprite spriteWithSpriteFrameName:@"iron.png"];
            iron.scale = 0.3;
            iron.anchorPoint = ccp(0, 0.5);
            iron.position = ccp(title.position.x, ba.position.y - 54);
            [leftLayer addChild:iron z:2];
            
            
            int ironcost = TROOP_CAVALRY_COST_IRON ;
            NSString *istr = [NSString stringWithFormat:@"%d",ironcost];
            CCLabelTTF* ironlabel = [CCLabelTTF labelWithString:istr fontName:@"Arial" fontSize:9];
            ironlabel.anchorPoint = ccp(0, 0.5);
            ironlabel.color = ccWHITE;
            ironlabel.position = ccp(iron.position.x + 20, iron.position.y);
            [leftLayer addChild:ironlabel z:2];
            
            //hp , mp , attack , mental , move , attack range
            NSString *hpstr = [NSString stringWithFormat:@"HP: %d",TROOP_CAVALRY_HP];
            CCLabelTTF* hplabel = [CCLabelTTF labelWithString:hpstr fontName:@"Arial" fontSize:9];
            hplabel.anchorPoint = ccp(0, 0.5);
            hplabel.position = ccp(hf.position.x, title.position.y - 10);
            [leftLayer addChild:hplabel z:2];
            
            NSString *mpstr = [NSString stringWithFormat:@"MP: %d",TROOP_CAVALRY_MP];
            CCLabelTTF* mplabel = [CCLabelTTF labelWithString:mpstr fontName:@"Arial" fontSize:9];
            mplabel.anchorPoint = ccp(0, 0.5);
            mplabel.position = ccp(hf.position.x, title.position.y - 22);
            [leftLayer addChild:mplabel z:2];
            
            NSString *attstr = [NSString stringWithFormat:@"攻击力: %d",TROOP_CAVALRY_ATTACK];
            CCLabelTTF* attlabel = [CCLabelTTF labelWithString:attstr fontName:@"Arial" fontSize:9];
            attlabel.anchorPoint = ccp(0, 0.5);
            attlabel.position = ccp(hf.position.x, title.position.y - 34);
            [leftLayer addChild:attlabel z:2];
            
            NSString *menstr = [NSString stringWithFormat:@"精神力: %d",TROOP_CAVALRY_MENTAL];
            CCLabelTTF* menlabel = [CCLabelTTF labelWithString:menstr fontName:@"Arial" fontSize:9];
            menlabel.anchorPoint = ccp(0, 0.5);
            menlabel.position = ccp(hf.position.x, title.position.y - 46);
            [leftLayer addChild:menlabel z:2];
            
            NSString *movestr = [NSString stringWithFormat:@"移动力: %d",TROOP_CAVALRY_MOVE];
            CCLabelTTF* movelabel = [CCLabelTTF labelWithString:movestr fontName:@"Arial" fontSize:9];
            movelabel.anchorPoint = ccp(0, 0.5);
            movelabel.position = ccp(hf.position.x, title.position.y - 58);
            [leftLayer addChild:movelabel z:2];
            
            NSString *arstr = [NSString stringWithFormat:@"攻击范围:%d",TROOP_CAVALRY_ATTACK_RANGE];
            CCLabelTTF* arlabel = [CCLabelTTF labelWithString:arstr fontName:@"Arial" fontSize:9];
            arlabel.anchorPoint = ccp(0, 0.5);
            arlabel.position = ccp(hf.position.x, title.position.y - 70);
            [leftLayer addChild:arlabel z:2];
        }
        
        CCSprite* hf3 = [CCSprite spriteWithSpriteFrameName:@"itemframe2.png"];
        hf3.position = ccp(wsize.width*0.5-168, wsize.height*0.5+ibgheight*0.5 - 25 - hfheight*0.5 -(hfheight+5)*3);
        [leftLayer addChild:hf3 z:1];
        
        if (cio.wizard == 1) {
            CCLabelTTF* title = [CCLabelTTF labelWithString:@"策士" fontName:@"Arial" fontSize:10];
            title.anchorPoint = ccp(0, 0.5);
            title.position = ccp(hf3.position.x - hf3.boundingBox.size.width*0.4, hf3.position.y + hf3.boundingBox.size.height*0.35);
            [leftLayer addChild:title z:2];
            
            RecruitDragTouchSprite* ba = [RecruitDragTouchSprite spriteWithSpriteFrameName:@"troop7_right_01.png"];
            ba.position = ccp(title.position.x + 10, title.position.y - 30);
            [leftLayer addChild:ba z:2];
            [ba initTheCallbackFunc0:@selector(checkReceiveSprite:) withCaller:self withTouchID:4 withImg:@"troop7_right_01.png" canDrag:YES];
            
            CCSprite* gold = [CCSprite spriteWithSpriteFrameName:@"gold.png"];
            gold.scale = 0.3;
            gold.anchorPoint = ccp(0, 0.5);
            gold.position = ccp(title.position.x, ba.position.y - 30);
            [leftLayer addChild:gold z:2];
            
            
            int money = TROOP_WIZARD_COST_GOLD ;
            NSString *mstr = [NSString stringWithFormat:@"%d",money];
            CCLabelTTF* goldlabel = [CCLabelTTF labelWithString:mstr fontName:@"Arial" fontSize:9];
            goldlabel.anchorPoint = ccp(0, 0.5);
            goldlabel.color = ccWHITE;
            goldlabel.position = ccp(gold.position.x + 20, gold.position.y);
            [leftLayer addChild:goldlabel z:2];
            
            CCSprite* wood = [CCSprite spriteWithSpriteFrameName:@"wood.png"];
            wood.scale = 0.3;
            wood.anchorPoint = ccp(0, 0.5);
            wood.position = ccp(title.position.x, ba.position.y - 42);
            [leftLayer addChild:wood z:2];
            
            
            int woodcost = TROOP_WIZARD_COST_WOOD ;
            NSString *wstr = [NSString stringWithFormat:@"%d",woodcost];
            CCLabelTTF* woodlabel = [CCLabelTTF labelWithString:wstr fontName:@"Arial" fontSize:9];
            woodlabel.anchorPoint = ccp(0, 0.5);
            woodlabel.color = ccWHITE;
            woodlabel.position = ccp(wood.position.x + 20, wood.position.y);
            [leftLayer addChild:woodlabel z:2];
            
            CCSprite* iron = [CCSprite spriteWithSpriteFrameName:@"iron.png"];
            iron.scale = 0.3;
            iron.anchorPoint = ccp(0, 0.5);
            iron.position = ccp(title.position.x, ba.position.y - 54);
            [leftLayer addChild:iron z:2];
            
            
            int ironcost = TROOP_WIZARD_COST_IRON ;
            NSString *istr = [NSString stringWithFormat:@"%d",ironcost];
            CCLabelTTF* ironlabel = [CCLabelTTF labelWithString:istr fontName:@"Arial" fontSize:9];
            ironlabel.anchorPoint = ccp(0, 0.5);
            ironlabel.color = ccWHITE;
            ironlabel.position = ccp(iron.position.x + 20, iron.position.y);
            [leftLayer addChild:ironlabel z:2];
            
            //hp , mp , attack , mental , move , attack range
            NSString *hpstr = [NSString stringWithFormat:@"HP: %d",TROOP_WIZARD_HP];
            CCLabelTTF* hplabel = [CCLabelTTF labelWithString:hpstr fontName:@"Arial" fontSize:9];
            hplabel.anchorPoint = ccp(0, 0.5);
            hplabel.position = ccp(hf.position.x, title.position.y - 10);
            [leftLayer addChild:hplabel z:2];
            
            NSString *mpstr = [NSString stringWithFormat:@"MP: %d",TROOP_WIZARD_MP];
            CCLabelTTF* mplabel = [CCLabelTTF labelWithString:mpstr fontName:@"Arial" fontSize:9];
            mplabel.anchorPoint = ccp(0, 0.5);
            mplabel.position = ccp(hf.position.x, title.position.y - 22);
            [leftLayer addChild:mplabel z:2];
            
            NSString *attstr = [NSString stringWithFormat:@"攻击力: %d",TROOP_WIZARD_ATTACK];
            CCLabelTTF* attlabel = [CCLabelTTF labelWithString:attstr fontName:@"Arial" fontSize:9];
            attlabel.anchorPoint = ccp(0, 0.5);
            attlabel.position = ccp(hf.position.x, title.position.y - 34);
            [leftLayer addChild:attlabel z:2];
            
            NSString *menstr = [NSString stringWithFormat:@"精神力: %d",TROOP_WIZARD_MENTAL];
            CCLabelTTF* menlabel = [CCLabelTTF labelWithString:menstr fontName:@"Arial" fontSize:9];
            menlabel.anchorPoint = ccp(0, 0.5);
            menlabel.position = ccp(hf.position.x, title.position.y - 46);
            [leftLayer addChild:menlabel z:2];
            
            NSString *movestr = [NSString stringWithFormat:@"移动力: %d",TROOP_WIZARD_MOVE];
            CCLabelTTF* movelabel = [CCLabelTTF labelWithString:movestr fontName:@"Arial" fontSize:9];
            movelabel.anchorPoint = ccp(0, 0.5);
            movelabel.position = ccp(hf.position.x, title.position.y - 58);
            [leftLayer addChild:movelabel z:2];
            
            NSString *arstr = [NSString stringWithFormat:@"攻击范围:%d",TROOP_WIZARD_ATTACK_RANGE];
            CCLabelTTF* arlabel = [CCLabelTTF labelWithString:arstr fontName:@"Arial" fontSize:9];
            arlabel.anchorPoint = ccp(0, 0.5);
            arlabel.position = ccp(hf.position.x, title.position.y - 70);
            [leftLayer addChild:arlabel z:2];
            
            
            
            
            
            
        }
        else {
            CCLabelTTF* title = [CCLabelTTF labelWithString:@"学院未造" fontName:@"Arial" fontSize:10];
            title.anchorPoint = ccp(0, 0.5);
            title.position = ccp(hf3.position.x - hf3.boundingBox.size.width*0.4, hf3.position.y + hf3.boundingBox.size.height*0.35);
            [leftLayer addChild:title z:2];
            
            RecruitDragTouchSprite* ba = [RecruitDragTouchSprite spriteWithSpriteFrameName:@"troop7_gray_right_01.png"];
            ba.position = ccp(title.position.x + 10, title.position.y - 30);
            [leftLayer addChild:ba z:2];
            [ba initTheCallbackFunc0:@selector(checkReceiveSprite:) withCaller:self withTouchID:4 withImg:@"troop7_gray_right_01.png" canDrag:NO];
            
            CCSprite* gold = [CCSprite spriteWithSpriteFrameName:@"gold.png"];
            gold.scale = 0.3;
            gold.anchorPoint = ccp(0, 0.5);
            gold.position = ccp(title.position.x, ba.position.y - 30);
            [leftLayer addChild:gold z:2];
            
            
            int money = TROOP_WIZARD_COST_GOLD ;
            NSString *mstr = [NSString stringWithFormat:@"%d",money];
            CCLabelTTF* goldlabel = [CCLabelTTF labelWithString:mstr fontName:@"Arial" fontSize:9];
            goldlabel.anchorPoint = ccp(0, 0.5);
            goldlabel.color = ccWHITE;
            goldlabel.position = ccp(gold.position.x + 20, gold.position.y);
            [leftLayer addChild:goldlabel z:2];
            
            CCSprite* wood = [CCSprite spriteWithSpriteFrameName:@"wood.png"];
            wood.scale = 0.3;
            wood.anchorPoint = ccp(0, 0.5);
            wood.position = ccp(title.position.x, ba.position.y - 42);
            [leftLayer addChild:wood z:2];
            
            
            int woodcost = TROOP_WIZARD_COST_WOOD ;
            NSString *wstr = [NSString stringWithFormat:@"%d",woodcost];
            CCLabelTTF* woodlabel = [CCLabelTTF labelWithString:wstr fontName:@"Arial" fontSize:9];
            woodlabel.anchorPoint = ccp(0, 0.5);
            woodlabel.color = ccWHITE;
            woodlabel.position = ccp(wood.position.x + 20, wood.position.y);
            [leftLayer addChild:woodlabel z:2];
            
            CCSprite* iron = [CCSprite spriteWithSpriteFrameName:@"iron.png"];
            iron.scale = 0.3;
            iron.anchorPoint = ccp(0, 0.5);
            iron.position = ccp(title.position.x, ba.position.y - 54);
            [leftLayer addChild:iron z:2];
            
            
            int ironcost = TROOP_WIZARD_COST_IRON ;
            NSString *istr = [NSString stringWithFormat:@"%d",ironcost];
            CCLabelTTF* ironlabel = [CCLabelTTF labelWithString:istr fontName:@"Arial" fontSize:9];
            ironlabel.anchorPoint = ccp(0, 0.5);
            ironlabel.color = ccWHITE;
            ironlabel.position = ccp(iron.position.x + 20, iron.position.y);
            [leftLayer addChild:ironlabel z:2];
            
            //hp , mp , attack , mental , move , attack range
            NSString *hpstr = [NSString stringWithFormat:@"HP: %d",TROOP_WIZARD_HP];
            CCLabelTTF* hplabel = [CCLabelTTF labelWithString:hpstr fontName:@"Arial" fontSize:9];
            hplabel.anchorPoint = ccp(0, 0.5);
            hplabel.position = ccp(hf.position.x, title.position.y - 10);
            [leftLayer addChild:hplabel z:2];
            
            NSString *mpstr = [NSString stringWithFormat:@"MP: %d",TROOP_WIZARD_MP];
            CCLabelTTF* mplabel = [CCLabelTTF labelWithString:mpstr fontName:@"Arial" fontSize:9];
            mplabel.anchorPoint = ccp(0, 0.5);
            mplabel.position = ccp(hf.position.x, title.position.y - 22);
            [leftLayer addChild:mplabel z:2];
            
            NSString *attstr = [NSString stringWithFormat:@"攻击力: %d",TROOP_WIZARD_ATTACK];
            CCLabelTTF* attlabel = [CCLabelTTF labelWithString:attstr fontName:@"Arial" fontSize:9];
            attlabel.anchorPoint = ccp(0, 0.5);
            attlabel.position = ccp(hf.position.x, title.position.y - 34);
            [leftLayer addChild:attlabel z:2];
            
            NSString *menstr = [NSString stringWithFormat:@"精神力: %d",TROOP_WIZARD_MENTAL];
            CCLabelTTF* menlabel = [CCLabelTTF labelWithString:menstr fontName:@"Arial" fontSize:9];
            menlabel.anchorPoint = ccp(0, 0.5);
            menlabel.position = ccp(hf.position.x, title.position.y - 46);
            [leftLayer addChild:menlabel z:2];
            
            NSString *movestr = [NSString stringWithFormat:@"移动力: %d",TROOP_WIZARD_MOVE];
            CCLabelTTF* movelabel = [CCLabelTTF labelWithString:movestr fontName:@"Arial" fontSize:9];
            movelabel.anchorPoint = ccp(0, 0.5);
            movelabel.position = ccp(hf.position.x, title.position.y - 58);
            [leftLayer addChild:movelabel z:2];
            
            NSString *arstr = [NSString stringWithFormat:@"攻击范围:%d",TROOP_WIZARD_ATTACK_RANGE];
            CCLabelTTF* arlabel = [CCLabelTTF labelWithString:arstr fontName:@"Arial" fontSize:9];
            arlabel.anchorPoint = ccp(0, 0.5);
            arlabel.position = ccp(hf.position.x, title.position.y - 70);
            [leftLayer addChild:arlabel z:2];
        }
        
        CCSprite* hf4 = [CCSprite spriteWithSpriteFrameName:@"itemframe2.png"];
        hf4.position = ccp(wsize.width*0.5-168, wsize.height*0.5+ibgheight*0.5 - 25 - hfheight*0.5 -(hfheight+5)*4);
        [leftLayer addChild:hf4 z:1];
        
        if (cio.blacksmith == 1) {
            CCLabelTTF* title = [CCLabelTTF labelWithString:@"弩车" fontName:@"Arial" fontSize:10];
            title.anchorPoint = ccp(0, 0.5);
            title.position = ccp(hf4.position.x - hf4.boundingBox.size.width*0.4, hf4.position.y + hf4.boundingBox.size.height*0.35);
            [leftLayer addChild:title z:2];
            
            RecruitDragTouchSprite* ba = [RecruitDragTouchSprite spriteWithSpriteFrameName:@"troop9_right_01.png"];
            ba.position = ccp(title.position.x + 10, title.position.y - 30);
            [leftLayer addChild:ba z:2];
            [ba initTheCallbackFunc0:@selector(checkReceiveSprite:) withCaller:self withTouchID:5 withImg:@"troop9_right_01.png" canDrag:YES];
            
            CCSprite* gold = [CCSprite spriteWithSpriteFrameName:@"gold.png"];
            gold.scale = 0.3;
            gold.anchorPoint = ccp(0, 0.5);
            gold.position = ccp(title.position.x, ba.position.y - 30);
            [leftLayer addChild:gold z:2];
            
            
            int money = TROOP_BALLISTA_COST_GOLD ;
            NSString *mstr = [NSString stringWithFormat:@"%d",money];
            CCLabelTTF* goldlabel = [CCLabelTTF labelWithString:mstr fontName:@"Arial" fontSize:9];
            goldlabel.anchorPoint = ccp(0, 0.5);
            goldlabel.color = ccWHITE;
            goldlabel.position = ccp(gold.position.x + 20, gold.position.y);
            [leftLayer addChild:goldlabel z:2];
            
            CCSprite* wood = [CCSprite spriteWithSpriteFrameName:@"wood.png"];
            wood.scale = 0.3;
            wood.anchorPoint = ccp(0, 0.5);
            wood.position = ccp(title.position.x, ba.position.y - 42);
            [leftLayer addChild:wood z:2];
            
            
            int woodcost = TROOP_BALLISTA_COST_WOOD ;
            NSString *wstr = [NSString stringWithFormat:@"%d",woodcost];
            CCLabelTTF* woodlabel = [CCLabelTTF labelWithString:wstr fontName:@"Arial" fontSize:9];
            woodlabel.anchorPoint = ccp(0, 0.5);
            woodlabel.color = ccWHITE;
            woodlabel.position = ccp(wood.position.x + 20, wood.position.y);
            [leftLayer addChild:woodlabel z:2];
            
            CCSprite* iron = [CCSprite spriteWithSpriteFrameName:@"iron.png"];
            iron.scale = 0.3;
            iron.anchorPoint = ccp(0, 0.5);
            iron.position = ccp(title.position.x, ba.position.y - 54);
            [leftLayer addChild:iron z:2];
            
            
            int ironcost = TROOP_BALLISTA_COST_IRON ;
            NSString *istr = [NSString stringWithFormat:@"%d",ironcost];
            CCLabelTTF* ironlabel = [CCLabelTTF labelWithString:istr fontName:@"Arial" fontSize:9];
            ironlabel.anchorPoint = ccp(0, 0.5);
            ironlabel.color = ccWHITE;
            ironlabel.position = ccp(iron.position.x + 20, iron.position.y);
            [leftLayer addChild:ironlabel z:2];
            
            //hp , mp , attack , mental , move , attack range
            NSString *hpstr = [NSString stringWithFormat:@"HP: %d",TROOP_BALLISTA_HP];
            CCLabelTTF* hplabel = [CCLabelTTF labelWithString:hpstr fontName:@"Arial" fontSize:9];
            hplabel.anchorPoint = ccp(0, 0.5);
            hplabel.position = ccp(hf.position.x, title.position.y - 10);
            [leftLayer addChild:hplabel z:2];
            
            NSString *mpstr = [NSString stringWithFormat:@"MP: %d",TROOP_BALLISTA_MP];
            CCLabelTTF* mplabel = [CCLabelTTF labelWithString:mpstr fontName:@"Arial" fontSize:9];
            mplabel.anchorPoint = ccp(0, 0.5);
            mplabel.position = ccp(hf.position.x, title.position.y - 22);
            [leftLayer addChild:mplabel z:2];
            
            NSString *attstr = [NSString stringWithFormat:@"攻击力: %d",TROOP_BALLISTA_ATTACK];
            CCLabelTTF* attlabel = [CCLabelTTF labelWithString:attstr fontName:@"Arial" fontSize:9];
            attlabel.anchorPoint = ccp(0, 0.5);
            attlabel.position = ccp(hf.position.x, title.position.y - 34);
            [leftLayer addChild:attlabel z:2];
            
            NSString *menstr = [NSString stringWithFormat:@"精神力: %d",TROOP_BALLISTA_MENTAL];
            CCLabelTTF* menlabel = [CCLabelTTF labelWithString:menstr fontName:@"Arial" fontSize:9];
            menlabel.anchorPoint = ccp(0, 0.5);
            menlabel.position = ccp(hf.position.x, title.position.y - 46);
            [leftLayer addChild:menlabel z:2];
            
            NSString *movestr = [NSString stringWithFormat:@"移动力: %d",TROOP_BALLISTA_MOVE];
            CCLabelTTF* movelabel = [CCLabelTTF labelWithString:movestr fontName:@"Arial" fontSize:9];
            movelabel.anchorPoint = ccp(0, 0.5);
            movelabel.position = ccp(hf.position.x, title.position.y - 58);
            [leftLayer addChild:movelabel z:2];
            
            NSString *arstr = [NSString stringWithFormat:@"攻击范围:%d",TROOP_BALLISTA_ATTACK_RANGE];
            CCLabelTTF* arlabel = [CCLabelTTF labelWithString:arstr fontName:@"Arial" fontSize:9];
            arlabel.anchorPoint = ccp(0, 0.5);
            arlabel.position = ccp(hf.position.x, title.position.y - 70);
            [leftLayer addChild:arlabel z:2];
            
            
            
            
            
            
        }
        else {
            CCLabelTTF* title = [CCLabelTTF labelWithString:@"铁匠铺未造" fontName:@"Arial" fontSize:10];
            title.anchorPoint = ccp(0, 0.5);
            title.position = ccp(hf4.position.x - hf4.boundingBox.size.width*0.4, hf4.position.y + hf4.boundingBox.size.height*0.35);
            [leftLayer addChild:title z:2];
            
            RecruitDragTouchSprite* ba = [RecruitDragTouchSprite spriteWithSpriteFrameName:@"troop9_gray_right_01.png"];
            ba.position = ccp(title.position.x + 10, title.position.y - 30);
            [leftLayer addChild:ba z:2];
            [ba initTheCallbackFunc0:@selector(checkReceiveSprite:) withCaller:self withTouchID:5 withImg:@"troop9_gray_right_01.png" canDrag:NO];
            
            CCSprite* gold = [CCSprite spriteWithSpriteFrameName:@"gold.png"];
            gold.scale = 0.3;
            gold.anchorPoint = ccp(0, 0.5);
            gold.position = ccp(title.position.x, ba.position.y - 30);
            [leftLayer addChild:gold z:2];
            
            
            int money = TROOP_BALLISTA_COST_GOLD ;
            NSString *mstr = [NSString stringWithFormat:@"%d",money];
            CCLabelTTF* goldlabel = [CCLabelTTF labelWithString:mstr fontName:@"Arial" fontSize:9];
            goldlabel.anchorPoint = ccp(0, 0.5);
            goldlabel.color = ccWHITE;
            goldlabel.position = ccp(gold.position.x + 20, gold.position.y);
            [leftLayer addChild:goldlabel z:2];
            
            CCSprite* wood = [CCSprite spriteWithSpriteFrameName:@"wood.png"];
            wood.scale = 0.3;
            wood.anchorPoint = ccp(0, 0.5);
            wood.position = ccp(title.position.x, ba.position.y - 42);
            [leftLayer addChild:wood z:2];
            
            
            int woodcost = TROOP_BALLISTA_COST_WOOD ;
            NSString *wstr = [NSString stringWithFormat:@"%d",woodcost];
            CCLabelTTF* woodlabel = [CCLabelTTF labelWithString:wstr fontName:@"Arial" fontSize:9];
            woodlabel.anchorPoint = ccp(0, 0.5);
            woodlabel.color = ccWHITE;
            woodlabel.position = ccp(wood.position.x + 20, wood.position.y);
            [leftLayer addChild:woodlabel z:2];
            
            CCSprite* iron = [CCSprite spriteWithSpriteFrameName:@"iron.png"];
            iron.scale = 0.3;
            iron.anchorPoint = ccp(0, 0.5);
            iron.position = ccp(title.position.x, ba.position.y - 54);
            [leftLayer addChild:iron z:2];
            
            
            int ironcost = TROOP_BALLISTA_COST_IRON ;
            NSString *istr = [NSString stringWithFormat:@"%d",ironcost];
            CCLabelTTF* ironlabel = [CCLabelTTF labelWithString:istr fontName:@"Arial" fontSize:9];
            ironlabel.anchorPoint = ccp(0, 0.5);
            ironlabel.color = ccWHITE;
            ironlabel.position = ccp(iron.position.x + 20, iron.position.y);
            [leftLayer addChild:ironlabel z:2];
            
            //hp , mp , attack , mental , move , attack range
            NSString *hpstr = [NSString stringWithFormat:@"HP: %d",TROOP_BALLISTA_HP];
            CCLabelTTF* hplabel = [CCLabelTTF labelWithString:hpstr fontName:@"Arial" fontSize:9];
            hplabel.anchorPoint = ccp(0, 0.5);
            hplabel.position = ccp(hf.position.x, title.position.y - 10);
            [leftLayer addChild:hplabel z:2];
            
            NSString *mpstr = [NSString stringWithFormat:@"MP: %d",TROOP_BALLISTA_MP];
            CCLabelTTF* mplabel = [CCLabelTTF labelWithString:mpstr fontName:@"Arial" fontSize:9];
            mplabel.anchorPoint = ccp(0, 0.5);
            mplabel.position = ccp(hf.position.x, title.position.y - 22);
            [leftLayer addChild:mplabel z:2];
            
            NSString *attstr = [NSString stringWithFormat:@"攻击力: %d",TROOP_BALLISTA_ATTACK];
            CCLabelTTF* attlabel = [CCLabelTTF labelWithString:attstr fontName:@"Arial" fontSize:9];
            attlabel.anchorPoint = ccp(0, 0.5);
            attlabel.position = ccp(hf.position.x, title.position.y - 34);
            [leftLayer addChild:attlabel z:2];
            
            NSString *menstr = [NSString stringWithFormat:@"精神力: %d",TROOP_BALLISTA_MENTAL];
            CCLabelTTF* menlabel = [CCLabelTTF labelWithString:menstr fontName:@"Arial" fontSize:9];
            menlabel.anchorPoint = ccp(0, 0.5);
            menlabel.position = ccp(hf.position.x, title.position.y - 46);
            [leftLayer addChild:menlabel z:2];
            
            NSString *movestr = [NSString stringWithFormat:@"移动力: %d",TROOP_BALLISTA_MOVE];
            CCLabelTTF* movelabel = [CCLabelTTF labelWithString:movestr fontName:@"Arial" fontSize:9];
            movelabel.anchorPoint = ccp(0, 0.5);
            movelabel.position = ccp(hf.position.x, title.position.y - 58);
            [leftLayer addChild:movelabel z:2];
            
            NSString *arstr = [NSString stringWithFormat:@"攻击范围:%d",TROOP_BALLISTA_ATTACK_RANGE];
            CCLabelTTF* arlabel = [CCLabelTTF labelWithString:arstr fontName:@"Arial" fontSize:9];
            arlabel.anchorPoint = ccp(0, 0.5);
            arlabel.position = ccp(hf.position.x, title.position.y - 70);
            [leftLayer addChild:arlabel z:2];
        }
        
        maxBottomLeftY = (hfheight+5)*5 - leftContent.size.height + 10 ;
        
        [self updateLeftLayerVisible];
        
        
        //now for the hero list
        CGFloat hbgheight = herobg.boundingBox.size.height;
        
        int kid = [ShareGameManager shareGameManager].kingID;
        NSArray* heroes = [[ShareGameManager shareGameManager] getHeroListFromCity:_cityID kingID:kid];
        int ilen = (int)[heroes count];
        for (int i=0;i<ilen;i++) {
            HeroObject *ho = [heroes objectAtIndex:i];
            
            //frame
            CCSprite* hf = [CCSprite spriteWithSpriteFrameName:@"heroframe.png"];
            hfheight = hf.boundingBox.size.height;
            hf.position = ccp(wsize.width*0.5+80, wsize.height*0.5+hbgheight*0.5 - 10 - hfheight*0.5 -(hfheight+5)*i);
            [rightLayer addChild:hf z:1];
            
            //hero head
            NSString* hfile = [NSString stringWithFormat:@"hero%d.png",ho.headImageID];
            CCSprite* hhead = [CCSprite spriteWithSpriteFrameName:hfile];
            hhead.position = ccp(hf.position.x - hf.boundingBox.size.width*0.5 + 40, hf.position.y+15);
            [rightLayer addChild:hhead z:2];
            
            //hero name , level , hp , mp , attack , //attack range, move range
            NSString* compound = [NSString stringWithFormat:@"%@ %d级", ho.cname, ho.level ];
            CCLabelTTF* hnamelabel = [CCLabelTTF labelWithString:compound fontName:@"Arial" fontSize:10];
            hnamelabel.anchorPoint = ccp(0, 0.5);
            //hnamelabel.color = ccORANGE;
            hnamelabel.position = ccp(hhead.position.x - 20, hhead.position.y - 30);
            [rightLayer addChild:hnamelabel z:2];
            
            NSString* sistr = [NSString stringWithFormat:@"武:%d  智:%d",ho.strength,ho.intelligence];
            CCLabelTTF* silabel = [CCLabelTTF labelWithString:sistr fontName:@"Arial" fontSize:10];
            silabel.anchorPoint = ccp(0, 0.5);
            //hnamelabel.color = ccORANGE;
            silabel.position = ccp(hhead.position.x - 20, hhead.position.y - 45);
            [rightLayer addChild:silabel z:2];
            
            NSString* armystr = [NSString stringWithFormat:@"部队攻击力: %d",ho.troopAttack];
            CCLabelTTF* armyatt = [CCLabelTTF labelWithString:armystr fontName:@"Arial" fontSize:10];
            armyatt.anchorPoint = ccp(0, 0.5);
            armyatt.position = ccp(hhead.position.x + hhead.boundingBox.size.width*0.5 + 30, hf.position.y+10);
            [rightLayer addChild:armyatt z:2];
            
            NSString* armystr2 = [NSString stringWithFormat:@"部队精神力: %d",ho.troopMental];
            CCLabelTTF* armyment = [CCLabelTTF labelWithString:armystr2 fontName:@"Arial" fontSize:10];
            armyment.anchorPoint = ccp(0, 0.5);
            armyment.position = ccp(armyatt.position.x, hf.position.y - 10);
            [rightLayer addChild:armyment z:2];
            
            CCSprite *armybg = [CCSprite spriteWithSpriteFrameName:@"hero_bg.png"];
            armybg.position = ccp(hf.position.x + hf.boundingBox.size.width*0.5 - 80, hhead.position.y-10);
            armybg.scale = 1.2;
            [rightLayer addChild:armybg z:2];
            
            NSString* armyfile = @"skill99.png";
            if (ho.troopType == 1) {
                armyfile = @"troop1_right_01.png";
            }
            else if (ho.troopType == 2) {
                armyfile = @"troop3_right_01.png";
            }
            else if (ho.troopType == 3) {
                armyfile = @"troop5_right_01.png";
            }
            else if (ho.troopType == 4) {
                armyfile = @"troop7_right_01.png";
            }
            else if (ho.troopType == 5) {
                armyfile = @"troop9_right_01.png";
            }
            UnitReceiveDropSprite* udsp = [UnitReceiveDropSprite spriteWithSpriteFrameName:armyfile];
            udsp.position = armybg.position;
            udsp.heroID = ho.heroID;
            udsp.unitTypeID = ho.troopType;
            udsp.count = ho.troopCount;
            [rightLayer addChild:udsp z:3];
            [receivers addObject:udsp];
            
            NSString* armycountstr = [NSString stringWithFormat:@"%d",ho.troopCount];
            CCLabelTTFWithInfo* armyinfo = [CCLabelTTFWithInfo labelWithString:armycountstr fontName:@"Arial" fontSize:12];
            armyinfo.position = ccp(udsp.position.x, udsp.position.y- 35);
            armyinfo.asscoiateID = ho.heroID;
            [rightLayer addChild:armyinfo z:2];
            [troopCountLabels addObject:armyinfo];
            
        }
        
        maxBootomRightY = (hfheight+5)*ilen - rightContent.size.height + 10 ;
        
        [self updateRightLayerVisible];
        
    }
    
    return self;
}



-(void) recruitTroopForHero
{
    
    CCLOG(@"recruit troop call....");
    [[SimpleAudioEngine sharedEngine] playEffect:@"sthget.caf"];
    int gcost;
    int wcost;
    int icost;
    int va = recruitTroopCount;
    switch (currentTroopType) {
        case 1:
            gcost = TROOP_FOOTMAN_COST_GOLD * va;
            wcost = TROOP_FOOTMAN_COST_WOOD * va;
            icost = TROOP_FOOTMAN_COST_IRON * va;
            break;
        case 2:
            gcost = TROOP_ARCHER_COST_GOLD * va;
            wcost = TROOP_ARCHER_COST_WOOD * va;
            icost = TROOP_ARCHER_COST_IRON * va;
            break;
        case 3:
            gcost = TROOP_CAVALRY_COST_GOLD * va;
            wcost = TROOP_CAVALRY_COST_WOOD * va;
            icost = TROOP_CAVALRY_COST_IRON * va;
            break;
        case 4:
            gcost = TROOP_WIZARD_COST_GOLD * va;
            wcost = TROOP_WIZARD_COST_WOOD * va;
            icost = TROOP_WIZARD_COST_IRON * va;
            break;
        case 5:
            gcost = TROOP_BALLISTA_COST_GOLD * va;
            wcost = TROOP_BALLISTA_COST_WOOD * va;
            icost = TROOP_BALLISTA_COST_IRON * va;
            break;
        default:
            gcost = TROOP_FOOTMAN_COST_GOLD * va;
            wcost = TROOP_FOOTMAN_COST_WOOD * va;
            icost = TROOP_FOOTMAN_COST_IRON * va;
            break;
            
    }
    
    //update the hero troop
    int newcount = recruitTroopCount + currentTroopCount;
    [[ShareGameManager shareGameManager] heroRecruitTroop:currentHeroID newTroopCount:newcount];
    
    //update the city troop count
    [[ShareGameManager shareGameManager] updateCityTroopCount:recruitTroopCount withTroopType:currentTroopType withCityID:_cityID];
    
    //update the right layer
    CCLabelTTFWithInfo *cli;
    CCARRAY_FOREACH(troopCountLabels, cli)
    {
        if (cli.asscoiateID == currentHeroID) {
            [cli setString:[NSString stringWithFormat:@"%d",newcount]];
            break;
        }
    }
    
    
    [ShareGameManager shareGameManager].gold -= gcost;
    [ShareGameManager shareGameManager].wood -= wcost;
    [ShareGameManager shareGameManager].iron -= icost;
    
    //play effect
    CGPoint startP = rgLabel.position;
    
    CCSprite* decpic = [CCSprite spriteWithSpriteFrameName:@"reduce.png"];
    decpic.position = ccp(startP.x - 40, startP.y);
    [self addChild:decpic z:3];
    CCMoveBy *mv0 = [CCMoveBy actionWithDuration:1.2f position:ccp(0,60)];
    CCFadeOut *fo0 = [CCFadeOut actionWithDuration:1.5f];
    CCSpawn *sp0 = [CCSpawn actions:mv0,fo0, nil];
    CCCallBlockN *cb0 = [CCCallBlockN actionWithBlock:^(CCNode *node) {
        [node removeFromParentAndCleanup:YES];
    }];
    CCSequence *se0 = [CCSequence actions:sp0,cb0, nil];
    [decpic runAction:se0];
    
    
    
    CCSprite* gold = [CCSprite spriteWithSpriteFrameName:@"gold.png"];
    gold.scale = 0.5;
    gold.position = ccp(startP.x - 20, startP.y);
    [self addChild:gold z:3];
    
    CCMoveBy *mv = [CCMoveBy actionWithDuration:1.2f position:ccp(0,60)];
    CCFadeOut *fo = [CCFadeOut actionWithDuration:1.5f];
    CCSpawn *sp = [CCSpawn actions:mv,fo, nil];
    CCCallBlockN *cb = [CCCallBlockN actionWithBlock:^(CCNode *node) {
        [node removeFromParentAndCleanup:YES];
    }];
    CCSequence *se = [CCSequence actions:sp,cb, nil];
    [gold runAction:se];
    
    CCSprite* wood = [CCSprite spriteWithSpriteFrameName:@"wood.png"];
    wood.scale = 0.5;
    wood.position = ccp(startP.x, startP.y);
    [self addChild:wood z:3];
    
    CCMoveBy *mv1 = [CCMoveBy actionWithDuration:1.2f position:ccp(0,60)];
    CCFadeOut *fo1 = [CCFadeOut actionWithDuration:1.5f];
    CCSpawn *sp1 = [CCSpawn actions:mv1,fo1, nil];
    CCCallBlockN *cb1 = [CCCallBlockN actionWithBlock:^(CCNode *node) {
        [node removeFromParentAndCleanup:YES];
    }];
    CCSequence *se1 = [CCSequence actions:sp1,cb1, nil];
    [wood runAction:se1];
    
    CCSprite* iron = [CCSprite spriteWithSpriteFrameName:@"iron.png"];
    iron.scale = 0.5;
    iron.position = ccp(startP.x + 20, startP.y);
    [self addChild:iron z:3];
    
    CCMoveBy *mv2 = [CCMoveBy actionWithDuration:1.2f position:ccp(0,60)];
    CCFadeOut *fo2 = [CCFadeOut actionWithDuration:1.5f];
    CCSpawn *sp2 = [CCSpawn actions:mv2,fo2, nil];
    CCCallBlockN *cb2 = [CCCallBlockN actionWithBlock:^(CCNode *node) {
        [node removeFromParentAndCleanup:YES];
    }];
    CCSequence *se2 = [CCSequence actions:sp2,cb2, nil];
    [iron runAction:se2];
    
    
    
    
    //update the main layer label
    //main update ui text
    CCScene* run = [[CCDirector sharedDirector] runningScene];
    CCLayer* main = (CCLayer*) [run getChildByTag:1];
    if (main) {
        [main performSelector:@selector(updateResourceLabel)];
    }
    
    //finall call closePaymentDialog
    [self closePaymentDialog];
}

-(void) closePaymentDialog
{
    showPaymentDialog = 0;
    currentHeroID = -1;
    currentTroopCount = 0;
    currentTroopType = 0;
    maxTroopCount = 0;
    recruitTroopCount = 0;
    
    CCLOG(@"close payment layer");
    if (paymentLayer) {
        [self removeChild:paymentLayer cleanup:YES];
    }
    paymentLayer = nil;
    
}

-(void) checkReceiveSprite:(UnitDragSprite*)_drag
{
    CCLOG(@"article id is : %d",_drag.unitTypeID);
    CGPoint mpos = _drag.position;
    CGPoint mpos1 = [rightLayer convertToNodeSpace:mpos];
    for (UnitReceiveDropSprite* item in receivers) {
        if (CGRectContainsPoint(item.boundingBox, mpos1)) {
            CCLOG(@"the receive is: hero : %d, article pos: %d",item.heroID,item.unitTypeID);
            if ((item.unitTypeID == 0)||(item.unitTypeID == _drag.unitTypeID)) {
                //原来没有部队，可以分配，或者原来有部队，和现在分配的事同一种
                currentHeroID = item.heroID;
                currentTroopType = _drag.unitTypeID;
                currentTroopCount = item.count;
                int goldcost;
                int woodcost;
                int ironcost;
                switch (currentTroopType) {
                    case 1:
                        goldcost = TROOP_FOOTMAN_COST_GOLD;
                        woodcost = TROOP_FOOTMAN_COST_WOOD;
                        ironcost = TROOP_FOOTMAN_COST_IRON;
                        break;
                    case 2:
                        goldcost = TROOP_ARCHER_COST_GOLD;
                        woodcost = TROOP_ARCHER_COST_WOOD;
                        ironcost = TROOP_ARCHER_COST_IRON;
                        break;
                    case 3:
                        goldcost = TROOP_CAVALRY_COST_GOLD;
                        woodcost = TROOP_CAVALRY_COST_WOOD;
                        ironcost = TROOP_CAVALRY_COST_IRON;
                        break;
                    case 4:
                        goldcost = TROOP_WIZARD_COST_GOLD;
                        woodcost = TROOP_WIZARD_COST_WOOD;
                        ironcost = TROOP_WIZARD_COST_IRON;
                        break;
                        goldcost = TROOP_BALLISTA_COST_GOLD;
                        woodcost = TROOP_BALLISTA_COST_WOOD;
                        ironcost = TROOP_BALLISTA_COST_IRON;
                        break;
                        
                    default:
                        goldcost = TROOP_FOOTMAN_COST_GOLD;
                        woodcost = TROOP_FOOTMAN_COST_WOOD;
                        ironcost = TROOP_FOOTMAN_COST_IRON;
                        break;
                }
                int max1 = [ShareGameManager shareGameManager].gold / goldcost;
                int max2;
                int max3;
                if ((woodcost==0)&&(ironcost==0)) {
                    max2 = max1;
                    max3 = max1;
                }
                else if (ironcost == 0) {
                    max2 = [ShareGameManager shareGameManager].wood / woodcost;
                    max3 = MIN(max1, max2);
                }
                else {
                    max2 = [ShareGameManager shareGameManager].wood / woodcost;
                    max3 = [ShareGameManager shareGameManager].iron / ironcost;
                }
                maxTroopCount = MIN(max1, MIN(max2, max3));
                CCLOG(@"max can recruit : %d",maxTroopCount);
                
                showPaymentDialog = 1;
                
                paymentLayer = [[CCNode alloc] init];
                [self addChild:paymentLayer z:2];
                
                
                CCSprite* mbg = [CCSprite spriteWithSpriteFrameName:@"unitrangebg.png"];
                CGSize wsize = [[CCDirector sharedDirector] winSize];
                mbg.position = ccp(wsize.width*0.5, wsize.height*0.5);
                [paymentLayer addChild:mbg z:0];
                
                NSString* unitfile = @"troop1_right_01.png";
                int unithp;
                int unitmp;
                int unitattack;
                int unitmental;
                int unitmove;
                int unitrange;
                int unitgold;
                int unitwood;
                int unitiron;
                switch (currentTroopType) {
                    case 1:
                        unitfile = @"troop1_right_01.png";
                        unithp = TROOP_FOOTMAN_HP;
                        unitmp = TROOP_FOOTMAN_MP;
                        unitattack = TROOP_FOOTMAN_ATTACK;
                        unitmental = TROOP_FOOTMAN_MENTAL;
                        unitmove = TROOP_FOOTMAN_MOVE;
                        unitrange = TROOP_FOOTMAN_ATTACK_RANGE;
                        unitgold = TROOP_FOOTMAN_COST_GOLD;
                        unitwood = TROOP_FOOTMAN_COST_WOOD;
                        unitiron = TROOP_FOOTMAN_COST_IRON;
                        break;
                    case 2:
                        unitfile = @"troop3_right_01.png";
                        unithp = TROOP_ARCHER_HP;
                        unitmp = TROOP_ARCHER_MP;
                        unitattack = TROOP_ARCHER_ATTACK;
                        unitmental = TROOP_ARCHER_MENTAL;
                        unitmove = TROOP_ARCHER_MOVE;
                        unitrange = TROOP_ARCHER_ATTACK_RANGE;
                        unitgold = TROOP_ARCHER_COST_GOLD;
                        unitwood = TROOP_ARCHER_COST_WOOD;
                        unitiron = TROOP_ARCHER_COST_IRON;
                        break;
                    case 3:
                        unitfile = @"troop5_right_01.png";
                        unithp = TROOP_CAVALRY_HP;
                        unitmp = TROOP_CAVALRY_MP;
                        unitattack = TROOP_CAVALRY_ATTACK;
                        unitmental = TROOP_CAVALRY_MENTAL;
                        unitmove = TROOP_CAVALRY_MOVE;
                        unitrange = TROOP_CAVALRY_ATTACK_RANGE;
                        unitgold = TROOP_CAVALRY_COST_GOLD;
                        unitwood = TROOP_CAVALRY_COST_WOOD;
                        unitiron = TROOP_CAVALRY_COST_IRON;
                        break;
                    case 4:
                        unitfile = @"troop7_right_01.png";
                        unithp = TROOP_WIZARD_HP;
                        unitmp = TROOP_WIZARD_MP;
                        unitattack = TROOP_WIZARD_ATTACK;
                        unitmental = TROOP_WIZARD_MENTAL;
                        unitmove = TROOP_WIZARD_MOVE;
                        unitrange = TROOP_WIZARD_ATTACK_RANGE;
                        unitgold = TROOP_WIZARD_COST_GOLD;
                        unitwood = TROOP_WIZARD_COST_WOOD;
                        unitiron = TROOP_WIZARD_COST_IRON;
                        break;
                    case 5:
                        unitfile = @"troop9_right_01.png";
                        unithp = TROOP_BALLISTA_HP;
                        unitmp = TROOP_BALLISTA_MP;
                        unitattack = TROOP_BALLISTA_ATTACK;
                        unitmental = TROOP_BALLISTA_MENTAL;
                        unitmove = TROOP_BALLISTA_MOVE;
                        unitrange = TROOP_BALLISTA_ATTACK_RANGE;
                        unitgold = TROOP_BALLISTA_COST_GOLD;
                        unitwood = TROOP_BALLISTA_COST_WOOD;
                        unitiron = TROOP_BALLISTA_COST_IRON;
                        break;
                    default:
                        unitfile = @"troop1_right_01.png";
                        unithp = TROOP_FOOTMAN_HP;
                        unitmp = TROOP_FOOTMAN_MP;
                        unitattack = TROOP_FOOTMAN_ATTACK;
                        unitmental = TROOP_FOOTMAN_MENTAL;
                        unitmove = TROOP_FOOTMAN_MOVE;
                        unitrange = TROOP_FOOTMAN_ATTACK_RANGE;
                        unitgold = TROOP_FOOTMAN_COST_GOLD;
                        unitwood = TROOP_FOOTMAN_COST_WOOD;
                        unitiron = TROOP_FOOTMAN_COST_IRON;
                        break;
                }
                
                CCSprite* unitimg = [CCSprite spriteWithSpriteFrameName:unitfile];
                unitimg.position = ccp(mbg.position.x - mbg.boundingBox.size.width*0.15, mbg.position.y + mbg.boundingBox.size.height*0.15);
                [paymentLayer addChild:unitimg z:1];
                
                //hp,mp,attack,mental,move,attack range
                NSString *hpstr = [NSString stringWithFormat:@"HP: %d",unithp];
                CCLabelTTF* hplabel = [CCLabelTTF labelWithString:hpstr fontName:@"Arial" fontSize:9];
                hplabel.anchorPoint = ccp(0, 0.5);
                hplabel.position = ccp(unitimg.position.x + 40, unitimg.position.y + 40);
                [paymentLayer addChild:hplabel z:1];
                
                NSString *mpstr = [NSString stringWithFormat:@"MP: %d",unitmp];
                CCLabelTTF* mplabel = [CCLabelTTF labelWithString:mpstr fontName:@"Arial" fontSize:9];
                mplabel.anchorPoint = ccp(0, 0.5);
                mplabel.position = ccp(unitimg.position.x + 40, unitimg.position.y + 25);
                [paymentLayer addChild:mplabel z:1];
                
                NSString *attstr = [NSString stringWithFormat:@"攻击力: %d",unitattack];
                CCLabelTTF* attlabel = [CCLabelTTF labelWithString:attstr fontName:@"Arial" fontSize:9];
                attlabel.anchorPoint = ccp(0, 0.5);
                attlabel.position = ccp(unitimg.position.x + 40, unitimg.position.y + 10);
                [paymentLayer addChild:attlabel z:1];
                
                NSString *menstr = [NSString stringWithFormat:@"精神力: %d",unitmental];
                CCLabelTTF* menlabel = [CCLabelTTF labelWithString:menstr fontName:@"Arial" fontSize:9];
                menlabel.anchorPoint = ccp(0, 0.5);
                menlabel.position = ccp(unitimg.position.x + 40, unitimg.position.y - 5);
                [paymentLayer addChild:menlabel z:1];
                
                NSString *movestr = [NSString stringWithFormat:@"移动力: %d",unitmove];
                CCLabelTTF* movelabel = [CCLabelTTF labelWithString:movestr fontName:@"Arial" fontSize:9];
                movelabel.anchorPoint = ccp(0, 0.5);
                movelabel.position = ccp(unitimg.position.x + 40, unitimg.position.y - 20);
                [paymentLayer addChild:movelabel z:1];
                
                NSString *arstr = [NSString stringWithFormat:@"攻击范围:%d",unitrange];
                CCLabelTTF* arlabel = [CCLabelTTF labelWithString:arstr fontName:@"Arial" fontSize:9];
                arlabel.anchorPoint = ccp(0, 0.5);
                arlabel.position = ccp(unitimg.position.x + 40, unitimg.position.y - 35);
                [paymentLayer addChild:arlabel z:1];
                
                CCSprite* sliderbg = [CCSprite spriteWithSpriteFrameName:@"slider_back1.png"];
                CCSprite* sliderbar = [CCSprite spriteWithSpriteFrameName:@"slider_bar1.png"];
                CCSprite* slider = [CCSprite spriteWithSpriteFrameName:@"slider.png"];
                CCControlSlider* cs = [CCControlSlider sliderWithBackgroundSprite:sliderbg progressSprite:sliderbar thumbSprite:slider];
                cs.position = ccp(mbg.position.x,mbg.position.y - mbg.boundingBox.size.height*0.2);
                [paymentLayer addChild:cs z:1];
                cs.minimumValue = 0;
                cs.maximumValue = maxTroopCount;
                [cs addTarget:self action:@selector(sliderChanged:) forControlEvents:CCControlEventValueChanged];
                
                CCLabelTTF* zero = [CCLabelTTF labelWithString:@"0" fontName:@"Arial" fontSize:12];
                zero.position = ccp(cs.position.x - cs.boundingBox.size.width*0.5, cs.position.y - 25);
                [paymentLayer addChild:zero z:1];
                
                recuritLabel = [CCLabelTTF labelWithString:@"0" fontName:@"Arial" fontSize:12];
                recuritLabel.position = ccp(cs.position.x + cs.boundingBox.size.width*0.5, cs.position.y - 25);
                [paymentLayer addChild:recuritLabel z:1];
                
                //now add cost money label
                TouchableSprite* otherBtn = [TouchableSprite spriteWithSpriteFrameName:@"buildrecruitbtn.png"];
                otherBtn.position = ccp(mbg.position.x + mbg.boundingBox.size.width*0.5-55, mbg.position.y + mbg.boundingBox.size.height*0.5 - 40);
                
                [paymentLayer addChild:otherBtn z:1];
                [otherBtn initTheCallbackFunc:@selector(recruitTroopForHero) withCaller:self withTouchID:-1];
                
                
                CCSprite* gold = [CCSprite spriteWithSpriteFrameName:@"gold.png"];
                gold.scale = 0.3;
                gold.anchorPoint = ccp(0, 0.5);
                gold.position = ccp(otherBtn.position.x-12, otherBtn.position.y - 20);
                [paymentLayer addChild:gold z:1];
                
                
                rgLabel = [CCLabelTTF labelWithString:@"0" fontName:@"Arial" fontSize:9];
                rgLabel.anchorPoint = ccp(0, 0.5);
                rgLabel.position = ccp(gold.position.x + 20, gold.position.y);
                [paymentLayer addChild:rgLabel z:1];
                
                CCSprite* wood = [CCSprite spriteWithSpriteFrameName:@"wood.png"];
                wood.scale = 0.3;
                wood.anchorPoint = ccp(0, 0.5);
                wood.position = ccp(otherBtn.position.x-12, otherBtn.position.y - 32);
                [paymentLayer addChild:wood z:1];
                
                
                rwLabel = [CCLabelTTF labelWithString:@"0" fontName:@"Arial" fontSize:9];
                rwLabel.anchorPoint = ccp(0, 0.5);
                rwLabel.position = ccp(wood.position.x + 20, wood.position.y);
                [paymentLayer addChild:rwLabel z:1];
                
                CCSprite* iron = [CCSprite spriteWithSpriteFrameName:@"iron.png"];
                iron.scale = 0.3;
                iron.anchorPoint = ccp(0, 0.5);
                iron.position = ccp(otherBtn.position.x-12, otherBtn.position.y - 44);
                [paymentLayer addChild:iron z:1];
                
                
                
                riLabel = [CCLabelTTF labelWithString:@"0" fontName:@"Arial" fontSize:9];
                riLabel.anchorPoint = ccp(0, 0.5);
                riLabel.position = ccp(iron.position.x + 20, iron.position.y);
                [paymentLayer addChild:riLabel z:1];
                
                
                
            }
            else {
                //原来有部队，和现在分配的不是同一种，无法分配
                [[SimpleAudioEngine sharedEngine] playEffect:@"fail.caf"];
                
                CGSize wszie = [[CCDirector sharedDirector] winSize];
                CCSprite* stbar = [CCSprite spriteWithSpriteFrameName:@"statusbar.png"];
                stbar.position = ccp(wszie.width*0.5, wszie.height*0.5);
                [self addChild:stbar z:5];
                [stbar performSelector:@selector(removeFromParent) withObject:nil afterDelay:1.5];
                
                CCLabelTTF* warn = [CCLabelTTF labelWithString:@"无法招募，兵种不同！" fontName:@"Arial" fontSize:15];
                warn.color = ccYELLOW;
                warn.position = stbar.position;
                [self addChild:warn z:6];
                [warn performSelector:@selector(removeFromParent) withObject:nil afterDelay:1.5];
            }
            
            
            break;
            
        }
    }
    
}

-(void) sliderChanged:(CCControlSlider*)sender
{
    int va = (int)sender.value;
    CCLOG(@"slider value is :%d",(int)(sender.value));
    if (recuritLabel) {
        [recuritLabel setString:[NSString stringWithFormat:@"%d",va]];
    }
    recruitTroopCount = va;
    //now change the cost label
    int gcost;
    int wcost;
    int icost;
    switch (currentTroopType) {
        case 1:
            gcost = TROOP_FOOTMAN_COST_GOLD * va;
            wcost = TROOP_FOOTMAN_COST_WOOD * va;
            icost = TROOP_FOOTMAN_COST_IRON * va;
            break;
        case 2:
            gcost = TROOP_ARCHER_COST_GOLD * va;
            wcost = TROOP_ARCHER_COST_WOOD * va;
            icost = TROOP_ARCHER_COST_IRON * va;
            break;
        case 3:
            gcost = TROOP_CAVALRY_COST_GOLD * va;
            wcost = TROOP_CAVALRY_COST_WOOD * va;
            icost = TROOP_CAVALRY_COST_IRON * va;
            break;
        case 4:
            gcost = TROOP_WIZARD_COST_GOLD * va;
            wcost = TROOP_WIZARD_COST_WOOD * va;
            icost = TROOP_WIZARD_COST_IRON * va;
            break;
        case 5:
            gcost = TROOP_BALLISTA_COST_GOLD * va;
            wcost = TROOP_BALLISTA_COST_WOOD * va;
            icost = TROOP_BALLISTA_COST_IRON * va;
            break;
        default:
            gcost = TROOP_FOOTMAN_COST_GOLD * va;
            wcost = TROOP_FOOTMAN_COST_WOOD * va;
            icost = TROOP_FOOTMAN_COST_IRON * va;
            break;
            
    }
    if (rgLabel) {
        [rgLabel setString:[NSString stringWithFormat:@"%d",gcost]];
    }
    if (rwLabel) {
        [rwLabel setString:[NSString stringWithFormat:@"%d",wcost]];
    }
    if (riLabel) {
        [riLabel setString:[NSString stringWithFormat:@"%d",icost]];
    }
    
    
}


-(void) updateLeftChildVisible:(CCNode*)ch
{
    CGRect cb = CGRectApplyAffineTransform(ch.boundingBox, [leftLayer nodeToParentTransform]);
    CGRect cb2 = CGRectApplyAffineTransform(cb, [self nodeToParentTransform]);
    if (CGRectContainsRect(leftContent, cb2)) {
        ch.visible = YES;
    }
    else {
        ch.visible = NO;
    }
}

-(void) updateRightChildVisible:(CCNode*)ch
{
    CGRect cb = CGRectApplyAffineTransform(ch.boundingBox, [rightLayer nodeToParentTransform]);
    CGRect cb2 = CGRectApplyAffineTransform(cb, [self nodeToParentTransform]);
    if (CGRectContainsRect(rightContent, cb2)) {
        ch.visible = YES;
    }
    else {
        ch.visible = NO;
    }
}

-(void) onEnter
{
    [[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:1 swallowsTouches:YES];
    [super onEnter];
}

-(void) onExit
{
    CCLOG(@"call SkillLayer onExit()....");
    [[[CCDirector sharedDirector] touchDispatcher] removeDelegate:self];
    [super onExit];
}

- (BOOL) ccTouchBegan:(UITouch*)touch withEvent:(UIEvent *)event {
    
    CGPoint touchLocation = [[CCDirector sharedDirector] convertToGL:[touch locationInView: [touch view]]];
    if (CGRectContainsPoint(leftContent, touchLocation)) {
        CCLOG(@"touch on skill left layer....");
        layerDragState = LeftLayerDrag;
        
        //if (showPaymentDialog) {
        //    needClosePayment = 1;
        //    needClose = 0;
        //}
        
        
        return YES;
    }
    else if (CGRectContainsPoint(rightContent, touchLocation)) {
        CCLOG(@"touch on skill right layer....");
        layerDragState = RightLayerDrag;
        
        //if (showPaymentDialog) {
        //    needClosePayment = 1;
        //    needClose = 0;
        //}
        
        return YES;
    }
    else {
        //close self after 0.5 second
        if (showPaymentDialog) {
            needClosePayment = 1;
            needClose = 0;
        }
        else {
            needClose = 1;
        }
        //[self performSelector:@selector(removeFromParent) withObject:nil afterDelay:0.5];
        return YES;
    }
    
    
}

- (void) ccTouchMoved:(UITouch*)touch withEvent:(UIEvent *)event {
    //check _dragging , _moveLeft , _moveRight tag
    
    CGPoint preLocation = [touch previousLocationInView:[touch view]];
    CGPoint curLocation = [touch locationInView:[touch view]];
    
    CGPoint a = [[CCDirector sharedDirector] convertToGL:preLocation];
    CGPoint b = [[CCDirector sharedDirector] convertToGL:curLocation];
    
    if (layerDragState == LeftLayerDrag) {
        CGPoint nowPosition = leftLayer.position;
        
        float minY = 0;
        float maxY = (leftContent.size.height) - leftLayer.contentSize.height;
        //CCLOG(@"maxY:%f",maxY);
        float delta = ( b.y - a.y );
        float deltaY = nowPosition.y + delta;
        if(deltaY < maxY || deltaY > minY) {
            delta *= 0.5;
        }
        nowPosition.y += delta;
        bounceDistance = 0;
        
        if (nowPosition.y <0) {
            bounceDistance = nowPosition.y;
        }
        else if (nowPosition.y > maxBottomLeftY) {
            bounceDistance = (nowPosition.y - maxBottomLeftY);
        }
        
        [leftLayer setPosition:nowPosition];
        [self updateLeftLayerVisible];
        
    }
    else if (layerDragState == RightLayerDrag) {
        CGPoint nowPosition = rightLayer.position;
        
        float minY = 0;
        float maxY = (rightContent.size.height) - rightLayer.contentSize.height;
        //CCLOG(@"maxY:%f",maxY);
        float delta = ( b.y - a.y );
        float deltaY = nowPosition.y + delta;
        if(deltaY < maxY || deltaY > minY) {
            delta *= 0.5;
        }
        nowPosition.y += delta;
        bounceDistance = 0;
        
        if (nowPosition.y <0) {
            bounceDistance = nowPosition.y;
        }
        else if (nowPosition.y > maxBootomRightY) {
            bounceDistance = (nowPosition.y - maxBootomRightY);
        }
        
        [rightLayer setPosition:nowPosition];
        [self updateRightLayerVisible];
    }
    
    
    
    
}

- (void) ccTouchEnded:(UITouch*)touch withEvent:(UIEvent *)event {
    //set all tag == 0
    //set drag image == nil
    
    if (layerDragState == LeftLayerDrag) {
        if (bounceDistance != 0) {
            CCMoveBy* mb = [CCMoveBy actionWithDuration:0.1 position:ccp(0, -bounceDistance)];
            __block AllRecruitLayer* ddl = self;
            CCCallBlock* cb = [CCCallBlock actionWithBlock:^{
                [ddl updateLeftLayerVisible];
            }];
            CCSequence* se = [CCSequence actions:mb,cb, nil];
            [leftLayer runAction:se];
            bounceDistance = 0;
        }
    }
    else if (layerDragState == RightLayerDrag) {
        if (bounceDistance != 0) {
            CCMoveBy* mb = [CCMoveBy actionWithDuration:0.1 position:ccp(0, -bounceDistance)];
            __block AllRecruitLayer* ddl = self;
            CCCallBlock* cb = [CCCallBlock actionWithBlock:^{
                [ddl updateRightLayerVisible];
            }];
            CCSequence* se = [CCSequence actions:mb,cb, nil];
            [rightLayer runAction:se];
            bounceDistance = 0;
        }
    }
    
    layerDragState = LayerNoDrag;
    if (needClosePayment == 1) {
        //close the payment .................
        [self closePaymentDialog];
        currentHeroID = -1;
        currentTroopType = -1;
        currentTroopCount = -1;
        needClosePayment = 0;
        
    }
    
    
    if (needClose == 1) {
        CCLayer* mainlayer = (CCLayer*)[[[CCDirector sharedDirector] runningScene] getChildByTag:1];
        if (mainlayer) {
            [mainlayer performSelector:@selector(enableBuildingTouchable) withObject:nil];
        }
        [self removeFromParentAndCleanup:YES];
    }
    
}

-(void) updateLeftLayerVisible
{
    for (CCNode* item in leftLayer.children) {
        [self updateLeftChildVisible:item];
    }
    
}
-(void) updateRightLayerVisible
{
    for (CCNode* item in rightLayer.children) {
        [self updateRightChildVisible:item];
    }
}

-(void) dealloc
{
    [receivers removeAllObjects];
    [receivers release];
    [troopCountLabels removeAllObjects];
    [troopCountLabels release];
    [super dealloc];
}


@end
