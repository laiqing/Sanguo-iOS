//
//  FightLayer.m
//  zhulusanguo
//
//  Created by qing on 15/3/27.
//  Copyright 2015年 qing lai. All rights reserved.
//

#import "FightLayer.h"


@implementation FightLayer

+ (id) slidingLayer:(SlideDirection) slideDirection contentRect:(CGRect)contentRect withTargetCityID:(int)tcid
{
    return [[[self alloc] initSlidingLayer:slideDirection contentRect:contentRect withTargetCityID:tcid] autorelease];
}

- (id) initSlidingLayer:(SlideDirection) slideDirection contentRect:(CGRect)contentRect withTargetCityID:(int)tcid{
    if ((self = [super init])) {
        slideDirection_ = slideDirection;
        
        _heroSelected = [[NSMutableArray alloc] init];
        
        _targetCityID = tcid;
        _payment = 0;
        isDragging_ = false;
        lasty = 0.0f;
        xvel = 0.0f;
        direction_ = BounceDirectionStayingStill;
        contentRect_ = contentRect;
        
        bounceDistance = 0;
        
        virtualLayer = [CCNode node];
        [self addChild:virtualLayer z:1];
        minTopY = virtualLayer.position.y;
        
        CCSprite* bg = [CCSprite spriteWithSpriteFrameName:@"mapdialog.png"];
        CGSize wsize = [[CCDirector sharedDirector] winSize];
        bg.position = ccp(wsize.width*0.5, wsize.height*0.5);
        [self addChild:bg z:0];
        CGFloat bgheight = bg.boundingBox.size.height;
        
        int kid = [ShareGameManager shareGameManager].kingID;
        NSArray* heroes = [[ShareGameManager shareGameManager] selectAllHeroForAttack:kid targetCityID:tcid];
        //[[ShareGameManager shareGameManager] selectHeroForDiaoDong:kid targetCityID:tcid];
        int len = (int)[heroes count];
        CCLOG(@"all heroes count: %d",len);
        CGFloat hfheight;
        for (int i=0;i<len;i++) {
            //add selectHeroFrame
            CCSprite* hf = [CCSprite spriteWithSpriteFrameName:@"selectHeroFrame.png"];
            hfheight = hf.boundingBox.size.height;
            hf.position = ccp(wsize.width*0.5-20, wsize.height*0.5+bgheight*0.5 - 20 - hfheight*0.5 -(hfheight+5)*i);
            [virtualLayer addChild:hf z:1];
            //CCLOG(@"hero name:%@",((HeroObject*)[heroes objectAtIndex:i]).cname);
            
            //add hero icon
            HeroObject* ho = (HeroObject*)[heroes objectAtIndex:i];
            NSString* hheadname = [NSString stringWithFormat:@"hero%d.png",ho.headImageID];
            CCSprite* hhead = [CCSprite spriteWithSpriteFrameName:hheadname];
            hhead.position = ccp(hf.position.x - hf.boundingBox.size.width*0.5 + 15 + hhead.boundingBox.size.width*0.5 , hf.position.y);
            [virtualLayer addChild:hhead z:2];
            
            float labely1 = hhead.position.y + hhead.boundingBox.size.height*0.25;
            float labely2 = hhead.position.y - hhead.boundingBox.size.height*0.25;
            
            //now add hero name , city,  level , strength, intelligence, skill1,2,3, troopatt,troopmental, trooptype , troopcount
            NSString* sk1;
            sk1 = skillnames[ho.skill1];
            NSString* sk2;
            if (ho.skill2==99) {
                sk2 = @"无";
            }
            else {
                sk2 = skillnames[ho.skill2];
            }
            NSString* sk3;
            if (ho.skill3==99) {
                sk3 = @"无";
            }
            else {
                sk3 = skillnames[ho.skill3];
            }
            NSString* sk4;
            if (ho.skill4==99) {
                sk4 = @"无";
            }
            else {
                sk4 = skillnames[ho.skill4];
            }
            NSString* sk5;
            if (ho.skill5==99) {
                sk5 = @"无";
            }
            else {
                sk5 = skillnames[ho.skill5];
            }
            NSString* cin = citynames[ho.cityID];
            NSString* line1 = [NSString stringWithFormat:@"%@ %@ %d级 武:%d 智:%d %@ %@ %@ %@ %@",ho.cname,cin,ho.level,ho.strength,ho.intelligence,sk1,sk2,sk3,sk4,sk5];
            CCLabelTTF* labelline1 = [CCLabelTTF labelWithString:line1 fontName:@"Arial" fontSize:12];
            labelline1.anchorPoint = ccp(0, 0.5);
            labelline1.color = ccYELLOW;
            labelline1.position = ccp(hhead.position.x + 30, labely1);
            [virtualLayer addChild:labelline1 z:2];
            
            NSString* trtp = trooptypes[ho.troopType];
            NSString* line2 = [NSString stringWithFormat:@"部队攻击力:%d 部队精神力:%d 部队:%@ 数量:%d",ho.troopAttack,ho.troopMental,trtp,ho.troopCount];
            CCLabelTTF* labelline2 = [CCLabelTTF labelWithString:line2 fontName:@"Arial" fontSize:12];
            labelline2.anchorPoint = ccp(0, 0.5);
            labelline2.color = ccORANGE;
            labelline2.position = ccp(hhead.position.x + 30, labely2);
            [virtualLayer addChild:labelline2 z:2];
            
            //add check box
            MoveTouchStateSprite* mcb = [MoveTouchStateSprite spriteWithSpriteFrameName:@"checkbox.png"];
            mcb.position = ccp(hf.position.x + hf.boundingBox.size.width*0.5 + 20, hf.position.y);
            mcb.tag = ho.heroID;
            
            [virtualLayer addChild:mcb z:2];
            [mcb initTheCallbackFunc0:@selector(selectHeroWithID:) withCallbackFunc1:@selector(unselectHeroWithID:) withCaller:self withTouchID:ho.heroID withState:0 withImage0:@"checkbox.png" withImage1:@"checkbox1.png"];
            
            
        }
        maxBottomY = (hfheight+5)*len - contentRect.size.height + 10 ;
        for (CCNode* item in virtualLayer.children) {
            [self updateChildVisible:item];
        }
        
        //add infobar in the bottom , target city, cost ,  button
        CCSprite* bottom = [CCSprite spriteWithSpriteFrameName:@"infobar.png"];
        bottom.position = ccp(wsize.width*0.5, wsize.height*0.5 - bg.boundingBox.size.height*0.5 - bottom.boundingBox.size.height*0.5 - 5);
        [self addChild:bottom z:1];
        
        //text
        NSString* ctna = citynames[tcid];
        CCLabelTTF* tcity = [CCLabelTTF labelWithString:ctna fontName:@"Arial" fontSize:12];
        tcity.color = ccYELLOW;
        tcity.position = ccp(bottom.position.x - bottom.boundingBox.size.width*0.4, bottom.position.y);
        [self addChild:tcity z:2];
        
        //gold
        CCSprite* gg = [CCSprite spriteWithSpriteFrameName:@"gold.png"];
        gg.scale = 0.5;
        gg.position = ccp(wsize.width*0.5, bottom.position.y);
        [self addChild:gg z:2];
        
        //gold text
        CCLabelTTF* ggtext = [CCLabelTTF labelWithString:@"0" fontName:@"Arial" fontSize:12];
        ggtext.anchorPoint = ccp(0, 0.5);
        ggtext.position = ccp(gg.position.x + 15, gg.position.y);
        ggtext.tag = PAYMENT_TEXT_TAG;
        [self addChild:ggtext z:2];
        
        
        //button
        TouchableSprite* btn = [TouchableSprite spriteWithSpriteFrameName:@"fight.png"];
        btn.position = ccp(bottom.position.x + bottom.boundingBox.size.width*0.4, bottom.position.y);
        [self addChild:btn z:2];
        [btn initTheCallbackFunc:@selector(fightToTargetCity) withCaller:self withTouchID:-1];
        
        
    }
    return self;
}


