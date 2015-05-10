//
//  MoveTouchStateSprite.h
//  zhulusanguo
//
//  Created by qing on 15/3/28.
//  Copyright 2015年 qing lai. All rights reserved.
//
//  这个类，用于在map界面，出现调动或者进攻layer时，需要滚动出现的选择框，
//  由于该选择框的位置会随着滚动变化，所以在touch时需要捕捉该控件的真实的位置


#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface MoveTouchStateSprite : CCSprite<CCTouchOneByOneDelegate> {
    id caller;
    SEL callbackFunc0;
    SEL callbackFunc1;
    int touchID;
    
    int state;
    NSString* state0Image;
    NSString* state1Image;
}

-(void) initTheCallbackFunc0:(SEL)cbfunc0_ withCallbackFunc1:(SEL)cbfunc1_ withCaller:(id)caller_  withTouchID:(int)tid withState:(int)st withImage0:(NSString*)st0 withImage1:(NSString*)st1;



- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event;

// touch updates:
- (void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event;
- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event;
- (void)ccTouchCancelled:(UITouch *)touch withEvent:(UIEvent *)event;

-(void) unchecked;

@end
