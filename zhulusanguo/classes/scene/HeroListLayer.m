//
//  HeroListLayer.m
//  zhulusanguo
//
//  Created by qing on 15/4/10.
//  Copyright 2015年 qing lai. All rights reserved.
//

#import "HeroListLayer.h"


@implementation HeroListLayer

+ (id) contentRect1:(CGRect)left contentRect2:(CGRect)right withCityID:(int)tcid
{
    return [[[self alloc] initcontentRect1:left contentRect2:right withCityID:tcid] autorelease];
}

- (id) initcontentRect1:(CGRect)left contentRect2:(CGRect)right withCityID:(int)tcid
{
    if ((self=[super init])) {
        
        _cityID = tcid;
        leftContent = left;
        rightContent = right;
        
        leftLayer = [[[CCNode alloc] init] autorelease];
        rightLayer = [[[CCNode alloc] init] autorelease];
        
        [self addChild:leftLayer z:1];
        [self addChild:rightLayer z:1];
        
        bounceDistance = 0;
        needClose = 0;
        
        minTopLeftY = leftLayer.position.y;
        minTopRightY = rightLayer.position.y;
        
        //两个背景
        
        //now add item bg , hero select bg to the layer children
        CCSprite* itembg = [CCSprite spriteWithSpriteFrameName:@"itemlist.png"];
        CGSize wsize = [[CCDirector sharedDirector] winSize];
        itembg.position = ccp(wsize.width*0.5-168, wsize.height*0.5);
        [self addChild:itembg z:0];
        CGFloat ibgheight = itembg.boundingBox.size.height;
        
        CCLabelTTF* itemtitle = [CCLabelTTF labelWithString:@"本城武将列表" fontName:@"Arial" fontSize:12];
        itemtitle.color = ccYELLOW;
        itemtitle.position = ccp(itembg.position.x, itembg.position.y + itembg.boundingBox.size.height*0.5 - 10);
        [self addChild:itemtitle z:1];
        
        herobg = [CCSprite spriteWithSpriteFrameName:@"heroselectbg2.png"];
        herobg.position = ccp(wsize.width*0.5+80, wsize.height*0.5);
        [self addChild:herobg z:0];
        
        int kid = [ShareGameManager shareGameManager].kingID;
        NSArray* heroes = [[ShareGameManager shareGameManager] getHeroListFromCity:_cityID kingID:kid];
        int ilen = (int)[heroes count];
        CGFloat hfheight;
        //CGFloat hbgheight = herobg.boundingBox.size.height;
        
        for (int i=0; i<ilen; i++) {
            HeroObject *ho = [heroes objectAtIndex:i];
            CCSprite* hf = [CCSprite spriteWithSpriteFrameName:@"itemframe.png"];
            hfheight = hf.boundingBox.size.height;
            hf.position = ccp(itembg.position.x, wsize.height*0.5+ibgheight*0.5 - 25 - hfheight*0.5 -(hfheight+5)*i);
            [leftLayer addChild:hf z:1];
            
            //hero head
            NSString* hfile = [NSString stringWithFormat:@"hero%d.png",ho.headImageID];
            HeroInfoMovableSprite* hhead = [HeroInfoMovableSprite spriteWithSpriteFrameName:hfile];
            hhead.position = ccp(hf.position.x - hf.boundingBox.size.width*0.5 + 45, hf.position.y);
            [leftLayer addChild:hhead z:3];
            [hhead initTheCallbackFunc0:@selector(showHeroDetail:) withCaller:self withTouchID:ho.heroID];
            
            CCSprite *armybg = [CCSprite spriteWithSpriteFrameName:@"hero_bg.png"];
            armybg.position = hhead.position;
            armybg.scale = 1.2;
            [leftLayer addChild:armybg z:2];
            
            //hero name , level , hp , mp , attack , //attack range, move range
            NSString* compound = [NSString stringWithFormat:@"%@", ho.cname];
            CCLabelTTF* hnamelabel = [CCLabelTTF labelWithString:compound fontName:@"Arial" fontSize:10];
            hnamelabel.anchorPoint = ccp(0, 0.5);
            //hnamelabel.color = ccORANGE;
            hnamelabel.position = ccp(hhead.position.x + 35, hhead.position.y);
            [leftLayer addChild:hnamelabel z:2];
            
            
            
        }
        maxBottomLeftY = (hfheight+5)*ilen - leftContent.size.height + 10 ;
        
        [self updateLeftLayerVisible];
        
        HeroObject* first = [heroes objectAtIndex:0];
        [self showHeroDetail:[NSNumber numberWithInt:first.heroID]];
        
        //maxBootomRightY = (hfheight+5)*ilen - rightContent.size.height + 10 ;
        
        //[self updateRightLayerVisible];
        
        
        
    }
    
    return self;
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


-(void) onEnter
{
    [[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:1 swallowsTouches:YES];
    [super onEnter];
}

-(void) onExit
{
    CCLOG(@"call hero list layer onExit()....");
    [[[CCDirector sharedDirector] touchDispatcher] removeDelegate:self];
    [super onExit];
}

- (BOOL) ccTouchBegan:(UITouch*)touch withEvent:(UIEvent *)event {
    
    CGPoint touchLocation = [[CCDirector sharedDirector] convertToGL:[touch locationInView: [touch view]]];
    if (CGRectContainsPoint(leftContent, touchLocation)) {
        CCLOG(@"touch on hero list left layer....");
        layerDragState = LeftLayerDrag;
        [self closeSkillDetailIfOpened];
        return YES;
    }
    else if (CGRectContainsPoint(rightContent, touchLocation)) {
        CCLOG(@"touch on hero detail right layer....");
        layerDragState = RightLayerDrag;
        [self closeSkillDetailIfOpened];
        return YES;
    }
    else {
        //close self after 0.5 second
        [self closeSkillDetailIfOpened];
        needClose = 1;
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
        //do nothing
    }
    
    
    
    
}

- (void) ccTouchEnded:(UITouch*)touch withEvent:(UIEvent *)event {
    //set all tag == 0
    //set drag image == nil
    
    if (layerDragState == LeftLayerDrag) {
        if (bounceDistance != 0) {
            CCMoveBy* mb = [CCMoveBy actionWithDuration:0.1 position:ccp(0, -bounceDistance)];
            __block HeroListLayer* ddl = self;
            CCCallBlock* cb = [CCCallBlock actionWithBlock:^{
                [ddl updateLeftLayerVisible];
            }];
            CCSequence* se = [CCSequence actions:mb,cb, nil];
            [leftLayer runAction:se];
            bounceDistance = 0;
        }
    }
    else if (layerDragState == RightLayerDrag) {
        //do nothing
    }
    
    layerDragState = LayerNoDrag;
    
    if (needClose == 1) {
        CCLayer* mainlayer = (CCLayer*)[[[CCDirector sharedDirector] runningScene] getChildByTag:1];
        if (mainlayer) {
            [mainlayer performSelector:@selector(enableBuildingTouchable) withObject:nil];
        }
        [self removeFromParentAndCleanup:YES];
    }
    
}

-(void) showHeroDetail:(NSNumber *)hid
{
    CCLOG(@"hero id from touch button : %d",[hid integerValue]);
    [rightLayer removeAllChildrenWithCleanup:YES];
    
    CCLabelTTF* title = [CCLabelTTF labelWithString:@"武将详情" fontName:@"Arial" fontSize:12];
    title.position = ccp(herobg.position.x, herobg.position.y + herobg.boundingBox.size.height*0.5 - 15);
    //title.color = ccGREEN;
    [rightLayer addChild:title z:2];
    
    HeroObject* ho = [[ShareGameManager shareGameManager] getHeroInfoFromID:[hid integerValue]];
    
    NSString* hfile = [NSString stringWithFormat:@"hero%d.png",ho.headImageID];
    CCSprite* hhead = [CCSprite spriteWithSpriteFrameName:hfile];
    hhead.position = ccp(herobg.position.x - herobg.boundingBox.size.width*0.5 + 40,herobg.position.y + herobg.boundingBox.size.height*0.5 - 55);
    [rightLayer addChild:hhead z:2];
    
    CCLabelTTF* namelab = [CCLabelTTF labelWithString:ho.cname fontName:@"Arial" fontSize:10];
    namelab.position = ccp(hhead.position.x, hhead.position.y - 32);
    namelab.color = ccGRAY;
    [rightLayer addChild:namelab z:2];
    

    NSString* compound = [NSString stringWithFormat:@"等级:%d  经验:%d", ho.level,ho.experience ];
    CCLabelTTF* hnamelabel = [CCLabelTTF labelWithString:compound fontName:@"Arial" fontSize:10];
    hnamelabel.anchorPoint = ccp(0, 0.5);
    //hnamelabel.color = ccORANGE;
    hnamelabel.position = ccp(hhead.position.x + 30, hhead.position.y + 10);
    [rightLayer addChild:hnamelabel z:2];
    
    compound = [NSString stringWithFormat:@"武力:%d 智力:%d",ho.strength,ho.intelligence];
    CCLabelTTF* strlabel = [CCLabelTTF labelWithString:compound fontName:@"Arial" fontSize:10];
    strlabel.anchorPoint = ccp(0, 0.5);
    strlabel.position = ccp(hnamelabel.position.x, hnamelabel.position.y - 15);
    [rightLayer addChild:strlabel z:2];
    
    ArticleObject* ao1 = nil;
    ArticleObject* ao2 = nil;
    if (ho.article1 != 0) {
        ao1 = [[ShareGameManager shareGameManager] getArticleDetailFromID:ho.article1];
    }
    if (ho.article2 != 0) {
        ao2 = [[ShareGameManager shareGameManager] getArticleDetailFromID:ho.article2];
    }
    
    //hp label
    int originhp = ho.strength*6 + 180 + (ho.level-1)*2 ;
    int addhp = 0 ;
    if (ho.article1 != 0) {
        if (ao1.effectTypeID == 2) {
            addhp += ao1.hp;
        }
    }
    if (ho.article2 != 0) {
        if (ao2.effectTypeID == 2) {
            addhp += ao2.hp;
        }
    }
    
    //mp label
    int originmp = ((float)(ho.intelligence))/15 * (ho.level+10) ;
    int addmp = 0;
    if (ho.article1 != 0) {
        if (ao1.effectTypeID == 3) {
            addmp += ao1.mp;
        }
    }
    if (ho.article2 != 0) {
        if (ao2.effectTypeID == 3) {
            addmp += ao2.mp;
        }
    }
    
    //attack label
    int originattack = (((float)(ho.strength))/4 + ho.level) * (ho.level+8) ;
    int addattack = 0;
    if (ho.article1 != 0) {
        if (ao1.effectTypeID == 1) {
            addattack += ao1.attack;
        }
    }
    if (ho.article2 != 0) {
        if (ao2.effectTypeID == 1) {
            addattack += ao2.attack;
        }
    }
    
    //mental attack label
    int mentalattack = (((float)(ho.intelligence))/4 + ho.level) * (ho.level+9) ;
    
    compound = [NSString stringWithFormat:@"HP:%d+%d  MP:%d+%d",originhp,addhp,originmp,addmp];
    CCLabelTTF *hplabel = [CCLabelTTF labelWithString:compound fontName:@"Arial" fontSize:10];
    hplabel.anchorPoint = ccp(0, 0.5);
    hplabel.position = ccp(strlabel.position.x, strlabel.position.y - 15);
    [rightLayer addChild:hplabel z:2];
    
    compound = [NSString stringWithFormat:@"物理攻击力:%d",originattack+addattack];
    CCLabelTTF *attlabel1 = [CCLabelTTF labelWithString:compound fontName:@"Arial" fontSize:10];
    attlabel1.anchorPoint = ccp(0, 0.5);
    attlabel1.color = ccYELLOW;
    attlabel1.position = ccp(hhead.position.x + 150, hhead.position.y + 10);
    [rightLayer addChild:attlabel1 z:2];
    
    compound = [NSString stringWithFormat:@"精神攻击力:%d",mentalattack];
    CCLabelTTF *attlabel2 = [CCLabelTTF labelWithString:compound fontName:@"Arial" fontSize:10];
    attlabel2.anchorPoint = ccp(0, 0.5);
    attlabel2.color = ccGREEN;
    attlabel2.position = ccp(attlabel1.position.x, attlabel1.position.y - 15);
    [rightLayer addChild:attlabel2 z:2];
    
    NSString* ar1 = @"无";
    NSString* ar2 = @"无";
    if (ao1) {
        ar1 = ao1.cname;
    }
    if (ao2) {
        ar2 = ao2.cname;
    }
    CCLabelTTF *aolabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"装备1:%@ 装备2:%@",ar1,ar2] fontName:@"Arial" fontSize:10];
    aolabel.anchorPoint = ccp(0,0.5);
    aolabel.position = ccp(attlabel1.position.x, attlabel2.position.y - 15);
    [rightLayer addChild:aolabel z:2];
    
    
    
    //第二行....
    
    NSString* armyfile = [NSString stringWithFormat:@"army%d_right_01.png",ho.armyAttackImageID];
    CCSprite* army = [CCSprite spriteWithSpriteFrameName:armyfile];
    army.position = ccp(hhead.position.x, hhead.position.y - 60);
    [rightLayer addChild:army z:2];
    
    CCSprite* tiparrow = [CCSprite spriteWithSpriteFrameName:@"tiparrow.png"];
    tiparrow.position = ccp(army.position.x + 60, army.position.y);
    [rightLayer addChild:tiparrow z:2];
    
    
    NSString* troopfile = @"skill99.png";
    int troopattack1 = 0;
    int troopmental1 = 0;
    if (ho.troopType == 1) {
        troopfile = @"troop1_right_01.png";
        troopattack1 = TROOP_FOOTMAN_ATTACK;
        troopmental1 = TROOP_FOOTMAN_MENTAL;
    }
    else if (ho.troopType == 2) {
        troopfile = @"troop3_right_01.png";
        troopattack1 = TROOP_ARCHER_ATTACK;
        troopmental1 = TROOP_ARCHER_MENTAL;
    }
    else if (ho.troopType == 3) {
        troopfile = @"troop5_right_01.png";
        troopattack1 = TROOP_CAVALRY_ATTACK;
        troopmental1 = TROOP_CAVALRY_MENTAL;
    }
    else if (ho.troopType == 4) {
        troopfile = @"troop7_right_01.png";
        troopattack1 = TROOP_WIZARD_ATTACK;
        troopmental1 = TROOP_WIZARD_MENTAL;
    }
    else if (ho.troopType == 5) {
        troopfile = @"troop9_right_01.png";
        troopattack1 = TROOP_BALLISTA_ATTACK;
        troopmental1 = TROOP_BALLISTA_MENTAL;
    }
    CCSprite* troopsp = [CCSprite spriteWithSpriteFrameName:troopfile];
    troopsp.position = ccp(tiparrow.position.x + 60, tiparrow.position.y);
    [rightLayer addChild:troopsp z:2];
    
    compound = [NSString stringWithFormat:@"兵力:%d",ho.troopCount];
    CCLabelTTF* trooplabel = [CCLabelTTF labelWithString:compound fontName:@"Arial" fontSize:10];
    //trooplabel.color = ccMAGENTA;
    trooplabel.anchorPoint = ccp(0, 0.5);
    trooplabel.position = ccp(troopsp.position.x + 35, troopsp.position.y + 15);
    [rightLayer addChild:trooplabel z:2];
    
    compound = [NSString stringWithFormat:@"攻:%d+%d",troopattack1 ,ho.troopAttack];
    CCLabelTTF* trattlabel = [CCLabelTTF labelWithString:compound fontName:@"Arial" fontSize:10];
    trattlabel.anchorPoint = ccp(0, 0.5);
    trattlabel.color = ccYELLOW;
    trattlabel.position = ccp(trooplabel.position.x, trooplabel.position.y -15);
    [rightLayer addChild:trattlabel z:2];
    
    compound = [NSString stringWithFormat:@"策:%d+%d",troopmental1,ho.troopMental];
    CCLabelTTF* trmenlabel = [CCLabelTTF labelWithString:compound fontName:@"Arial" fontSize:10];
    trmenlabel.anchorPoint = ccp(0, 0.5);
    trmenlabel.color = ccGREEN;
    trmenlabel.position = ccp(trattlabel.position.x, trattlabel.position.y -15);
    [rightLayer addChild:trmenlabel z:2];
    
    
    //第三行，技能
    // y - 60
    NSString* simg = [NSString stringWithFormat:@"skill%d.png",ho.skill1];
    TouchableSprite* rsp1 = [TouchableSprite spriteWithSpriteFrameName:simg];
    //rsp1.position = ccp(hf.position.x + hf.boundingBox.size.width*0.5 - 135 , hf.position.y + 20);
    rsp1.position = ccp(hhead.position.x , army.position.y - 60);
    [rightLayer addChild:rsp1 z:2];
    if (ho.skill1 != 99) {
        [rsp1 initTheCallbackFunc:@selector(showSkillDetail:) withCaller:self withTouchID:ho.skill1];
    }
    
    simg = [NSString stringWithFormat:@"skill%d.png",ho.skill2];
    TouchableSprite* rsp2 = [TouchableSprite spriteWithSpriteFrameName:simg];
    //rsp1.position = ccp(hf.position.x + hf.boundingBox.size.width*0.5 - 135 , hf.position.y + 20);
    rsp2.position = ccp(rsp1.position.x + 50 , army.position.y - 60);
    [rightLayer addChild:rsp2 z:2];
    if (ho.skill2 != 99) {
        [rsp2 initTheCallbackFunc:@selector(showSkillDetail:) withCaller:self withTouchID:ho.skill2];
    }
    
    simg = [NSString stringWithFormat:@"skill%d.png",ho.skill3];
    TouchableSprite* rsp3 = [TouchableSprite spriteWithSpriteFrameName:simg];
    //rsp1.position = ccp(hf.position.x + hf.boundingBox.size.width*0.5 - 135 , hf.position.y + 20);
    rsp3.position = ccp(rsp2.position.x + 50 , army.position.y - 60);
    [rightLayer addChild:rsp3 z:2];
    if (ho.skill3 != 99) {
        [rsp3 initTheCallbackFunc:@selector(showSkillDetail:) withCaller:self withTouchID:ho.skill3];
    }
    
    simg = [NSString stringWithFormat:@"skill%d.png",ho.skill4];
    TouchableSprite* rsp4 = [TouchableSprite spriteWithSpriteFrameName:simg];
    //rsp1.position = ccp(hf.position.x + hf.boundingBox.size.width*0.5 - 135 , hf.position.y + 20);
    rsp4.position = ccp(rsp3.position.x + 50 , army.position.y - 60);
    [rightLayer addChild:rsp4 z:2];
    if (ho.skill4 != 99) {
        [rsp4 initTheCallbackFunc:@selector(showSkillDetail:) withCaller:self withTouchID:ho.skill4];
    }
    
    simg = [NSString stringWithFormat:@"skill%d.png",ho.skill5];
    TouchableSprite* rsp5 = [TouchableSprite spriteWithSpriteFrameName:simg];
    //rsp1.position = ccp(hf.position.x + hf.boundingBox.size.width*0.5 - 135 , hf.position.y + 20);
    rsp5.position = ccp(rsp4.position.x + 50 , army.position.y - 60);
    [rightLayer addChild:rsp5 z:2];
    if (ho.skill5 != 99) {
        [rsp5 initTheCallbackFunc:@selector(showSkillDetail:) withCaller:self withTouchID:ho.skill5];
    }
    
    
}

-(void) showSkillDetail:(NSNumber*)skid
{
    int sid = (int)[skid integerValue];
    NSString* skfile = [NSString stringWithFormat:@"skillinfo%d.png",sid];
    CCSprite* skcard = (CCSprite*)[self getChildByTag:SKILL_DETAIL_CARD_TAG];
    if (skcard) {
        [skcard setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:skfile]];
        skcard.visible = YES;
        skcard.scale = 1.2;
    }
    else {
        skcard = [CCSprite spriteWithSpriteFrameName:skfile];
        CGSize wsize = [[CCDirector sharedDirector] winSize];
        skcard.visible = YES;
        skcard.scale = 1.2;
        skcard.position = ccp(wsize.width*0.5, wsize.height*0.5);
        skcard.tag = SKILL_DETAIL_CARD_TAG;
        [self addChild:skcard z:4];
    }
}

-(void) closeSkillDetailIfOpened
{
    CCSprite* skcard = (CCSprite*)[self getChildByTag:SKILL_DETAIL_CARD_TAG];
    if (skcard) {
        skcard.visible = NO;
    }
}


@end
