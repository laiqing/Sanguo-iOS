//
//  MapLayer.m
//  zhulusanguo
//
//  Created by qing on 15/3/26.
//  Copyright 2015年 qing lai. All rights reserved.
//

#import "MapLayer.h"




@implementation MapLayer



// on "init" you need to initialize your instance
-(id) init
{
    // always call "super" init
    // Apple recommends to re-assign "self" with the "super's" return value
    if( (self=[super init]) ) {
        
        
        bg = [CCSprite spriteWithFile:@"map.png"];
        bg.anchorPoint = CGPointZero;
        bg.position = CGPointZero;
        bg.color = ccGRAY;
        bg.tag = 0;
        [self addChild:bg z:0];
        
        
        
        //add batch node
        bnode = [CCSpriteBatchNode batchNodeWithFile:@"sanguo.pvr.ccz"];
        //init sprite cache
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"sanguo.plist"];
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"sanguoeffect.plist"];
        //sb.tag = 1000;
        [self addChild:bnode z:2];
        
        //add city from database
        
        NSString *rootpath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString *curdb = [rootpath stringByAppendingPathComponent:@"current.db"];
        sqlite3* _database;
        sqlite3_open([curdb UTF8String], &_database);
        sqlite3_stmt *statement;
        
        citySprites = [[NSMutableArray alloc] init];
        
        NSString *query = @"SELECT id, cname, ename,xpos,ypos,flag,capital FROM city";
        if (sqlite3_prepare_v2(_database, [query UTF8String], -1, &statement, nil) == SQLITE_OK) {
            while (sqlite3_step(statement) == SQLITE_ROW) {
                //int uniqueId = sqlite3_column_int(statement, 0);
                int cid = (int) sqlite3_column_int(statement, 0);
                char *cname = (char *) sqlite3_column_text(statement, 1);
                char *ename = (char *) sqlite3_column_text(statement, 2);
                NSString *cname2 = [[NSString alloc] initWithUTF8String:cname];
                NSString *ename2 = [[NSString alloc] initWithUTF8String:ename];
                int xpos = (int) sqlite3_column_int(statement, 3);
                int ypos = (int) sqlite3_column_int(statement, 4);
                int flag = (int) sqlite3_column_int(statement, 5);
                int capital = (int) sqlite3_column_int(statement, 6);
                
                //CityInfoObject* cio = [[CityInfoObject alloc] init];
                CitySprite *cs = [CitySprite spriteWithSpriteFrameName:@"city.png"];
                cs.tag = cid;
                cs.cityID = cid;
                cs.flagID = flag;
                cs.posx = xpos;
                cs.posy = ypos;
                cs.capital = capital;
                cs.cnName = cname2;
                cs.enName = ename2;
                cs.position = ccp(xpos*0.5,bg.boundingBox.size.height - ypos*0.5);
                [bnode addChild:cs z:1];
                [citySprites addObject:cs];
                
                //add city name label
                CCLabelTTF* ncLabel = [CCLabelTTF labelWithString:cname2 fontName:@"Verdana-Bold" fontSize:16];
                ncLabel.tag = 100+cid;
                ncLabel.position = ccp(cs.position.x, cs.position.y - cs.boundingBox.size.height*0.4);
                [self addChild:ncLabel z:2];
                
                //add flag
                if (flag!=99) {
                    NSString* flagname = [NSString stringWithFormat:@"flag%d01.png",flag];
                    CCSprite* flagsp = [CCSprite spriteWithSpriteFrameName:flagname];
                    flagsp.tag = 200 + cid;
                    flagsp.position = ccp(cs.position.x + flagsp.boundingBox.size.width*0.5 , cs.position.y + cs.boundingBox.size.height*0.4 + flagsp.boundingBox.size.height*0.5);
                    [bnode addChild:flagsp z:2];
                    
                    
                    //flag run animation
                    NSString* flaganiName = [NSString stringWithFormat:@"flag%d",flag];
                    CCAnimation *aniact = [[CCAnimationCache sharedAnimationCache] animationByName:flaganiName];
                    aniact.restoreOriginalFrame = YES;
                    CCAnimate *a1 = [CCAnimate actionWithAnimation:aniact];
                    CCRepeatForever *rf = [CCRepeatForever actionWithAction:a1];
                    [flagsp runAction:rf];
                    
                }
                
                //add captial
                if (capital==1) {
                    NSString* cpname = [NSString stringWithFormat:@"capital%d.png",flag];
                    CCSprite* cp = [CCSprite spriteWithSpriteFrameName:cpname];
                    CGPoint cpp = ccp(cs.position.x - cs.boundingBox.size.width*0.4, cs.position.y + cs.boundingBox.size.height*0.4);
                    cp.position = cpp;
                    [self addChild:cp z:2];
                    
                }
                
                
                
                
                [cname2 release];
                [ename2 release];
                
            }
            sqlite3_finalize(statement);
        }
        
        sqlite3_close(_database);
        

        //add cloud move
        int div = bg.boundingBox.size.height / 80;
        for (int i=1; i<div; i++) {
            NSString* cloudfile;
            cloudfile = @"cloud01.png";
            CloudSprite *ccsp = [CloudSprite spriteWithSpriteFrameName:cloudfile];
            [ccsp initBoundary:bg.boundingBox.size.width withYPos:(80*i+arc4random()%30)];
            [bnode addChild:ccsp z:3];
        }
        
        
        
        
        
        //schedule update
        [self scheduleUpdate];
        
        //[self schedule:@selector(scheduleAddInfo) interval:5];
        [self schedule:@selector(scheduleUpdateRes) interval:4];
        
        //move to the captial
        int kingid = [ShareGameManager shareGameManager].kingID;
        int capitalid = [[ShareGameManager shareGameManager] getTheCapitalCityWithKingID:kingid];
        [self moveMapToCity:capitalid];
        
    }
    return self;
}

