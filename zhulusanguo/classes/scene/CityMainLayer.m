//
//  CityMainLayer.m
//  zhulusanguo
//
//  Created by qing on 15/3/28.
//  Copyright 2015年 qing lai. All rights reserved.
//

#import "CityMainLayer.h"
#import "MapScene.h"


@implementation CityMainLayer


-(id)initWithCityID:(int)cid
{
    if ((self = [super init])) {
        _cityID = cid;
        
        [[ShareGameManager shareGameManager] initDefaultAllAnimationInScene];
        
        CGSize wsize = [[CCDirector sharedDirector] winSize];
        CCSprite* bg = [CCSprite spriteWithFile:@"cityscene.png"];
        bg.position = ccp(wsize.width*0.5, wsize.height*0.5);
        [self addChild:bg z:0];
        
        
        //from sharegamemanager select city info , then draw 11 building
        cio = [[[ShareGameManager shareGameManager] getCityInfoForCityScene:cid] retain];
        
        tower1Building = [CCSprite spriteWithSpriteFrameName:@"citytower.png"];
        tower1Building.position = ccp(wsize.width*0.5-180, wsize.height*0.5-112);
        [self addChild:tower1Building z:2];
        
        tower2Building = [CCSprite spriteWithSpriteFrameName:@"citytower.png"];
        tower2Building.position = ccp(wsize.width*0.5-90, wsize.height*0.5-112);
        [self addChild:tower2Building z:2];
        
        tower3Building = [CCSprite spriteWithSpriteFrameName:@"citytower.png"];
        tower3Building.position = ccp(wsize.width*0.5+95, wsize.height*0.5-112);
        [self addChild:tower3Building z:2];
        
        tower4Building = [CCSprite spriteWithSpriteFrameName:@"citytower.png"];
        tower4Building.position = ccp(wsize.width*0.5+185, wsize.height*0.5-112);
        [self addChild:tower4Building z:2];
        
        if (cio.hall == 0) {
            hallBuilding = [TouchableSprite spriteWithSpriteFrameName:@"cityhall_gray.png"];
            hallBuilding.position = ccp(wsize.width*0.51, wsize.height*0.68);
            [self addChild:hallBuilding z:2];
        }
        else {
            hallBuilding = [TouchableSprite spriteWithSpriteFrameName:@"cityhall.png"];
            hallBuilding.position = ccp(wsize.width*0.51, wsize.height*0.68);
            [self addChild:hallBuilding z:2];
            [hallBuilding initTheCallbackFunc:@selector(showCityHallInfo) withCaller:self withTouchID:-1];
        }
        
        if (cio.barrack == 0) {
            barrackBuilding = [TouchableSprite spriteWithSpriteFrameName:@"barrack_gray.png"];
            barrackBuilding.position = ccp(wsize.width*0.3, wsize.height*0.42);
            [self addChild:barrackBuilding z:2];
            [barrackBuilding initTheCallbackFunc:@selector(showBarrackInfo) withCaller:self withTouchID:-1];
        }
        else {
            barrackBuilding = [TouchableSprite spriteWithSpriteFrameName:@"barrack.png"];
            barrackBuilding.position = ccp(wsize.width*0.3, wsize.height*0.42);
            [self addChild:barrackBuilding z:2];
            [barrackBuilding initTheCallbackFunc:@selector(showBarrackInfo) withCaller:self withTouchID:-1];
        }
        
        if (cio.archer == 0) {
            archerBuilding = [TouchableSprite spriteWithSpriteFrameName:@"archer_gray.png"];
            archerBuilding.position = ccp(wsize.width*0.4, wsize.height*0.42);
            [self addChild:archerBuilding z:2];
            [archerBuilding initTheCallbackFunc:@selector(showArcherInfo) withCaller:self withTouchID:-1];
        }
        else {
            archerBuilding = [TouchableSprite spriteWithSpriteFrameName:@"archer.png"];
            archerBuilding.position = ccp(wsize.width*0.4, wsize.height*0.42);
            [self addChild:archerBuilding z:2];
            [archerBuilding initTheCallbackFunc:@selector(showArcherInfo) withCaller:self withTouchID:-1];
        }
        
        if (cio.cavalry == 0) {
            cavalryBuilding = [TouchableSprite spriteWithSpriteFrameName:@"cavalry_gray.png"];
            cavalryBuilding.position = ccp(wsize.width*0.6, wsize.height*0.42);
            [self addChild:cavalryBuilding z:2];
            [cavalryBuilding initTheCallbackFunc:@selector(showCavalryInfo) withCaller:self withTouchID:-1];
        }
        else {
            cavalryBuilding = [TouchableSprite spriteWithSpriteFrameName:@"cavalry.png"];
            cavalryBuilding.position = ccp(wsize.width*0.6, wsize.height*0.42);
            [self addChild:cavalryBuilding z:2];
            [cavalryBuilding initTheCallbackFunc:@selector(showCavalryInfo) withCaller:self withTouchID:-1];
        }
        
        if (cio.wizard == 0) {
            wizardBuilding = [TouchableSprite spriteWithSpriteFrameName:@"wizard_gray.png"];
            wizardBuilding.position = ccp(wsize.width*0.7, wsize.height*0.42);
            [self addChild:wizardBuilding z:2];
            [wizardBuilding initTheCallbackFunc:@selector(showWizardInfo) withCaller:self withTouchID:-1];
        }
        else {
            wizardBuilding = [TouchableSprite spriteWithSpriteFrameName:@"wizard.png"];
            wizardBuilding.position = ccp(wsize.width*0.7, wsize.height*0.42);
            [self addChild:wizardBuilding z:2];
            [wizardBuilding initTheCallbackFunc:@selector(showWizardInfo) withCaller:self withTouchID:-1];
        }
        
        if (cio.blacksmith == 0) {
            blacksmithBuilding = [TouchableSprite spriteWithSpriteFrameName:@"blacksmith_gray.png"];
            blacksmithBuilding.position = ccp(wsize.width*0.3, wsize.height*0.68);
            [self addChild:blacksmithBuilding z:2];
            [blacksmithBuilding initTheCallbackFunc:@selector(showBlacksmithInfo) withCaller:self withTouchID:-1];
        }
        else {
            blacksmithBuilding = [TouchableSprite spriteWithSpriteFrameName:@"blacksmith.png"];
            blacksmithBuilding.position = ccp(wsize.width*0.3, wsize.height*0.68);
            [self addChild:blacksmithBuilding z:2];
            [blacksmithBuilding initTheCallbackFunc:@selector(showBlacksmithInfo) withCaller:self withTouchID:-1];
        }
        
        if (cio.steelmill == 0) {
            steelmillBuilding = [TouchableSprite spriteWithSpriteFrameName:@"steelmill_gray.png"];
            steelmillBuilding.position = ccp(wsize.width*0.4, wsize.height*0.68);
            [self addChild:steelmillBuilding z:2];
            [steelmillBuilding initTheCallbackFunc:@selector(showSteelMillInfo) withCaller:self withTouchID:-1];
        }
        else {
            steelmillBuilding = [TouchableSprite spriteWithSpriteFrameName:@"steelmill.png"];
            steelmillBuilding.position = ccp(wsize.width*0.4, wsize.height*0.68);
            [self addChild:steelmillBuilding z:2];
            [steelmillBuilding initTheCallbackFunc:@selector(showSteelMillInfo) withCaller:self withTouchID:-1];
        }
        
        if (cio.lumbermill == 0) {
            lumbermillBuilding = [TouchableSprite spriteWithSpriteFrameName:@"lumbermill_gray.png"];
            lumbermillBuilding.position = ccp(wsize.width*0.62, wsize.height*0.68);
            [self addChild:lumbermillBuilding z:2];
            [lumbermillBuilding initTheCallbackFunc:@selector(showLumberMillInfo) withCaller:self withTouchID:-1];
        }
        else {
            lumbermillBuilding = [TouchableSprite spriteWithSpriteFrameName:@"lumbermill.png"];
            lumbermillBuilding.position = ccp(wsize.width*0.62, wsize.height*0.68);
            [self addChild:lumbermillBuilding z:2];
            [lumbermillBuilding initTheCallbackFunc:@selector(showLumberMillInfo) withCaller:self withTouchID:-1];
        }
        
        if (cio.market == 0) {
            marketBuilding = [TouchableSprite spriteWithSpriteFrameName:@"market_gray.png"];
            marketBuilding.position = ccp(wsize.width*0.72, wsize.height*0.68);
            [self addChild:marketBuilding z:2];
            [marketBuilding initTheCallbackFunc:@selector(showMarketInfo) withCaller:self withTouchID:-1];
        }
        else {
            marketBuilding = [TouchableSprite spriteWithSpriteFrameName:@"market.png"];
            marketBuilding.position = ccp(wsize.width*0.72, wsize.height*0.68);
            [self addChild:marketBuilding z:2];
            [marketBuilding initTheCallbackFunc:@selector(showMarketInfo) withCaller:self withTouchID:-1];
        }
        
        if (cio.magictower == 0) {
            magictowerBuilding = [TouchableSprite spriteWithSpriteFrameName:@"magictower_gray.png"];
            magictowerBuilding.position = ccp(wsize.width*0.35, wsize.height*0.56);
            [self addChild:magictowerBuilding z:2];
            [magictowerBuilding initTheCallbackFunc:@selector(showMagicTowerInfo) withCaller:self withTouchID:-1];
        }
        else {
            magictowerBuilding = [TouchableSprite spriteWithSpriteFrameName:@"magictower.png"];
            magictowerBuilding.position = ccp(wsize.width*0.35, wsize.height*0.56);
            [self addChild:magictowerBuilding z:2];
            [magictowerBuilding initTheCallbackFunc:@selector(showMagicTowerInfo) withCaller:self withTouchID:-1];
        }
        
        if (cio.tavern == 0) {
            tavernBuilding = [TouchableSprite spriteWithSpriteFrameName:@"tavern_gray.png"];
            tavernBuilding.position = ccp(wsize.width*0.66, wsize.height*0.56);
            [self addChild:tavernBuilding z:2];
            [tavernBuilding initTheCallbackFunc:@selector(showTavernInfo) withCaller:self withTouchID:-1];
        }
        else {
            tavernBuilding = [TouchableSprite spriteWithSpriteFrameName:@"tavern.png"];
            tavernBuilding.position = ccp(wsize.width*0.66, wsize.height*0.56);
            [self addChild:tavernBuilding z:2];
            [tavernBuilding initTheCallbackFunc:@selector(showTavernInfo) withCaller:self withTouchID:-1];
        }
        
        
        
        //draw 8 button below
        //buildBtn = [TouchableSprite spriteWithSpriteFrameName:@"buildbtn.png"];
        //buildBtn.position = ccp(wsize.width*0.12-20, 22);
        //[self addChild:buildBtn z:2];
        
        
        articleBtn = [TouchableSprite spriteWithSpriteFrameName:@"articlebtn.png"];
        articleBtn.position = ccp(wsize.width*0.14, 22);
        [self addChild:articleBtn z:2];
        
        recruitBtn = [TouchableSprite spriteWithSpriteFrameName:@"recruitbtn.png"];
        recruitBtn.position = ccp(wsize.width*0.26, 22);
        [self addChild:recruitBtn z:2];
        
        distributeBtn = [TouchableSprite spriteWithSpriteFrameName:@"distributebtn.png"];
        distributeBtn.position = ccp(wsize.width*0.38, 22);
        [self addChild:distributeBtn z:2];
        
        heroBtn = [TouchableSprite spriteWithSpriteFrameName:@"herobtn.png"];
        heroBtn.position = ccp(wsize.width*0.5, 22);
        [self addChild:heroBtn z:2];
        
        skillBtn = [TouchableSprite spriteWithSpriteFrameName:@"skillbtn.png"];
        skillBtn.position = ccp(wsize.width*0.62, 22);
        [self addChild:skillBtn z:2];
        
        forgeBtn = [TouchableSprite spriteWithSpriteFrameName:@"forgebtn.png"];
        forgeBtn.position = ccp(wsize.width*0.74, 22);
        [self addChild:forgeBtn z:2];
        
        tradeBtn = [TouchableSprite spriteWithSpriteFrameName:@"tradebtn.png"];
        tradeBtn.position = ccp(wsize.width*0.86, 22);
        [self addChild:tradeBtn z:2];
        
        
        //draw money infobar close.button up
        //add infobar
        CCSprite* infobg = [CCSprite spriteWithSpriteFrameName:@"infobar.png"];
        infobg.position = ccp(230, 305);
        [self addChild:infobg z:2];
        
        //add hero capital icon
        int kkid = [ShareGameManager shareGameManager].kingID;
        NSString* kfile = [NSString stringWithFormat:@"capital%d.png",kkid];
        CCSprite *dragon = [CCSprite spriteWithSpriteFrameName:kfile];
        dragon.position = ccp(15,305);
        [self addChild:dragon z:3];
        
        _year = [ShareGameManager shareGameManager].year;
        _month = [ShareGameManager shareGameManager].month;
        _day = [ShareGameManager shareGameManager].day;
        //add year label
        NSString* ystr = [NSString stringWithFormat:@"%d年%d月%d日",_year,_month,_day];
        ylabel = [CCLabelTTF labelWithString:ystr fontName:@"Verdana" fontSize:12];
        ylabel.position = ccp(70, 305);
        [self addChild:ylabel z:3];
        
        //add cityname label
        CCLabelTTF* kingLabel = [CCLabelTTF labelWithString:citynames[_cityID] fontName:@"Verdana" fontSize:12];
        kingLabel.position = ccp(130, 305);
        [self addChild:kingLabel z:3];
        
        _gold = [ShareGameManager shareGameManager].gold;
        _wood = [ShareGameManager shareGameManager].wood;
        _iron = [ShareGameManager shareGameManager].iron;
        
        //add gold icon
        CCSprite* money = [CCSprite spriteWithSpriteFrameName:@"gold.png"];
        money.scale = 0.5;
        money.position = ccp(165, 305);
        [self addChild:money z:3];
        
        //add money text
        moneyLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d",_gold] fontName:@"Verdana" fontSize:12];
        moneyLabel.anchorPoint = ccp(0, 0.5);
        moneyLabel.position = ccp(180, 305);
        [self addChild:moneyLabel z:3];
        
        //add wood icon
        CCSprite* wood = [CCSprite spriteWithSpriteFrameName:@"wood.png"];
        wood.scale = 0.5;
        wood.position = ccp(265, 305);
        [self addChild:wood z:3];
        
        //add wood text
        woodLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d",_wood] fontName:@"Verdana" fontSize:12];
        woodLabel.anchorPoint = ccp(0, 0.5);
        woodLabel.position = ccp(280, 305);
        [self addChild:woodLabel z:3];
        
        //add iron icon
        CCSprite* iron = [CCSprite spriteWithSpriteFrameName:@"iron.png"];
        iron.scale = 0.5;
        iron.position = ccp(365, 305);
        [self addChild:iron z:3];
        
        //add iron label
        ironLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d",_iron] fontName:@"Verdana" fontSize:12];
        ironLabel.anchorPoint = ccp(0, 0.5);
        ironLabel.position = ccp(380, 305);
        [self addChild:ironLabel z:3];
        
        //add close button
        //------------------- add close layer event function
        menu = [TouchableSprite spriteWithSpriteFrameName:@"close.png"];
        menu.anchorPoint = ccp(0.5, 1);
        //menu.scale = 1.5;
        menu.position = ccp(wsize.width-20,315);
        [self addChild:menu z:2];
        [menu initTheCallbackFunc:@selector(backtoMap) withCaller:self withTouchID:-1];
        
        
        
        //draw walker animation
        SoliderWalkSprite* swsp = [SoliderWalkSprite spriteWithSpriteFrameName:@"soliderwalk01.png"];
        swsp.position = ccp(wsize.width*0.5+70, wsize.height*0.5-100);
        [self addChild:swsp z:1];
        [swsp initRange:140];
        
        LeftSoliderWalkSprite* swsp1 = [LeftSoliderWalkSprite spriteWithSpriteFrameName:@"soliderwalk01.png"];
        swsp1.position = ccp(wsize.width*0.5-70, wsize.height*0.5-100);
        [self addChild:swsp1 z:1];
        [swsp1 initRange:140];
        
        
        //draw cloud
        for (int i=1; i<4; i++) {
            NSString* cloudfile;
            cloudfile = @"cloud01.png";
            CloudSprite *ccsp = [CloudSprite spriteWithSpriteFrameName:cloudfile];
            ccsp.scale = 0.5;
            [ccsp initBoundary:wsize.width withYPos:wsize.height*0.2*i];
            [self addChild:ccsp z:3];
        }
    }
    return self;
}

