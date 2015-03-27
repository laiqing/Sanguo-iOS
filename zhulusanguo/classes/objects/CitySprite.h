//
//  CitySprite.h
//  sanguo
//
//  Created by lai qing on 15/1/27.
//  Copyright 2015年 qing lai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface CitySprite : CCSprite {
    int _cityID;
    int _flagID;
    NSString *_enName;
    NSString *_cnName;
    int _posx;
    int _posy;
    int _capital;
}

@property (nonatomic, assign) int cityID;
@property (nonatomic, assign) int flagID;
@property (nonatomic, copy) NSString* enName;
@property (nonatomic, copy) NSString* cnName;
@property (nonatomic, assign) int posx;
@property (nonatomic, assign) int posy;
@property (nonatomic, assign) int capital;


@end
