//
//  DistributeLayer.m
//  zhulusanguo
//
//  Created by qing on 15/4/10.
//  Copyright 2015年 qing lai. All rights reserved.
//

#import "DistributeLayer.h"


@implementation DistributeLayer

+ (id) contentRect1:(CGRect)left contentRect2:(CGRect)right withCityID:(int)tcid
{
    return [[[self alloc] initcontentRect1:left contentRect2:right withCityID:tcid] autorelease];
}

- (id) initcontentRect1:(CGRect)left contentRect2:(CGRect)right withCityID:(int)tcid
{
    if ((self=[super init])) {
        currentLeftHeroID = 0;
        currentRightHeroID = 0;
        currentTroopType = 0;
        currentLeftTroopCount = 0;
        currentRightTroopCount = 0;
        maxTroopCount = 0;
        
        _cityID = tcid;
        leftContent = left;
        rightContent = right;
        
        needClosePayment = 0;
        
        leftLayer = [[[CCNode alloc] init] autorelease];
        rightLayer = [[[CCNode alloc] init] autorelease];
        
        [self addChild:leftLayer z:1];
        [self addChild:rightLayer z:1];
        
        bounceDistance = 0;
        needClose = 0;
        
        receivers = [[CCArray alloc] init];
        troopCountLabels = [[CCArray alloc] init];
        senders = [[CCArray alloc] init];
        
        minTopLeftY = leftLayer.position.y;
        minTopRightY = rightLayer.position.y;
        
        //两个背景
        
        //now add item bg , hero select bg to the layer children
        CCSprite* itembg = [CCSprite spriteWithSpriteFrameName:@"itemlist2.png"];
        CGSize wsize = [[CCDirector sharedDirector] winSize];
        itembg.position = ccp(wsize.width*0.5-110, wsize.height*0.5);
        [self addChild:itembg z:0];
        CGFloat ibgheight = itembg.boundingBox.size.height;
        
        CCSprite* herobg = [CCSprite spriteWithSpriteFrameName:@"itemlist2.png"];
        herobg.position = ccp(wsize.width*0.5+110, wsize.height*0.5);
        [self addChild:herobg z:0];
        
        int kid = [ShareGameManager shareGameManager].kingID;
        NSArray* heroes = [[ShareGameManager shareGameManager] getHeroListFromCity:_cityID kingID:kid];
        int ilen = (int)[heroes count];
        CGFloat hfheight;
        CGFloat hbgheight = herobg.boundingBox.size.height;
        
        for (int i=0; i<ilen; i++) {
            HeroObject *ho = [heroes objectAtIndex:i];
            CCSprite* hf = [CCSprite spriteWithSpriteFrameName:@"itemframe3.png"];
            hfheight = hf.boundingBox.size.height;
            hf.position = ccp(itembg.position.x, wsize.height*0.5+hbgheight*0.5 - 25 - hfheight*0.5 -(hfheight+5)*i);
            [leftLayer addChild:hf z:1];
            
            //hero head
            NSString* hfile = [NSString stringWithFormat:@"hero%d.png",ho.headImageID];
            CCSprite* hhead = [CCSprite spriteWithSpriteFrameName:hfile];
            hhead.position = ccp(hf.position.x - hf.boundingBox.size.width*0.5 + 30, hf.position.y);
            [leftLayer addChild:hhead z:2];
            
            //hero name , level , hp , mp , attack , //attack range, move range
            NSString* compound = [NSString stringWithFormat:@"%@", ho.cname];
            CCLabelTTF* hnamelabel = [CCLabelTTF labelWithString:compound fontName:@"Arial" fontSize:10];
            hnamelabel.anchorPoint = ccp(0, 0.5);
            //hnamelabel.color = ccORANGE;
            hnamelabel.position = ccp(hhead.position.x + 25, hhead.position.y);
            [leftLayer addChild:hnamelabel z:2];
            
            CCSprite *armybg = [CCSprite spriteWithSpriteFrameName:@"hero_bg.png"];
            armybg.position = ccp(hf.position.x + hf.boundingBox.size.width*0.5 - 65, hhead.position.y);
            armybg.scale = 1.2;
            [leftLayer addChild:armybg z:2];
            
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
            
            TroopDragTouchSprite* tdsp = [TroopDragTouchSprite spriteWithSpriteFrameName:armyfile];
            tdsp.position = armybg.position;
            tdsp.heroID = ho.heroID;
            [leftLayer addChild:tdsp z:3];
            [tdsp initTheCallbackFunc0:@selector(checkReceiveSprite:) withCaller:self withTouchID:ho.troopType withImg:armyfile canDrag:YES];
            [senders addObject:tdsp];
            
            
            NSString* armycountstr = [NSString stringWithFormat:@"%d",ho.troopCount];
            CCLabelTTFWithInfo* armyinfo = [CCLabelTTFWithInfo labelWithString:armycountstr fontName:@"Arial" fontSize:9];
            armyinfo.anchorPoint = ccp(0, 0.5);
            armyinfo.position = ccp(tdsp.position.x + 28, tdsp.position.y);
            armyinfo.asscoiateID = ho.heroID;
            [leftLayer addChild:armyinfo z:2];
            [troopCountLabels addObject:armyinfo];
            
            
        }
        
        //maxBottomLeftY = (hfheight+5)*5 - leftContent.size.height + 10 ;
        maxBottomLeftY = (hfheight+5)*ilen - leftContent.size.height + 10 ;
        
        [self updateLeftLayerVisible];
        
        for (int i=0;i<ilen;i++) {
            HeroObject *ho = [heroes objectAtIndex:i];
            
            //frame
            CCSprite* hf = [CCSprite spriteWithSpriteFrameName:@"itemframe3.png"];
            hfheight = hf.boundingBox.size.height;
            hf.position = ccp(herobg.position.x, wsize.height*0.5+hbgheight*0.5 - 25 - hfheight*0.5 -(hfheight+5)*i);
            [rightLayer addChild:hf z:1];
            
            //hero head
            NSString* hfile = [NSString stringWithFormat:@"hero%d.png",ho.headImageID];
            CCSprite* hhead = [CCSprite spriteWithSpriteFrameName:hfile];
            hhead.position = ccp(hf.position.x - hf.boundingBox.size.width*0.5 + 30, hf.position.y);
            [rightLayer addChild:hhead z:2];
            
            //hero name , level , hp , mp , attack , //attack range, move range
            NSString* compound = [NSString stringWithFormat:@"%@", ho.cname];
            CCLabelTTF* hnamelabel = [CCLabelTTF labelWithString:compound fontName:@"Arial" fontSize:10];
            hnamelabel.anchorPoint = ccp(0, 0.5);
            //hnamelabel.color = ccORANGE;
            hnamelabel.position = ccp(hhead.position.x + 25, hhead.position.y);
            [rightLayer addChild:hnamelabel z:2];
            
            CCSprite *armybg = [CCSprite spriteWithSpriteFrameName:@"hero_bg.png"];
            armybg.position = ccp(hf.position.x + hf.boundingBox.size.width*0.5 - 65, hhead.position.y);
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
            CCLabelTTFWithInfo* armyinfo = [CCLabelTTFWithInfo labelWithString:armycountstr fontName:@"Arial" fontSize:9];
            armyinfo.anchorPoint = ccp(0, 0.5);
            armyinfo.position = ccp(udsp.position.x+28, udsp.position.y);
            armyinfo.asscoiateID = ho.heroID;
            [rightLayer addChild:armyinfo z:2];
            [troopCountLabels addObject:armyinfo];
            
        }
        
        maxBootomRightY = (hfheight+5)*ilen - rightContent.size.height + 10 ;
        
        [self updateRightLayerVisible];
        
        
        
    }
    
    return self;
}





