//
//  RecruitDragTouchSprite.h
//  zhulusanguo
//
//  Created by qing on 15/5/11.
//  Copyright 2015年 qing lai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

#import "UnitDragSprite.h"

@interface RecruitDragTouchSprite : CCSprite<CCTouchOneByOneDelegate> {
    id caller;
    SEL callbackFunc0;
    int touchID;    //在这里，touchID表示unitTypeID
    UnitDragSprite* dragSprite;
    BOOL dragable;
    
    //int state;
    NSString* state0Image;
}

@property (nonatomic,assign) BOOL candrag;

-(void) initTheCallbackFunc0:(SEL)cbfunc0_ withCaller:(id)caller_ withTouchID:(int)tid withImg:(NSString*)img1 canDrag:(BOOL)_dr;


@end
