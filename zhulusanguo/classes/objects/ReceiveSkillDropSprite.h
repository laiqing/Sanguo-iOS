//
//  ReceiveSkillDropSprite.h
//  zhulusanguo
//
//  Created by qing on 15/5/11.
//  Copyright 2015年 qing lai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

#import "ArticleDragSprite.h"
#import "ShareGameManager.h"

@interface ReceiveSkillDropSprite : CCSprite<CCTouchOneByOneDelegate> {
    int _heroID;  //
    int _skillID;
    int _skillPosID;  //skill 1, 2, 3, 4, 5
    int _articlePosID; //article 1 , 2
    int _purpose; // 1 : article , 2 : skill
    
}

@property (nonatomic,assign) int skillID;
@property (nonatomic,assign) int heroID;
@property (nonatomic,assign) int skillPosID;
@property (nonatomic,assign) int articlePosID;
@property (nonatomic,assign) int purpose;

@end
