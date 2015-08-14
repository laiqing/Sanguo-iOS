//
//  MapHUDLayer.m
//  zhulusanguo
//
//  Created by qing on 15/3/26.
//  Copyright 2015年 qing lai. All rights reserved.
//

#import "MapHUDLayer.h"


@implementation MapHUDLayer

-(id) init
{
    if ((self = [super init])) {
        uvi = nil;
        statusbar = nil;
        
        year = [ShareGameManager shareGameManager].year;
        month = [ShareGameManager shareGameManager].month;
        day = [ShareGameManager shareGameManager].day;
        
        _gold = [ShareGameManager shareGameManager].gold;
        _wood = [ShareGameManager shareGameManager].wood;
        _iron = [ShareGameManager shareGameManager].iron;
        
        //[[[CCDirector sharedDirector] touchDispatcher] addStandardDelegate:self priority:1];
        CGSize wsize = [[CCDirector sharedDirector] winSize];
        
        
        //don't schedule pop attack info
        //[self schedule:@selector(scheduleAddInfo) interval:5];
        
        //add infobar
        CCSprite* infobg = [CCSprite spriteWithSpriteFrameName:@"infobar.png"];
        infobg.position = ccp(230, 305);
        [self addChild:infobg z:2];
        
        //add dragon icon
        CCSprite *dragon = [CCSprite spriteWithSpriteFrameName:@"dragon.png"];
        dragon.position = ccp(15,300);
        dragon.scale = 0.3;
        [self addChild:dragon z:3];
        
        //add year label
        NSString* ystr = [NSString stringWithFormat:@"%d年%d月%d日",year,month,day];
        ylabel = [CCLabelTTF labelWithString:ystr fontName:@"Verdana" fontSize:12];
        ylabel.position = ccp(70, 305);
        [self addChild:ylabel z:3];
        
        //add king label
        int kingid = [ShareGameManager shareGameManager].kingID;
        NSString* kingstr;
        switch (kingid) {
            case 0:
                kingstr = @"董卓";
                break;
            case 1:
                kingstr = @"马腾";
                break;
            case 2:
                kingstr = @"刘璋";
                break;
            case 3:
                kingstr = @"刘表";
                break;
            case 4:
                kingstr = @"孙坚";
                break;
            case 5:
                kingstr = @"曹操";
                break;
            case 6:
                kingstr = @"陶谦";
                break;
            case 7:
                kingstr = @"孔融";
                break;
            case 8:
                kingstr = @"袁术";
                break;
            case 9:
                kingstr = @"袁绍";
                break;
            case 10:
                kingstr = @"刘备";
                break;
            case 11:
                kingstr = @"公孙瓒";
                break;
            default:
                kingstr = @"董卓";
                break;
        }
        
        CCLabelTTF* kingLabel = [CCLabelTTF labelWithString:kingstr fontName:@"Verdana" fontSize:12];
        kingLabel.position = ccp(130, 305);
        [self addChild:kingLabel z:3];
        
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
        
        //add menu btn
        //------------------- add pop menu layer event function
        menu = [TouchableSprite spriteWithSpriteFrameName:@"menu2.png"];
        menu.anchorPoint = ccp(0.5, 1);
        
        menu.position = ccp(wsize.width-38,320);
        [self addChild:menu z:2];
        
        //menu text
        //CCLabelTTF* menutxt = [CCLabelTTF labelWithString:@"菜单" fontName:@"Verdana" fontSize:12];
        //menutxt.position = menu.position;
        //[self addChild:menutxt z:3];
        
        
        [self schedule:@selector(scheduleUpdateRes) interval:4];
    }
    return self;
    
}