//------------------------------------
//  add hero id to select list, get hero city,
//  count the distance hero city to target city, count the payment , addpayment to _payment,
//  update payment text
//------------------------------------
-(void) selectHeroWithID:(NSNumber*)heID
{
    //max 5 hero
    if ([_heroSelected count]>=5) {
        
        [[SimpleAudioEngine sharedEngine] playEffect:@"fail.caf"];
        
        CGSize wszie = [[CCDirector sharedDirector] winSize];
        CCSprite* stbar = [CCSprite spriteWithSpriteFrameName:@"statusbar.png"];
        stbar.position = ccp(wszie.width*0.5, wszie.height*0.5);
        [self addChild:stbar z:5];
        [stbar performSelector:@selector(removeFromParent) withObject:nil afterDelay:1.2];
        CCLabelTTF* warn = [CCLabelTTF labelWithString:@"最多只能选择5只部队！" fontName:@"Arial" fontSize:16];
        warn.color = ccYELLOW;
        warn.position = stbar.position;
        [self addChild:warn z:6];
        [warn performSelector:@selector(removeFromParent) withObject:nil afterDelay:1.2];
        
        //get the touch checkbox
        MoveTouchStateSprite* msb = (MoveTouchStateSprite*)[virtualLayer getChildByTag:[heID integerValue]];
        [msb unchecked];
        return;
    }
    [[SimpleAudioEngine sharedEngine] playEffect:@"menu.caf"];
    int hid = (int)[heID integerValue];
    CCLOG(@"hid select : %d",hid);
    //add hero id to the list
    NSNumber* hh = [NSNumber numberWithInt:hid];
    [_heroSelected addObject:hh];
    //get the hero city pos and target city pos sqrt
    int fee = [[ShareGameManager shareGameManager] calcHeroDiaoDongFeet:hid targetCityID:_targetCityID];
    _payment += fee;
    //update label
    CCLabelTTF* ggtext = (CCLabelTTF*)[self getChildByTag:PAYMENT_TEXT_TAG];
    [ggtext setString:[NSString stringWithFormat:@"%d",_payment]];
    
}

