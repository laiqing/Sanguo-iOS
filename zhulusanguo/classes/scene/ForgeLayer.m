//
//  ForgeLayer.m
//  zhulusanguo
//
//  Created by qing on 15/4/10.
//  Copyright 2015年 qing lai. All rights reserved.
//

#import "ForgeLayer.h"


@implementation ForgeLayer

+ (id) contentRect1:(CGRect)left contentRect2:(CGRect)right withCityID:(int)tcid
{
    return [[[self alloc] initcontentRect1:left contentRect2:right withCityID:tcid] autorelease];
}


- (id) initcontentRect1:(CGRect)left contentRect2:(CGRect)right withCityID:(int)tcid
{
    if ((self=[super init])) {

        needClose = 0;
        
        _cityID = tcid;
        leftContent = left;
        rightContent = right;
        
        leftLayer = [[[CCNode alloc] init] autorelease];
        
        
        [self addChild:leftLayer z:1];
        
        minTopLeftY = leftLayer.position.y;
        
        //now add item bg , hero select bg to the layer children
        CCSprite* itembg = [CCSprite spriteWithSpriteFrameName:@"forgebg.png"];
        CGSize wsize = [[CCDirector sharedDirector] winSize];
        itembg.position = ccp(wsize.width*0.5, wsize.height*0.5);
        [self addChild:itembg z:0];
        
        int de = _cityID % 14;
        NSString* destr = articleForCitys[de];
        NSArray* dearr = [destr componentsSeparatedByString:@","] ;
        int de1 = [(NSString*)(dearr[0]) intValue];
        int de2 = [(NSString*)(dearr[1]) intValue];
        int de3 = [(NSString*)(dearr[2]) intValue];
        int de4 = [(NSString*)(dearr[3]) intValue];
        int de5 = [(NSString*)(dearr[4]) intValue];
        
        //add 12 item pic, name label, desc label, buy button.
        
        int randomid = _cityID%3 + 1;
        
        NSString* articlefile1 = [NSString stringWithFormat:@"article%d.png",randomid];
        //add item 1
        CCSprite *item1 = [CCSprite spriteWithSpriteFrameName:articlefile1];
        item1.anchorPoint = ccp(0, 0.5);
        item1.position = ccp(wsize.width*0.5 - itembg.boundingBox.size.width*0.5 + 20, wsize.height*0.5 + itembg.boundingBox.size.height*0.5 - item1.boundingBox.size.height*0.5 - 30);
        [leftLayer addChild:item1 z:0];
        
        ArticleObject* ao1 = [[ShareGameManager shareGameManager] getArticleDetailFromID:randomid];
        //cname , cdesc
        CCLabelTTF* namelabel1 = [CCLabelTTF labelWithString:ao1.cname fontName:@"Arial" fontSize:12];
        namelabel1.anchorPoint = ccp(0, 0.5);
        namelabel1.position = ccp(item1.position.x + 45, item1.position.y + 8);
        //namelabel1.color = ccGREEN;
        [leftLayer addChild:namelabel1 z:2];
        
        CCLabelTTF* desclabel1 = [CCLabelTTF labelWithString:ao1.cdesc fontName:@"Arial" fontSize:10];
        desclabel1.anchorPoint = ccp(0, 0.5);
        desclabel1.position = ccp(item1.position.x + 45, item1.position.y - 8);
        [leftLayer addChild:desclabel1 z:2];
        
        //buy button , cost resource text
        TouchableBuySprite* tb1 = [TouchableBuySprite spriteWithSpriteFrameName:@"buildbuybtn.png"];
        tb1.position = ccp(item1.position.x + 20, item1.position.y - 35);
        [leftLayer addChild:tb1 z:2];
        [tb1 initTheCallbackFunc:@selector(buyArticleWithItem:withPosID:) withCaller:self withTouchID:randomid withPosID:0];
        stPosi[0] = tb1.position;
        
        CCSprite* gold1 = [CCSprite spriteWithSpriteFrameName:@"gold.png"];
        gold1.scale = 0.3;
        gold1.anchorPoint = ccp(0, 0.5);
        gold1.position = ccp(tb1.position.x + 30, tb1.position.y + 10);
        [leftLayer addChild:gold1 z:1];
        
        CCLabelTTF* rgLabel1 = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d",ao1.gold] fontName:@"Arial" fontSize:9];
        rgLabel1.anchorPoint = ccp(0, 0.5);
        rgLabel1.position = ccp(gold1.position.x + 17, gold1.position.y);
        [leftLayer addChild:rgLabel1 z:1];
        
        CCSprite* wood1 = [CCSprite spriteWithSpriteFrameName:@"wood.png"];
        wood1.scale = 0.3;
        wood1.anchorPoint = ccp(0, 0.5);
        wood1.position = ccp(tb1.position.x+30, tb1.position.y);
        [leftLayer addChild:wood1 z:1];
        
        CCLabelTTF* rwLabel1 = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d",ao1.wood] fontName:@"Arial" fontSize:9];
        rwLabel1.anchorPoint = ccp(0, 0.5);
        rwLabel1.position = ccp(wood1.position.x + 17, wood1.position.y);
        [leftLayer addChild:rwLabel1 z:1];
        
        CCSprite* iron1 = [CCSprite spriteWithSpriteFrameName:@"iron.png"];
        iron1.scale = 0.3;
        iron1.anchorPoint = ccp(0, 0.5);
        iron1.position = ccp(tb1.position.x+30, tb1.position.y - 10);
        [leftLayer addChild:iron1 z:1];
        
        CCLabelTTF* riLabel1 = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d",ao1.iron] fontName:@"Arial" fontSize:9];
        riLabel1.anchorPoint = ccp(0, 0.5);
        riLabel1.position = ccp(iron1.position.x + 17, iron1.position.y);
        [leftLayer addChild:riLabel1 z:1];
        
        
        //add item 2
        NSString* articlefile2 = [NSString stringWithFormat:@"article%d.png",randomid+3];
        CCSprite *item2 = [CCSprite spriteWithSpriteFrameName:articlefile2];
        item2.anchorPoint = ccp(0, 0.5);
        item2.position = ccp(item1.position.x + 105, item1.position.y);
        [leftLayer addChild:item2 z:0];
        
        ArticleObject* ao2 = [[ShareGameManager shareGameManager] getArticleDetailFromID:randomid+3];
        //cname , cdesc
        CCLabelTTF* namelabel2 = [CCLabelTTF labelWithString:ao2.cname fontName:@"Arial" fontSize:12];
        namelabel2.anchorPoint = ccp(0, 0.5);
        namelabel2.position = ccp(item2.position.x + 45, item2.position.y + 8);
        //namelabel2.color = ccGREEN;
        [leftLayer addChild:namelabel2 z:2];
        
        CCLabelTTF* desclabel2 = [CCLabelTTF labelWithString:ao2.cdesc fontName:@"Arial" fontSize:10];
        desclabel2.anchorPoint = ccp(0, 0.5);
        desclabel2.position = ccp(item2.position.x + 45, item2.position.y - 8);
        [leftLayer addChild:desclabel2 z:2];
        
        //buy button , cost resource text
        TouchableBuySprite* tb2 = [TouchableBuySprite spriteWithSpriteFrameName:@"buildbuybtn.png"];
        tb2.position = ccp(item2.position.x + 20, item2.position.y - 35);
        [leftLayer addChild:tb2 z:2];
        [tb2 initTheCallbackFunc:@selector(buyArticleWithItem:withPosID:) withCaller:self withTouchID:randomid+3 withPosID:1];
        stPosi[1] = tb2.position;
        
        CCSprite* gold2 = [CCSprite spriteWithSpriteFrameName:@"gold.png"];
        gold2.scale = 0.3;
        gold2.anchorPoint = ccp(0, 0.5);
        gold2.position = ccp(tb2.position.x + 30, tb2.position.y + 10);
        [leftLayer addChild:gold2 z:1];
        
        CCLabelTTF* rgLabel2 = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d",ao2.gold] fontName:@"Arial" fontSize:9];
        rgLabel2.anchorPoint = ccp(0, 0.5);
        rgLabel2.position = ccp(gold2.position.x + 17, gold2.position.y);
        [leftLayer addChild:rgLabel2 z:1];
        
        CCSprite* wood2 = [CCSprite spriteWithSpriteFrameName:@"wood.png"];
        wood2.scale = 0.3;
        wood2.anchorPoint = ccp(0, 0.5);
        wood2.position = ccp(tb2.position.x+30, tb2.position.y);
        [leftLayer addChild:wood2 z:1];
        
        CCLabelTTF* rwLabel2 = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d",ao2.wood] fontName:@"Arial" fontSize:9];
        rwLabel2.anchorPoint = ccp(0, 0.5);
        rwLabel2.position = ccp(wood2.position.x + 17, wood2.position.y);
        [leftLayer addChild:rwLabel2 z:1];
        
        CCSprite* iron2 = [CCSprite spriteWithSpriteFrameName:@"iron.png"];
        iron2.scale = 0.3;
        iron2.anchorPoint = ccp(0, 0.5);
        iron2.position = ccp(tb2.position.x+30, tb2.position.y - 10);
        [leftLayer addChild:iron2 z:1];
        
        CCLabelTTF* riLabel2 = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d",ao2.iron] fontName:@"Arial" fontSize:9];
        riLabel2.anchorPoint = ccp(0, 0.5);
        riLabel2.position = ccp(iron2.position.x + 17, iron2.position.y);
        [leftLayer addChild:riLabel2 z:1];
        
        //add item 3
        NSString* articlefile3 = [NSString stringWithFormat:@"article%d.png",randomid+6];
        CCSprite *item3 = [CCSprite spriteWithSpriteFrameName:articlefile3];
        item3.anchorPoint = ccp(0, 0.5);
        item3.position = ccp(item2.position.x + 105, item2.position.y);
        [leftLayer addChild:item3 z:0];
        
        ArticleObject* ao3 = [[ShareGameManager shareGameManager] getArticleDetailFromID:randomid+6];
        //cname , cdesc
        CCLabelTTF* namelabel3 = [CCLabelTTF labelWithString:ao3.cname fontName:@"Arial" fontSize:12];
        namelabel3.anchorPoint = ccp(0, 0.5);
        //namelabel3.color = ccGREEN;
        namelabel3.position = ccp(item3.position.x + 45, item3.position.y + 8);
        [leftLayer addChild:namelabel3 z:2];
        
        CCLabelTTF* desclabel3 = [CCLabelTTF labelWithString:ao3.cdesc fontName:@"Arial" fontSize:10];
        desclabel3.anchorPoint = ccp(0, 0.5);
        desclabel3.position = ccp(item3.position.x + 45, item3.position.y - 8);
        [leftLayer addChild:desclabel3 z:2];
        
        //buy button , cost resource text
        TouchableBuySprite* tb3 = [TouchableBuySprite spriteWithSpriteFrameName:@"buildbuybtn.png"];
        tb3.position = ccp(item3.position.x + 20, item3.position.y - 35);
        [leftLayer addChild:tb3 z:2];
        [tb3 initTheCallbackFunc:@selector(buyArticleWithItem:withPosID:) withCaller:self withTouchID:randomid+6 withPosID:2];
        stPosi[2] = tb3.position;
        
        CCSprite* gold3 = [CCSprite spriteWithSpriteFrameName:@"gold.png"];
        gold3.scale = 0.3;
        gold3.anchorPoint = ccp(0, 0.5);
        gold3.position = ccp(tb3.position.x + 30, tb3.position.y + 10);
        [leftLayer addChild:gold3 z:1];
        
        CCLabelTTF* rgLabel3 = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d",ao3.gold] fontName:@"Arial" fontSize:9];
        rgLabel3.anchorPoint = ccp(0, 0.5);
        rgLabel3.position = ccp(gold3.position.x + 17, gold3.position.y);
        [leftLayer addChild:rgLabel3 z:1];
        
        CCSprite* wood3 = [CCSprite spriteWithSpriteFrameName:@"wood.png"];
        wood3.scale = 0.3;
        wood3.anchorPoint = ccp(0, 0.5);
        wood3.position = ccp(tb3.position.x+30, tb3.position.y);
        [leftLayer addChild:wood3 z:1];
        
        CCLabelTTF* rwLabel3 = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d",ao3.wood] fontName:@"Arial" fontSize:9];
        rwLabel3.anchorPoint = ccp(0, 0.5);
        rwLabel3.position = ccp(wood3.position.x + 17, wood3.position.y);
        [leftLayer addChild:rwLabel3 z:1];
        
        CCSprite* iron3 = [CCSprite spriteWithSpriteFrameName:@"iron.png"];
        iron3.scale = 0.3;
        iron3.anchorPoint = ccp(0, 0.5);
        iron3.position = ccp(tb3.position.x+30, tb3.position.y - 10);
        [leftLayer addChild:iron3 z:1];
        
        CCLabelTTF* riLabel3 = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d",ao3.iron] fontName:@"Arial" fontSize:9];
        riLabel3.anchorPoint = ccp(0, 0.5);
        riLabel3.position = ccp(iron3.position.x + 17, iron3.position.y);
        [leftLayer addChild:riLabel3 z:1];
        
        //add item 4
        NSString* articlefile4 = [NSString stringWithFormat:@"article%d.png",de1];
        CCSprite *item4 = [CCSprite spriteWithSpriteFrameName:articlefile4];
        item4.anchorPoint = ccp(0, 0.5);
        item4.position = ccp(item3.position.x + 105, item3.position.y);
        [leftLayer addChild:item4 z:0];
        
        ArticleObject* ao4 = [[ShareGameManager shareGameManager] getArticleDetailFromID:de1];
        //cname , cdesc
        CCLabelTTF* namelabel4 = [CCLabelTTF labelWithString:ao4.cname fontName:@"Arial" fontSize:12];
        namelabel4.anchorPoint = ccp(0, 0.5);
        namelabel4.color = ccGREEN;
        namelabel4.position = ccp(item4.position.x + 45, item4.position.y + 8);
        [leftLayer addChild:namelabel4 z:2];
        
        CCLabelTTF* desclabel4 = [CCLabelTTF labelWithString:ao4.cdesc fontName:@"Arial" fontSize:10];
        desclabel4.anchorPoint = ccp(0, 0.5);
        desclabel4.position = ccp(item4.position.x + 45, item4.position.y - 8);
        [leftLayer addChild:desclabel4 z:2];
        
        //buy button , cost resource text
        TouchableBuySprite* tb4 = [TouchableBuySprite spriteWithSpriteFrameName:@"buildbuybtn.png"];
        tb4.position = ccp(item4.position.x + 20, item4.position.y - 35);
        [leftLayer addChild:tb4 z:2];
        [tb4 initTheCallbackFunc:@selector(buyArticleWithItem:withPosID:) withCaller:self withTouchID:de1 withPosID:3];
        stPosi[3] = tb4.position;
        
        CCSprite* gold4 = [CCSprite spriteWithSpriteFrameName:@"gold.png"];
        gold4.scale = 0.3;
        gold4.anchorPoint = ccp(0, 0.5);
        gold4.position = ccp(tb4.position.x + 30, tb4.position.y + 10);
        [leftLayer addChild:gold4 z:1];
        
        CCLabelTTF* rgLabel4 = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d",ao4.gold] fontName:@"Arial" fontSize:9];
        rgLabel4.anchorPoint = ccp(0, 0.5);
        rgLabel4.position = ccp(gold4.position.x + 17, gold4.position.y);
        [leftLayer addChild:rgLabel4 z:1];
        
        CCSprite* wood4 = [CCSprite spriteWithSpriteFrameName:@"wood.png"];
        wood4.scale = 0.3;
        wood4.anchorPoint = ccp(0, 0.5);
        wood4.position = ccp(tb4.position.x+30, tb4.position.y);
        [leftLayer addChild:wood4 z:1];
        
        CCLabelTTF* rwLabel4 = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d",ao4.wood] fontName:@"Arial" fontSize:9];
        rwLabel4.anchorPoint = ccp(0, 0.5);
        rwLabel4.position = ccp(wood4.position.x + 17, wood4.position.y);
        [leftLayer addChild:rwLabel4 z:1];
        
        CCSprite* iron4 = [CCSprite spriteWithSpriteFrameName:@"iron.png"];
        iron4.scale = 0.3;
        iron4.anchorPoint = ccp(0, 0.5);
        iron4.position = ccp(tb4.position.x+30, tb4.position.y - 10);
        [leftLayer addChild:iron4 z:1];
        
        CCLabelTTF* riLabel4 = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d",ao4.iron] fontName:@"Arial" fontSize:9];
        riLabel4.anchorPoint = ccp(0, 0.5);
        riLabel4.position = ccp(iron4.position.x + 17, iron4.position.y);
        [leftLayer addChild:riLabel4 z:1];
        
        
        //add item 5,6,7,8
        
        //add item 5
        NSString* articlefile5 = [NSString stringWithFormat:@"article%d.png",de2];
        CCSprite *item5 = [CCSprite spriteWithSpriteFrameName:articlefile5];
        item5.anchorPoint = ccp(0, 0.5);
        item5.position = ccp(wsize.width*0.5 - itembg.boundingBox.size.width*0.5 + 20, wsize.height*0.5 - 30);
        [leftLayer addChild:item5 z:0];
        
        ArticleObject* ao5 = [[ShareGameManager shareGameManager] getArticleDetailFromID:de2];
        //cname , cdesc
        CCLabelTTF* namelabel5 = [CCLabelTTF labelWithString:ao5.cname fontName:@"Arial" fontSize:12];
        namelabel5.anchorPoint = ccp(0, 0.5);
        namelabel5.color = ccGREEN;
        namelabel5.position = ccp(item5.position.x + 45, item5.position.y + 8);
        [leftLayer addChild:namelabel5 z:2];
        
        CCLabelTTF* desclabel5 = [CCLabelTTF labelWithString:ao5.cdesc fontName:@"Arial" fontSize:10];
        desclabel5.anchorPoint = ccp(0, 0.5);
        desclabel5.position = ccp(item5.position.x + 45, item5.position.y - 8);
        [leftLayer addChild:desclabel5 z:2];
        
        //buy button , cost resource text
        TouchableBuySprite* tb5 = [TouchableBuySprite spriteWithSpriteFrameName:@"buildbuybtn.png"];
        tb5.position = ccp(item5.position.x + 20, item5.position.y - 35);
        [leftLayer addChild:tb5 z:2];
        [tb5 initTheCallbackFunc:@selector(buyArticleWithItem:withPosID:) withCaller:self withTouchID:de2 withPosID:4];
        stPosi[4] = tb5.position;
        
        CCSprite* gold5 = [CCSprite spriteWithSpriteFrameName:@"gold.png"];
        gold5.scale = 0.3;
        gold5.anchorPoint = ccp(0, 0.5);
        gold5.position = ccp(tb5.position.x + 30, tb5.position.y + 10);
        [leftLayer addChild:gold5 z:1];
        
        CCLabelTTF* rgLabel5 = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d",ao5.gold] fontName:@"Arial" fontSize:9];
        rgLabel5.anchorPoint = ccp(0, 0.5);
        rgLabel5.position = ccp(gold5.position.x + 17, gold5.position.y);
        [leftLayer addChild:rgLabel5 z:1];
        
        CCSprite* wood5 = [CCSprite spriteWithSpriteFrameName:@"wood.png"];
        wood5.scale = 0.3;
        wood5.anchorPoint = ccp(0, 0.5);
        wood5.position = ccp(tb5.position.x+30, tb5.position.y);
        [leftLayer addChild:wood5 z:1];
        
        CCLabelTTF* rwLabel5 = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d",ao5.wood] fontName:@"Arial" fontSize:9];
        rwLabel5.anchorPoint = ccp(0, 0.5);
        rwLabel5.position = ccp(wood5.position.x + 17, wood5.position.y);
        [leftLayer addChild:rwLabel5 z:1];
        
        CCSprite* iron5 = [CCSprite spriteWithSpriteFrameName:@"iron.png"];
        iron5.scale = 0.3;
        iron5.anchorPoint = ccp(0, 0.5);
        iron5.position = ccp(tb5.position.x+30, tb5.position.y - 10);
        [leftLayer addChild:iron5 z:1];
        
        CCLabelTTF* riLabel5 = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d",ao5.iron] fontName:@"Arial" fontSize:9];
        riLabel5.anchorPoint = ccp(0, 0.5);
        riLabel5.position = ccp(iron5.position.x + 17, iron5.position.y);
        [leftLayer addChild:riLabel5 z:1];
        
        
        //add item 6
        NSString* articlefile6 = [NSString stringWithFormat:@"article%d.png",de3];
        CCSprite *item6 = [CCSprite spriteWithSpriteFrameName:articlefile6];
        item6.anchorPoint = ccp(0, 0.5);
        item6.position = ccp(item5.position.x + 105, item5.position.y);
        [leftLayer addChild:item6 z:0];
        
        ArticleObject* ao6 = [[ShareGameManager shareGameManager] getArticleDetailFromID:de3];
        //cname , cdesc
        CCLabelTTF* namelabel6 = [CCLabelTTF labelWithString:ao6.cname fontName:@"Arial" fontSize:12];
        namelabel6.anchorPoint = ccp(0, 0.5);
        namelabel6.color = ccGREEN;
        namelabel6.position = ccp(item6.position.x + 45, item6.position.y + 8);
        [leftLayer addChild:namelabel6 z:2];
        
        CCLabelTTF* desclabel6 = [CCLabelTTF labelWithString:ao6.cdesc fontName:@"Arial" fontSize:10];
        desclabel6.anchorPoint = ccp(0, 0.5);
        desclabel6.position = ccp(item6.position.x + 45, item6.position.y - 8);
        [leftLayer addChild:desclabel6 z:2];
        
        //buy button , cost resource text
        TouchableBuySprite* tb6 = [TouchableBuySprite spriteWithSpriteFrameName:@"buildbuybtn.png"];
        tb6.position = ccp(item6.position.x + 20, item6.position.y - 35);
        [leftLayer addChild:tb6 z:2];
        [tb6 initTheCallbackFunc:@selector(buyArticleWithItem:withPosID:) withCaller:self withTouchID:de3 withPosID:5];
        stPosi[5] = tb6.position;
        
        CCSprite* gold6 = [CCSprite spriteWithSpriteFrameName:@"gold.png"];
        gold6.scale = 0.3;
        gold6.anchorPoint = ccp(0, 0.5);
        gold6.position = ccp(tb6.position.x + 30, tb6.position.y + 10);
        [leftLayer addChild:gold6 z:1];
        
        CCLabelTTF* rgLabel6 = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d",ao6.gold] fontName:@"Arial" fontSize:9];
        rgLabel6.anchorPoint = ccp(0, 0.5);
        rgLabel6.position = ccp(gold6.position.x + 17, gold6.position.y);
        [leftLayer addChild:rgLabel6 z:1];
        
        CCSprite* wood6 = [CCSprite spriteWithSpriteFrameName:@"wood.png"];
        wood6.scale = 0.3;
        wood6.anchorPoint = ccp(0, 0.5);
        wood6.position = ccp(tb6.position.x+30, tb6.position.y);
        [leftLayer addChild:wood6 z:1];
        
        CCLabelTTF* rwLabel6 = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d",ao6.wood] fontName:@"Arial" fontSize:9];
        rwLabel6.anchorPoint = ccp(0, 0.5);
        rwLabel6.position = ccp(wood6.position.x + 17, wood6.position.y);
        [leftLayer addChild:rwLabel6 z:1];
        
        CCSprite* iron6 = [CCSprite spriteWithSpriteFrameName:@"iron.png"];
        iron6.scale = 0.3;
        iron6.anchorPoint = ccp(0, 0.5);
        iron6.position = ccp(tb6.position.x+30, tb6.position.y - 10);
        [leftLayer addChild:iron6 z:1];
        
        CCLabelTTF* riLabel6 = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d",ao6.iron] fontName:@"Arial" fontSize:9];
        riLabel6.anchorPoint = ccp(0, 0.5);
        riLabel6.position = ccp(iron6.position.x + 17, iron6.position.y);
        [leftLayer addChild:riLabel6 z:1];
        
        //add item 7
        NSString* articlefile7 = [NSString stringWithFormat:@"article%d.png",de4];
        CCSprite *item7 = [CCSprite spriteWithSpriteFrameName:articlefile7];
        item7.anchorPoint = ccp(0, 0.5);
        item7.position = ccp(item6.position.x + 105, item6.position.y);
        [leftLayer addChild:item7 z:0];
        
        ArticleObject* ao7 = [[ShareGameManager shareGameManager] getArticleDetailFromID:de4];
        //cname , cdesc
        CCLabelTTF* namelabel7 = [CCLabelTTF labelWithString:ao7.cname fontName:@"Arial" fontSize:12];
        namelabel7.anchorPoint = ccp(0, 0.5);
        namelabel7.color = ccGREEN;
        namelabel7.position = ccp(item7.position.x + 45, item7.position.y + 8);
        [leftLayer addChild:namelabel7 z:2];
        
        CCLabelTTF* desclabel7 = [CCLabelTTF labelWithString:ao7.cdesc fontName:@"Arial" fontSize:10];
        desclabel7.anchorPoint = ccp(0, 0.5);
        desclabel7.position = ccp(item7.position.x + 45, item7.position.y - 8);
        [leftLayer addChild:desclabel7 z:2];
        
        //buy button , cost resource text
        TouchableBuySprite* tb7 = [TouchableBuySprite spriteWithSpriteFrameName:@"buildbuybtn.png"];
        tb7.position = ccp(item7.position.x + 20, item7.position.y - 35);
        [leftLayer addChild:tb7 z:2];
        [tb7 initTheCallbackFunc:@selector(buyArticleWithItem:withPosID:) withCaller:self withTouchID:de4 withPosID:6];
        stPosi[6] = tb7.position;
        
        CCSprite* gold7 = [CCSprite spriteWithSpriteFrameName:@"gold.png"];
        gold7.scale = 0.3;
        gold7.anchorPoint = ccp(0, 0.5);
        gold7.position = ccp(tb7.position.x + 30, tb7.position.y + 10);
        [leftLayer addChild:gold7 z:1];
        
        CCLabelTTF* rgLabel7 = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d",ao7.gold] fontName:@"Arial" fontSize:9];
        rgLabel7.anchorPoint = ccp(0, 0.5);
        rgLabel7.position = ccp(gold7.position.x + 17, gold7.position.y);
        [leftLayer addChild:rgLabel7 z:1];
        
        CCSprite* wood7 = [CCSprite spriteWithSpriteFrameName:@"wood.png"];
        wood7.scale = 0.3;
        wood7.anchorPoint = ccp(0, 0.5);
        wood7.position = ccp(tb7.position.x+30, tb7.position.y);
        [leftLayer addChild:wood7 z:1];
        
        CCLabelTTF* rwLabel7 = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d",ao7.wood] fontName:@"Arial" fontSize:9];
        rwLabel7.anchorPoint = ccp(0, 0.5);
        rwLabel7.position = ccp(wood7.position.x + 17, wood7.position.y);
        [leftLayer addChild:rwLabel7 z:1];
        
        CCSprite* iron7 = [CCSprite spriteWithSpriteFrameName:@"iron.png"];
        iron7.scale = 0.3;
        iron7.anchorPoint = ccp(0, 0.5);
        iron7.position = ccp(tb7.position.x+30, tb7.position.y - 10);
        [leftLayer addChild:iron7 z:1];
        
        CCLabelTTF* riLabel7 = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d",ao7.iron] fontName:@"Arial" fontSize:9];
        riLabel7.anchorPoint = ccp(0, 0.5);
        riLabel7.position = ccp(iron7.position.x + 17, iron7.position.y);
        [leftLayer addChild:riLabel7 z:1];
        
        //add item 8
        NSString* articlefile8 = [NSString stringWithFormat:@"article%d.png",de5];
        CCSprite *item8 = [CCSprite spriteWithSpriteFrameName:articlefile8];
        item8.anchorPoint = ccp(0, 0.5);
        item8.position = ccp(item7.position.x + 105, item7.position.y);
        [leftLayer addChild:item8 z:0];
        
        ArticleObject* ao8 = [[ShareGameManager shareGameManager] getArticleDetailFromID:de5];
        //cname , cdesc
        CCLabelTTF* namelabel8 = [CCLabelTTF labelWithString:ao8.cname fontName:@"Arial" fontSize:12];
        namelabel8.anchorPoint = ccp(0, 0.5);
        namelabel8.color = ccGREEN;
        namelabel8.position = ccp(item8.position.x + 45, item8.position.y + 8);
        [leftLayer addChild:namelabel8 z:2];
        
        CCLabelTTF* desclabel8 = [CCLabelTTF labelWithString:ao8.cdesc fontName:@"Arial" fontSize:10];
        desclabel8.anchorPoint = ccp(0, 0.5);
        desclabel8.position = ccp(item8.position.x + 45, item8.position.y - 8);
        [leftLayer addChild:desclabel8 z:2];
        
        //buy button , cost resource text
        TouchableBuySprite* tb8 = [TouchableBuySprite spriteWithSpriteFrameName:@"buildbuybtn.png"];
        tb8.position = ccp(item8.position.x + 20, item8.position.y - 35);
        [leftLayer addChild:tb8 z:2];
        [tb8 initTheCallbackFunc:@selector(buyArticleWithItem:withPosID:) withCaller:self withTouchID:de5 withPosID:7];
        stPosi[7] = tb8.position;
        
        CCSprite* gold8 = [CCSprite spriteWithSpriteFrameName:@"gold.png"];
        gold8.scale = 0.3;
        gold8.anchorPoint = ccp(0, 0.5);
        gold8.position = ccp(tb8.position.x + 30, tb8.position.y + 10);
        [leftLayer addChild:gold8 z:1];
        
        CCLabelTTF* rgLabel8 = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d",ao8.gold] fontName:@"Arial" fontSize:9];
        rgLabel8.anchorPoint = ccp(0, 0.5);
        rgLabel8.position = ccp(gold8.position.x + 17, gold8.position.y);
        [leftLayer addChild:rgLabel8 z:1];
        
        CCSprite* wood8 = [CCSprite spriteWithSpriteFrameName:@"wood.png"];
        wood8.scale = 0.3;
        wood8.anchorPoint = ccp(0, 0.5);
        wood8.position = ccp(tb8.position.x+30, tb8.position.y);
        [leftLayer addChild:wood8 z:1];
        
        CCLabelTTF* rwLabel8 = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d",ao8.wood] fontName:@"Arial" fontSize:9];
        rwLabel8.anchorPoint = ccp(0, 0.5);
        rwLabel8.position = ccp(wood8.position.x + 17, wood8.position.y);
        [leftLayer addChild:rwLabel8 z:1];
        
        CCSprite* iron8 = [CCSprite spriteWithSpriteFrameName:@"iron.png"];
        iron8.scale = 0.3;
        iron8.anchorPoint = ccp(0, 0.5);
        iron8.position = ccp(tb8.position.x+30, tb8.position.y - 10);
        [leftLayer addChild:iron8 z:1];
        
        CCLabelTTF* riLabel8 = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d",ao8.iron] fontName:@"Arial" fontSize:9];
        riLabel8.anchorPoint = ccp(0, 0.5);
        riLabel8.position = ccp(iron8.position.x + 17, iron8.position.y);
        [leftLayer addChild:riLabel8 z:1];
        
        
        
        
        
    }
    return self;
}

