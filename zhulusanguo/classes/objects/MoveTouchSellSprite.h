//
//  MoveTouchSellSprite.h
//  zhulusanguo
//
//  Created by qing on 15/6/1.
//  Copyright 2015年 qing lai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface MoveTouchSellSprite : CCSprite<CCTouchOneByOneDelegate> {
    id caller;
    SEL callbackFunc0;
    int touchID;
}

-(void) initTheCallbackFunc:(SEL)cbfunc_ withCaller:(id)caller_  withTouchID:(int)tid;



- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event;

// touch updates:
- (void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event;
- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event;
- (void)ccTouchCancelled:(UITouch *)touch withEvent:(UIEvent *)event;

@end