-(void) onEnter
{
    [[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:NO];
    [super onEnter];
}

-(void) onExit
{
    [[[CCDirector sharedDirector] touchDispatcher] removeDelegate:self];
    [super onExit];
}

-(void) dealloc
{
    [self unscheduleAllSelectors];
    
    if (uvi != nil) {
        [uvi removeFromSuperview];
    }
    [super dealloc];
}


//--------------------------------
//  add real money
//--------------------------------
-(void) scheduleUpdateRes
{
    //update gold, lumber, iron, time
    if (month==1) {
        day += 1;
        if (day>31) {
            day = 1;
            month = 2;
        }
    }
    else if(month==2) {
        day += 1;
        if (day>28) {
            day = 1;
            month = 3;
        }
    }
    else if(month==3) {
        day += 1;
        if (day>31) {
            day = 1;
            month = 4;
        }
    }
    else if(month==4) {
        day += 1;
        if (day>30) {
            day = 1;
            month = 5;
        }
    }
    else if(month==5) {
        day += 1;
        if (day>31) {
            day = 1;
            month = 6;
        }
    }
    else if(month==6) {
        day += 1;
        if (day>30) {
            day = 1;
            month = 7;
        }
    }
    else if(month==7) {
        day += 1;
        if (day>31) {
            day = 1;
            month = 8;
        }
    }
    else if(month==8) {
        day += 1;
        if (day>31) {
            day = 1;
            month = 9;
        }
    }
    else if(month==9) {
        day += 1;
        if (day>30) {
            day = 1;
            month = 10;
        }
    }
    else if(month==10) {
        day += 1;
        if (day>31) {
            day = 1;
            month = 11;
        }
    }
    else if(month==11) {
        day += 1;
        if (day>30) {
            day = 1;
            month = 12;
        }
    }
    else if(month==12) {
        day += 1;
        if (day>31) {
            day = 1;
            month = 1;
            year += 1;
        }
    }
    NSString* ystr = [NSString stringWithFormat:@"%d年%d月%d日",year,month,day];
    [ylabel setString:ystr];
    
    //--------------------------
    //update money,wood,iron
    //--------------------------
    _gold += 4000;
    _wood += 10;
    _iron += 10;
    [moneyLabel setString:[NSString stringWithFormat:@"%d",_gold]];
    [woodLabel setString:[NSString stringWithFormat:@"%d",_wood]];
    [ironLabel setString:[NSString stringWithFormat:@"%d",_iron]];
    
}

-(void) updateResourceLabel
{
    //假设_gold有和share manager 同步
    _gold = [ShareGameManager shareGameManager].gold;
    _wood = [ShareGameManager shareGameManager].wood;
    _iron = [ShareGameManager shareGameManager].iron;
    [moneyLabel setString:[NSString stringWithFormat:@"%d",_gold]];
    [woodLabel setString:[NSString stringWithFormat:@"%d",_wood]];
    [ironLabel setString:[NSString stringWithFormat:@"%d",_iron]];
}

-(void) scheduleAddInfo
{
    if (uvi) {
        return;
    }
    else {
        //add a bar to screen bottom
        CGSize wsize = [[CCDirector sharedDirector] winSize];
        if (statusbar==nil) {
            //statusbar = [CCSprite spriteWithSpriteFrameName:@"statusbar.png"];
            statusbar = [CCSprite spriteWithFile:@"statusbar2.png"];
            statusbar.position = ccp(1+statusbar.boundingBox.size.width*0.5, statusbar.boundingBox.size.height*0.5+1);
            [self addChild:statusbar z:2];
        }
        else {
            statusbar.visible = YES;
        }
        //add text on the statusbar
        float topx = statusbar.boundingBox.origin.x;
        float topy = wsize.height - statusbar.boundingBox.origin.y - statusbar.boundingBox.size.height + 10;
        float rwidth = statusbar.boundingBox.size.width;
        float rheight = statusbar.boundingBox.size.height;
        CCLOG(@"new rect %f,%f,%f,%f",topx,topy,rwidth,rheight);
        CGRect cr = CGRectMake(topx, topy, rwidth, rheight);
        uvi = [[UIView alloc] initWithFrame:cr ];
        
        UILabel* label = [[ShareGameManager shareGameManager] addLabelWithString:@"刘备，大事不好了，董卓军向平原发起了进攻！" dimension:cr normalColor:[UIColor whiteColor] highColor:[UIColor redColor] nrange:@"2,7,11,2,15,6" hrange:@"0,2,9,2,13,2"];
        
        [uvi addSubview:label];
        
        //[[[[UIApplication sharedApplication] windows] objectAtIndex:0] addSubview:uvi];
        [[[CCDirector sharedDirector] view] addSubview:uvi];
        
    }
}

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    if (uvi) {
        return YES;
    }
    else {
        return NO;
    }
}


