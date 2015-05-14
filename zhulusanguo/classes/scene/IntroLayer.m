//
//  IntroLayer.m
//  zhulusanguo
//
//  Created by qing on 15/3/23.
//  Copyright qing lai 2015年. All rights reserved.
//


// Import the interfaces
#import "IntroLayer.h"
//#import "MainLandScene.h"
#import "SelectKingLayer.h"

#pragma mark - IntroLayer

// HelloWorldLayer implementation
@implementation IntroLayer

+(CCScene *) scene
{
    // 'scene' is an autorelease object.
    CCScene *scene = [CCScene node];
    
    //bg color
    CCLayerColor* bglayer = [[[CCLayerColor  alloc] initWithColor:ccc4(50, 50, 50, 255)] autorelease];
    [scene addChild:bglayer z:-1];
    
    // 'layer' is an autorelease object.
    IntroLayer *layer = [IntroLayer node]; //[[[IntroLayer alloc] initWithColor:ccc4(50, 50, 50, 255)] autorelease];
    
    // add layer as a child to scene
    [scene addChild: layer z:1];
    
    // return the scene
    return scene;
}

//
-(id) init
{
    if( (self=[super init])) {
        
        [[SimpleAudioEngine sharedEngine] preloadBackgroundMusic:@"sanguo_menu2.aifc"];
        [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"sanguo_menu2.aifc" loop:YES];
        
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"menu.caf"];
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"upgrade.caf"];
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"sthget.caf"];
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"fail.caf"];
        
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"sanguo.plist"];
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"sanguoeffect.plist"];
        
        CGSize size = [[CCDirector sharedDirector] winSize];
        
        //only iPhone layout
        
        

        //add title png
        //CCSprite *title = [CCSprite spriteWithSpriteFrameName:@"title.png"];
        CCSprite *title = [CCSprite spriteWithSpriteFrameName:@"title.png"];
        title.position = ccp(size.width*0.45, size.height*0.65);
        [self addChild:title z:1];
            
        CCFadeIn *tfi = [CCFadeIn actionWithDuration:4];
        [title runAction:tfi];
        
        CCSprite *dragon = [CCSprite spriteWithSpriteFrameName:@"dragon.png"];
        dragon.position = ccp(size.width*0.85, size.height*0.65);
        [self addChild:dragon z:1];
        
        CCFadeIn *dfi = [CCFadeIn actionWithDuration:8];
        [dragon runAction:dfi];
        
        //add mapbg
        CCSprite *mpg = [CCSprite spriteWithFile:@"map.png"];
        mpg.anchorPoint = ccp(0, 0);
        mpg.position = ccp(0, 0);
        mpg.opacity = 100;
        //mpg.color = ccGRAY;
        [self addChild:mpg z:-1];
        
        CCSprite *btn1 = [CCSprite spriteWithSpriteFrameName:@"button.png"];
        btn1.position = ccp(size.width*0.5, size.height*0.32);
        [self addChild:btn1 z:1];
        
        CCSprite *btn2 = [CCSprite spriteWithSpriteFrameName:@"button.png"];
        btn2.position = ccp(size.width*0.5, size.height*0.15);
        [self addChild:btn2 z:1];
        
        
        //add menu to hello layer
        CCLabelTTF *newlb = [CCLabelTTF labelWithString:@"新的游戏" fontName:@"Verdana-Bold" fontSize:20];
        newlb.color = ccc3(255, 255, 255);
        CCMenuItemLabel *tl = [CCMenuItemLabel itemWithLabel:newlb target:self selector:@selector(loadnew)];
        
        CCLabelTTF *continuelab = [CCLabelTTF labelWithString:@"读取进度" fontName:@"Verdana-Bold" fontSize:20];
        continuelab.color = ccc3(255, 255, 0);
        CCMenuItemLabel *ml = [CCMenuItemLabel itemWithLabel:continuelab target:self selector:@selector(continueold)];
        
        CCMenu *me = [CCMenu menuWithItems:tl,ml, nil];
        [me alignItemsVerticallyWithPadding:28];
        me.position = ccp(size.width*0.5,size.height*0.24);
        [self addChild:me z:2];
        
        //add snow
        CCParticleSystem *snow = [CCParticleSnow node];
        snow.position = ccp(size.width*0.5, size.height+5);
        snow.speed = 30;
        snow.speedVar = 5;
        [self addChild:snow z:1];
        
        //add version in right
        
        NSString* plistpath = [[NSBundle mainBundle] pathForResource:@"Info" ofType:@"plist"];
        NSDictionary *setting = [NSDictionary dictionaryWithContentsOfFile:plistpath];
        NSString* vernum = [setting objectForKey:@"CFBundleVersion"];
        NSString* fu = [NSString stringWithFormat:@"version:%@",vernum];
        
        CCLabelTTF *ver = [CCLabelTTF labelWithString:fu fontName:@"Arial" fontSize:12];
        ver.color = ccORANGE;
        ver.anchorPoint = ccp(1,0.5);
        ver.position = ccp(size.width-5, 10);
        [self addChild:ver z:1];
        
        //add comment button in left
        TouchableSprite* comment = [TouchableSprite spriteWithSpriteFrameName:@"rateus.png"];
        comment.position = ccp(comment.boundingBox.size.width*0.7, comment.boundingBox.size.height*0.7);
        [self addChild:comment z:1];
        [comment initTheCallbackFunc:@selector(openRateURL) withCaller:self withTouchID:-1];
        

        /*
        else {
            //add menu to hello layer
            CCLabelTTF *newlb = [CCLabelTTF labelWithString:@"[New Game]" fontName:@"Verdana-Bold" fontSize:32];
            newlb.color = ccc3(255, 0, 255);
            CCMenuItemLabel *tl = [CCMenuItemLabel itemWithLabel:newlb target:self selector:@selector(loadnew)];
            
            CCLabelTTF *continuelab = [CCLabelTTF labelWithString:@"[Continue]" fontName:@"Verdana-Bold" fontSize:32];
            continuelab.color = ccc3(255, 255, 0);
            CCMenuItemLabel *ml = [CCMenuItemLabel itemWithLabel:continuelab target:self selector:@selector(continueold)];
            
            CCMenu *me = [CCMenu menuWithItems:tl,ml, nil];
            [me alignItemsVerticallyWithPadding:24];
            me.position = ccp(size.width*0.5,size.height*0.18);
            [self addChild:me z:2];
        }
         */
        
        //self.isTouchEnabled = YES;
        //[[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
        
        
    }
    
    return self;
}

-(void) openRateURL
{
    NSString* staticurl = @"itms-apps://itunes.apple.com/app/id880612121";
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:staticurl]];
}

-(void) loadnew
{
    CCLOG(@"new game");
    [[SimpleAudioEngine sharedEngine] playEffect:@"menu.caf"];
    //[[ShareGameManager shareGameManager] initDefaultAllAnimationInScene];
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[SelectKingLayer node] ]];
}

-(void) continueold
{
    CCLOG(@"continue...");
    //[[CCDirector sharedDirector] replaceScene:[TestScrollLayer scene]];
    //[[CCDirector sharedDirector] replaceScene:[TestGruopLayer scene]];
}



/*
-(void) onEnter
{
	[super onEnter];
	[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[HelloWorldLayer scene] ]];
}
 */
 
@end