-(void) changeHeroTroop
{
    
    
    //update the left and right hero troop count in the db
    [[ShareGameManager shareGameManager] updateHeroTroopCount:currentLeftHeroID withCount1:currentLeftTroopCount hero2:currentRightHeroID withCount2:currentRightTroopCount withTroopType:currentTroopType];
    
    //update the left layer and right layer corresponding hero troop count label
    CCLabelTTFWithInfo* cio;
    CCARRAY_FOREACH(troopCountLabels, cio)
    {
        if (cio.asscoiateID == currentLeftHeroID) {
            [cio setString:[NSString stringWithFormat:@"%d",currentLeftTroopCount]];
        }
        if (cio.asscoiateID == currentRightHeroID) {
            [cio setString:[NSString stringWithFormat:@"%d",currentRightTroopCount]];
        }
    }
    
    //update the receives image
    HeroObject* ho1 = [[ShareGameManager shareGameManager] getHeroInfoFromID:currentLeftHeroID];
    HeroObject* ho2 = [[ShareGameManager shareGameManager] getHeroInfoFromID:currentRightHeroID];
    
    NSString* h1img;
    switch (ho1.troopType) {
        case 1:
            h1img = @"troop1_right_01.png";
            break;
        case 2:
            h1img = @"troop3_right_01.png";
            break;
        case 3:
            h1img = @"troop5_right_01.png";
            break;
        case 4:
            h1img = @"troop7_right_01.png";
            break;
        case 5:
            h1img = @"troop9_right_01.png";
            break;
        default:
            h1img = @"skill99.png";
            break;
    }
    NSString *h2img;
    switch (ho2.troopType) {
        case 1:
            h2img = @"troop1_right_01.png";
            break;
        case 2:
            h2img = @"troop3_right_01.png";
            break;
        case 3:
            h2img = @"troop5_right_01.png";
            break;
        case 4:
            h2img = @"troop7_right_01.png";
            break;
        case 5:
            h2img = @"troop9_right_01.png";
            break;
        default:
            h2img = @"skill99.png";
            break;
    }
    
    TroopDragTouchSprite* se;
    CCARRAY_FOREACH(senders, se)
    {
        if (se.heroID == currentLeftHeroID) {
            [se setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:h1img]];
            
            if (ho1.troopType ==0) {
                se.candrag = NO;
            }
            else {
                se.candrag = YES;
            }
        }
        if (se.heroID == currentRightHeroID) {
            [se setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:h2img]];
            if (ho2.troopType ==0) {
                se.candrag = NO;
            }
            else {
                se.candrag = YES;
            }
        }
    }
    
    for (UnitReceiveDropSprite* item in receivers)
    {
        if (item.heroID == currentLeftHeroID) {
            [item setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:h1img]];
            item.unitTypeID = ho1.troopType;
            item.count = ho1.troopCount;
        }
        if (item.heroID == currentRightHeroID) {
            [item setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:h2img]];
            item.unitTypeID = ho2.troopType;
            item.count = ho2.troopCount;
        }
    }
    
    
    //close dialog
    [self closeChangeDialog];
    
}