-(void) dealloc
{
    [cio release];
    [super dealloc];
}

-(void) backtoMap
{
    [[ShareGameManager shareGameManager] initDefaultAllAnimationInScene];
    [[CCDirector sharedDirector] replaceScene:[MapScene node]];
}

-(void) scheduleUpdateRes
{
    //just copy the MapHUDLayer update res funciton to here
    
    //schedule add enemy resource , distribute enemy's army , add enemy city's building , this function add in hud
    //----------------------------------------
    //----------------------------------------
    //schedule add inccident. flood, plage, thief.
    //schedule other enemy fight each other.
    //"刘备，据探马来报，董卓正在集结部队，准备10天后对xx城进攻，请做好准备。"
    
}

-(void) showCityHallInfo
{

    //use the _cityID
    CityHallInfoLayer* chlayer = [CityHallInfoLayer node];
    chlayer.tag = 4;
    CCScene* run = [[CCDirector sharedDirector] runningScene];
    
    CCNode* anylayer = [run getChildByTag:4];
    if (anylayer) {
        [anylayer removeFromParentAndCleanup:YES];
    }
    
    //chlayer.tag = 4;
    [run addChild:chlayer z:4];
    [chlayer setCityID:_cityID];
    
    [self disableBuildingTouchable];
    
}