-(void) onEnter
{
    [[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:2 swallowsTouches:YES];
    [super onEnter];
}

-(void) onExit
{
    [[[CCDirector sharedDirector] touchDispatcher] removeDelegate:self];
    [super onExit];
}

-(void) moveMapToCity:(int)cityID
{
    CitySprite *cs = nil;
    for (CitySprite* controlUnit in citySprites)
    {
        if (controlUnit.cityID == cityID) {
            cs = controlUnit;
            break;
        }
    }
    CGSize winSize = [CCDirector sharedDirector].winSize;
    CGPoint np = ccp(-cs.position.x+winSize.width*0.5 ,-cs.position.y+winSize.height*0.5);
    np.x = MIN(np.x, 0);
    np.x = MAX(np.x, -bg.contentSize.width*bg.scale+winSize.width);
    np.y = MIN(np.y, 0);
    np.y = MAX(np.y, -bg.contentSize.height*bg.scale+winSize.height);
    self.position = np;
    
    //[self moveMap:cs.position];
}

-(void) moveMap:(CGPoint)moveValue
{
    
    CGPoint newPos = ccpAdd(self.position, moveValue);
    CGSize winSize = [CCDirector sharedDirector].winSize;
    CGPoint retval = newPos;
    retval.x = MIN(retval.x, 0);
    retval.x = MAX(retval.x, -bg.contentSize.width*bg.scale+winSize.width);
    retval.y = MIN(retval.y, 0);
    retval.y = MAX(retval.y, -bg.contentSize.height*bg.scale+winSize.height);
    self.position = retval;
    
}

-(void) selectUnitFromTouch:(UITouch*) touch
{
    CGPoint touchLocation = [self convertTouchToNodeSpace:touch];
    for (CitySprite* controlUnit in citySprites) {
        if (CGRectContainsPoint(controlUnit.boundingBox, touchLocation)) {
            
            //[[SimpleAudioEngine sharedEngine] playEffect:@"menutouch.caf"];
            
            selUnit = controlUnit;
            CCLOG(@"select city %d",selUnit.cityID);
            break;
        }
    }
    
}


-(BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    if (selUnit!=nil) {
        selUnit = nil;
    }
    [self selectUnitFromTouch:touch];
    return YES;
}




-(void) ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
    if (selUnit!=nil) {
        selUnit = nil;
    }
    CGPoint touchLocation = [self convertTouchToNodeSpace:touch];
    
    CGPoint oldTouchLocation = [touch previousLocationInView:touch.view];
    oldTouchLocation = [[CCDirector sharedDirector] convertToGL:oldTouchLocation];
    oldTouchLocation = [self convertToNodeSpace:oldTouchLocation];
    
    CGPoint translation = ccpSub(touchLocation, oldTouchLocation);
    [self moveMap:translation];
}

-(void)ccTouchCancelled:(UITouch *)touch withEvent:(UIEvent *)event
{
    [self removeSelectedAndTargeted];
}


-(void) removeSelectedAndTargeted
{
    
}





