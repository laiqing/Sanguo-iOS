//
//  SkillsLayer.m
//  zhulusanguo
//
//  Created by qing on 15/3/30.
//  Copyright 2015年 qing lai. All rights reserved.
//

#import "SkillsLayer.h"


@implementation SkillsLayer

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
        
        receivers = [[CCArray alloc] init];
        
        minTopLeftY = leftLayer.position.y;
        minTopRightY = rightLayer.position.y;
        
        //两个背景
        
        //now add item bg , hero select bg to the layer children
        CCSprite* itembg = [CCSprite spriteWithSpriteFrameName:@"itemlist.png"];
        CGSize wsize = [[CCDirector sharedDirector] winSize];
        itembg.position = ccp(wsize.width*0.5-168, wsize.height*0.5);
        [self addChild:itembg z:0];
        CGFloat ibgheight = itembg.boundingBox.size.height;
        
        CCSprite* herobg = [CCSprite spriteWithSpriteFrameName:@"heroselectbg2.png"];
        herobg.position = ccp(wsize.width*0.5+80, wsize.height*0.5);
        [self addChild:herobg z:0];
        CGFloat hbgheight = herobg.boundingBox.size.height;
        
        //select from citySkills where cityID = %d , 填充左边的layer
        CGFloat hfheight;
        NSArray* items = [[ShareGameManager shareGameManager] getSkillListFromCity:_cityID];
        int ilen = (int)[items count];
        for (int i=0;i<ilen;i++) {
            SkillDBObject* so = [items objectAtIndex:i];
            //frame , image, cname , cdesc
            CCSprite* hf = [CCSprite spriteWithSpriteFrameName:@"itemframe.png"];
            hfheight = hf.boundingBox.size.height;
            hf.position = ccp(wsize.width*0.5-168, wsize.height*0.5+ibgheight*0.5 - 25 - hfheight*0.5 -(hfheight+5)*i);
            [leftLayer addChild:hf z:1];
            
            
            //image
            NSString* afile = [NSString stringWithFormat:@"skill%d.png",so.skillID];
            SkillDragTouchSprite *mts = [SkillDragTouchSprite spriteWithSpriteFrameName:afile];
            mts.position = ccp(hf.position.x - hf.boundingBox.size.width*0.5 + 25, hf.position.y);
            [leftLayer addChild:mts z:2];
            [mts initTheCallbackFunc0:@selector(checkReceiveSprite:) withBeforeCallback:@selector(hideSkillDetail) withCaller:self withTouchID:so.skillID withImg:afile];
            
            //skill learn cost , money , text , detail button
            CCSprite* gold = [CCSprite spriteWithSpriteFrameName:@"gold.png"];
            gold.scale = 0.5;
            gold.anchorPoint = ccp(0, 0.5);
            gold.position = ccp(mts.position.x + 25, mts.position.y);
            [leftLayer addChild:gold z:2];
            
            
            int money = so.skillLevel * 1000 ;
            NSString *mstr = [NSString stringWithFormat:@"%d",money];
            CCLabelTTF* namelabel = [CCLabelTTF labelWithString:mstr fontName:@"Arial" fontSize:12];
            namelabel.anchorPoint = ccp(0, 0.5);
            namelabel.color = ccWHITE;
            namelabel.position = ccp(mts.position.x + 45, mts.position.y);
            [leftLayer addChild:namelabel z:2];
            
            SkillInfoMovableSprite * sisp = [SkillInfoMovableSprite spriteWithSpriteFrameName:@"info.png"];
            sisp.position = ccp(mts.position.x + 85, mts.position.y);
            sisp.scale = 1.2;
            [leftLayer addChild:sisp z:2];
            [sisp initTheCallbackFunc0:@selector(showSkillDetail:) withCaller:self withTouchID:so.skillID];
            
            
        }
        
        maxBottomLeftY = (hfheight+5)*ilen - leftContent.size.height + 10 ;
        
        [self updateLeftLayerVisible];
        
        //now add hero
        int kid = [ShareGameManager shareGameManager].kingID;
        NSArray* heroes = [[ShareGameManager shareGameManager] getHeroListFromCity:_cityID kingID:kid];
        ilen = (int)[heroes count];
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
            hhead.position = ccp(hf.position.x - hf.boundingBox.size.width*0.5 + 30, hf.position.y+15);
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
            
            NSString* s1img = [NSString stringWithFormat:@"skill%d.png",ho.skill1];
            ReceiveSkillDropSprite* rsp1 = [ReceiveSkillDropSprite spriteWithSpriteFrameName:s1img];
            //rsp1.position = ccp(hf.position.x + hf.boundingBox.size.width*0.5 - 135 , hf.position.y + 20);
            rsp1.position = ccp(hhead.position.x + 48, hf.position.y);
            [rightLayer addChild:rsp1 z:2];
            rsp1.heroID = ho.heroID;
            rsp1.skillPosID = 1;
            rsp1.skillID = ho.skill1;
            [receivers addObject:rsp1];
            
            NSString* s2img = [NSString stringWithFormat:@"skill%d.png",ho.skill2];
            ReceiveSkillDropSprite* rsp2 = [ReceiveSkillDropSprite spriteWithSpriteFrameName:s2img];
            //rsp2.position = ccp(hf.position.x + hf.boundingBox.size.width*0.5 - 90 , hf.position.y + 20);
            rsp2.position = ccp(rsp1.position.x + 42, hf.position.y);
            [rightLayer addChild:rsp2 z:2];
            rsp2.heroID = ho.heroID;
            rsp2.skillPosID = 2;
            rsp2.skillID = ho.skill2;
            [receivers addObject:rsp2];
            
            NSString* s3img = [NSString stringWithFormat:@"skill%d.png",ho.skill3];
            ReceiveSkillDropSprite* rsp3 = [ReceiveSkillDropSprite spriteWithSpriteFrameName:s3img];
            //rsp3.position = ccp(hf.position.x + hf.boundingBox.size.width*0.5 - 45 , hf.position.y + 20);
            rsp3.position = ccp(rsp2.position.x + 42, hf.position.y);
            [rightLayer addChild:rsp3 z:2];
            rsp3.heroID = ho.heroID;
            rsp3.skillPosID = 3;
            rsp3.skillID = ho.skill3;
            [receivers addObject:rsp3];
            
            NSString* s4img = [NSString stringWithFormat:@"skill%d.png",ho.skill4];
            ReceiveSkillDropSprite* rsp4 = [ReceiveSkillDropSprite spriteWithSpriteFrameName:s4img];
            //rsp4.position = ccp(hf.position.x + hf.boundingBox.size.width*0.5 - 110 , hf.position.y - 20);
            rsp4.position = ccp(rsp3.position.x + 42, hf.position.y);
            [rightLayer addChild:rsp4 z:2];
            rsp4.heroID = ho.heroID;
            rsp4.skillPosID = 4;
            rsp4.skillID = ho.skill4;
            [receivers addObject:rsp4];
            
            NSString* s5img = [NSString stringWithFormat:@"skill%d.png",ho.skill5];
            ReceiveSkillDropSprite* rsp5 = [ReceiveSkillDropSprite spriteWithSpriteFrameName:s5img];
            //rsp5.position = ccp(hf.position.x + hf.boundingBox.size.width*0.5 - 65 , hf.position.y - 20);
            rsp5.position = ccp(rsp4.position.x + 42, hf.position.y);
            [rightLayer addChild:rsp5 z:2];
            rsp5.heroID = ho.heroID;
            rsp5.skillPosID = 5;
            rsp5.skillID = ho.skill5;
            [receivers addObject:rsp5];
            
            
        }
        
        maxBootomRightY = (hfheight+5)*ilen - rightContent.size.height + 10 ;
        
        [self updateRightLayerVisible];
        
        
    }
    return self;
}

