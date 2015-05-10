//
//  ArticleDragSprite.h
//  zhulusanguo
//
//  Created by qing on 15/5/7.
//  Copyright 2015年 qing lai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface ArticleDragSprite : CCSprite {
    int _articleID;
    int _skillID;
}

@property (nonatomic,assign) int articleID;
@property (nonatomic,assign) int skillID;

@end
