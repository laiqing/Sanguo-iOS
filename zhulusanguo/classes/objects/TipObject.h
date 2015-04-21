//
//  TipObject.h
//  zhulusanguo
//
//  Created by qing on 15/4/21.
//  Copyright (c) 2015年 qing lai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TipObject : NSObject
{
    int _tipID;
    NSString* _etip;
    NSString* _ctip;
    NSString* _nrange;
    NSString* _hrange;
}

@property (nonatomic, copy) NSString* etip;
@property (nonatomic, copy) NSString* ctip;
@property (nonatomic, copy) NSString* nrange;
@property (nonatomic, copy) NSString* hrange;
@property (nonatomic, assign) int tipID;


@end
