//
//  TouchableSprite.h
//  zhulusanguo
//
//  Created by qing on 15/3/24.
//  Copyright 2015年 qing lai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"


//use for button , skill button ,
@interface TouchableSprite : CCSprite<CCTouchOneByOneDelegate> {
    id caller;
    SEL callbackFunc;
    int touchID;
    
    BOOL _touchable;
}



-(void) initTheCallbackFunc:(SEL)cbfunc_ withCaller:(id)caller_ withTouchID:(int)tid;

-(void) setTouchable:(BOOL)t;

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event;

// touch updates:
- (void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event;
- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event;
- (void)ccTouchCancelled:(UITouch *)touch withEvent:(UIEvent *)event;

@end
