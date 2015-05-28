//
//  TradeLayer.m
//  zhulusanguo
//
//  Created by qing on 15/4/10.
//  Copyright 2015年 qing lai. All rights reserved.
//

#import "TradeLayer.h"


@implementation TradeLayer

+ (id) contentRect1:(CGRect)left contentRect2:(CGRect)right withCityID:(int)tcid
{
    return [[[self alloc] initcontentRect1:left contentRect2:right withCityID:tcid] autorelease];
}

- (id) initcontentRect1:(CGRect)left contentRect2:(CGRect)right withCityID:(int)tcid
{
    if ((self=[super init])) {
        currentResForInType = 0;
        currentResForOutType = 0;
        currentResInCount = 0;
        currentResOutCount = 0;
        maxResInCount = 0;
        
        _cityID = tcid;
        leftContent = left;
        rightContent = right;
        
        needClosePayment = 0;
        showPaymentDialog = 0;

        
        leftLayer = [[[CCNode alloc] init] autorelease];
        rightLayer = nil;
        
        [self addChild:leftLayer z:1];
        
        bounceDistance = 0;
        needClose = 0;
        
        receivers = [[CCArray alloc] init];
        
        minTopLeftY = leftLayer.position.y;
        
        //select city market level from sqlite, then get the rate.
        CityInfoObject* cio = [[ShareGameManager shareGameManager] getCityInfoForCityScene:_cityID];
        int marketLevel = cio.market;
        int gold_wood_rate = goldToWoodRate[marketLevel];
        int gold_iron_rate = goldToIronRate[marketLevel];
        int wood_gold_rate = woodToGoldRate[marketLevel];
        int wood_iron_rate = woodToIronRate[marketLevel];
        int iron_gold_rate = ironToGoldRate[marketLevel];
        int iron_wood_rate = ironToWoodRate[marketLevel];
        
        //now add item bg , hero select bg to the layer children
        CCSprite* itembg = [CCSprite spriteWithSpriteFrameName:@"heroselectbg.png"];
        CGSize wsize = [[CCDirector sharedDirector] winSize];
        itembg.position = ccp(wsize.width*0.5, wsize.height*0.5);
        [self addChild:itembg z:0];
        
        //show 6 exchange rate in the top
        NSString* tstr = [NSString stringWithFormat:@"市场等级:%d -- 当前资源汇率",marketLevel];
        CCLabelTTF *title = [CCLabelTTF labelWithString:tstr fontName:@"Arial" fontSize:12];
        title.color = ccYELLOW;
        title.position = ccp(wsize.width*0.5, wsize.height*0.5 + itembg.boundingBox.size.height*0.5 - 20);
        [leftLayer addChild:title z:1];
        
        
        //gold to wood
        CCSprite* gicon1 = [CCSprite spriteWithSpriteFrameName:@"gold.png"];
        gicon1.scale = 0.4;
        gicon1.position = ccp(title.position.x - 110, title.position.y - 20);
        [leftLayer addChild:gicon1 z:1];
        
        CCLabelTTF* gtext1 = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d",gold_wood_rate] fontName:@"Arial" fontSize:10];
        gtext1.position = ccp(gicon1.position.x - 18, gicon1.position.y);
        [leftLayer addChild:gtext1 z:1];
        
        CCLabelTTF* gtext2 = [CCLabelTTF labelWithString:@"-->  1" fontName:@"Arial" fontSize:10];
        gtext2.anchorPoint = ccp(0, 0.5);
        gtext2.position = ccp(gicon1.position.x + 10, gicon1.position.y);
        [leftLayer addChild:gtext2 z:1];
        
        CCSprite* wicon1 = [CCSprite spriteWithSpriteFrameName:@"wood.png"];
        wicon1.scale = 0.4;
        wicon1.position = ccp(gtext2.position.x + 35, gtext2.position.y);
        [leftLayer addChild:wicon1 z:1];
        
        //gold to iron
        CCSprite* gicon2 = [CCSprite spriteWithSpriteFrameName:@"gold.png"];
        gicon2.scale = 0.4;
        gicon2.position = ccp(gicon1.position.x, gicon1.position.y - 20);
        [leftLayer addChild:gicon2 z:1];
        
        CCLabelTTF* gtext3 = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d",gold_iron_rate] fontName:@"Arial" fontSize:10];
        gtext3.position = ccp(gicon2.position.x - 18, gicon2.position.y);
        [leftLayer addChild:gtext3 z:1];
        
        CCLabelTTF* gtext4 = [CCLabelTTF labelWithString:@"-->  1" fontName:@"Arial" fontSize:10];
        gtext4.anchorPoint = ccp(0, 0.5);
        gtext4.position = ccp(gicon2.position.x + 10, gicon2.position.y);
        [leftLayer addChild:gtext4 z:1];
        
        CCSprite* iicon1 = [CCSprite spriteWithSpriteFrameName:@"iron.png"];
        iicon1.scale = 0.4;
        iicon1.position = ccp(gtext4.position.x + 35, gtext4.position.y);
        [leftLayer addChild:iicon1 z:1];
        
        
        //add wood -> gold , iron info
        CCSprite* wicon2 = [CCSprite spriteWithSpriteFrameName:@"wood.png"];
        wicon2.scale = 0.4;
        wicon2.position = ccp(gicon1.position.x + 90, title.position.y - 20);
        [leftLayer addChild:wicon2 z:1];
        
        CCLabelTTF* wtext1 = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d",wood_gold_rate] fontName:@"Arial" fontSize:10];
        wtext1.position = ccp(wicon2.position.x - 18, wicon2.position.y);
        [leftLayer addChild:wtext1 z:1];
        
        CCLabelTTF* wtext2 = [CCLabelTTF labelWithString:@"-->  1" fontName:@"Arial" fontSize:10];
        wtext2.anchorPoint = ccp(0, 0.5);
        wtext2.position = ccp(wicon2.position.x + 10, wicon2.position.y);
        [leftLayer addChild:wtext2 z:1];
        
        CCSprite* gicon3 = [CCSprite spriteWithSpriteFrameName:@"gold.png"];
        gicon3.scale = 0.4;
        gicon3.position = ccp(wtext2.position.x + 35, wtext2.position.y);
        [leftLayer addChild:gicon3 z:1];
        
        //wood to iron
        CCSprite* wicon3 = [CCSprite spriteWithSpriteFrameName:@"wood.png"];
        wicon3.scale = 0.4;
        wicon3.position = ccp(wicon2.position.x, wicon2.position.y - 20);
        [leftLayer addChild:wicon3 z:1];
        
        CCLabelTTF* wtext3 = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d",wood_iron_rate] fontName:@"Arial" fontSize:10];
        wtext3.position = ccp(wicon3.position.x - 18, wicon3.position.y);
        [leftLayer addChild:wtext3 z:1];
        
        CCLabelTTF* wtext4 = [CCLabelTTF labelWithString:@"-->  1" fontName:@"Arial" fontSize:10];
        wtext4.anchorPoint = ccp(0, 0.5);
        wtext4.position = ccp(wicon3.position.x + 10, wicon3.position.y);
        [leftLayer addChild:wtext4 z:1];
        
        CCSprite* iicon2 = [CCSprite spriteWithSpriteFrameName:@"iron.png"];
        iicon2.scale = 0.4;
        iicon2.position = ccp(wtext4.position.x + 35, wtext4.position.y);
        [leftLayer addChild:iicon2 z:1];
        
        //iron to gold , wood
        CCSprite* iicon3 = [CCSprite spriteWithSpriteFrameName:@"iron.png"];
        iicon3.scale = 0.4;
        iicon3.position = ccp(wicon2.position.x + 90, title.position.y - 20);
        [leftLayer addChild:iicon3 z:1];
        
        CCLabelTTF* itext1 = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d",iron_gold_rate] fontName:@"Arial" fontSize:10];
        itext1.position = ccp(iicon3.position.x - 18, iicon3.position.y);
        [leftLayer addChild:itext1 z:1];
        
        CCLabelTTF* itext2 = [CCLabelTTF labelWithString:@"-->  1" fontName:@"Arial" fontSize:10];
        itext2.anchorPoint = ccp(0, 0.5);
        itext2.position = ccp(iicon3.position.x + 10, iicon3.position.y);
        [leftLayer addChild:itext2 z:1];
        
        CCSprite* gicon4 = [CCSprite spriteWithSpriteFrameName:@"gold.png"];
        gicon4.scale = 0.4;
        gicon4.position = ccp(itext2.position.x + 35, itext2.position.y);
        [leftLayer addChild:gicon4 z:1];
        
        //iron to wood
        CCSprite* iicon4 = [CCSprite spriteWithSpriteFrameName:@"iron.png"];
        iicon4.scale = 0.4;
        iicon4.position = ccp(iicon3.position.x, iicon3.position.y - 20);
        [leftLayer addChild:iicon4 z:1];
        
        CCLabelTTF* itext3 = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d",iron_wood_rate] fontName:@"Arial" fontSize:10];
        itext3.position = ccp(iicon4.position.x - 18, iicon4.position.y);
        [leftLayer addChild:itext3 z:1];
        
        CCLabelTTF* itext4 = [CCLabelTTF labelWithString:@"-->  1" fontName:@"Arial" fontSize:10];
        itext4.anchorPoint = ccp(0, 0.5);
        itext4.position = ccp(iicon4.position.x + 10, iicon4.position.y);
        [leftLayer addChild:itext4 z:1];
        
        CCSprite* wicon4 = [CCSprite spriteWithSpriteFrameName:@"wood.png"];
        wicon4.scale = 0.4;
        wicon4.position = ccp(itext4.position.x + 35, itext4.position.y);
        [leftLayer addChild:wicon4 z:1];
        
        //show touch drag able  3 sprite
        CCSprite* goldbg = [CCSprite spriteWithSpriteFrameName:@"hero_bg.png"];
        goldbg.position = ccp(title.position.x - 80, title.position.y - 100);
        [leftLayer addChild:goldbg z:1];
        
        goldtouch = [ResourceDragTouchSprite spriteWithSpriteFrameName:@"gold.png"];
        goldtouch.position = goldbg.position;
        [leftLayer addChild:goldtouch z:2];
        [goldtouch initTheCallbackFunc0:@selector(checkReceiveSprite:) withCaller:self withTouchID:1 withImg:@"gold.png" canDrag:YES];
        NSString* ggtext = [NSString stringWithFormat:@"%d",[ShareGameManager shareGameManager].gold];
        goldLabel = [CCLabelTTF labelWithString:ggtext fontName:@"Arial" fontSize:12];
        goldLabel.position = ccp(goldtouch.position.x, goldtouch.position.y - 30);
        goldLabel.color = ccGREEN;
        [leftLayer addChild:goldLabel z:1];
        
        CCSprite* woodbg = [CCSprite spriteWithSpriteFrameName:@"hero_bg.png"];
        woodbg.position = ccp(title.position.x, title.position.y - 100);
        [leftLayer addChild:woodbg z:1];
        
        woodtouch = [ResourceDragTouchSprite spriteWithSpriteFrameName:@"wood.png"];
        woodtouch.position = woodbg.position;
        [leftLayer addChild:woodtouch z:2];
        [woodtouch initTheCallbackFunc0:@selector(checkReceiveSprite:) withCaller:self withTouchID:2 withImg:@"wood.png" canDrag:YES];
        NSString* wwtext = [NSString stringWithFormat:@"%d",[ShareGameManager shareGameManager].wood];
        woodLabel = [CCLabelTTF labelWithString:wwtext fontName:@"Arial" fontSize:12];
        woodLabel.position = ccp(woodtouch.position.x, woodtouch.position.y - 30);
        woodLabel.color = ccGREEN;
        [leftLayer addChild:woodLabel z:1];
        
        
        CCSprite* ironbg = [CCSprite spriteWithSpriteFrameName:@"hero_bg.png"];
        ironbg.position = ccp(title.position.x + 80, title.position.y - 100);
        [leftLayer addChild:ironbg z:1];
        
        irontouch = [ResourceDragTouchSprite spriteWithSpriteFrameName:@"iron.png"];
        irontouch.position = ironbg.position;
        [leftLayer addChild:irontouch z:2];
        [irontouch initTheCallbackFunc0:@selector(checkReceiveSprite:) withCaller:self withTouchID:3 withImg:@"iron.png" canDrag:YES];
        NSString* iitext = [NSString stringWithFormat:@"%d",[ShareGameManager shareGameManager].iron];
        ironLabel = [CCLabelTTF labelWithString:iitext fontName:@"Arial" fontSize:12];
        ironLabel.position = ccp(irontouch.position.x, irontouch.position.y - 30);
        ironLabel.color = ccGREEN;
        [leftLayer addChild:ironLabel z:1];
        
        
        
        //show receive 3 sprite
        CCSprite* goldbg1 = [CCSprite spriteWithSpriteFrameName:@"hero_bg1.png"];
        goldbg1.position = ccp(goldbg.position.x, goldbg.position.y - 70);
        [leftLayer addChild:goldbg1 z:1];
        ResourceReceiveDropSprite* goldrecv = [ResourceReceiveDropSprite spriteWithSpriteFrameName:@"gold.png"];
        goldrecv.position = goldbg1.position;
        goldrecv.resID = 1;
        [leftLayer addChild:goldrecv z:2];
        [receivers addObject:goldrecv];
        
        CCSprite* woodbg1 = [CCSprite spriteWithSpriteFrameName:@"hero_bg1.png"];
        woodbg1.position = ccp(woodbg.position.x, woodbg.position.y - 70);
        [leftLayer addChild:woodbg1 z:1];
        ResourceReceiveDropSprite* woodrecv = [ResourceReceiveDropSprite spriteWithSpriteFrameName:@"wood.png"];
        woodrecv.position = woodbg1.position;
        woodrecv.resID = 2;
        [leftLayer addChild:woodrecv z:2];
        [receivers addObject:woodrecv];
        
        CCSprite* ironbg1 = [CCSprite spriteWithSpriteFrameName:@"hero_bg1.png"];
        ironbg1.position = ccp(ironbg.position.x, ironbg.position.y - 70);
        [leftLayer addChild:ironbg1 z:1];
        ResourceReceiveDropSprite* ironrecv = [ResourceReceiveDropSprite spriteWithSpriteFrameName:@"iron.png"];
        ironrecv.position = ironbg1.position;
        ironrecv.resID = 3;
        [leftLayer addChild:ironrecv z:2];
        [receivers addObject:ironrecv];
        
        
        
    }
    return self;
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
        CCLOG(@"touch on trade left layer....");
        layerDragState = LeftLayerDrag;
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

- (void) ccTouchMoved:(UITouch*)touch withEvent:(UIEvent *)event
{
    //nothing
}

- (void) ccTouchEnded:(UITouch*)touch withEvent:(UIEvent *)event
{

    //set all tag == 0
    //set drag image == nil
    
    layerDragState = LayerNoDrag;
    if (needClosePayment == 1) {
        //close the payment .................
        [self closePaymentDialog];
        currentResForInType = 0;
        currentResForOutType = 0;
        currentResInCount = 0;
        currentResOutCount = 0;
        needClosePayment = 0;
        maxResInCount = 0;
        
    }
    
    
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
    [super dealloc];
}

-(void) checkReceiveSprite:(ResourceDragSprite *)_drag
{
    CGPoint mpos = _drag.position;
    CGPoint mpos1 = [leftLayer convertToNodeSpace:mpos];
    for (ResourceReceiveDropSprite* item in receivers) {
        if (CGRectContainsPoint(item.boundingBox, mpos1)) {
            CCLOG(@"resource in id:%d, resource out id:%d",_drag.resID,item.resID);
            //get the market level
            CityInfoObject* cio = [[ShareGameManager shareGameManager] getCityInfoForCityScene:_cityID];
            int marketLevel = cio.market;
            if (_drag.resID != item.resID) {
                //show payment dialog
                currentResForInType = item.resID;
                currentResForOutType = _drag.resID;
                
                int maxResOut;
                if ((_drag.resID == 1)&&(item.resID==2)) {
                    currentRate = goldToWoodRate[marketLevel];
                    maxResOut = [ShareGameManager shareGameManager].gold;
                    maxResInCount = maxResOut / currentRate;
                    
                }
                else if ((_drag.resID ==1)&&(item.resID==3)) {
                    currentRate = goldToIronRate[marketLevel];
                    maxResOut = [ShareGameManager shareGameManager].gold;
                    maxResInCount = maxResOut / currentRate;
                }
                else if ((_drag.resID ==2)&&(item.resID==1)) {
                    currentRate = woodToGoldRate[marketLevel];
                    maxResOut = [ShareGameManager shareGameManager].wood;
                    maxResInCount = maxResOut / currentRate;
                }
                else if ((_drag.resID ==2)&&(item.resID==3)) {
                    currentRate = woodToIronRate[marketLevel];
                    maxResOut = [ShareGameManager shareGameManager].wood;
                    maxResInCount = maxResOut / currentRate;
                }
                else if ((_drag.resID ==3)&&(item.resID ==1)) {
                    currentRate = ironToGoldRate[marketLevel];
                    maxResOut = [ShareGameManager shareGameManager].iron;
                    maxResInCount = maxResOut / currentRate;
                }
                else if ((_drag.resID ==3)&&(item.resID ==2)) {
                    currentRate = ironToWoodRate[marketLevel];
                    maxResOut = [ShareGameManager shareGameManager].iron;
                    maxResInCount = maxResOut / currentRate;
                }
                
                //show the payment dialog, with a bg, title, 2 resource icon, a tip arrow.  a slider control. 2 label show resInCount, resOutCount
                //and a button to pay
                showPaymentDialog = 1;
                
                //disable the touch drag sprite
                goldtouch.candrag = NO;
                woodtouch.candrag = NO;
                irontouch.candrag = NO;
                
                paymentLayer = [[CCNode alloc] init];
                [self addChild:paymentLayer z:2];
                
                CCSprite* mbg = [CCSprite spriteWithSpriteFrameName:@"unitrangebg.png"];
                CGSize wsize = [[CCDirector sharedDirector] winSize];
                mbg.position = ccp(wsize.width*0.5, wsize.height*0.5);
                [paymentLayer addChild:mbg z:0];
                
                NSString* resOutFile;
                switch (currentResForOutType) {
                    case 1:
                        resOutFile = @"gold.png";
                        break;
                    case 2:
                        resOutFile = @"wood.png";
                        break;
                    case 3:
                        resOutFile = @"iron.png";
                        break;
                    default:
                        resOutFile = @"gold.png";
                        break;
                }
                NSString* resInFile;
                switch (currentResForInType) {
                    case 1:
                        resInFile = @"gold.png";
                        break;
                    case 2:
                        resInFile = @"wood.png";
                        break;
                    case 3:
                        resInFile = @"iron.png";
                        break;
                    default:
                        resInFile = @"gold.png";
                        break;
                }
                
                CCSprite* res1bg = [CCSprite spriteWithSpriteFrameName:@"hero_bg1.png"];
                res1bg.position = ccp(wsize.width*0.5 - 50, wsize.height*0.5 + 40);
                [paymentLayer addChild:res1bg z:1];
                CCSprite* res1 = [CCSprite spriteWithSpriteFrameName:resOutFile];
                res1.position = res1bg.position;
                [paymentLayer addChild:res1 z:2];
                
                CCSprite* res2bg = [CCSprite spriteWithSpriteFrameName:@"hero_bg1.png"];
                res2bg.position = ccp(wsize.width*0.5 + 50, wsize.height*0.5 + 40);
                [paymentLayer addChild:res2bg z:1];
                CCSprite* res2 = [CCSprite spriteWithSpriteFrameName:resInFile];
                res2.position = res2bg.position;
                [paymentLayer addChild:res2 z:2];
                
                resourceInLabel = [CCLabelTTF labelWithString:@"0" fontName:@"Arial" fontSize:12];
                resourceInLabel.anchorPoint = ccp(0, 0.5);
                resourceInLabel.color = ccGREEN;
                resourceInLabel.position = ccp(res2.position.x + 30, res2.position.y);
                [paymentLayer addChild:resourceInLabel z:1];
                
                //arrow
                CCSprite* arrow = [CCSprite spriteWithSpriteFrameName:@"tiparrow.png"];
                arrow.position = ccp(wsize.width*0.5, res1bg.position.y);
                [paymentLayer addChild:arrow z:1];
                
                //slider
                CCSprite* sliderbg = [CCSprite spriteWithSpriteFrameName:@"slider_back1.png"];
                CCSprite* sliderbar = [CCSprite spriteWithSpriteFrameName:@"slider_bar1.png"];
                CCSprite* slider = [CCSprite spriteWithSpriteFrameName:@"slider.png"];
                CCControlSlider* cs = [CCControlSlider sliderWithBackgroundSprite:sliderbg progressSprite:sliderbar thumbSprite:slider];
                cs.position = ccp(mbg.position.x,mbg.position.y -10);
                [paymentLayer addChild:cs z:1];
                cs.minimumValue = 0;
                cs.maximumValue = maxResInCount;
                [cs addTarget:self action:@selector(sliderChanged:) forControlEvents:CCControlEventValueChanged];
                
                //label
                CCSprite* resout = [CCSprite spriteWithSpriteFrameName:resOutFile];
                resout.scale = 0.5;
                resout.position = ccp(cs.position.x + 35, cs.position.y - 45);
                [paymentLayer addChild:resout z:1];
                
                resourceOutLabel = [CCLabelTTF labelWithString:@"0" fontName:@"Arial" fontSize:10];
                resourceOutLabel.anchorPoint = ccp(0, 0.5);
                resourceOutLabel.position = ccp(resout.position.x + 12, resout.position.y);
                [paymentLayer addChild:resourceOutLabel z:1];
                
                //button
                TouchableSprite* okbtn = [TouchableSprite spriteWithSpriteFrameName:@"buildtradebtn.png"];
                okbtn.position = ccp(cs.position.x + 120, cs.position.y - 45);
                [paymentLayer addChild:okbtn z:1];
                [okbtn initTheCallbackFunc:@selector(tradeResource) withCaller:self withTouchID:-1];
                
                
                
            }
            else {
                //do nothing , because no need to exchange same resource
            }
            
            
            break;
        }
    }
    
}

-(void) closePaymentDialog
{
    showPaymentDialog = 0;
    currentResForInType = 0;
    currentResForOutType = 0;
    currentResInCount = 0;
    currentResOutCount = 0;
    maxResInCount = 0;
    
    CCLOG(@"close payment layer");
    if (paymentLayer) {
        [self removeChild:paymentLayer cleanup:YES];
    }
    paymentLayer = nil;
    resourceInLabel = nil;
    resourceOutLabel = nil;
    
    goldtouch.candrag = YES;
    woodtouch.candrag = YES;
    irontouch.candrag = YES;
    
    //update the label
    [goldLabel setString:[NSString stringWithFormat:@"%d",[ShareGameManager shareGameManager].gold]];
    [woodLabel setString:[NSString stringWithFormat:@"%d",[ShareGameManager shareGameManager].wood]];
    [ironLabel setString:[NSString stringWithFormat:@"%d",[ShareGameManager shareGameManager].iron]];
    
}

-(void) tradeResource
{
    [[SimpleAudioEngine sharedEngine] playEffect:@"sthget.caf"];
    
    if (currentResForInType==1) {
        //add gold
        [ShareGameManager shareGameManager].gold += currentResInCount ;
    }
    else if (currentResForInType==2) {
        //add wood
        [ShareGameManager shareGameManager].wood += currentResInCount ;
    }
    else {
        //add iron
        [ShareGameManager shareGameManager].iron += currentResInCount ;
    }
    
    if (currentResForOutType==1) {
        //decrease gold
        [ShareGameManager shareGameManager].gold -= currentResOutCount ;
    }
    else if (currentResForOutType==2) {
        //decrease wood
        [ShareGameManager shareGameManager].wood -= currentResOutCount ;
    }
    else {
        //decrease iron
        [ShareGameManager shareGameManager].iron -= currentResOutCount ;
    }
    
    //resource up effect
    CGPoint startP = ccp(resourceOutLabel.position.x + 70, resourceOutLabel.position.y);
    
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
    
    NSString* resOutFile;
    switch (currentResForOutType) {
        case 1:
            resOutFile = @"gold.png";
            break;
        case 2:
            resOutFile = @"wood.png";
            break;
        case 3:
            resOutFile = @"iron.png";
            break;
        default:
            resOutFile = @"gold.png";
            break;
    }
    CCSprite* gold = [CCSprite spriteWithSpriteFrameName:resOutFile];
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
    
    CCLabelTTF* goldmvtxt = [CCLabelTTF labelWithString:resourceOutLabel.string fontName:@"Arial" fontSize:10];
    goldmvtxt.position = ccp(startP.x, startP.y);
    [self addChild:goldmvtxt z:3];
    CCMoveBy *mv1 = [CCMoveBy actionWithDuration:1.2f position:ccp(0,60)];
    CCFadeOut *fo1 = [CCFadeOut actionWithDuration:1.5f];
    CCSpawn *sp1 = [CCSpawn actions:mv1,fo1, nil];
    CCCallBlockN *cb1 = [CCCallBlockN actionWithBlock:^(CCNode *node) {
        [node removeFromParentAndCleanup:YES];
    }];
    CCSequence *se1 = [CCSequence actions:sp1,cb1, nil];
    [goldmvtxt runAction:se1];
    
    [self closePaymentDialog];
    
    //main layer update hud label
    //update the main layer label
    //main update ui text
    CCScene* run = [[CCDirector sharedDirector] runningScene];
    CCLayer* main = (CCLayer*) [run getChildByTag:1];
    if (main) {
        [main performSelector:@selector(updateResourceLabel)];
    }
    
    
}


-(void) sliderChanged:(CCControlSlider*)sender
{
    int va = (int)sender.value;
    CCLOG(@"slider value is :%d",(int)(sender.value));
    if (resourceInLabel) {
        [resourceInLabel setString:[NSString stringWithFormat:@"%d",va]];
    }
    if (resourceOutLabel) {
        //get the exchange rate , multi the va.
        int va2 = va * currentRate;
        // set the value to va2
        [resourceOutLabel setString:[NSString stringWithFormat:@"%d",va2]];
    }
    
    currentResInCount = va;  //想买入的资源数量
    currentResOutCount = va * currentRate;

}


@end
