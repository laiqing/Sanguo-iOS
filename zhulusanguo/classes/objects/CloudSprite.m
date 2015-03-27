//
//  CloudSprite.m
//  sanguo
//
//  Created by lai qing on 15/1/27.
//  Copyright 2015年 qing lai. All rights reserved.
//

#import "CloudSprite.h"


@implementation CloudSprite

-(void) initBoundary:(float)maxX  withYPos:(float)posy
{
    //init in the random postion
    int spp = arc4random()%20;
    int dir = arc4random()%2;
    if (dir==0) {
        _moveOff = (10 + spp)*0.01;
    }
    else {
        _moveOff = (10 + spp)*0.01;
    }
    
    _maxX = maxX;
    //self.color = ccGRAY;
    self.opacity = 100;
    
    self.position = ccp(30 + arc4random()%((int)maxX),posy);
    [self scheduleUpdate];
}

-(void)update:(ccTime)delta
{
    float halfwidth = self.boundingBox.size.width*0.5;
    if (self.position.x <= -halfwidth) {
        self.position = ccp(_maxX-halfwidth, self.position.y);
    }
    else if (self.position.x >= (_maxX+halfwidth)) {
        self.position = ccp(halfwidth, self.position.y);
    }
    else {
        self.position = ccp(self.position.x + _moveOff, self.position.y);
    }
}

-(void) dealloc
{
    [self unscheduleUpdate];
    [super dealloc];
}

@end
