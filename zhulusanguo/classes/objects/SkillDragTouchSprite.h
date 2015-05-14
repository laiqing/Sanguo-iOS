//
//  SkillDragTouchSprite.h
//  zhulusanguo
//
//  Created by qing on 15/5/10.
//  Copyright 2015年 qing lai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "ArticleDragSprite.h"

@interface SkillDragTouchSprite : CCSprite<CCTouchOneByOneDelegate> {
    id caller;
    SEL callbackFunc0;
    SEL beforeMoveCallbackFunc;
    int touchID;
    //BOOL needChangeImg;
    
    ArticleDragSprite* dragSprite;
    
    //int state;
    NSString* state0Image;  //normal image
    //NSString* state1Image;  //image during move , for example , skillInfo card png
}

-(void) initTheCallbackFunc0:(SEL)cbfunc0_ withBeforeCallback:(SEL)cbfunc1_ withCaller:(id)caller_ withTouchID:(int)tid withImg:(NSString*)img1;

@end