-(void) showLumberMillInfo
{
    
    //use the _cityID
    LumberMillInfoLayer* chlayer = [LumberMillInfoLayer node];
    chlayer.tag = 4;
    CCScene* run = [[CCDirector sharedDirector] runningScene];
    
    CCNode* anylayer = [run getChildByTag:4];
    if (anylayer) {
        [anylayer removeFromParentAndCleanup:YES];
    }
    
    //chlayer.tag = 4;
    [run addChild:chlayer z:4];
    [chlayer setCityID:_cityID];
    
    [self disableBuildingTouchable];
    
}

-(void) showSteelMillInfo
{
    
    //use the _cityID
    SteelMillInfoLayer* chlayer = [SteelMillInfoLayer node];
    chlayer.tag = 4;
    CCScene* run = [[CCDirector sharedDirector] runningScene];
    
    CCNode* anylayer = [run getChildByTag:4];
    if (anylayer) {
        [anylayer removeFromParentAndCleanup:YES];
    }
    
    //chlayer.tag = 4;
    [run addChild:chlayer z:4];
    [chlayer setCityID:_cityID];
    
    [self disableBuildingTouchable];
    
}

-(void) showMarketInfo
{
    
    //use the _cityID
    MarketInfoLayer* chlayer = [MarketInfoLayer node];
    chlayer.tag = 4;
    CCScene* run = [[CCDirector sharedDirector] runningScene];
    
    CCNode* anylayer = [run getChildByTag:4];
    if (anylayer) {
        [anylayer removeFromParentAndCleanup:YES];
    }
    
    //chlayer.tag = 4;
    [run addChild:chlayer z:4];
    [chlayer setCityID:_cityID];
    
    [self disableBuildingTouchable];
    
}

