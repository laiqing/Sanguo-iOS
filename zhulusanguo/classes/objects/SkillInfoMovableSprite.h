//
//  SkillInfoMovableSprite.h
//  zhulusanguo
//
//  Created by qing on 15/5/9.
//  Copyright 2015年 qing lai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface SkillInfoMovableSprite : CCSprite<CCTouchOneByOneDelegate> {
    id caller;
    SEL callbackFunc0;
    int touchID;
    
}

-(void) initTheCallbackFunc0:(SEL)cbfunc0_ withCaller:(id)caller_  withTouchID:(int)tid ;

@end
