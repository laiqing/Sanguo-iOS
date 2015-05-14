//
//  ArticleLayer.m
//  zhulusanguo
//
//  Created by qing on 15/4/6.
//  Copyright 2015年 qing lai. All rights reserved.
//

#import "ArticleLayer.h"


@implementation ArticleLayer

+ (id) contentRect1:(CGRect)left contentRect2:(CGRect)right withCityID:(int)tcid
{
    return [[[self alloc] initcontentRect1:left contentRect2:right withCityID:tcid] autorelease];
}

- (id) initcontentRect1:(CGRect)left contentRect2:(CGRect)right withCityID:(int)tcid
{
    if ((self=[super init])) {
        bounceDistance = 0;
        needClose = 0;
        
        receivers = [[CCArray alloc] init];
        hplabels = [[CCArray alloc] init];
        mplabels = [[CCArray alloc] init];
        attacklabels = [[CCArray alloc] init];
        desclabels = [[CCArray alloc] init];
        
        _cityID = tcid;
        leftContent = left;
        rightContent = right;
        
        leftLayer = [[[CCNode alloc] init] autorelease];
        rightLayer = [[[CCNode alloc] init] autorelease];
        
        [self addChild:leftLayer z:1];
        [self addChild:rightLayer z:1];
        
        minTopLeftY = leftLayer.position.y;
        minTopRightY = rightLayer.position.y;
        
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
        
        
        //hero bg posx : +80
        //item bg posx : -80 - 16 - 72
        
        //now add item
        CGFloat hfheight;
        NSArray* items = [[ShareGameManager shareGameManager] getArticleListFromCity:_cityID];
        int ilen = (int)[items count];
        for (int i=0;i<ilen;i++) {
            ArticleObject* ao = [items objectAtIndex:i];
            //frame , image, cname , cdesc
            CCSprite* hf = [CCSprite spriteWithSpriteFrameName:@"itemframe.png"];
            hfheight = hf.boundingBox.size.height;
            hf.position = ccp(wsize.width*0.5-168, wsize.height*0.5+ibgheight*0.5 - 25 - hfheight*0.5 -(hfheight+5)*i);
            [leftLayer addChild:hf z:1];
            
            //image
            NSString* afile = [NSString stringWithFormat:@"article%d.png",ao.aid];
            DragableTouchSprite *mts = [DragableTouchSprite spriteWithSpriteFrameName:afile];
            mts.position = ccp(hf.position.x - hf.boundingBox.size.width*0.5 + 25, hf.position.y);
            [leftLayer addChild:mts z:2];
            [mts initTheCallbackFunc0:@selector(checkReceiveSprite:) withCaller:self withTouchID:ao.aid needChangeImg:NO withImage0:afile withImage1:afile];
            
            //cname , cdesc
            CCLabelTTF* namelabel = [CCLabelTTF labelWithString:ao.cname fontName:@"Arial" fontSize:12];
            namelabel.anchorPoint = ccp(0, 0.5);
            namelabel.color = ccWHITE;
            namelabel.position = ccp(mts.position.x + 25, mts.position.y + 8);
            [leftLayer addChild:namelabel z:2];
            
            CCLabelTTF* desclabel = [CCLabelTTF labelWithString:ao.cdesc fontName:@"Arial" fontSize:12];
            desclabel.anchorPoint = ccp(0, 0.5);
            desclabel.color = ccWHITE;
            desclabel.position = ccp(mts.position.x + 25, mts.position.y - 8);
            [leftLayer addChild:desclabel z:2];
            
            
            
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
            hhead.position = ccp(hf.position.x - hf.boundingBox.size.width*0.5 + 40, hf.position.y+10);
            [rightLayer addChild:hhead z:2];
            
            //hero name , level , hp , mp , attack , //attack range, move range
            NSString* compound = [NSString stringWithFormat:@"%@ %d级", ho.cname, ho.level ];
            CCLabelTTF* hnamelabel = [CCLabelTTF labelWithString:compound fontName:@"Arial" fontSize:10];
            hnamelabel.anchorPoint = ccp(0, 0.5);
            //hnamelabel.color = ccORANGE;
            hnamelabel.position = ccp(hhead.position.x - 20, hhead.position.y - 40);
            [rightLayer addChild:hnamelabel z:2];
            
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
            NSString* realhp = [NSString stringWithFormat:@"HP: %d +%d",originhp,addhp];
            CCLabelTTFWithInfo* hpLabel = [CCLabelTTFWithInfo labelWithString:realhp fontName:@"Arial" fontSize:10];
            hpLabel.anchorPoint = ccp(0, 0.5);
            hpLabel.position = ccp(hhead.position.x + 35, hhead.position.y + 15);
            hpLabel.asscoiateID = ho.heroID;
            [rightLayer addChild:hpLabel z:2];
            [hplabels addObject:hpLabel];
            
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
            NSString* realmp = [NSString stringWithFormat:@"MP: %d +%d",originmp,addmp];
            CCLabelTTFWithInfo *mpLabel = [CCLabelTTFWithInfo labelWithString:realmp fontName:@"Arial" fontSize:10];
            mpLabel.anchorPoint = ccp(0, 0.5);
            mpLabel.position = ccp(hhead.position.x + 35, hhead.position.y-5);
            mpLabel.asscoiateID = ho.heroID;
            [rightLayer addChild:mpLabel z:2];
            [mplabels addObject:mpLabel];
            
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
            NSString* realattack = [NSString stringWithFormat:@"攻击力: %d +%d",originattack,addattack];
            CCLabelTTFWithInfo *attackLabel = [CCLabelTTFWithInfo labelWithString:realattack fontName:@"Arial" fontSize:10];
            attackLabel.anchorPoint = ccp(0, 0.5);
            attackLabel.position = ccp(hhead.position.x + 35, hhead.position.y - 25);
            attackLabel.asscoiateID = ho.heroID;
            [rightLayer addChild:attackLabel z:2];
            [attacklabels addObject:attackLabel];
            
            int amt = ho.armyType;
            NSString* amstr;
            amstr = @"武将类型：步兵";
            
            if (amt == 2) {
                amstr = @"武将类型：弓兵";
            }
            else if (amt == 3) {
                amstr = @"武将类型：骑兵";
            }
            CCLabelTTF* amtlabel = [CCLabelTTF labelWithString:amstr fontName:@"Arial" fontSize:10];
            amtlabel.anchorPoint = ccp(0, 0.5);
            amtlabel.position = ccp(hhead.position.x + 35, hhead.position.y - 45);
            [rightLayer addChild:amtlabel z:2];
            
            
            
            //article1 bgimage, article1 image , desc bgimg, name label, desc label, unarmor btn
            CCSprite *article1bg = [CCSprite spriteWithSpriteFrameName:@"article_bg.png"];
            article1bg.position = ccp(hf.position.x + hf.boundingBox.size.width*0.5 - 100, hf.position.y + 10);
            [rightLayer addChild:article1bg z:2];
            
            ReceiveDropSprite *article1sp;
            if (ho.article1 != 0) {
                NSString* a1file = [NSString stringWithFormat:@"article%d.png",ao1.aid];
                article1sp = [ReceiveDropSprite spriteWithSpriteFrameName:a1file];
            }
            else {
                article1sp = [ReceiveDropSprite spriteWithSpriteFrameName:@"article_empty_bg.png"];
            }
            article1sp.position = article1bg.position;
            article1sp.heroID = ho.heroID;
            article1sp.articlePosID = 1;
            [rightLayer addChild:article1sp z:3];
            [receivers addObject:article1sp];
            
            CCSprite *desc1bg = [CCSprite spriteWithSpriteFrameName:@"article_desc_bg.png"];
            desc1bg.position = ccp(article1bg.position.x, article1bg.position.y-40);
            [rightLayer addChild:desc1bg z:2];
            
            CCLabelTTFWithInfo* desc1label;
            if (ho.article1 != 0) {
                desc1label = [CCLabelTTFWithInfo labelWithString:ao1.cdesc fontName:@"Arial" fontSize:10];
                desc1label.position = desc1bg.position;
                desc1label.asscoiateID = ho.heroID;
                desc1label.asscoiatePosID = 1;
                [rightLayer addChild:desc1label z:3];
            }
            else {
                desc1label = [CCLabelTTFWithInfo labelWithString:@"无装备" fontName:@"Arial" fontSize:10];
                desc1label.position = desc1bg.position;
                desc1label.asscoiateID = ho.heroID;
                desc1label.asscoiatePosID = 1;
                [rightLayer addChild:desc1label z:3];
            }
            [desclabels addObject:desc1label];
            
            //article2 bgimage, article2 image , desc bgimg, name label, desc label, unarmor btn
            CCSprite *article2bg = [CCSprite spriteWithSpriteFrameName:@"article_bg.png"];
            article2bg.position = ccp(hf.position.x + hf.boundingBox.size.width*0.5 - 40, hf.position.y + 10);
            [rightLayer addChild:article2bg z:2];
            
            ReceiveDropSprite *article2sp;
            if (ho.article2 != 0) {
                NSString* a1file = [NSString stringWithFormat:@"article%d.png",ao2.aid];
                article2sp = [ReceiveDropSprite spriteWithSpriteFrameName:a1file];
            }
            else {
                article2sp = [ReceiveDropSprite spriteWithSpriteFrameName:@"article_empty_bg.png"];
            }
            article2sp.position = article2bg.position;
            article2sp.heroID = ho.heroID;
            article2sp.articlePosID = 2;
            [rightLayer addChild:article2sp z:3];
            [receivers addObject:article2sp];
            
            CCSprite *desc2bg = [CCSprite spriteWithSpriteFrameName:@"article_desc_bg.png"];
            desc2bg.position = ccp(article2bg.position.x, article2bg.position.y-40);
            [rightLayer addChild:desc2bg z:2];
            
            CCLabelTTFWithInfo* desc2label;
            if (ho.article2 != 0) {
                desc2label = [CCLabelTTFWithInfo labelWithString:ao2.cdesc fontName:@"Arial" fontSize:10];
                desc2label.position = desc2bg.position;
                desc2label.asscoiateID = ho.heroID;
                desc2label.asscoiatePosID = 2;
                [rightLayer addChild:desc2label z:3];
            }
            else {
                desc2label = [CCLabelTTFWithInfo labelWithString:@"无装备" fontName:@"Arial" fontSize:10];
                desc2label.position = desc2bg.position;
                desc2label.asscoiateID = ho.heroID;
                desc2label.asscoiatePosID = 2;
                [rightLayer addChild:desc2label z:3];
            }
            
            [desclabels addObject:desc2label];
            
            
        }
        
        maxBootomRightY = (hfheight+5)*ilen - rightContent.size.height + 10 ;
        
        [self updateRightLayerVisible];
        
    }
    return self;
}

