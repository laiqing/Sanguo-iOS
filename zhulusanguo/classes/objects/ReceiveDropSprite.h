//
//  ReceiveDropSprite.h
//  zhulusanguo
//
//  Created by qing on 15/5/6.
//  Copyright 2015年 qing lai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

#import "ArticleDragSprite.h"

//for article receive, skill receive 

@interface ReceiveDropSprite : CCSprite {
    int _heroID;  //
    int _skillPosID;  //skill 1, 2, 3, 4, 5
    int _articlePosID; //article 1 , 2
    int _purpose; // 1 : article , 2 : skill
    
    CCLabelTTF *_hpLabel;
    CCLabelTTF *_mpLabel;
    CCLabelTTF *_attackLabel;
    CCLabelTTF *_articleNameLabel;
    CCLabelTTF *_articleDescLabel;
}

@property (nonatomic,assign) int heroID;
@property (nonatomic,assign) int skillPosID;
@property (nonatomic,assign) int articlePosID;
@property (nonatomic,assign) int purpose;

@property (nonatomic,retain) CCLabelTTF* hpLabel;
@property (nonatomic,retain) CCLabelTTF* mpLabel;
@property (nonatomic,retain) CCLabelTTF* attackLabel;
@property (nonatomic,retain) CCLabelTTF* articleNameLabel;
@property (nonatomic,retain) CCLabelTTF* articleDescLabel;

@end
