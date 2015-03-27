//
//  DiaoDongLayer.m
//  zhulusanguo
//
//  Created by qing on 15/3/27.
//  Copyright 2015年 qing lai. All rights reserved.
//

#import "DiaoDongLayer.h"


@implementation DiaoDongLayer

+ (id) slidingLayer:(SlideDirection) slideDirection size:(CGSize)contentSize contentRect:(CGRect)contentRect withTargetCityID:(int)tcid
{
    return [[[self alloc] initSlidingLayer:slideDirection size:contentSize contentRect:contentRect withTargetCityID:tcid] autorelease];
}

- (id) initSlidingLayer:(SlideDirection) slideDirection size:(CGSize)contentSize contentRect:(CGRect)contentRect withTargetCityID:(int)tcid{
    if ((self = [super init])) {
        slideDirection_ = slideDirection;
        [self setContentSize:contentSize];
        _targetCityID = tcid;
        isDragging_ = false;
        lasty = 0.0f;
        xvel = 0.0f;
        direction_ = BounceDirectionStayingStill;
        contentRect_ = contentRect;
        [self setAnchorPoint:CGPointZero];
        if(slideDirection_ == Vertically) {
            CGPoint newPosition = CGPointMake(contentRect.origin.x, -1 * (self.contentSize.width - contentRect_.size.height));
            [self setPosition:newPosition];
        }
        else if(slideDirection_ == Horizontally){
            [self setPosition:ccp(contentRect.origin.x, contentRect.origin.y)];
        }
        [self scheduleUpdate];
        [self registerWithTouchDispatcher]; // register touch
        
        virtualLayer = [CCNode node];
        [self addChild:virtualLayer z:1];
        
        //try to select hero from other city, 
        
        
    }
    return self;
}

- (void) dealloc {
    [[[CCDirector sharedDirector] touchDispatcher] removeDelegate:self];
    [super dealloc];
}

-(void) addChildToVirtualNode:(CCNode *)child
{
    [virtualLayer addChild:child z:1];
}

- (void) update:(ccTime) deltaTime {
    CGPoint pos = self.position;
    // positions for slidingLayer
    float right = pos.x + 0 + self.contentSize.width;
    float left = pos.x + 0;
    float top = pos.y + 0;
    float bottom = pos.y + 0 + self.contentSize.height;
    
    // Bounding area of slidingview
    float minX = contentRect_.origin.x;
    float maxX = contentRect_.origin.x + contentRect_.size.width;
    
    float minY = contentRect_.origin.y;
    float maxY = contentRect_.origin.y + contentRect_.size.height;
    
    if(!isDragging_) {
        static float friction = 0.96f;
        if(slideDirection_ == Horizontally){
            if(left > minX && direction_ != BounceDirectionGoingLeft) {
                xvel = 0;
                direction_ = BounceDirectionGoingLeft;
            }
            else if(right < maxX && direction_ != BounceDirectionGoingRight) {
                xvel = 0;
                direction_ = BounceDirectionGoingRight;
            }
        }
        else if(slideDirection_ == Vertically) {
            if(top > minY && direction_ != BounceDirectionGoingUp) {
                xvel = 0;
                direction_ = BounceDirectionGoingUp;
            }
            else if(bottom < maxY && direction_ != BounceDirectionGoingDown) {
                xvel = 0;
                direction_ = BounceDirectionGoingDown;
            }
        }
        if(direction_ == BounceDirectionGoingRight) {
            if(xvel >= 0) {
                float delta = (maxX - right);
                float yDeltaPerFrame = (delta / (BOUNCE_TIME * FRAME_RATE));
                xvel = yDeltaPerFrame;
            }
            if((right + 0.5f) == maxX) {
                pos.x = right -  self.contentSize.width;
                xvel = 0;
                direction_ = BounceDirectionStayingStill;
            }
        }
        else if(direction_ == BounceDirectionGoingLeft) {
            if(xvel <= 0) {
                float delta = (minX - left);
                float yDeltaPerFrame = (delta / (BOUNCE_TIME * FRAME_RATE));
                xvel = yDeltaPerFrame;
            }
            if((left + 0.5f) == minX) {
                pos.x = left - 0;
                xvel = 0;
                direction_ = BounceDirectionStayingStill;
            }
        }
        else if(direction_ == BounceDirectionGoingDown) {
            if(xvel >= 0) {
                float delta = (maxY - bottom);
                float yDeltaPerFrame = (delta / (BOUNCE_TIME * FRAME_RATE));
                xvel = yDeltaPerFrame;
            }
            if((bottom + 0.5f) == maxY) {
                pos.y = bottom -  self.contentSize.height;
                xvel = 0;
                direction_ = BounceDirectionStayingStill;
            }
        }
        else if(direction_ == BounceDirectionGoingUp) {
            if(xvel <= 0) {
                float delta = (minY - top);
                float yDeltaPerFrame = (delta / (BOUNCE_TIME * FRAME_RATE));
                xvel = yDeltaPerFrame;
            }
            if((top + 0.5f) == minY) {
                
                pos.y = top - 0;
                xvel = 0;
                direction_ = BounceDirectionStayingStill;
            }
        }
        else {
            xvel *= friction;
        }
        if(slideDirection_ == Horizontally) {
            pos.x += xvel;
        }
        else if (slideDirection_ == Vertically) {
            pos.y += xvel;
        }
        [self setPosition:pos];
    }
    else {
        if(slideDirection_ == Horizontally) {
            if(left <= minX || right >= maxX) {
                direction_ = BounceDirectionStayingStill;
            }
            if(direction_ == BounceDirectionStayingStill) {
                xvel = (pos.x - lasty)/2;
                lasty = pos.x;
            }
        }
        else if(slideDirection_ == Vertically){
            if(top <= minY || bottom >= maxY) {
                direction_ = BounceDirectionStayingStill;
            }
            if(direction_ == BounceDirectionStayingStill) {
                xvel = (pos.y - lasty)/2;
                lasty = pos.y;
            }
        }
    }
}