-(void) refreshLeftLayer
{
    //at first remove all child in left layer
    [leftLayer removeAllChildren];
    leftLayer.position = CGPointZero;
    
    //
    CGSize wsize = [[CCDirector sharedDirector] winSize];
    CGFloat hfheight;
    NSArray* items = [[ShareGameManager shareGameManager] getArticleListFromCity:_cityID];
    int ilen = [items count];
    for (int i=0;i<ilen;i++) {
        ArticleObject* ao = [items objectAtIndex:i];
        //frame , image, cname , cdesc
        CCSprite* hf = [CCSprite spriteWithSpriteFrameName:@"itemframe.png"];
        hfheight = hf.boundingBox.size.height;
        hf.position = ccp(wsize.width*0.5-168, wsize.height*0.5+95 - hfheight*0.5 -(hfheight+5)*i);
        [leftLayer addChild:hf z:1];
        
        //image
        NSString* afile = [NSString stringWithFormat:@"article%d.png",ao.aid];
        DragableTouchSprite *mts = [DragableTouchSprite spriteWithSpriteFrameName:afile];
        mts.position = ccp(hf.position.x - hf.boundingBox.size.width*0.5 + 25, hf.position.y);
        [leftLayer addChild:mts z:2];
        [mts initTheCallbackFunc0:@selector(checkReceiveSprite:) withCaller:self withTouchID:ao.aid needChangeImg:NO withImage0:afile withImage1:afile];
        
        //cname , cdesc
        CCLabelTTF* namelabel = [CCLabelTTF labelWithString:ao.cname fontName:@"Arial" fontSize:12];
        namelabel.anchorPoint = ccp(0, 0.5);
        namelabel.color = ccWHITE;
        namelabel.position = ccp(mts.position.x + 25, mts.position.y + 8);
        [leftLayer addChild:namelabel z:2];
        
        CCLabelTTF* desclabel = [CCLabelTTF labelWithString:ao.cdesc fontName:@"Arial" fontSize:12];
        desclabel.anchorPoint = ccp(0, 0.5);
        desclabel.color = ccWHITE;
        desclabel.position = ccp(mts.position.x + 25, mts.position.y - 8);
        [leftLayer addChild:desclabel z:2];
        
        
        
    }
    
    maxBottomLeftY = (hfheight+5)*ilen - leftContent.size.height + 10 ;
    
    [self updateLeftLayerVisible];
}