-(void) refreshLayer
{
    //no refresh , because no need to set invisible
    
}

-(void) playMoneyEffectAtPos:(CGPoint)startPos
{
    //sound effect
    [[SimpleAudioEngine sharedEngine] playEffect:@"sthget.caf"];
    
    //play effect
    CGPoint startP = startPos;
    
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
    
    CCSprite* wood = [CCSprite spriteWithSpriteFrameName:@"wood.png"];
    wood.scale = 0.5;
    wood.position = ccp(startP.x, startP.y);
    [self addChild:wood z:3];
    
    CCMoveBy *mv1 = [CCMoveBy actionWithDuration:1.2f position:ccp(0,60)];
    CCFadeOut *fo1 = [CCFadeOut actionWithDuration:1.5f];
    CCSpawn *sp1 = [CCSpawn actions:mv1,fo1, nil];
    CCCallBlockN *cb1 = [CCCallBlockN actionWithBlock:^(CCNode *node) {
        [node removeFromParentAndCleanup:YES];
    }];
    CCSequence *se1 = [CCSequence actions:sp1,cb1, nil];
    [wood runAction:se1];
    
    CCSprite* iron = [CCSprite spriteWithSpriteFrameName:@"iron.png"];
    iron.scale = 0.5;
    iron.position = ccp(startP.x + 20, startP.y);
    [self addChild:iron z:3];
    
    CCMoveBy *mv2 = [CCMoveBy actionWithDuration:1.2f position:ccp(0,60)];
    CCFadeOut *fo2 = [CCFadeOut actionWithDuration:1.5f];
    CCSpawn *sp2 = [CCSpawn actions:mv2,fo2, nil];
    CCCallBlockN *cb2 = [CCCallBlockN actionWithBlock:^(CCNode *node) {
        [node removeFromParentAndCleanup:YES];
    }];
    CCSequence *se2 = [CCSequence actions:sp2,cb2, nil];
    [iron runAction:se2];
}

