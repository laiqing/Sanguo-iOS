//
//  BattleHUDLayer.h
//  zhulusanguo
//
//  Created by qing on 15/3/26.
//  Copyright 2015年 qing lai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

#import "ShareGameManager.h"


//check every touch on this layer
// touch on the hero, self unit, grid in range, grid out range, skill menu, bot unit nearby, bot not nearby, tower nearby, tower not nearby, camp.

//current turn == self turn or bot turn.

//state , 1. hero not selected.
//        2.hero selected.
//        3. hero selected and not skill selected.
//        4. hero selected and move on execute.
//        5. hero selected and attack on execute.
//        6. hero selected and not move and skill on execute.
//        7. hero selected and skill selected.
//        8. hero selected and skill on execute.




@interface BattleHUDLayer : CCLayer {
    
}

@end
