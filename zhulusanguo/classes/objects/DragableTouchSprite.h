//
//  DragableTouchSprite.h
//  zhulusanguo
//
//  Created by qing on 15/5/6.
//  Copyright 2015年 qing lai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
//#import "ReceiveDropSprite.h"
#import "ArticleDragSprite.h"

@interface DragableTouchSprite : CCSprite<CCTouchOneByOneDelegate> {
    id caller;
    SEL callbackFunc0;
    int touchID;
    BOOL needChangeImg;
    
    ArticleDragSprite* dragSprite;
    
    //int state;
    NSString* state0Image;  //normal image
    NSString* state1Image;  //image during move , for example , skillInfo card png
}

-(void) initTheCallbackFunc0:(SEL)cbfunc0_ withCaller:(id)caller_ withTouchID:(int)tid needChangeImg:(BOOL)changeImg withImage0:(NSString*)st0 withImage1:(NSString*)st1;

@end
