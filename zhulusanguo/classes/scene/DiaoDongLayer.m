//
//  DiaoDongLayer.m
//  zhulusanguo
//
//  Created by qing on 15/3/27.
//  Copyright 2015年 qing lai. All rights reserved.
//

#import "DiaoDongLayer.h"


@implementation DiaoDongLayer

+ (id) slidingLayer:(SlideDirection) slideDirection contentRect:(CGRect)contentRect withTargetCityID:(int)tcid
{
    return [[[self alloc] initSlidingLayer:slideDirection contentRect:contentRect withTargetCityID:tcid] autorelease];
}

- (id) initSlidingLayer:(SlideDirection) slideDirection contentRect:(CGRect)contentRect withTargetCityID:(int)tcid{
    if ((self = [super init])) {
        slideDirection_ = slideDirection;
        //[self setContentSize:contentSize];
        _targetCityID = tcid;
        isDragging_ = false;
        lasty = 0.0f;
        xvel = 0.0f;
        direction_ = BounceDirectionStayingStill;
        contentRect_ = contentRect;
        //[self setAnchorPoint:CGPointZero];
        //if(slideDirection_ == Vertically) {
        //    CGPoint newPosition = CGPointMake(contentRect.origin.x, -1 * (self.contentSize.width - contentRect_.size.height));
        //    [self setPosition:newPosition];
        //}
        //else if(slideDirection_ == Horizontally){
        //    [self setPosition:ccp(contentRect.origin.x, contentRect.origin.y)];
        //}
        //[self scheduleUpdate];
        // register touch
        
        virtualLayer = [CCNode node];
        [self addChild:virtualLayer z:1];
        minTopY = virtualLayer.position.y;

        CCSprite* bg = [CCSprite spriteWithSpriteFrameName:@"mapdialog.png"];
        CGSize wsize = [[CCDirector sharedDirector] winSize];
        bg.position = ccp(wsize.width*0.5, wsize.height*0.5);
        [self addChild:bg z:0];
        CGFloat bgheight = bg.boundingBox.size.height;
        
        int kid = [ShareGameManager shareGameManager].kingID;
        NSArray* heroes = [[ShareGameManager shareGameManager] selectHeroForDiaoDong:kid targetCityID:tcid];
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
            NSString* cin = citynames[ho.cityID];
            NSString* line1 = [NSString stringWithFormat:@"%@  %@  等级:%d  武力:%d  智力:%d  %@  %@  %@",ho.cname,cin,ho.level,ho.strength,ho.intelligence,sk1,sk2,sk3];
            CCLabelTTF* labelline1 = [CCLabelTTF labelWithString:line1 fontName:@"Arial" fontSize:12];
            labelline1.anchorPoint = ccp(0, 0.5);
            labelline1.color = ccYELLOW;
            labelline1.position = ccp(hhead.position.x + 30, labely1);
            [virtualLayer addChild:labelline1 z:2];
            
            NSString* trtp = trooptypes[ho.troopType];
            NSString* line2 = [NSString stringWithFormat:@"部队攻击力:%d  部队精神力:%d  %@  数量:%d",ho.troopAttack,ho.troopMental,trtp,ho.troopCount];
            CCLabelTTF* labelline2 = [CCLabelTTF labelWithString:line2 fontName:@"Arial" fontSize:12];
            labelline2.anchorPoint = ccp(0, 0.5);
            labelline2.color = ccORANGE;
            labelline2.position = ccp(hhead.position.x + 30, labely2);
            [virtualLayer addChild:labelline2 z:2];
            
            //add check box
            TouchableSprite* cb = [TouchableSprite spriteWithSpriteFrameName:@"checkbox.png"];
            cb.position = ccp(hf.position.x + hf.boundingBox.size.width*0.5 + 20, hf.position.y);
            
            [virtualLayer addChild:cb z:2];
            [cb initTheCallbackFunc:@selector(touchHeroWithID:) withCaller:self withTouchID:ho.heroID];
            
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
        [self addChild:ggtext z:2];
        
        
        //button
        TouchableSprite* btn = [TouchableSprite spriteWithSpriteFrameName:@"diaodong.png"];
        btn.position = ccp(bottom.position.x + bottom.boundingBox.size.width*0.4, bottom.position.y);
        [self addChild:btn z:2];
        
        
    }
    return self;
}

-(void) touchHeroWithID:(NSNumber*)heID
{
    int hid = (int)[heID integerValue];
    CCLOG(@"hid select : %d",hid);
}

-(void) onEnter
{
    [self registerWithTouchDispatcher];
    [super onEnter];
}

-(void) onExit
{
    [[[CCDirector sharedDirector] touchDispatcher] removeDelegate:self];
    [super onExit];
}

- (void) dealloc {
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
    
    if(slideDirection_ == Vertically) {
        float minY = 0;
        float maxY = (contentRect_.size.height) - self.contentSize.height;
        //CCLOG(@"maxY:%f",maxY);
        float delta = ( b.y - a.y );
        float deltaY = nowPosition.y + delta;
        if(deltaY < maxY || deltaY > minY) {
            delta *= 0.5;
        }
        nowPosition.y += delta;
    }
    
    //CCLOG(@"now position.y %f , max: %f",nowPosition.y,maxBottomY);
    if (nowPosition.y <0) {
        nowPosition.y = 0;
    }
    else if (nowPosition.y > maxBottomY) {
        nowPosition.y = maxBottomY;
    }
    
    [virtualLayer setPosition:nowPosition];
    
    for (CCNode* item in virtualLayer.children) {
        [self updateChildVisible:item];
    }
    
}

- (void) ccTouchEnded:(UITouch*)touch withEvent:(UIEvent *)event {
    isDragging_ = NO;
}

@end
