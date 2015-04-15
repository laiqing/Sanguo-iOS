//
//  MarketInfoLayer.m
//  zhulusanguo
//
//  Created by qing on 15/4/10.
//  Copyright 2015年 qing lai. All rights reserved.
//

#import "MarketInfoLayer.h"


@implementation MarketInfoLayer

//int const MAXLEVEL = 5;
int const goldcost4[] = {0,1000,2000,4000,6000,10000};
int const woodcost4[] = {0,5,8,10,12,15};
int const ironcost4[] = {0,5,8,10,12,15};
int const goldprovide4[] = {0,0,0,0,0,0};
int const woodprovide4[] = {0,1,2,3,4,5};
int const ironprovide4[] = {0,1,2,3,4,5};


-(id) init
{
    if ((self=[super init])) {
        //add bg png
        CGSize wsize = [[CCDirector sharedDirector] winSize];
        bg = [CCSprite spriteWithSpriteFrameName:@"buildinfobg.png"];
        bg.position = ccp(wsize.width*0.5, wsize.height*0.5);
        [self addChild:bg z:0];
        
        //add title "city hall level"
        
        //add cityhall.png scale 2.0
        building = [CCSprite spriteWithSpriteFrameName:@"market.png"];
        building.scale = 2.0f;
        building.position = ccp(wsize.width*0.5-bg.boundingBox.size.width*0.5+building.contentSize.width+25, wsize.height*0.53);
        [self addChild:building z:1];
        
        //add text desc
        desc = [CCSprite spriteWithSpriteFrameName:@"marketdesc.png"];
        desc.anchorPoint = ccp(0, 0.5);
        //desc = [CCLabelTTF labelWithString:@"市政厅每天为你提供一定数量的金币。" fontName:@"Verdana" fontSize:16];
        desc.position = ccp(wsize.width*0.45, wsize.height*0.58);
        [self addChild:desc z:1];
        
        
        //add upgrade btn
        upgradeBtn = [TouchableSprite spriteWithSpriteFrameName:@"buildupgbtn.png"];
        upgradeBtn.position = ccp(bg.position.x + bg.boundingBox.size.width*0.5-35, bg.position.y - bg.boundingBox.size.height*0.5 + 20);
        [self addChild:upgradeBtn z:1];
        [upgradeBtn initTheCallbackFunc:@selector(touchUpgrade) withCaller:self withTouchID:-1];
        
        
    }
    return self;
}

-(void) dealloc
{
    [super dealloc];
}


