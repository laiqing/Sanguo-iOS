//
//  ShareGameManager.h
//  sanguo
//
//  Created by lai qing on 15/1/27.
//  Copyright (c) 2015年 qing lai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "cocos2d.h"
#import "SimpleAudioEngine.h"
#import "CityInfoObject.h"
#import "HeroObject.h"


#define AUDIO_MAX_WAITTIME 150

typedef enum {
    kAudioManagerUninitialized=0,
    kAudioManagerFailed=1,
    kAudioManagerInitializing=2,
    kAudioManagerInitialized=100,
    kAudioManagerLoading=200,
    kAudioManagerReady=300
    
} GameManagerSoundState;


@protocol MapHUDProtocol

-(void) popCityInfoWithCityID:(int)cid;
-(void) removePopCityInfo;

@end

extern NSString* const skillnames[];
extern NSString* const trooptypes[];
extern NSString* const citynames[];

@interface ShareGameManager : NSObject {
    BOOL hasAudioBeenInitialized;
    GameManagerSoundState managerSoundState;
    NSArray* musicname;
    
    
    int _selectedCityID; //this is used for when select city in the map
    
    int _gameDifficulty;
    int _kingID;
    
    int _gold;
    int _wood;
    int _iron;
}

+(ShareGameManager*) shareGameManager;

-(void)setupAudioEngine;
-(ALuint)playSoundEffect:(NSString*)soundEffectName;

-(void)stopSoundEffect:(ALuint)soundEffectID;
-(void)playBackgroundTrack:(NSString*)trackFileName;
-(void)playCurrentBackgroundTrack;
-(void)initAudioAsync; //此方法在setupAudioEngine里用线程异步调用

-(void) initDefaultAllAnimationInScene;



-(NSArray*) selectAllHero:(int)king_id; //return NSMutableArray , include heroobject[]

-(NSArray*) selectHeroForDiaoDong:(int)king_id targetCityID:(int)cid;

-(NSArray*) selectAllHeroForAttack:(int)king_id targetCityID:(int)cid;

-(void) initNewGameDBWithKingID:(int)king_id;

-(int) getTheCapitalCityWithKingID:(int)king_id;

-(CityInfoObject*) getCityInfoObjectFromID:(int)cityID;
-(int) getCityHeroCount:(int)cityID withKingID:(int)kingid;
-(int) getCityKingID:(int)cityID;

//-----------------------------------
//  save game , del game , load game
//-----------------------------------
-(void) saveGameToRecord:(int)recID;
-(void) loadGameFromRecord:(int)recID;
-(void) autoSaveCurrentDB;



//add UILabel to dialog in hudlayer
-(id)addLabelWithString:(NSString*)text dimension:(CGRect)rect normalColor:(UIColor*)nc highColor:(UIColor*)hc nrange:(NSString*)nr hrange:(NSString*)hr;


@property (assign) int selectedCityID;
@property (assign) int gameDifficulty;
@property (assign) int kingID;
@property (assign) int gold;
@property (assign) int wood;
@property (assign) int iron;


@end