-(void) showBarrackInfo
{
    
    //use the _cityID
    BarrackInfoLayer* chlayer = [BarrackInfoLayer node];
    chlayer.tag = 4;
    CCScene* run = [[CCDirector sharedDirector] runningScene];
    
    CCNode* anylayer = [run getChildByTag:4];
    if (anylayer) {
        [anylayer removeFromParentAndCleanup:YES];
    }
    
    //chlayer.tag = 4;
    [run addChild:chlayer z:4];
    [chlayer setCityID:_cityID];
    
    [self disableBuildingTouchable];
    
}

-(void) showArcherInfo
{
    
    //use the _cityID
    ArcherInfoLayer* chlayer = [ArcherInfoLayer node];
    chlayer.tag = 4;
    CCScene* run = [[CCDirector sharedDirector] runningScene];
    
    CCNode* anylayer = [run getChildByTag:4];
    if (anylayer) {
        [anylayer removeFromParentAndCleanup:YES];
    }
    
    //chlayer.tag = 4;
    [run addChild:chlayer z:4];
    [chlayer setCityID:_cityID];
    
    [self disableBuildingTouchable];
    
}

-(void) showCavalryInfo
{
    
    //use the _cityID
    CavalryInfoLayer* chlayer = [CavalryInfoLayer node];
    chlayer.tag = 4;
    CCScene* run = [[CCDirector sharedDirector] runningScene];
    
    CCNode* anylayer = [run getChildByTag:4];
    if (anylayer) {
        [anylayer removeFromParentAndCleanup:YES];
    }
    
    //chlayer.tag = 4;
    [run addChild:chlayer z:4];
    [chlayer setCityID:_cityID];
    
    [self disableBuildingTouchable];
    
}

