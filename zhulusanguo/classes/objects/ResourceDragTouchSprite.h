//
//  ResourceDragTouchSprite.h
//  zhulusanguo
//
//  Created by qing on 15/5/27.
//  Copyright 2015年 qing lai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "ResourceDragSprite.h"

@interface ResourceDragTouchSprite : CCSprite<CCTouchOneByOneDelegate> {
    id caller;
    SEL callbackFunc0;
    int touchID;    //在这里，touchID表示resource type id
    ResourceDragSprite* dragSprite;
    BOOL dragable;
    
    //int state;
    NSString* state0Image;

}

@property (nonatomic,assign) BOOL candrag;

-(void) initTheCallbackFunc0:(SEL)cbfunc0_ withCaller:(id)caller_ withTouchID:(int)tid withImg:(NSString*)img1 canDrag:(BOOL)_dr;


@end