- (void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
    
}

- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    if (uvi) {
        [uvi removeFromSuperview];
        uvi = nil;
        if (statusbar) {
            statusbar.visible = NO;
        }
    }
}

- (void)ccTouchCancelled:(UITouch *)touch withEvent:(UIEvent *)event
{
    
}

-(void) popCityInfoWithCityID:(int)cid
{
    [[SimpleAudioEngine sharedEngine] playEffect:@"menu.caf"];
    CGSize winsize = [CCDirector sharedDirector].winSize;
    //add bginfo
    if (citydlg==nil) {
        citydlg = [CCSprite spriteWithSpriteFrameName:@"cityinfo_bg.png"];
        [self addChild:citydlg z:2];
    }
    else {
        citydlg.visible = YES;
    }
    
    CCLOG(@"touch city id : %d",cid);
    
    citydlg.position = ccp(winsize.width - self.position.x - citydlg.boundingBox.size.width*0.6 , winsize.height - self.position.y - citydlg.boundingBox.size.height*0.63);
    //hero icon , frame , city name , level , hero count, warrior archer cavalry wizard ballista count.
    
    if (heroIcon) {
        [heroIcon removeFromParent];
        heroIcon = nil;
    }
    if (heroFrame) {
        [heroFrame removeFromParent];
        heroFrame = nil;
    }
    if (heroName) {
        [heroName removeFromParent];
        heroName = nil;
    }
    if (cityName) {
        [cityName removeFromParent];
        cityName = nil;
    }
    if (cityLevel) {
        [cityLevel removeFromParent];
        cityLevel = nil;
    }
    if (heroCount) {
        [heroCount removeFromParent];
        heroCount = nil;
    }
    if (warriorCount) {
        [warriorCount removeFromParent];
        warriorCount = nil;
    }
    if (archerCount) {
        [archerCount removeFromParent];
        archerCount = nil;
    }
    if (cavalryCount) {
        [cavalryCount removeFromParent];
        cavalryCount = nil;
    }
    if (wizardCount) {
        [wizardCount removeFromParent];
        wizardCount = nil;
    }
    if (ballistaCount) {
        [ballistaCount removeFromParent];
        ballistaCount = nil;
    }
    if (btn1) {
        [btn1 removeFromParent];
        btn1 = nil;
    }
    if (btn2) {
        [btn2 removeFromParent];
        btn2 = nil;
    }
    
    int selkid = [[ShareGameManager shareGameManager] getCityKingID:cid];
    int selhc = [[ShareGameManager shareGameManager] getCityHeroCount:cid withKingID:selkid];
    CityInfoObject* cio = [[ShareGameManager shareGameManager] getCityInfoObjectFromID:cid];
    
    //int kingid = [ShareGameManager shareGameManager].kingID;
    if (selkid!=99) {
        NSString* heroname = [NSString stringWithFormat:@"hero%d.png",selkid];
        heroIcon = [CCSprite spriteWithSpriteFrameName:heroname];
        [self addChild:heroIcon z:4];
        heroIcon.position = ccp(citydlg.position.x - 30 , citydlg.position.y + 70);
    }
    
    //frame
    heroFrame = [CCSprite spriteWithSpriteFrameName:@"hero_bg.png"];
    [self addChild:heroFrame z:3];
    heroFrame.position = ccp(citydlg.position.x - 30 , citydlg.position.y + 70);
    
    
    
    NSString* kingstr;
    switch (selkid) {
        case 0:
            kingstr = @"董卓";
            break;
        case 1:
            kingstr = @"马腾";
            break;
        case 2:
            kingstr = @"刘璋";
            break;
        case 3:
            kingstr = @"刘表";
            break;
        case 4:
            kingstr = @"孙坚";
            break;
        case 5:
            kingstr = @"曹操";
            break;
        case 6:
            kingstr = @"陶谦";
            break;
        case 7:
            kingstr = @"孔融";
            break;
        case 8:
            kingstr = @"袁术";
            break;
        case 9:
            kingstr = @"袁绍";
            break;
        case 10:
            kingstr = @"刘备";
            break;
        case 11:
            kingstr = @"公孙瓒";
            break;
        case 99:
            kingstr = @"无";
            break;
        default:
            kingstr = @"无";
            break;
    }
    heroName = [CCLabelTTF labelWithString:kingstr fontName:@"Verdana" fontSize:12];
    heroName.anchorPoint = ccp(0, 0.5);
    heroName.color = ccYELLOW;
    heroName.position = ccp(citydlg.position.x+5, citydlg.position.y + 70);
    [self addChild:heroName z:3];
    
    
    
    //city name
    cityName = [CCLabelTTF labelWithString:cio.cnName fontName:@"Verdana" fontSize:12];
    cityName.anchorPoint = ccp(0, 0.5);
    cityName.color = ccYELLOW;
    cityName.position = ccp(citydlg.position.x+5, citydlg.position.y + 85);
    [self addChild:cityName z:3];
    
    NSString* clv = [NSString stringWithFormat:@"等级:%d",cio.level ];
    
    cityLevel = [CCLabelTTF labelWithString:clv fontName:@"Verdana" fontSize:12];
    cityLevel.anchorPoint = ccp(0, 0.5);
    cityLevel.color = ccMAGENTA;
    cityLevel.position = ccp(citydlg.position.x+5, citydlg.position.y + 55);
    [self addChild:cityLevel z:3];
    
    NSString* hcou = [NSString stringWithFormat:@"武将:%d",selhc];
    heroCount = [CCLabelTTF labelWithString:hcou fontName:@"Verdana" fontSize:12];
    heroCount.anchorPoint = ccp(0, 0.5);
    heroCount.position = ccp(citydlg.position.x-50, citydlg.position.y + 35);
    [self addChild:heroCount z:3];
    
    NSString* wcstr = [NSString stringWithFormat:@"步兵:%d",cio.warriorCount];
    NSString* mwcstr = wcstr;
    if (selkid != [ShareGameManager shareGameManager].kingID) {
        NSError *error = nil;
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[0-9]" options:NSRegularExpressionCaseInsensitive error:&error];
        mwcstr = [regex stringByReplacingMatchesInString:wcstr options:0 range:NSMakeRange(0, [wcstr length]) withTemplate:@"?"];
    }
    warriorCount = [CCLabelTTF labelWithString:mwcstr fontName:@"Verdana" fontSize:12];
    warriorCount.anchorPoint = ccp(0, 0.5);
    warriorCount.position = ccp(citydlg.position.x-50, citydlg.position.y+20);
    [self addChild:warriorCount z:3];
    
    NSString* acstr = [NSString stringWithFormat:@"弓兵:%d",cio.archerCount];
    NSString* macstr = acstr;
    if (selkid != [ShareGameManager shareGameManager].kingID) {
        NSError *error = nil;
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[0-9]" options:NSRegularExpressionCaseInsensitive error:&error];
        macstr = [regex stringByReplacingMatchesInString:acstr options:0 range:NSMakeRange(0, [acstr length]) withTemplate:@"?"];
    }
    archerCount = [CCLabelTTF labelWithString:macstr fontName:@"Verdana" fontSize:12];
    archerCount.anchorPoint= ccp(0, 0.5);
    archerCount.position = ccp(citydlg.position.x-50, citydlg.position.y + 5);
    [self addChild:archerCount z:3];
    
    NSString* ccstr = [NSString stringWithFormat:@"骑兵:%d",cio.cavalryCount];
    NSString* mccstr = ccstr;
    if (selkid != [ShareGameManager shareGameManager].kingID) {
        NSError *error = nil;
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[0-9]" options:NSRegularExpressionCaseInsensitive error:&error];
        mccstr = [regex stringByReplacingMatchesInString:ccstr options:0 range:NSMakeRange(0, [ccstr length]) withTemplate:@"?"];
    }
    cavalryCount = [CCLabelTTF labelWithString:mccstr fontName:@"Verdana" fontSize:12];
    cavalryCount.anchorPoint = ccp(0, 0.5);
    cavalryCount.position = ccp(citydlg.position.x-50, citydlg.position.y - 10);
    [self addChild:cavalryCount z:3];
    
    NSString* wicstr = [NSString stringWithFormat:@"策士:%d",cio.wizardCount];
    NSString* mwicstr = wicstr;
    if (selkid != [ShareGameManager shareGameManager].kingID) {
        NSError *error = nil;
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[0-9]" options:NSRegularExpressionCaseInsensitive error:&error];
        mwicstr = [regex stringByReplacingMatchesInString:wicstr options:0 range:NSMakeRange(0, [wicstr length]) withTemplate:@"?"];
    }
    wizardCount = [CCLabelTTF labelWithString:mwicstr fontName:@"Verdana" fontSize:12];
    wizardCount.anchorPoint = ccp(0, 0.5);
    wizardCount.position = ccp(citydlg.position.x-50, citydlg.position.y - 25);
    [self addChild:wizardCount z:3];
    
    NSString* bcstr = [NSString stringWithFormat:@"弩车:%d",cio.ballistaCount];
    NSString* mbcstr = bcstr;
    if (selkid != [ShareGameManager shareGameManager].kingID) {
        NSError *error = nil;
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[0-9]" options:NSRegularExpressionCaseInsensitive error:&error];
        mbcstr = [regex stringByReplacingMatchesInString:bcstr options:0 range:NSMakeRange(0, [bcstr length]) withTemplate:@"?"];
    }
    ballistaCount = [CCLabelTTF labelWithString:mbcstr fontName:@"Verdana" fontSize:12];
    ballistaCount.anchorPoint = ccp(0, 0.5);
    ballistaCount.position = ccp(citydlg.position.x-50, citydlg.position.y - 40);
    [self addChild:ballistaCount z:3];
    
    //add btn
    if (selkid != [ShareGameManager shareGameManager].kingID) {
        
    }
    else {
        btn1 = [TouchableSprite spriteWithSpriteFrameName:@"diaodong.png"];
        btn1.position = ccp(citydlg.position.x-33, citydlg.position.y - 80);
        [self addChild:btn1 z:3];
        [btn1 initTheCallbackFunc:@selector(performDiaoDongToCity:) withCaller:self withTouchID:cid];
    }
    
    if (selkid != [ShareGameManager shareGameManager].kingID) {
        btn2 = [TouchableSprite spriteWithSpriteFrameName:@"fight.png"];
        btn2.position =ccp(citydlg.position.x+33, citydlg.position.y - 80);
        [self addChild:btn2 z:3];
        [btn2 initTheCallbackFunc:@selector(performFightToCity:) withCaller:self withTouchID:cid];
    }
    else {
        btn2 = [TouchableSprite spriteWithSpriteFrameName:@"enter.png"];
        btn2.position =ccp(citydlg.position.x+33, citydlg.position.y - 80);
        [self addChild:btn2 z:3];
        [btn2 initTheCallbackFunc:@selector(performEnterCity:) withCaller:self withTouchID:cid];
    }
    
    
}

