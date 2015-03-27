//
//  SelectKingLayer.m
//  zhulusanguo
//
//  Created by qing on 15/3/24.
//  Copyright 2015年 qing lai. All rights reserved.
//

#import "SelectKingLayer.h"
#import "MapScene.h"


@implementation SelectKingLayer

+(CCScene *) scene
{
 
    CCScene *scene = [CCScene node];
    
    CCLayerColor* bglayer = [[[CCLayerColor  alloc] initWithColor:ccc4(50, 50, 50, 255)] autorelease];
    [scene addChild:bglayer z:-1];
    
    SelectKingLayer *layer = [SelectKingLayer node]; //[[[IntroLayer alloc] initWithColor:ccc4(50, 50, 50, 255)] autorelease];
    layer.tag = 1;
    
    [scene addChild: layer z:1];
    
    return scene;
}


-(id) init
{
    if ((self = [super init])) {
        
        selectFlag = nil;
        
        //select from db, show the icon on the mini map
        CGSize wsize = [[CCDirector sharedDirector] winSize];
        //add title
        CCSprite* title = [CCSprite spriteWithSpriteFrameName:@"selectplayer.png"];
        title.position = ccp(wsize.width*0.5, wsize.height*0.9);
        [self addChild:title z:0];
        
        //add back ground
        CCSprite* minimap = [CCSprite spriteWithSpriteFrameName:@"minimap.png"];
        minimap.position = ccp(wsize.width*0.5, wsize.height*0.5);
        [self addChild:minimap z:0];
        
        //add 12 hero touchable icon on the mini map
        //{235,180}
        TouchableSprite* hero0 = [TouchableSprite spriteWithSpriteFrameName:@"selecthero0.png"];
        hero0.position = ccp(wsize.width*0.5-48, wsize.height*0.5+21);
        [self addChild:hero0 z:1];
        [hero0 initTheCallbackFunc:@selector(touchHeroIcon:) withCaller:self withTouchID:0];
        heropos[0] = hero0.position;
        
        TouchableSprite* hero1 = [TouchableSprite spriteWithSpriteFrameName:@"selecthero1.png"];
        hero1.position = ccp(wsize.width*0.5 - 137, wsize.height*0.5 +50);
        [self addChild:hero1 z:1];
        [hero1 initTheCallbackFunc:@selector(touchHeroIcon:) withCaller:self withTouchID:1];
        heropos[1] = hero1.position;
        
        TouchableSprite* hero2 = [TouchableSprite spriteWithSpriteFrameName:@"selecthero2.png"];
        hero2.position = ccp(wsize.width*0.5- 125, wsize.height*0.5 -28);
        [self addChild:hero2 z:1];
        [hero2 initTheCallbackFunc:@selector(touchHeroIcon:) withCaller:self withTouchID:2];
        heropos[2] = hero2.position;
        
        TouchableSprite* hero3 = [TouchableSprite spriteWithSpriteFrameName:@"selecthero3.png"];
        hero3.position = ccp(wsize.width*0.5-48, wsize.height*0.5 -24);
        [self addChild:hero3 z:1];
        [hero3 initTheCallbackFunc:@selector(touchHeroIcon:) withCaller:self withTouchID:3];
        heropos[3] = hero3.position;
        
        TouchableSprite* hero4 = [TouchableSprite spriteWithSpriteFrameName:@"selecthero4.png"];
        hero4.position = ccp(wsize.width*0.5 +27, wsize.height*0.5 -48);
        [self addChild:hero4 z:1];
        [hero4 initTheCallbackFunc:@selector(touchHeroIcon:) withCaller:self withTouchID:4];
        heropos[4] = hero4.position;
        
        TouchableSprite* hero5 = [TouchableSprite spriteWithSpriteFrameName:@"selecthero5.png"];
        hero5.position = ccp(wsize.width*0.5 +32, wsize.height*0.5 +18);
        [self addChild:hero5 z:1];
        [hero5 initTheCallbackFunc:@selector(touchHeroIcon:) withCaller:self withTouchID:5];
        heropos[5] = hero5.position;
        
        TouchableSprite* hero6 = [TouchableSprite spriteWithSpriteFrameName:@"selecthero6.png"];
        hero6.position = ccp(wsize.width*0.5+ 140, wsize.height*0.5 -5);
        [self addChild:hero6 z:1];
        [hero6 initTheCallbackFunc:@selector(touchHeroIcon:) withCaller:self withTouchID:6];
        heropos[6] = hero6.position;
        
        TouchableSprite* hero7 = [TouchableSprite spriteWithSpriteFrameName:@"selecthero7.png"];
        hero7.position = ccp(wsize.width*0.5 +155,wsize.height*0.5 +42);
        [self addChild:hero7 z:1];
        [hero7 initTheCallbackFunc:@selector(touchHeroIcon:) withCaller:self withTouchID:7];
        heropos[7] = hero7.position;
        
        TouchableSprite* hero8 = [TouchableSprite spriteWithSpriteFrameName:@"selecthero8.png"];
        hero8.position = ccp(wsize.width*0.5 +80, wsize.height*0.5 -15);
        [self addChild:hero8 z:1];
        [hero8 initTheCallbackFunc:@selector(touchHeroIcon:) withCaller:self withTouchID:8];
        heropos[8] = hero8.position;
        
        TouchableSprite* hero9 = [TouchableSprite spriteWithSpriteFrameName:@"selecthero9.png"];
        hero9.position = ccp(wsize.width*0.5+32, wsize.height*0.5 +70);
        [self addChild:hero9 z:1];
        [hero9 initTheCallbackFunc:@selector(touchHeroIcon:) withCaller:self withTouchID:9];
        heropos[9] = hero9.position;
        
        TouchableSprite* hero10 = [TouchableSprite spriteWithSpriteFrameName:@"selecthero10.png"];
        hero10.position = ccp(wsize.width*0.5+ 78, wsize.height*0.5+45);
        [self addChild:hero10 z:1];
        [hero10 initTheCallbackFunc:@selector(touchHeroIcon:) withCaller:self withTouchID:10];
        heropos[10] = hero10.position;
        
        TouchableSprite* hero11 = [TouchableSprite spriteWithSpriteFrameName:@"selecthero11.png"];
        hero11.position = ccp(wsize.width*0.5+115, wsize.height*0.5+ 70);
        [self addChild:hero11 z:1];
        [hero11 initTheCallbackFunc:@selector(touchHeroIcon:) withCaller:self withTouchID:11];
        heropos[11] = hero11.position;
        
        //add easy , normal , hard , nightmare text and checkbox on the screen
        CCLabelTTF* easy = [CCLabelTTF labelWithString:@"容易" fontName:@"Arial" fontSize:15];
        easy.position = ccp(wsize.width*0.25, wsize.height*0.12);
        [self addChild:easy z:1];
        
        TouchableSprite* checkbox1 = [TouchableSprite spriteWithSpriteFrameName:@"checkbox.png"];
        checkbox1.position = ccp(wsize.width*0.2, wsize.height*0.12);
        [self addChild:checkbox1 z:1];
        checkboxPos[0] = checkbox1.position;
        [checkbox1 initTheCallbackFunc:@selector(touchCheckbox:) withCaller:self withTouchID:0];
        
        CCLabelTTF* normal = [CCLabelTTF labelWithString:@"普通" fontName:@"Arial" fontSize:15];
        normal.position = ccp(wsize.width*0.42, wsize.height*0.12);
        [self addChild:normal z:1];
        
        TouchableSprite* checkbox2 = [TouchableSprite spriteWithSpriteFrameName:@"checkbox.png"];
        checkbox2.position = ccp(wsize.width*0.37, wsize.height*0.12);
        [self addChild:checkbox2 z:1];
        checkboxPos[1] = checkbox2.position;
        [checkbox2 initTheCallbackFunc:@selector(touchCheckbox:) withCaller:self withTouchID:1];
        
        CCLabelTTF* hard = [CCLabelTTF labelWithString:@"困难" fontName:@"Arial" fontSize:15];
        hard.position = ccp(wsize.width*0.58, wsize.height*0.12);
        [self addChild:hard z:1];
        
        TouchableSprite* checkbox3 = [TouchableSprite spriteWithSpriteFrameName:@"checkbox.png"];
        checkbox3.position = ccp(wsize.width*0.53, wsize.height*0.12);
        [self addChild:checkbox3 z:1];
        checkboxPos[2] = checkbox3.position;
        [checkbox3 initTheCallbackFunc:@selector(touchCheckbox:) withCaller:self withTouchID:2];
        
        CCLabelTTF* nightmare = [CCLabelTTF labelWithString:@"梦魇" fontName:@"Arial" fontSize:15];
        nightmare.position = ccp(wsize.width*0.75, wsize.height*0.12);
        [self addChild:nightmare z:1];
        
        TouchableSprite* checkbox4 = [TouchableSprite spriteWithSpriteFrameName:@"checkbox.png"];
        checkbox4.position = ccp(wsize.width*0.7, wsize.height*0.12);
        [self addChild:checkbox4 z:1];
        checkboxPos[3] = checkbox4.position;
        [checkbox4 initTheCallbackFunc:@selector(touchCheckbox:) withCaller:self withTouchID:3];
        
        
        tick = [CCSprite spriteWithSpriteFrameName:@"check.png"];
        tick.position = checkboxPos[0];
        [self addChild:tick z:2];
        
        //set the game difficulty to 1
        [ShareGameManager shareGameManager].gameDifficulty = 1;
        
        //add go to next button
        TouchableSprite* next = [TouchableSprite spriteWithSpriteFrameName:@"citybtn.png"];
        next.position = ccp(wsize.width - next.boundingBox.size.width*0.6, next.boundingBox.size.height*0.6);
        [self addChild:next z:1];
        [next initTheCallbackFunc:@selector(gotoNextScene) withCaller:self withTouchID:-1];
        
        CCLabelTTF* ntext = [CCLabelTTF labelWithString:@"继续" fontName:@"Arial" fontSize:12];
        ntext.position = next.position;
        [self addChild:ntext z:2];
        
        
        
    }
    return self;
}

