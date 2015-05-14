//
//  TroopDragTouchSprite.h
//  zhulusanguo
//
//  Created by qing on 15/5/14.
//  Copyright 2015年 qing lai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

#import "ShareGameManager.h"
#import "HeroObject.h"
#import "UnitDragSprite.h"


@interface TroopDragTouchSprite : CCSprite<CCTouchOneByOneDelegate> {
    id caller;
    SEL callbackFunc0;
    int _touchID;    //在这里，touchID表示unitTypeID
    UnitDragSprite* dragSprite;
    BOOL dragable;
    
    int _heroID;
    //int state;
    NSString* state0Image;
}

@property (nonatomic,assign) BOOL candrag;
@property (nonatomic,assign) int heroID;
@property (nonatomic,assign) int touchID;

-(void) initTheCallbackFunc0:(SEL)cbfunc0_ withCaller:(id)caller_ withTouchID:(int)tid withImg:(NSString*)img1 canDrag:(BOOL)_dr;


@end