-(void) unselectHeroWithID:(NSNumber*)heID
{
    [[SimpleAudioEngine sharedEngine] playEffect:@"menu.caf"];
    int hid = (int)[heID integerValue];
    CCLOG(@"hid unselect : %d",hid);
    NSNumber* needRemove = nil;
    for (NSNumber* h in _heroSelected) {
        if ([h integerValue]==hid) {
            needRemove = h;
            break;
        }
    }
    [_heroSelected removeObject:needRemove];
    //calc the payment
    int fee = [[ShareGameManager shareGameManager] calcHeroDiaoDongFeet:hid targetCityID:_targetCityID];
    _payment -= fee;
    if (_payment<0) {
        _payment = 0;
    }
    //update label
    CCLabelTTF* ggtext = (CCLabelTTF*)[self getChildByTag:PAYMENT_TEXT_TAG];
    [ggtext setString:[NSString stringWithFormat:@"%d",_payment]];
    
}


-(void) fightToTargetCity
{
    [[SimpleAudioEngine sharedEngine] playEffect:@"menu.caf"];
    
    if (_payment > [ShareGameManager shareGameManager].gold) {
        
        [[SimpleAudioEngine sharedEngine] playEffect:@"fail.caf"];
        
        //show statusbar.png and a text
        CGSize wszie = [[CCDirector sharedDirector] winSize];
        CCSprite* stbar = [CCSprite spriteWithSpriteFrameName:@"statusbar.png"];
        stbar.position = ccp(wszie.width*0.5, wszie.height*0.5);
        [self addChild:stbar z:5];
        [stbar performSelector:@selector(removeFromParent) withObject:nil afterDelay:1.2];
        CCLabelTTF* warn = [CCLabelTTF labelWithString:@"无法进攻，没有足够的金钱！" fontName:@"Arial" fontSize:16];
        warn.color = ccYELLOW;
        warn.position = stbar.position;
        [self addChild:warn z:6];
        [warn performSelector:@selector(removeFromParent) withObject:nil afterDelay:1.2];
        return;
    }
    [self performSelector:@selector(removeFromParent) withObject:nil afterDelay:0.5];
    
}

-(void) moveTheHeroListToTargetCity
{
    [[SimpleAudioEngine sharedEngine] playEffect:@"menu.caf"];
    if (_payment > [ShareGameManager shareGameManager].gold) {
        //show statusbar.png and a text
        [[SimpleAudioEngine sharedEngine] playEffect:@"fail.caf"];
        CGSize wszie = [[CCDirector sharedDirector] winSize];
        CCSprite* stbar = [CCSprite spriteWithSpriteFrameName:@"statusbar.png"];
        stbar.position = ccp(wszie.width*0.5, wszie.height*0.5);
        [self addChild:stbar z:5];
        [stbar performSelector:@selector(removeFromParent) withObject:nil afterDelay:1.2];
        CCLabelTTF* warn = [CCLabelTTF labelWithString:@"无法调动，没有足够的金钱！" fontName:@"Arial" fontSize:16];
        warn.color = ccYELLOW;
        warn.position = stbar.position;
        [self addChild:warn z:6];
        [warn performSelector:@selector(removeFromParent) withObject:nil afterDelay:1.2];
        return;
    }
    //for heroid in _heroselected, update the hero table, set the hero to the target city.
    [[ShareGameManager shareGameManager] diaoDongHerolistToCity:_heroSelected targetCityID:_targetCityID];
    
    //sharegamemanager remove money
    [ShareGameManager shareGameManager].gold = [ShareGameManager shareGameManager].gold - _payment;
    _payment = 0;
    //self remove from parent
    [self performSelector:@selector(removeFromParent) withObject:nil afterDelay:0.5];
    
}