-(void) onEnter
{
    [[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:1 swallowsTouches:YES];
    [super onEnter];
}

-(void) onExit
{
    CCLOG(@"call MarketLayer onExit()....");
    [[[CCDirector sharedDirector] touchDispatcher] removeDelegate:self];
    [super onExit];
}


-(void) setCityID:(int)cid
{
    CGSize wsize = [[CCDirector sharedDirector] winSize];
    
    _cityID = cid;
    //now set the current info string , and next level info string
    CityInfoObject* cio = [[[ShareGameManager shareGameManager] getCityInfoForCityScene:cid] retain];
    _currentLevel = cio.market;
    _cityLevel = cio.level;
    
    
    //add title "city hall level"
    if (_currentLevel > 0) {
        NSString* tstr = [NSString stringWithFormat:@"市场  %d级",_currentLevel];
        title = [CCLabelTTF labelWithString:tstr fontName:@"Verdana" fontSize:14];
        title.color = ccc3(215, 255, 0);
        title.position = ccp(wsize.width*0.5, bg.position.y+bg.boundingBox.size.height*0.5-12);
        [self addChild:title z:1];
    }
    else {
        // == 0
        title = [CCLabelTTF labelWithString:@"市场  未建造" fontName:@"Verdana" fontSize:14];
        title.color = ccc3(215, 255, 0);
        title.position = ccp(wsize.width*0.5, bg.position.y+bg.boundingBox.size.height*0.5-12);
        [self addChild:title z:1];
    }
    
    //add current provide
    if (_currentLevel>0) {
        //
        NSString* cprov = [NSString stringWithFormat:@"当前等级：%d木材/天 %d铁矿/天",woodprovide4[_currentLevel] ,ironprovide4[_currentLevel]];
        currentProvide = [CCLabelTTF labelWithString:cprov fontName:@"Verdana" fontSize:12];
        //currentProvide.color = ccORANGE;
        currentProvide.anchorPoint = ccp(0, 0.5);
        currentProvide.position = ccp(desc.position.x, wsize.height*0.45);
        [self addChild:currentProvide z:1];
    }
    else {
        //show nothing
        currentProvide = nil;
    }
    
    //add next provide , if current level = max , show nothing.
    if (_currentLevel==5) {
        //next provide = already max level
        nextProvide = [CCLabelTTF labelWithString:@"已经是最高等级" fontName:@"Verdana" fontSize:12];
        nextProvide.color = ccGREEN;
        nextProvide.anchorPoint = ccp(0, 0.5);
        nextProvide.position = ccp(desc.position.x, wsize.height*0.4);
        [self addChild:nextProvide z:1];
        
    }
    else {
        //show _currentLevel+1 info
        NSString* nstr = [NSString stringWithFormat:@"下一等级：%d木材/天 %d铁矿/天",woodprovide4[_currentLevel+1],ironprovide4[_currentLevel+1]];
        nextProvide = [CCLabelTTF labelWithString:nstr fontName:@"Verdana" fontSize:12];
        nextProvide.color = ccGREEN;
        nextProvide.anchorPoint = ccp(0, 0.5);
        nextProvide.position = ccp(desc.position.x, wsize.height*0.4);
        [self addChild:nextProvide z:1];
        
    }
    
    //add upgrade cost text, if current level = max , show nothing.
    if (_currentLevel<5) {
        //show upgrade cost text
        nextgold = [CCSprite spriteWithSpriteFrameName:@"gold.png"];
        nextgold.scale = 0.3;
        nextgold.position = ccp(upgradeBtn.position.x - 70, upgradeBtn.position.y+16);
        [self addChild:nextgold z:1];
        
        NSString* ngstr = [NSString stringWithFormat:@"%d",goldcost4[_currentLevel+1]];
        nextGoldCost = [CCLabelTTF labelWithString:ngstr fontName:@"Verdana" fontSize:10];
        nextGoldCost.anchorPoint = ccp(0, 0.5);
        nextGoldCost.position = ccp(nextgold.position.x+10, nextgold.position.y);
        [self addChild:nextGoldCost z:1];
        
        nextwood = [CCSprite spriteWithSpriteFrameName:@"wood.png"];
        nextwood.scale= 0.3;
        nextwood.position = ccp(upgradeBtn.position.x - 70, upgradeBtn.position.y+4);
        [self addChild:nextwood z:1];
        
        NSString* nwstr = [NSString stringWithFormat:@"%d",woodcost4[_currentLevel+1]];
        nextWoodCost = [CCLabelTTF labelWithString:nwstr fontName:@"Verdana" fontSize:10];
        nextWoodCost.anchorPoint = ccp(0, 0.5);
        nextWoodCost.position = ccp(nextwood.position.x+10, nextwood.position.y);
        [self addChild:nextWoodCost z:1];
        
        nextiron = [CCSprite spriteWithSpriteFrameName:@"iron.png"];
        nextiron.scale = 0.3;
        nextiron.position = ccp(upgradeBtn.position.x-70, upgradeBtn.position.y-8);
        [self addChild:nextiron z:1];
        
        NSString* nistr = [NSString stringWithFormat:@"%d",ironcost4[_currentLevel+1]];
        nextIronCost = [CCLabelTTF labelWithString:nistr fontName:@"Verdana" fontSize:10];
        nextIronCost.anchorPoint = ccp(0, 0.5);
        nextIronCost.position = ccp(nextiron.position.x+10, nextiron.position.y);
        [self addChild:nextIronCost z:1];
        
        
        
    }
    else {
        [upgradeBtn setTouchable:NO];
        upgradeBtn.visible = NO;
    }
    
    //add trade btn
    if (_currentLevel>0) {
        //add other btn , trade
        otherBtn = [TouchableSprite spriteWithSpriteFrameName:@"buildtradebtn.png"];
        otherBtn.position = ccp(bg.position.x - bg.boundingBox.size.width*0.5+35, bg.position.y - bg.boundingBox.size.height*0.5 + 20);
        [self addChild:otherBtn z:1];
    }
    
    
}

-(void) touchOutside
{
    //restore mainlayer touchable sprite
    CCLayer* mainlayer = (CCLayer*)[[[CCDirector sharedDirector] runningScene] getChildByTag:1];
    if (mainlayer) {
        [mainlayer performSelector:@selector(enableBuildingTouchable) withObject:nil];
    }
    
    //close self
    [self removeFromParentAndCleanup:YES];
    
}


//------------------------------------------------
// todo:
//
//------------------------------------------------
-(void) touchUpgrade
{
    if (_currentLevel<5) {
        //if money enough
        int needgold = goldcost4[_currentLevel+1];
        int needwood = woodcost4[_currentLevel+1];
        int neediron = ironcost4[_currentLevel+1];
        if (([ShareGameManager shareGameManager].gold >= needgold)&&([ShareGameManager shareGameManager].wood>= needwood)&&([ShareGameManager shareGameManager].iron >= neediron)) {
            
            [[SimpleAudioEngine sharedEngine] playEffect:@"upgrade.caf"];
            //
            //update the sql set city hall = +1 and citylevel +1
            CCLOG(@"current city level: %d",_cityLevel);
            [[ShareGameManager shareGameManager] upgradeCityBuilding:9 withNewLevel:_currentLevel+1 withCityID:_cityID withNewCityLevel:_cityLevel+1];
            
            //set sharegamemanage gold,wood,iron -
            [ShareGameManager shareGameManager].gold -= needgold;
            [ShareGameManager shareGameManager].wood -= needwood;
            [ShareGameManager shareGameManager].iron -= neediron;
            
            //close self
            [self touchOutside];
            
            //update hud show and play animation
            CCScene* sc = [[CCDirector sharedDirector] runningScene];
            CCLayer<CityHUDProtocol>* cl = (CCLayer<CityHUDProtocol>*) [sc getChildByTag:1];
            if (cl) {
                [cl updateResourceLabel];
                [cl upgradeBuildAnimation:9];
            }
            
        }
        else {
            //not enough money
            CGSize wszie = [[CCDirector sharedDirector] winSize];
            CCSprite* stbar = [CCSprite spriteWithSpriteFrameName:@"statusbar.png"];
            stbar.position = ccp(wszie.width*0.5, wszie.height*0.5);
            [self addChild:stbar z:5];
            [stbar performSelector:@selector(removeFromParent) withObject:nil afterDelay:1.2];
            CCLabelTTF* warn = [CCLabelTTF labelWithString:@"资源不足，无法完成升级！" fontName:@"Arial" fontSize:16];
            warn.color = ccRED;
            warn.position = stbar.position;
            [self addChild:warn z:6];
            [warn performSelector:@selector(removeFromParent) withObject:nil afterDelay:1.2];
            
        }
        
    }
}

-(void) touchOther
{
    //touch trade btn , show trade layer
    
    
}

-(BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    return YES;
}

-(void) ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
    
}


-(void) ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    CGPoint location = [touch locationInView:[touch view]];
    location = [[CCDirector sharedDirector] convertToGL:location];
    BOOL touchInBG = CGRectContainsPoint([bg boundingBox], location);
    if (touchInBG) {
        //do nothing
    }
    else {
        //close
        [self touchOutside];
    }
    
}

@end