-(void) showWizardInfo
{
    
    //use the _cityID
    WizardInfoLayer* chlayer = [WizardInfoLayer node];
    chlayer.tag = 4;
    CCScene* run = [[CCDirector sharedDirector] runningScene];
    
    CCNode* anylayer = [run getChildByTag:4];
    if (anylayer) {
        [anylayer removeFromParentAndCleanup:YES];
    }
    
    //chlayer.tag = 4;
    [run addChild:chlayer z:4];
    [chlayer setCityID:_cityID];
    
    [self disableBuildingTouchable];
    
}

-(void) showBlacksmithInfo
{
    
    //use the _cityID
    BlacksmithInfoLayer* chlayer = [BlacksmithInfoLayer node];
    chlayer.tag = 4;
    CCScene* run = [[CCDirector sharedDirector] runningScene];
    
    CCNode* anylayer = [run getChildByTag:4];
    if (anylayer) {
        [anylayer removeFromParentAndCleanup:YES];
    }
    
    //chlayer.tag = 4;
    [run addChild:chlayer z:4];
    [chlayer setCityID:_cityID];
    
    [self disableBuildingTouchable];
    
}

-(void) showMagicTowerInfo
{
    
    //use the _cityID
    MagicTowerInfoLayer* chlayer = [MagicTowerInfoLayer node];
    chlayer.tag = 4;
    CCScene* run = [[CCDirector sharedDirector] runningScene];
    
    CCNode* anylayer = [run getChildByTag:4];
    if (anylayer) {
        [anylayer removeFromParentAndCleanup:YES];
    }
    
    //chlayer.tag = 4;
    [run addChild:chlayer z:4];
    [chlayer setCityID:_cityID];
    
    [self disableBuildingTouchable];
    
}