-(void) touchHeroIcon:(NSNumber*)heroID
{
    CCLOG(@"toch at hero:%d",(int)[heroID integerValue]);
    [[SimpleAudioEngine sharedEngine] playEffect:@"menu.caf"];
    int hid = (int)[heroID integerValue];
    
    if (selectFlag==nil) {
        selectFlag = [CCSprite spriteWithSpriteFrameName:@"selected.png"];
        selectFlag.anchorPoint = ccp(0.5, 0);
        selectFlag.position = ccp( heropos[hid].x, heropos[hid].y-5);
        [self addChild:selectFlag z:3];
    }
    else {
        selectFlag.position = ccp( heropos[hid].x, heropos[hid].y-5);
    }
    [ShareGameManager shareGameManager].kingID = hid;

}

-(void) touchCheckbox:(NSNumber*)chID
{
    [[SimpleAudioEngine sharedEngine] playEffect:@"menu.caf"];
    int cid = (int)[chID integerValue];
    tick.position = checkboxPos[cid];
    
    [ShareGameManager shareGameManager].gameDifficulty = cid+1;
    
}


-(void) gotoNextScene
{
    CCLOG(@"goto next.....");
    [[SimpleAudioEngine sharedEngine] playEffect:@"menu.caf"];
    //if heroID = -1 , show alert
    int hid = [ShareGameManager shareGameManager].kingID;
    if (hid == -1) {
        //not select the hero
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"无法开始"
                                  message:@"你还没有选择一位君主，请先选择好君主再继续！"
                                  delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
        [alertView show];
    }
    else {
        [[ShareGameManager shareGameManager] initNewGameDBWithKingID:hid];
        [[ShareGameManager shareGameManager] initDefaultAllAnimationInScene];
        
        [[CCDirector sharedDirector] replaceScene:[MapScene node]];
        
        
    }
    
}

-(void) gotoBackScene
{
    
}

@end