-(void) updateArticleItemForHero:(int)hid withArticle:(int)aid articlePos:(int)apid;
{
    //get hero
    HeroObject *ho = [[ShareGameManager shareGameManager] getHeroInfoFromID:hid];
    //get article
    ArticleObject *ao = [[ShareGameManager shareGameManager] getArticleDetailFromID:aid];
    ArticleObject *ao2 = nil;
    //get hero another article info
    int anotheraid ;
    if (apid==1) {
        anotheraid = ho.article2;
    }
    else {
        anotheraid = ho.article1;
    }
    if (anotheraid != 0) {
        ao2 = [[ShareGameManager shareGameManager] getArticleDetailFromID:anotheraid];
    }
    
    NSString* afile = [NSString stringWithFormat:@"article%d.png",aid];
    ReceiveDropSprite* recv;
    CCARRAY_FOREACH(receivers, recv)
    {
        if ((recv.heroID == hid)&&(recv.articlePosID == apid)) {
            //change image
            [recv setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:afile]];
            break;
        }
    }
    CCLabelTTFWithInfo* hpl;
    CCARRAY_FOREACH(hplabels, hpl)
    {
        if ((hpl.asscoiateID == hid)) {
            //
            int originhp = ho.strength*6 + 180 + (ho.level-1)*2 ;
            int addhp = 0 ;
            if (ao.effectTypeID == 2) {
                addhp += ao.hp;
            }
            if (ao2) {
                if (ao2.effectTypeID == 2) {
                    addhp += ao2.hp;
                }
            }
            NSString* realhp = [NSString stringWithFormat:@"HP: %d +%d",originhp,addhp];
            [hpl setString:realhp];
            break;
        }
    }
    
    CCLabelTTFWithInfo* mpl;
    CCARRAY_FOREACH(mplabels, mpl)
    {
        if ((mpl.asscoiateID == hid)) {
            //
            int originmp = ((float)(ho.intelligence))/15 * (ho.level+10) ;
            int addmp = 0;
            if (ao.effectTypeID == 3) {
                addmp += ao.mp;
            }
            if (ao2) {
                if (ao2.effectTypeID == 3) {
                    addmp += ao2.mp;
                }
            }
            NSString* realhp = [NSString stringWithFormat:@"MP: %d +%d",originmp,addmp];
            [mpl setString:realhp];
            break;
        }
    }
    
    CCLabelTTFWithInfo* attl;
    CCARRAY_FOREACH(attacklabels, attl)
    {
        if ((attl.asscoiateID == hid)) {
            //
            int originattack = (((float)(ho.strength))/4 + ho.level) * (ho.level+8) ;
            int addattack = 0;
            if (ao.effectTypeID ==1) {
                addattack += ao.attack;
            }
            if (ao2) {
                if (ao2.effectTypeID == 1) {
                    addattack += ao2.attack;
                }
            }
            NSString* realattack = [NSString stringWithFormat:@"攻击力: %d +%d",originattack,addattack];
            [attl setString:realattack];
            break;
        }
    }
    
    CCLabelTTFWithInfo* descl;
    CCARRAY_FOREACH(desclabels, descl)
    {
        if ((descl.asscoiateID == hid)&&(descl.asscoiatePosID == apid)) {
            //
            [descl setString:ao.cdesc];
            break;
        }
    }
    
    
}