-(void) buyArticleWithItem:(NSNumber*)arID withPosID:(NSNumber *)poID
{
    
    //get the article id from the table to get the price
    int needg;
    int needw;
    int needi;
    
    ArticleObject* ao = [[ShareGameManager shareGameManager] getArticleDetailFromID:(int)[arID integerValue]];
    needg = ao.gold;
    needw = ao.wood;
    needi = ao.iron;
    
    //if price is below sharemanager
    int g = [ShareGameManager shareGameManager].gold;
    int w = [ShareGameManager shareGameManager].wood;
    int i = [ShareGameManager shareGameManager].iron;
    
    if ((needg <= g)&&(needw <= w)&&(needi <= i)) {
        
        [ShareGameManager shareGameManager].gold = g - needg;
        [ShareGameManager shareGameManager].wood = w = needw;
        [ShareGameManager shareGameManager].iron = i - needi;
        
        //insert into the table articles values (null,articleID,cityID);
        int aid = (int)[arID integerValue];
        [[ShareGameManager shareGameManager] addArticleForID:aid cityID:_cityID];
        
        CGPoint pos;
        int posid = (int)[poID integerValue];
        //switch posid = 1 , 2, 3 , 4, 5 , 6, 7, 8, 9, 10, 11, 12
        pos = stPosi[posid];
        [self playMoneyEffectAtPos:pos];
        
        //update the ui lable
        //update the main layer label
        //main update ui text
        CCScene* run = [[CCDirector sharedDirector] runningScene];
        CCLayer* main = (CCLayer*) [run getChildByTag:1];
        if (main) {
            [main performSelector:@selector(updateResourceLabel)];
        }

    }
    else {
        //show not enough money
        [[SimpleAudioEngine sharedEngine] playEffect:@"fail.caf"];
        
        CGSize wszie = [[CCDirector sharedDirector] winSize];
        CCSprite* stbar = [CCSprite spriteWithSpriteFrameName:@"statusbar.png"];
        stbar.position = ccp(wszie.width*0.5, wszie.height*0.5);
        [self addChild:stbar z:5];
        [stbar performSelector:@selector(removeFromParent) withObject:nil afterDelay:1.5];
        
        CCLabelTTF* warn = [CCLabelTTF labelWithString:@"无法购买，资源不足！" fontName:@"Arial" fontSize:15];
        warn.color = ccYELLOW;
        warn.position = stbar.position;
        [self addChild:warn z:6];
        [warn performSelector:@selector(removeFromParent) withObject:nil afterDelay:1.5];
        
        /*
        CCLabelTTF* warn = [CCLabelTTF labelWithString:@"无法购买，没有足够的资源！" fontName:@"Arial" fontSize:15];
        warn.color = ccRED;
        
        CGPoint pos;
        int posid = (int)[poID integerValue];
        //switch posid = 1 , 2, 3 , 4, 5 , 6, 7, 8, 9, 10, 11, 12
        pos = stPosi[posid];
        
        warn.position = pos;
        [self addChild:warn z:6];
        
        CCMoveBy *mv2 = [CCMoveBy actionWithDuration:1.2f position:ccp(0,60)];
        CCFadeOut *fo2 = [CCFadeOut actionWithDuration:1.5f];
        CCSpawn *sp2 = [CCSpawn actions:mv2,fo2, nil];
        CCCallBlockN *cb2 = [CCCallBlockN actionWithBlock:^(CCNode *node) {
            [node removeFromParentAndCleanup:YES];
        }];
        CCSequence *se2 = [CCSequence actions:sp2,cb2, nil];
        [warn runAction:se2];
        */
        
        
    }
    
    
    
    
    
}


-(void) onEnter
{
    [[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:1 swallowsTouches:YES];
    [super onEnter];
}

-(void) onExit
{
    CCLOG(@"call ForgeLayer onExit()....");
    [[[CCDirector sharedDirector] touchDispatcher] removeDelegate:self];
    [super onExit];
}

- (BOOL) ccTouchBegan:(UITouch*)touch withEvent:(UIEvent *)event {
    
    CGPoint touchLocation = [[CCDirector sharedDirector] convertToGL:[touch locationInView: [touch view]]];
    if (CGRectContainsPoint(leftContent, touchLocation)) {
        CCLOG(@"touch on forge left layer....");
        //layerDragState = LeftLayerDrag;
        return NO;
    }
    else {
        //close self after 0.5 second
        needClose = 1;
        //[self performSelector:@selector(removeFromParent) withObject:nil afterDelay:0.5];
        return YES;
    }
    
    
}

- (void) ccTouchMoved:(UITouch*)touch withEvent:(UIEvent *)event {
    //move do nothing
}

- (void) ccTouchEnded:(UITouch*)touch withEvent:(UIEvent *)event {
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
    
    [super dealloc];
}

@end