//this for the skillInfoMovableSprite button

-(void) showSkillDetail:(NSNumber*)skID
{
    //if skill png exist , then set display frame
    int sid = (int)[skID integerValue];
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

-(void) hideSkillDetail
{
    CCNode* node = [self getChildByTag:SKILL_DETAIL_CARD_TAG];
    if (node) {
        node.visible = NO;
    }
}

-(void) updateHeroSkill:(int)hid skill:(int)skid skillPos:(int)skposID
{
    HeroObject* ho = [[ShareGameManager shareGameManager] getHeroInfoFromID:hid];
    int sk = ho.skill1;
    if (skposID == 2) {
        sk = ho.skill2;
    }
    else if (skposID == 3) {
        sk = ho.skill3;
    }
    else if (skposID == 4) {
        sk = ho.skill4;
    }
    else if (skposID == 5) {
        sk = ho.skill5;
    }
    NSString* skfile = [NSString stringWithFormat:@"skill%d.png",sk];
    //loop in the receive to find the correct skill icon
    ReceiveSkillDropSprite* recv;
    CCARRAY_FOREACH(receivers, recv)
    {
        if ((recv.heroID == hid)&&(recv.skillPosID==skposID)) {
            [recv setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:skfile]];
            break;
        }
    }
    
}

-(void) addReduceResourceEffect:(ArticleDragSprite*) _drag costNumber:(int)_cost
{
    CGPoint startP = _drag.position;
    
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
    
    
    NSString* cstr = [NSString stringWithFormat:@"%d",_cost];
    CCLabelTTF *clabel = [CCLabelTTF labelWithString:cstr fontName:@"Arial" fontSize:9];
    clabel.anchorPoint = ccp(0, 0.5);
    clabel.position = ccp(startP.x-10, startP.y);
    [self addChild:clabel z:3];
    
    CCMoveBy *mv2 = [CCMoveBy actionWithDuration:1.2f position:ccp(0,60)];
    CCFadeOut *fo2 = [CCFadeOut actionWithDuration:1.5f];
    CCSpawn *sp2 = [CCSpawn actions:mv2,fo2, nil];
    CCCallBlockN *cb2 = [CCCallBlockN actionWithBlock:^(CCNode *node) {
        [node removeFromParentAndCleanup:YES];
    }];
    CCSequence *se2 = [CCSequence actions:sp2,cb2, nil];
    [clabel runAction:se2];
    
    
    
}