-(void) checkReceiveSprite:(ArticleDragSprite *)_drag
{
    CCLOG(@"article id is : %d",_drag.articleID);
    CGPoint mpos = _drag.position;
    CGPoint mpos1 = [rightLayer convertToNodeSpace:mpos];
    for (ReceiveDropSprite* item in receivers) {
        if (CGRectContainsPoint(item.boundingBox, mpos1)) {
            CCLOG(@"the receive is: hero : %d, article pos: %d",item.heroID,item.articlePosID);
            
            //need check the item available in this hero
            ArticleObject* ao = [[ShareGameManager shareGameManager] getArticleDetailFromID:_drag.articleID];
            HeroObject* ho = [[ShareGameManager shareGameManager] getHeroInfoFromID:item.heroID];
            if (ao.requireArmyType != -1) {
                if (ao.requireArmyType != ho.armyType) {
                    [[SimpleAudioEngine sharedEngine] playEffect:@"fail.caf"];
                    //not the same
                    CGSize wszie = [[CCDirector sharedDirector] winSize];
                    CCSprite* stbar = [CCSprite spriteWithSpriteFrameName:@"statusbar.png"];
                    stbar.position = ccp(wszie.width*0.5, wszie.height*0.5);
                    [self addChild:stbar z:5];
                    [stbar performSelector:@selector(removeFromParent) withObject:nil afterDelay:1.5];
                    
                    NSString* amstr = @"该装备只能给步兵类型的武将使用！";
                    if (ao.requireArmyType == 2) {
                        amstr = @"该装备只能给弓兵类型的武将使用！";
                    }
                    else if (ao.requireArmyType == 3) {
                        amstr = @"该装备只能给骑兵类型的武将使用！";
                    }
                    
                    CCLabelTTF* warn = [CCLabelTTF labelWithString:amstr fontName:@"Arial" fontSize:15];
                    warn.color = ccYELLOW;
                    warn.position = stbar.position;
                    [self addChild:warn z:6];
                    [warn performSelector:@selector(removeFromParent) withObject:nil afterDelay:1.5];
                    
                    return;
                }
            }
            
            [[SimpleAudioEngine sharedEngine] playEffect:@"sthget.caf"];
            //    update hero set article1 = _drag.articleID , delete from artiles where aid=_drag.articleID and cityID = _cityID
            [[ShareGameManager shareGameManager] updateHeroaddArticle:item.heroID newArticle:_drag.articleID articlePos:item.articlePosID];
            
            // update the hp,mp,attack,image,desc in the view
            [self updateArticleItemForHero:item.heroID withArticle:_drag.articleID articlePos:item.articlePosID];
            
            // refresh the leftlayer
            [self refreshLeftLayer];
            break;
        }
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
    CCLOG(@"call ArticleLayer onExit()....");
    [[[CCDirector sharedDirector] touchDispatcher] removeDelegate:self];
    [super onExit];
}

- (BOOL) ccTouchBegan:(UITouch*)touch withEvent:(UIEvent *)event {
    
    CGPoint touchLocation = [[CCDirector sharedDirector] convertToGL:[touch locationInView: [touch view]]];
    if (CGRectContainsPoint(leftContent, touchLocation)) {
        CCLOG(@"touch on article left layer....");
        layerDragState = LeftLayerDrag;
        return YES;
    }
    else if (CGRectContainsPoint(rightContent, touchLocation)) {
        CCLOG(@"touch on article right layer....");
        layerDragState = RightLayerDrag;
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
            __block ArticleLayer* ddl = self;
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
            __block ArticleLayer* ddl = self;
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

-(void) dealloc
{
    [receivers removeAllObjects];
    [receivers release];
    [hplabels removeAllObjects];
    [hplabels release];
    [mplabels removeAllObjects];
    [mplabels release];
    [attacklabels removeAllObjects];
    [attacklabels release];
    [desclabels removeAllObjects];
    [desclabels release];
    
    [super dealloc];
}


@end