//---------------------------------
//
//---------------------------------
-(void) performDiaoDongToCity:(NSNumber*)cid
{
    int _cid = (int)[cid integerValue];
    //show diao dong dialog
    CCLOG(@"show diao dong dialong with cityid :%d",_cid);
    [[SimpleAudioEngine sharedEngine] playEffect:@"menu.caf"];
    
    CGSize wsize = [[CCDirector sharedDirector] winSize];
    //410*205
    CGPoint origin = ccp(wsize.width*0.5-205, wsize.height*0.5-103);
    CGRect vrect = CGRectMake(origin.x, origin.y, 410, 206);
    
    DiaoDongLayer* ddlayer = [DiaoDongLayer slidingLayer:Vertically contentRect:vrect withTargetCityID:_cid];
    CCScene* run = [[CCDirector sharedDirector] runningScene];
    ddlayer.tag = 3;
    [run addChild:ddlayer z:3];
    
    [self performSelector:@selector(removePopCityInfo) withObject:nil afterDelay:0.5];
    
}

-(void) performEnterCity:(NSNumber*)cid
{
    int _cid = (int)[cid integerValue];
    [[SimpleAudioEngine sharedEngine] playEffect:@"menu.caf"];
    //change to the city scene
    CCLOG(@"go into the city scene in cityid : %d",_cid);
    [ShareGameManager shareGameManager].gold = _gold;
    [ShareGameManager shareGameManager].wood = _wood;
    [ShareGameManager shareGameManager].iron = _iron;
    [ShareGameManager shareGameManager].year = year;
    [ShareGameManager shareGameManager].month = month;
    [ShareGameManager shareGameManager].day = day;
    
    [[CCDirector sharedDirector] replaceScene:[CityScene nodeWithCityID:_cid]];
}

