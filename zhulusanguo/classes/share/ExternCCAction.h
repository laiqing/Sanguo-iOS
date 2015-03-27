//
//  ExternCCAction.h
//  zhulusanguo
//
//  Created by qing on 15/3/27.
//  Copyright (c) 2015年 qing lai. All rights reserved.
//

#ifndef zhulusanguo_ExternCCAction_h
#define zhulusanguo_ExternCCAction_h

#import <Foundation/Foundation.h>
#import "cocos2d.h"


@interface CCXJumpBy : CCActionInterval <NSCopying>
{
    CGPoint startPosition_;
    CGPoint delta_;
    ccTime height_;
    NSUInteger jumps_;
}
/** creates the action */
+(id) actionWithDuration: (ccTime)duration position:(CGPoint)position height:(ccTime)height jumps:(NSUInteger)jumps;
/** initializes the action */
-(id) initWithDuration: (ccTime)duration position:(CGPoint)position height:(ccTime)height jumps:(NSUInteger)jumps;

@end

#endif