-(void) showTavernInfo
{
    
    //use the _cityID
    TavernInfoLayer* chlayer = [TavernInfoLayer node];
    chlayer.tag = 4;
    CCScene* run = [[CCDirector sharedDirector] runningScene];
    
    CCNode* anylayer = [run getChildByTag:4];
    if (anylayer) {
        [anylayer removeFromParentAndCleanup:YES];
    }
    
    //chlayer.tag = 4;
    [run addChild:chlayer z:4];
    [chlayer setCityID:_cityID];
    
    [self disableBuildingTouchable];
    
}

-(void) enableBuildingTouchable
{
    [hallBuilding setTouchable:YES];
    [barrackBuilding setTouchable:YES];
    [archerBuilding setTouchable:YES];
    [cavalryBuilding setTouchable:YES];
    [wizardBuilding setTouchable:YES];
    [blacksmithBuilding setTouchable:YES];
    [steelmillBuilding setTouchable:YES];
    [lumbermillBuilding setTouchable:YES];
    [marketBuilding setTouchable:YES];
    [magictowerBuilding setTouchable:YES];
    [tavernBuilding setTouchable:YES];
}

-(void) disableBuildingTouchable
{
    [hallBuilding setTouchable:NO];
    [barrackBuilding setTouchable:NO];
    [archerBuilding setTouchable:NO];
    [cavalryBuilding setTouchable:NO];
    [wizardBuilding setTouchable:NO];
    [blacksmithBuilding setTouchable:NO];
    [steelmillBuilding setTouchable:NO];
    [lumbermillBuilding setTouchable:NO];
    [marketBuilding setTouchable:NO];
    [magictowerBuilding setTouchable:NO];
    [tavernBuilding setTouchable:NO];
}

@end