-(void) performFightToCity:(NSNumber*)cid
{
    int _cid = (int)[cid integerValue];
    //show fight dialog
    CCLOG(@"show fight dialog for cityid : %d",_cid);
    
    [[SimpleAudioEngine sharedEngine] playEffect:@"menu.caf"];
    
    CGSize wsize = [[CCDirector sharedDirector] winSize];
    //410*205
    CGPoint origin = ccp(wsize.width*0.5-205, wsize.height*0.5-103);
    CGRect vrect = CGRectMake(origin.x, origin.y, 410, 206);
    
    FightLayer* ddlayer = [FightLayer slidingLayer:Vertically contentRect:vrect withTargetCityID:_cid];
    CCScene* run = [[CCDirector sharedDirector] runningScene];
    ddlayer.tag = 4;
    [run addChild:ddlayer z:4];
    
    [self performSelector:@selector(removePopCityInfo) withObject:nil afterDelay:0.5];
    
}


-(void) removePopCityInfo
{
    if (citydlg != nil) {
        citydlg.visible = NO;
        //remove other
        if (heroIcon) {
            [heroIcon removeFromParent];
            heroIcon = nil;
        }
        if (heroFrame) {
            [heroFrame removeFromParent];
            heroFrame = nil;
        }
        if (heroName) {
            [heroName removeFromParent];
            heroName = nil;
        }
        if (cityName) {
            [cityName removeFromParent];
            cityName = nil;
        }
        if (cityLevel) {
            [cityLevel removeFromParent];
            cityLevel = nil;
        }
        if (heroCount) {
            [heroCount removeFromParent];
            heroCount = nil;
        }
        if (warriorCount) {
            [warriorCount removeFromParent];
            warriorCount = nil;
        }
        if (archerCount) {
            [archerCount removeFromParent];
            archerCount = nil;
        }
        if (cavalryCount) {
            [cavalryCount removeFromParent];
            cavalryCount = nil;
        }
        if (wizardCount) {
            [wizardCount removeFromParent];
            wizardCount = nil;
        }
        if (ballistaCount) {
            [ballistaCount removeFromParent];
            ballistaCount = nil;
        }
        if (btn1) {
            [btn1 removeFromParent];
            btn1 = nil;
        }
        if (btn2) {
            [btn2 removeFromParent];
            btn2 = nil;
        }
    }
}



@end
