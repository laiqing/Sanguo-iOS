//
//  TouchableBuySprite.h
//  zhulusanguo
//
//  Created by qing on 15/5/25.
//  Copyright 2015年 qing lai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface TouchableBuySprite : CCSprite<CCTouchOneByOneDelegate> {
    id caller;
    SEL callbackFunc;
    int touchID;
    int posID;
    
    BOOL _touchable;
}

-(void) initTheCallbackFunc:(SEL)cbfunc_ withCaller:(id)caller_ withTouchID:(int)tid withPosID:(int)pID;

-(void) setTouchable:(BOOL)t;

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event;

// touch updates:
- (void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event;
- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event;
- (void)ccTouchCancelled:(UITouch *)touch withEvent:(UIEvent *)event;


@end