-(void) ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    if (selUnit) {
        CCLOG(@"pop city info dialog, user want to see city info %d",selUnit.cityID);
        //Call the HUDlayer to popCityInfo
        CCLayer<MapHUDProtocol>* hud = (CCLayer<MapHUDProtocol>*)[[[CCDirector sharedDirector] runningScene] getChildByTag:2];
        if (hud) {
            [hud popCityInfoWithCityID:selUnit.cityID];
        }
        selUnit = nil;
        
        
    }
    else {
        //hud remove pop info
        CCLayer<MapHUDProtocol>* hud = (CCLayer<MapHUDProtocol>*)[[[CCDirector sharedDirector] runningScene] getChildByTag:2];
        if (hud) {
            [hud removePopCityInfo];
        }
    }
}

-(void) scheduleUpdateRes
{
    int flagID = [ShareGameManager shareGameManager].kingID;
    [self popCityAddGoldText:flagID];
    
    //schedule add enemy resource , distribute enemy's army , add enemy city's building , this function add in hud
    //----------------------------------------
    //----------------------------------------
    //schedule add inccident. flood, plage, thief.
    //schedule other enemy fight each other.
    //"刘备，据探马来报，董卓正在集结部队，准备10天后对xx城进攻，请做好准备。"
    
}


-(void) popCityAddGoldText:(int)flagID
{
    for (CitySprite* controlUnit in citySprites)
    {
        if (controlUnit.flagID == flagID) {
            //add text up effect
            CCSprite* addpic = [CCSprite spriteWithSpriteFrameName:@"increase.png"];
            addpic.position = ccp(controlUnit.position.x - 40, controlUnit.position.y);
            [self addChild:addpic z:2];
            
            CCMoveBy *mv0 = [CCMoveBy actionWithDuration:1.2f position:ccp(0,60)];
            CCFadeOut *fo0 = [CCFadeOut actionWithDuration:1.5f];
            CCSpawn *sp0 = [CCSpawn actions:mv0,fo0, nil];
            [addpic runAction:sp0];
            [addpic performSelector:@selector(removeFromParent) withObject:nil afterDelay:1.8];
            
            
            
            CCSprite* gold = [CCSprite spriteWithSpriteFrameName:@"gold.png"];
            gold.scale = 0.5;
            gold.position = ccp(controlUnit.position.x - 20, controlUnit.position.y);
            [self addChild:gold z:2];
            
            CCMoveBy *mv = [CCMoveBy actionWithDuration:1.2f position:ccp(0,60)];
            CCFadeOut *fo = [CCFadeOut actionWithDuration:1.5f];
            CCSpawn *sp = [CCSpawn actions:mv,fo, nil];
            [gold runAction:sp];
            [gold performSelector:@selector(removeFromParent) withObject:nil afterDelay:1.8];
            
            CCSprite* wood = [CCSprite spriteWithSpriteFrameName:@"wood.png"];
            wood.scale = 0.5;
            wood.position = ccp(controlUnit.position.x, controlUnit.position.y);
            [self addChild:wood z:2];
            
            CCMoveBy *mv1 = [CCMoveBy actionWithDuration:1.2f position:ccp(0,60)];
            CCFadeOut *fo1 = [CCFadeOut actionWithDuration:1.5f];
            CCSpawn *sp1 = [CCSpawn actions:mv1,fo1, nil];
            [wood runAction:sp1];
            [wood performSelector:@selector(removeFromParent) withObject:nil afterDelay:1.8];
            
            
            CCSprite* iron = [CCSprite spriteWithSpriteFrameName:@"iron.png"];
            iron.scale = 0.5;
            iron.position = ccp(controlUnit.position.x + 20, controlUnit.position.y);
            [self addChild:iron z:2];
            
            CCMoveBy *mv2 = [CCMoveBy actionWithDuration:1.2f position:ccp(0,60)];
            CCFadeOut *fo2 = [CCFadeOut actionWithDuration:1.5f];
            CCSpawn *sp2 = [CCSpawn actions:mv2,fo2, nil];
            [iron runAction:sp2];
            [iron performSelector:@selector(removeFromParent) withObject:nil afterDelay:1.8];
            
        }
    }
}


// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
    [self unscheduleAllSelectors];
    
    
    
    //remove citys
    for (long i=[citySprites count]-1; i>=0; i--) {
        CitySprite* cs  = [citySprites objectAtIndex:i];
        [citySprites removeObject:cs];
    }
    
    //remove clouds
    for (long i=[clouds count]-1; i>=0; i--) {
        CloudSprite* csp = [clouds objectAtIndex:i];
        [clouds removeObject:csp];
        [bnode removeChild:csp cleanup:YES];
        //[csp release];
    }
    
    
    // don't forget to call "super dealloc"
    [super dealloc];
}

-(void) update:(ccTime)delta
{
    //clouds move random
    
    
    //enemies attack
    
    //gather money
    
}


@end