-(void) onEnter
{
    [self registerWithTouchDispatcher];
    [super onEnter];
}

-(void) onExit
{
    CCLOG(@"call FightLayer onExit()....");
    [[[CCDirector sharedDirector] touchDispatcher] removeDelegate:self];
    [super onExit];
}

- (void) dealloc {
    [_heroSelected release];
    [super dealloc];
}

-(void) addChildToVirtualNode:(CCNode *)child
{
    [virtualLayer addChild:child z:1];
}



- (void) registerWithTouchDispatcher {
    [[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:1 swallowsTouches:YES];
}

- (BOOL) ccTouchBegan:(UITouch*)touch withEvent:(UIEvent *)event {
    CGPoint touchLocation = [[CCDirector sharedDirector] convertToGL:[touch locationInView: [touch view]]];
    if (CGRectContainsPoint(contentRect_, touchLocation)) {
        isDragging_ = YES;
        return YES;
    }
    else {
        //close self after 0.5 second
        [self performSelector:@selector(removeFromParent) withObject:nil afterDelay:0.5];
        return YES;
    }
    
}


//
//here , ch is a child to virtualLayer node
//
-(void) updateChildVisible:(CCNode*)ch
{
    CGRect cb = CGRectApplyAffineTransform(ch.boundingBox, [virtualLayer nodeToParentTransform]);
    CGRect cb2 = CGRectApplyAffineTransform(cb, [self nodeToParentTransform]);
    if (CGRectContainsRect(contentRect_, cb2)) {
        ch.visible = YES;
    }
    else {
        ch.visible = NO;
    }
}

- (void) ccTouchMoved:(UITouch*)touch withEvent:(UIEvent *)event {
    if (!isDragging_) return;
    CGPoint preLocation = [touch previousLocationInView:[touch view]];
    CGPoint curLocation = [touch locationInView:[touch view]];
    
    CGPoint a = [[CCDirector sharedDirector] convertToGL:preLocation];
    CGPoint b = [[CCDirector sharedDirector] convertToGL:curLocation];
    
    CGPoint nowPosition = virtualLayer.position;
    
    //if(slideDirection_ == Vertically) {
        float minY = 0;
        float maxY = (contentRect_.size.height) - self.contentSize.height;
        //CCLOG(@"maxY:%f",maxY);
        float delta = ( b.y - a.y );
        float deltaY = nowPosition.y + delta;
        if(deltaY < maxY || deltaY > minY) {
            delta *= 0.5;
        }
        nowPosition.y += delta;
    //}
    
    bounceDistance = 0;
    
    //CCLOG(@"now position.y %f , max: %f",nowPosition.y,maxBottomY);
    if (nowPosition.y <0) {
        bounceDistance = nowPosition.y;
        //nowPosition.y = 0;
    }
    else if (nowPosition.y > maxBottomY) {
        //nowPosition.y = maxBottomY;
        bounceDistance = nowPosition.y - maxBottomY;
    }
    
    [virtualLayer setPosition:nowPosition];
    
    for (CCNode* item in virtualLayer.children) {
        [self updateChildVisible:item];
    }
    
}

- (void) ccTouchEnded:(UITouch*)touch withEvent:(UIEvent *)event {
    isDragging_ = NO;
    if (bounceDistance != 0) {
        CCMoveBy* mb = [CCMoveBy actionWithDuration:0.1 position:ccp(0, -bounceDistance)];
        __block FightLayer* fl = self;
        CCCallBlock* cb = [CCCallBlock actionWithBlock:^{
            [fl updateVisibleInLayer];
        }];
        CCSequence* se = [CCSequence actions:mb,cb, nil];
        [virtualLayer runAction:se];
        //[self performSelector:@selector(updateVisibleInLayer) withObject:nil afterDelay:0.2];
        bounceDistance = 0;
    }
    
    
}

-(void) updateVisibleInLayer
{
    for (CCNode* item in virtualLayer.children) {
        [self updateChildVisible:item];
    }
}

@end
