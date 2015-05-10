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
#import "TipObject.h"
#import "ArticleObject.h"
#import "SkillDBObject.h"


#define AUDIO_MAX_WAITTIME 150

#define FRAME_RATE 60
#define BOUNCE_TIME 0.2f

//payment_text_tag used in diaodong layer and fight layer , when select hero or unselect hero, it will change cost text
#define PAYMENT_TEXT_TAG 9999

//tip text in city scene
#define TIP_SOLIDER_HEAD_TAG 2000
#define TIP_SOLIDER_SPEECH_BG_TAG 2001


#define BUILDING_HALL_ID 1
#define BUILDING_BARRACK_ID 2
#define BUILDING_ARCHER_ID 3
#define BUILDING_CAVALRY_ID 4
#define BUILDING_WIZARD_ID 5
#define BUILDING_BLACKSMITH_ID 6
#define BUILDING_LUMBERMILL_ID 7
#define BUILDING_STEELMILL_ID 8
#define BUILDING_MARKET_ID 9
#define BUILDING_MAGICTOWER_ID 10
#define BUILDING_TAVERN_ID 11


#define ARMY_TYPE_FOOTMAN 1
#define ARMY_TYPE_ARCHER 2
#define ARMY_TYPE_CAVALRY 3

#define ARMY_FRIEND_FOOTMAN 1
#define ARMY_FRIEND_ARCHER 2
#define ARMY_FRIEND_CAVALRY 3
#define ARMY_FRIEND_WIZARD 4
#define ARMY_FRIEND_BALLISTA 5
#define ARMY_FRIEND_HERO 6

#define ARMY_ENEMY_FOOTMAN 11
#define ARMY_ENEMY_ARCHER 12
#define ARMY_ENEMY_CAVALRY 13
#define ARMY_ENEMY_WIZARD 14
#define ARMY_ENEMY_BALLISTA 15
#define ARMY_ENEMY_HERO 16


typedef enum {
    kAudioManagerUninitialized=0,
    kAudioManagerFailed=1,
    kAudioManagerInitializing=2,
    kAudioManagerInitialized=100,
    kAudioManagerLoading=200,
    kAudioManagerReady=300
    
} GameManagerSoundState;

typedef enum{
    Vertically,
    Horizontally
} SlideDirection;

typedef enum{
    BounceDirectionGoingUp = 1,
    BounceDirectionStayingStill = 0,
    BounceDirectionGoingDown = -1,
    BounceDirectionGoingLeft = 2,
    BounceDirectionGoingRight = 3
} BounceDirection;


typedef enum {
    LayerNoDrag = 0,
    LeftLayerDrag = 1,
    RightLayerDrag = 2,
    DragSpriteFromLeftToRight = 3,
    DragSpriteFromRightToLeft = 4,
    DragSpriteFromRightToRight = 5
} LayerDragMode;


@protocol MapHUDProtocol

-(void) popCityInfoWithCityID:(int)cid;
-(void) removePopCityInfo;

@end


@protocol CityHUDProtocol

-(void) updateResourceLabel;
-(void) upgradeBuildAnimation:(int)buildID;


@end


extern NSString* const skillnames[];
extern NSString* const trooptypes[];
extern NSString* const citynames[];
extern NSString* const armytypes[];




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
    
    int _year;
    int _month;
    int _day;
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
//for the pop city info dialog
-(CityInfoObject*) getCityInfoObjectFromID:(int)cityID;
-(int) getCityHeroCount:(int)cityID withKingID:(int)kingid;
-(int) getCityKingID:(int)cityID;

-(int) calcHeroDiaoDongFeet:(int)heroID targetCityID:(int)tcid;

-(void) diaoDongHerolistToCity:(NSArray*)heroIDList targetCityID:(int)tcid;

//------------------
//for city scene
//------------------
-(CityInfoObject*) getCityInfoForCityScene:(int)cityID;
-(void) upgradeCityBuilding:(int)buildID withNewLevel:(int)lev withCityID:(int)cid withNewCityLevel:(int)nlev;
-(TipObject*) getRandomTip;

-(NSArray*) getHeroListFromCity:(int)cid kingID:(int)kid;
-(NSArray*) getArticleListFromCity:(int)cid;
-(ArticleObject*) getArticleDetailFromID:(int)aid;
-(HeroObject*) getHeroInfoFromID:(int)hid;

-(void) addArticleForID:(int)aid cityID:(int)cid;
-(void) removeArticleForID:(int)aid cityID:(int)cid;
-(void) removeArticleFromHero:(int)heroID cityID:(int)cid article:(int)aid articlePos:(int)posID;
-(void) updateHeroaddArticle:(int)heroID newArticle:(int)aid articlePos:(int)posID;

-(void) generateRandomMagicTower:(int)cityID towerLevel:(int)tlev;
-(void) heroLearnSkill:(int)heroID skill:(int)skillID skillPos:(int)skillPosID;


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

@property (assign) int year;
@property (assign) int month;
@property (assign) int day;


@end