-(void) checkReceiveSprite:(ArticleDragSprite *)_drag
{
    CCLOG(@"article id is : %d",_drag.skillID);
    CGPoint mpos = _drag.position;
    CGPoint mpos1 = [rightLayer convertToNodeSpace:mpos];
    for (ReceiveSkillDropSprite* item in receivers) {
        if (CGRectContainsPoint(item.boundingBox, mpos1)) {
            CCLOG(@"the receive is: hero : %d, article pos: %d",item.heroID,item.skillPosID);
            
            //need check the item available in this hero
            SkillDBObject* sdo = [[ShareGameManager shareGameManager] getSkillInfoFromID:_drag.skillID];
            HeroObject* ho = [[ShareGameManager shareGameManager] getHeroInfoFromID:item.heroID];
            int sk = ho.skill1;
            if (item.skillPosID == 2) {
                sk = ho.skill2;
            }
            else if (item.skillPosID == 3) {
                sk = ho.skill3;
            }
            else if (item.skillPosID == 4) {
                sk = ho.skill4;
            }
            else if (item.skillPosID == 5) {
                sk = ho.skill5;
            }
            if (sk != 99) {
                
                [[SimpleAudioEngine sharedEngine] playEffect:@"fail.caf"];
                
                CGSize wszie = [[CCDirector sharedDirector] winSize];
                CCSprite* stbar = [CCSprite spriteWithSpriteFrameName:@"statusbar.png"];
                stbar.position = ccp(wszie.width*0.5, wszie.height*0.5);
                [self addChild:stbar z:5];
                [stbar performSelector:@selector(removeFromParent) withObject:nil afterDelay:1.5];

                CCLabelTTF* warn = [CCLabelTTF labelWithString:@"已经学习的技能，不能被新技能替换！" fontName:@"Arial" fontSize:15];
                warn.color = ccYELLOW;
                warn.position = stbar.position;
                [self addChild:warn z:6];
                [warn performSelector:@selector(removeFromParent) withObject:nil afterDelay:1.5];
                
                
            }
            else {
                //already learn skill in other pos
                if ((_drag.skillID == ho.skill1)||(_drag.skillID == ho.skill2)||(_drag.skillID == ho.skill3)||(_drag.skillID == ho.skill4)||(_drag.skillID == ho.skill5)) {
                    [[SimpleAudioEngine sharedEngine] playEffect:@"fail.caf"];
                    
                    CGSize wszie = [[CCDirector sharedDirector] winSize];
                    CCSprite* stbar = [CCSprite spriteWithSpriteFrameName:@"statusbar.png"];
                    stbar.position = ccp(wszie.width*0.5, wszie.height*0.5);
                    [self addChild:stbar z:5];
                    [stbar performSelector:@selector(removeFromParent) withObject:nil afterDelay:1.5];
                    
                    CCLabelTTF* warn = [CCLabelTTF labelWithString:@"该武将已经学习过了此技能！" fontName:@"Arial" fontSize:15];
                    warn.color = ccYELLOW;
                    warn.position = stbar.position;
                    [self addChild:warn z:6];
                    [warn performSelector:@selector(removeFromParent) withObject:nil afterDelay:1.5];
                }
                else {
                    // money enough ???
                    int reqgold = sdo.skillLevel*1000;
                    if ([ShareGameManager shareGameManager].gold >= reqgold) {
                        if ((sdo.strengthRequire <= ho.strength)&&(sdo.intelligenceRequire <= ho.intelligence)) {
                            
                            //------------------------------------
                            // check if this is a passive skill ,
                            // and if hero already have a passive skill
                            //------------------------------------
                            BOOL alreadyHasPassive = NO;
                            if (sdo.passive == 1) {
                                if (ho.skill1 != 99) {
                                    SkillDBObject* sdo1 = [[ShareGameManager shareGameManager] getSkillInfoFromID:ho.skill1];
                                    if (sdo1.passive == 1) {
                                        alreadyHasPassive = YES;
                                    }
                                }
                                if (ho.skill2 != 99) {
                                    SkillDBObject* sdo1 = [[ShareGameManager shareGameManager] getSkillInfoFromID:ho.skill2];
                                    if (sdo1.passive == 1) {
                                        alreadyHasPassive = YES;
                                    }
                                }
                                if (ho.skill3 != 99) {
                                    SkillDBObject* sdo1 = [[ShareGameManager shareGameManager] getSkillInfoFromID:ho.skill3];
                                    if (sdo1.passive == 1) {
                                        alreadyHasPassive = YES;
                                    }
                                }
                                if (ho.skill4 != 99) {
                                    SkillDBObject* sdo1 = [[ShareGameManager shareGameManager] getSkillInfoFromID:ho.skill4];
                                    if (sdo1.passive == 1) {
                                        alreadyHasPassive = YES;
                                    }
                                }
                                if (ho.skill5 != 99) {
                                    SkillDBObject* sdo1 = [[ShareGameManager shareGameManager] getSkillInfoFromID:ho.skill5];
                                    if (sdo1.passive == 1) {
                                        alreadyHasPassive = YES;
                                    }
                                }
                                if (alreadyHasPassive) {
                                    [[SimpleAudioEngine sharedEngine] playEffect:@"fail.caf"];
                                    CGSize wszie = [[CCDirector sharedDirector] winSize];
                                    CCSprite* stbar = [CCSprite spriteWithSpriteFrameName:@"statusbar.png"];
                                    stbar.position = ccp(wszie.width*0.5, wszie.height*0.5);
                                    [self addChild:stbar z:5];
                                    [stbar performSelector:@selector(removeFromParent) withObject:nil afterDelay:1.5];
                                    
                                    CCLabelTTF* warn = [CCLabelTTF labelWithString:@"一个武将只能有一个被动技能！" fontName:@"Arial" fontSize:15];
                                    warn.color = ccYELLOW;
                                    warn.position = stbar.position;
                                    [self addChild:warn z:6];
                                    [warn performSelector:@selector(removeFromParent) withObject:nil afterDelay:1.5];
                                    return;
                                }
                                else {
                                    [[SimpleAudioEngine sharedEngine] playEffect:@"sthget.caf"];
                                    [ShareGameManager shareGameManager].gold -= reqgold;
                                    //play effect
                                    [self addReduceResourceEffect:_drag costNumber:reqgold];
                                    //main update ui text
                                    CCScene* run = [[CCDirector sharedDirector] runningScene];
                                    CCLayer* main = (CCLayer*) [run getChildByTag:1];
                                    if (main) {
                                        [main performSelector:@selector(updateResourceLabel)];
                                    }
                                    
                                    //can learn
                                    [[ShareGameManager shareGameManager] heroLearnSkill:item.heroID skill:_drag.skillID skillPos:item.skillPosID];
                                    
                                    // update the skill icon for the hero in the right layer
                                    [self updateHeroSkill:item.heroID skill:_drag.skillID skillPos:item.skillPosID];
                                }
                            }
                            else {
                            
                                //
                                [[SimpleAudioEngine sharedEngine] playEffect:@"sthget.caf"];
                                [ShareGameManager shareGameManager].gold -= reqgold;
                                //play effect
                                [self addReduceResourceEffect:_drag costNumber:reqgold];
                                //main update ui text
                                CCScene* run = [[CCDirector sharedDirector] runningScene];
                                CCLayer* main = (CCLayer*) [run getChildByTag:1];
                                if (main) {
                                    [main performSelector:@selector(updateResourceLabel)];
                                }
                                
                                //can learn
                                [[ShareGameManager shareGameManager] heroLearnSkill:item.heroID skill:_drag.skillID skillPos:item.skillPosID];
                                
                                // update the skill icon for the hero in the right layer
                                [self updateHeroSkill:item.heroID skill:_drag.skillID skillPos:item.skillPosID];
                            }
                        }
                        else {
                            [[SimpleAudioEngine sharedEngine] playEffect:@"fail.caf"];
                            CGSize wszie = [[CCDirector sharedDirector] winSize];
                            CCSprite* stbar = [CCSprite spriteWithSpriteFrameName:@"statusbar.png"];
                            stbar.position = ccp(wszie.width*0.5, wszie.height*0.5);
                            [self addChild:stbar z:5];
                            [stbar performSelector:@selector(removeFromParent) withObject:nil afterDelay:1.5];
                            
                            CCLabelTTF* warn = [CCLabelTTF labelWithString:@"该武将的武力或智力不足以装配此技能！" fontName:@"Arial" fontSize:15];
                            warn.color = ccYELLOW;
                            warn.position = stbar.position;
                            [self addChild:warn z:6];
                            [warn performSelector:@selector(removeFromParent) withObject:nil afterDelay:1.5];
                        }
                    }
                    else {
                        [[SimpleAudioEngine sharedEngine] playEffect:@"fail.caf"];
                        CGSize wszie = [[CCDirector sharedDirector] winSize];
                        CCSprite* stbar = [CCSprite spriteWithSpriteFrameName:@"statusbar.png"];
                        stbar.position = ccp(wszie.width*0.5, wszie.height*0.5);
                        [self addChild:stbar z:5];
                        [stbar performSelector:@selector(removeFromParent) withObject:nil afterDelay:1.5];
                        
                        CCLabelTTF* warn = [CCLabelTTF labelWithString:@"没有足够的金币来为武将装配此技能！" fontName:@"Arial" fontSize:15];
                        warn.color = ccYELLOW;
                        warn.position = stbar.position;
                        [self addChild:warn z:6];
                        [warn performSelector:@selector(removeFromParent) withObject:nil afterDelay:1.5];
                    }
                    
                    
                }
            }
            
            break;
        }
    } // end for
    
    
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
        [self hideSkillDetail];
        return YES;
    }
    else if (CGRectContainsPoint(rightContent, touchLocation)) {
        CCLOG(@"touch on skill right layer....");
        layerDragState = RightLayerDrag;
        
        [self hideSkillDetail];
        
        return YES;
    }
    else {
        //close self after 0.5 second
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
            __block SkillsLayer* ddl = self;
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
            __block SkillsLayer* ddl = self;
            CCCallBlock* cb = [CCCallBlock actionWithBlock:^{
                [ddl updateRightLayerVisible];
            }];
            CCSequence* se = [CCSequence actions:mb,cb, nil];
            [rightLayer runAction:se];
            bounceDistance = 0;
        }
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
    [super dealloc];
}



@end