- (void) registerWithTouchDispatcher {
    [[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:1 swallowsTouches:NO];
}

- (BOOL) ccTouchBegan:(UITouch*)touch withEvent:(UIEvent *)event {
    CGPoint touchLocation = [[CCDirector sharedDirector] convertToGL:[touch locationInView: [touch view]]];
    if (CGRectContainsPoint(contentRect_, touchLocation)) {
        //touchLocation in area, now try to detect is dragging or drag icon
        for (CCLabelTTF* label in virtualLayer.children) {
            CGRect cb = CGRectApplyAffineTransform(label.boundingBox, [virtualLayer nodeToParentTransform]);
            CGRect cb2 = CGRectApplyAffineTransform(cb, [self nodeToParentTransform]);
            if ( CGRectContainsPoint(cb2, touchLocation) ) {
                CCLOG(@"touch on label");
                return YES;
            }
        }
        CCLOG(@"finish search children but not found....");
        isDragging_ = YES;
    }
    return YES;
}

-(void) updateChildVisible:(CCNode*)ch
{
    CGRect cb = CGRectApplyAffineTransform(ch.boundingBox, [virtualLayer nodeToParentTransform]);
    CGRect cb2 = CGRectApplyAffineTransform(cb, [self nodeToParentTransform]);
    if (CGRectContainsRect(contentRect_, cb2)) {
        ch.visible = YES;
    }
    else {
        ch.visible = NO;
    }
}

- (void) ccTouchMoved:(UITouch*)touch withEvent:(UIEvent *)event {
    if (!isDragging_) return;
    CGPoint preLocation = [touch previousLocationInView:[touch view]];
    CGPoint curLocation = [touch locationInView:[touch view]];
    
    CGPoint a = [[CCDirector sharedDirector] convertToGL:preLocation];
    CGPoint b = [[CCDirector sharedDirector] convertToGL:curLocation];
    
    CGPoint nowPosition = self.position;
    
    if(slideDirection_ == Vertically) {
        float minY = 0;
        float maxY = (contentRect_.size.height) - self.contentSize.height;
        float delta = ( b.y - a.y );
        float deltaY = nowPosition.y + delta;
        if(deltaY < maxY || deltaY > minY) {
            delta *= 0.2;
        }
        nowPosition.y += delta;
    }
    else if(slideDirection_ == Horizontally) {
        float minX = 0;
        float maxX = (contentRect_.size.height) - self.contentSize.height;
        float delta = ( b.x - a.x );
        float deltaX = nowPosition.x + delta;
        if(deltaX < maxX || deltaX > minX) {
            delta *= 0.2;
        }
        nowPosition.x += delta;
    }
    [self setPosition:nowPosition];
    
    for (CCNode* item in virtualLayer.children) {
        [self updateChildVisible:item];
    }
    
}

- (void) ccTouchEnded:(UITouch*)touch withEvent:(UIEvent *)event {
    isDragging_ = NO;
}

@end