-(void) closeChangeDialog
{
    currentLeftHeroID = -1;
    currentRightHeroID = -1;
    currentTroopType = -1;
    currentLeftTroopCount = 0;
    currentRightTroopCount = 0;
    needClosePayment = 0;
    showPaymentDialog = 0;
    
    CCLOG(@"close payment layer");
    if (paymentLayer) {
        [self removeChild:paymentLayer cleanup:YES];
    }
    paymentLayer = nil;
    
}


-(void) checkReceiveSprite:(UnitDragSprite*)_drag
{
    CCLOG(@"heroid is : %d ,army id is : %d",_drag.heroID, _drag.unitTypeID);
    CGPoint mpos = _drag.position;
    CGPoint mpos1 = [rightLayer convertToNodeSpace:mpos];
    for (UnitReceiveDropSprite* item in receivers) {
        if (CGRectContainsPoint(item.boundingBox, mpos1)) {
            CCLOG(@"the receive is: hero : %d, article pos: %d",item.heroID,item.unitTypeID);
            if (item.heroID == _drag.heroID) {
                //不能对同一个武将操作
                [[SimpleAudioEngine sharedEngine] playEffect:@"fail.caf"];
                
                CGSize wszie = [[CCDirector sharedDirector] winSize];
                CCSprite* stbar = [CCSprite spriteWithSpriteFrameName:@"statusbar.png"];
                stbar.position = ccp(wszie.width*0.5, wszie.height*0.5);
                [self addChild:stbar z:5];
                [stbar performSelector:@selector(removeFromParent) withObject:nil afterDelay:1.5];
                
                CCLabelTTF* warn = [CCLabelTTF labelWithString:@"无法对同一个武将进行此操作！" fontName:@"Arial" fontSize:15];
                warn.color = ccYELLOW;
                warn.position = stbar.position;
                [self addChild:warn z:6];
                [warn performSelector:@selector(removeFromParent) withObject:nil afterDelay:1.5];
            }
            
            else if ((item.unitTypeID == 0)||(item.unitTypeID == _drag.unitTypeID)) {
                //原来没有部队，可以分配，或者原来有部队，和现在分配的事同一种
                currentLeftHeroID = _drag.heroID;
                currentTroopType = _drag.unitTypeID;
                currentLeftTroopCount = _drag.unitCount;
                currentRightHeroID = item.heroID;
                currentRightTroopCount = item.count;
                maxTroopCount = currentLeftTroopCount + currentRightTroopCount;
                
                //show the payment dialog
                showPaymentDialog = 1;
                
                paymentLayer = [[CCNode alloc] init];
                [self addChild:paymentLayer z:2];
                
                CCSprite* mbg = [CCSprite spriteWithSpriteFrameName:@"unitrangebg.png"];
                CGSize wsize = [[CCDirector sharedDirector] winSize];
                mbg.position = ccp(wsize.width*0.5, wsize.height*0.5);
                [paymentLayer addChild:mbg z:0];
                
                //add title
                CCLabelTTF* title = [CCLabelTTF labelWithString:@"重新分配兵力" fontName:@"Arial" fontSize:10];
                title.position = ccp(mbg.position.x, mbg.position.y + mbg.boundingBox.size.height*0.4);
                
                NSString* unitfile = @"troop1_right_01.png";
                switch (currentTroopType) {
                    case 1:
                        unitfile = @"troop1_right_01.png";
                        break;
                    case 2:
                        unitfile = @"troop3_right_01.png";
                        break;
                    case 3:
                        unitfile = @"troop5_right_01.png";
                        break;
                    case 4:
                        unitfile = @"troop7_right_01.png";
                        break;
                    case 5:
                        unitfile = @"troop9_right_01.png";
                        break;
                    default:
                        unitfile = @"troop1_right_01.png";
                        break;
                }
                
                CCSprite* unitimg = [CCSprite spriteWithSpriteFrameName:unitfile];
                unitimg.position = ccp(mbg.position.x, mbg.position.y + mbg.boundingBox.size.height*0.15);
                [paymentLayer addChild:unitimg z:1];
                
                HeroObject* ho1 = [[ShareGameManager shareGameManager] getHeroInfoFromID:currentLeftHeroID];
                NSString* headfile = [NSString stringWithFormat:@"hero%d.png", ho1.headImageID];
                CCSprite* ho1head = [CCSprite spriteWithSpriteFrameName:headfile];
                ho1head.position = ccp(mbg.position.x - 80 , unitimg.position.y);
                [paymentLayer addChild:ho1head z:1];
                
                CCLabelTTF* hname1 = [CCLabelTTF labelWithString:ho1.cname fontName:@"Arial" fontSize:9];
                hname1.position = ccp(ho1head.position.x, ho1head.position.y + 30);
                [paymentLayer addChild:hname1 z:1];
                
                HeroObject* ho2 = [[ShareGameManager shareGameManager] getHeroInfoFromID:currentRightHeroID];
                headfile = [NSString stringWithFormat:@"hero%d.png", ho2.headImageID];
                CCSprite* ho2head = [CCSprite spriteWithSpriteFrameName:headfile];
                ho2head.position = ccp(mbg.position.x + 80 , unitimg.position.y);
                [paymentLayer addChild:ho2head z:1];
                
                CCLabelTTF* hname2 = [CCLabelTTF labelWithString:ho2.cname fontName:@"Arial" fontSize:9];
                hname2.position = ccp(ho2head.position.x, ho2head.position.y + 30);
                [paymentLayer addChild:hname2 z:1];
                
                CCSprite* sliderbg = [CCSprite spriteWithSpriteFrameName:@"slider_back1.png"];
                CCSprite* sliderbar = [CCSprite spriteWithSpriteFrameName:@"slider_bar1.png"];
                CCSprite* slider = [CCSprite spriteWithSpriteFrameName:@"slider.png"];
                CCControlSlider* cs = [CCControlSlider sliderWithBackgroundSprite:sliderbg progressSprite:sliderbar thumbSprite:slider];
                cs.position = ccp(mbg.position.x,mbg.position.y - mbg.boundingBox.size.height*0.22);
                [paymentLayer addChild:cs z:1];
                cs.minimumValue = 0;
                cs.maximumValue = maxTroopCount;
                cs.value = currentLeftTroopCount;
                [cs addTarget:self action:@selector(sliderChanged:) forControlEvents:CCControlEventValueChanged];
                
                leftCountLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d",currentLeftTroopCount] fontName:@"Arial" fontSize:12];
                leftCountLabel.position = ccp(hname1.position.x, cs.position.y + 22);
                [paymentLayer addChild:leftCountLabel z:1];
                
                rightCountLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d",currentRightTroopCount] fontName:@"Arial" fontSize:12];
                rightCountLabel.position = ccp(hname2.position.x, cs.position.y + 22);
                [paymentLayer addChild:rightCountLabel z:1];
                
                TouchableSprite* otherBtn = [TouchableSprite spriteWithSpriteFrameName:@"buildokbtn.png"];
                otherBtn.position = ccp(mbg.position.x, cs.position.y - 30);
                
                [paymentLayer addChild:otherBtn z:1];
                [otherBtn initTheCallbackFunc:@selector(changeHeroTroop) withCaller:self withTouchID:-1];
                
                
            }
            else {
                //兵种不一样无法分配
                [[SimpleAudioEngine sharedEngine] playEffect:@"fail.caf"];
                
                CGSize wszie = [[CCDirector sharedDirector] winSize];
                CCSprite* stbar = [CCSprite spriteWithSpriteFrameName:@"statusbar.png"];
                stbar.position = ccp(wszie.width*0.5, wszie.height*0.5);
                [self addChild:stbar z:5];
                [stbar performSelector:@selector(removeFromParent) withObject:nil afterDelay:1.5];
                
                CCLabelTTF* warn = [CCLabelTTF labelWithString:@"无法进行分配，两边兵种不同！" fontName:@"Arial" fontSize:15];
                warn.color = ccYELLOW;
                warn.position = stbar.position;
                [self addChild:warn z:6];
                [warn performSelector:@selector(removeFromParent) withObject:nil afterDelay:1.5];
            }
            
            break;
            
        } // end if found the receiver ccsprite
    
    
    } // end for loop
    
    
    
    
}

-(void) sliderChanged:(CCControlSlider*)sender
{
    int va = (int)sender.value;
    CCLOG(@"slider value is :%d",(int)(sender.value));
    currentLeftTroopCount = va;
    if (leftCountLabel) {
        [leftCountLabel setString:[NSString stringWithFormat:@"%d",va]];
        
    }
    int vr = maxTroopCount - va;
    currentRightTroopCount = vr;
    if (rightCountLabel) {
        [rightCountLabel setString:[NSString stringWithFormat:@"%d",vr]];
        
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
            __block DistributeLayer* ddl = self;
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
            __block DistributeLayer* ddl = self;
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
        [self closeChangeDialog];
        currentLeftHeroID = -1;
        currentRightHeroID = -1;
        currentTroopType = -1;
        currentLeftTroopCount = 0;
        currentRightTroopCount = 0;
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
    [senders removeAllObjects];
    [senders release];
    [super dealloc];
}


@end
