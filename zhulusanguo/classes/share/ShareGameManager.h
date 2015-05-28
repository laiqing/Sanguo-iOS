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

#define SKILL_DETAIL_CARD_TAG 3000


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

#define TROOP_FOOTMAN_HP 20
#define TROOP_FOOTMAN_MP 16
#define TROOP_FOOTMAN_ATTACK 8
#define TROOP_FOOTMAN_MENTAL 6
#define TROOP_FOOTMAN_MOVE 4
#define TROOP_FOOTMAN_ATTACK_RANGE 1
#define TROOP_FOOTMAN_COST_GOLD 20
#define TROOP_FOOTMAN_COST_WOOD 0
#define TROOP_FOOTMAN_COST_IRON 0

#define TROOP_MENTAL_ATTACK_RANGE 3

#define TROOP_FOOTMAN_HP 20
#define TROOP_FOOTMAN_MP 16
#define TROOP_FOOTMAN_ATTACK 8
#define TROOP_FOOTMAN_MENTAL 6
#define TROOP_FOOTMAN_MOVE 4
#define TROOP_FOOTMAN_ATTACK_RANGE 1
#define TROOP_FOOTMAN_COST_GOLD 20
#define TROOP_FOOTMAN_COST_WOOD 0
#define TROOP_FOOTMAN_COST_IRON 0

#define TROOP_ARCHER_HP 25
#define TROOP_ARCHER_MP 20
#define TROOP_ARCHER_ATTACK 10
#define TROOP_ARCHER_MENTAL 10
#define TROOP_ARCHER_MOVE 5
#define TROOP_ARCHER_ATTACK_RANGE 3
#define TROOP_ARCHER_COST_GOLD 30
#define TROOP_ARCHER_COST_WOOD 1
#define TROOP_ARCHER_COST_IRON 0

#define TROOP_CAVALRY_HP 50
#define TROOP_CAVALRY_MP 30
#define TROOP_CAVALRY_ATTACK 15
#define TROOP_CAVALRY_MENTAL 8
#define TROOP_CAVALRY_MOVE 6
#define TROOP_CAVALRY_ATTACK_RANGE 1
#define TROOP_CAVALRY_COST_GOLD 100
#define TROOP_CAVALRY_COST_WOOD 2
#define TROOP_CAVALRY_COST_IRON 2

#define TROOP_WIZARD_HP 20
#define TROOP_WIZARD_MP 50
#define TROOP_WIZARD_ATTACK 5
#define TROOP_WIZARD_MENTAL 15
#define TROOP_WIZARD_MOVE 4
#define TROOP_WIZARD_ATTACK_RANGE 1
#define TROOP_WIZARD_COST_GOLD 80
#define TROOP_WIZARD_COST_WOOD 2
#define TROOP_WIZARD_COST_IRON 2

#define TROOP_BALLISTA_HP 100
#define TROOP_BALLISTA_MP 0
#define TROOP_BALLISTA_ATTACK 30
#define TROOP_BALLISTA_MENTAL 0
#define TROOP_BALLISTA_MOVE 3
#define TROOP_BALLISTA_ATTACK_RANGE 5
#define TROOP_BALLISTA_COST_GOLD 200
#define TROOP_BALLISTA_COST_WOOD 3
#define TROOP_BALLISTA_COST_IRON 3

// 12 * 2000 = 24000, 12*10 = 120 , 120  20*a + 30*b + 100*c + 80*d + 200*e <= 24000
//                                              b + 2c + 2d + 3e <= 120
//                                                  2c + 2d + 3e <= 120
//                                        max (a+b+c+d+e)



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

@protocol MoneyEffectProtocol

-(void) playMoneyEffectAtPos:(CGPoint)startPos;

@end


extern NSString* const skillnames[];
extern NSString* const trooptypes[];
extern NSString* const citynames[];
extern NSString* const armytypes[];
extern NSString* const articleForCitys[];
extern int const goldToWoodRate[];
extern int const goldToIronRate[];
extern int const woodToGoldRate[];
extern int const woodToIronRate[];
extern int const ironToGoldRate[];
extern int const ironToWoodRate[];






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
-(SkillDBObject*) getSkillInfoFromID:(int)skID;
-(NSArray*) getSkillListFromCity:(int)cityID;

-(void) heroRecruitTroop:(int)heroID newTroopCount:(int)nc;
-(void) updateHeroTroopCount:(int)hid1 withCount1:(int)c1 hero2:(int)hid2 withCount2:(int)c2 withTroopType:(int)tt;



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
