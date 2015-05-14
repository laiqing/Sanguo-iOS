//
//  SkillInfoMovableSprite.h
//  zhulusanguo
//
//  Created by qing on 15/5/9.
//  Copyright 2015年 qing lai. All rights reserved.
//
//  本类用于在skill layer里，每个具体的skill里的可以点击的按钮，用于弹出skill info card

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface SkillInfoMovableSprite : CCSprite<CCTouchOneByOneDelegate> {
    id caller;
    SEL callbackFunc0;
    int touchID;
    
}

-(void) initTheCallbackFunc0:(SEL)cbfunc0_ withCaller:(id)caller_  withTouchID:(int)tid ;

@end
