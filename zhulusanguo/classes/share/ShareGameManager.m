//
//  ShareGameManager.m
//  sanguo
//
//  Created by lai qing on 15/1/27.
//  Copyright (c) 2015年 qing lai. All rights reserved.
//

#import "ShareGameManager.h"

@implementation ShareGameManager

@synthesize gameDifficulty = _gameDifficulty;
@synthesize selectedCityID = _selectedCityID;
@synthesize kingID = _kingID;
@synthesize gold = _gold;
@synthesize wood = _wood;
@synthesize iron = _iron;

static id instance = nil;


+(ShareGameManager*)shareGameManager {
    @synchronized([ShareGameManager class]) {
        if (instance == nil) {
            instance = [[self alloc] init];
        }
    }
    return instance;
}

+(id)alloc {
    @synchronized([ShareGameManager class]) {
        NSAssert(instance==nil, @"ShareGameObjectManager singleton already exists...");
        instance = [super alloc];
        return instance;
    }
    return nil;
}

-(id) init
{
    if ((self = [super init])) {
        hasAudioBeenInitialized = NO;
        _gameDifficulty = 1;
        _kingID = -1;
        _selectedCityID = -1;
    }
    return self;
}

-(void)initAudioAsync {
    // Initializes the audio engine asynchronously
    managerSoundState = kAudioManagerInitializing;
    // Indicate that we are trying to start up the Audio Manager
    [CDSoundEngine setMixerSampleRate:CD_SAMPLE_RATE_MID];
    
    //Init audio manager asynchronously as it can take a few seconds
    //The FXPlusMusicIfNoOtherAudio mode will check if the user is
    // playing music and disable background music playback if
    // that is the case.
    [CDAudioManager initAsynchronously:kAMM_FxPlusMusicIfNoOtherAudio];
    
    //Wait for the audio manager to initialise
    while ([CDAudioManager sharedManagerState] != kAMStateInitialised)
    {
        [NSThread sleepForTimeInterval:0.1];
    }
    
    //At this point the CocosDenshion should be initialized
    // Grab the CDAudioManager and check the state
    CDAudioManager *audioManager = [CDAudioManager sharedManager];
    if (audioManager.soundEngine == nil ||
        audioManager.soundEngine.functioning == NO) {
        CCLOG(@"CocosDenshion failed to init, no audio will play.");
        managerSoundState = kAudioManagerFailed;
    } else {
        [audioManager setResignBehavior:kAMRBStopPlay autoHandle:YES];
        //soundEngine = [SimpleAudioEngine sharedEngine];
        managerSoundState = kAudioManagerReady;
        CCLOG(@"CocosDenshion is Ready");
        //[[SimpleAudioEngine sharedEngine] setEffectsVolume:0.2f];
        
    }
}

-(void)setupAudioEngine {
    if (hasAudioBeenInitialized == YES) {
        return;
    } else {
        hasAudioBeenInitialized = YES;
        NSOperationQueue *queue = [[NSOperationQueue new] autorelease];
        NSInvocationOperation *asyncSetupOperation =
        [[NSInvocationOperation alloc] initWithTarget:self
                                             selector:@selector(initAudioAsync)
                                               object:nil];
        [queue addOperation:asyncSetupOperation];
        [asyncSetupOperation autorelease];
    }
}

-(void)playCurrentBackgroundTrack
{
    
}

-(void)playBackgroundTrack:(NSString*)trackFileName {
    // Wait to make sure soundEngine is initialized
    if ((managerSoundState != kAudioManagerReady) &&
        (managerSoundState != kAudioManagerFailed)) {
        
        int waitCycles = 0;
        while (waitCycles < AUDIO_MAX_WAITTIME) {
            [NSThread sleepForTimeInterval:0.1f];
            if ((managerSoundState == kAudioManagerReady) ||
                (managerSoundState == kAudioManagerFailed)) {
                break;
            }
            waitCycles = waitCycles + 1;
        }
    }
    
    if (managerSoundState == kAudioManagerReady) {
        if ([[SimpleAudioEngine sharedEngine] isBackgroundMusicPlaying]) {
            [[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
        }
        //[[SimpleAudioEngine sharedEngine] preloadBackgroundMusic:trackFileName];
        [[SimpleAudioEngine sharedEngine] playBackgroundMusic:trackFileName loop:YES];
    }
}

-(void)stopSoundEffect:(ALuint)soundEffectID {
    if (managerSoundState == kAudioManagerReady) {
        [[SimpleAudioEngine sharedEngine] stopEffect:soundEffectID];
    }
}

-(ALuint)playSoundEffect:(NSString*)soundEffectName {
    ALuint soundID = 0;
    if (managerSoundState == kAudioManagerReady) {
        soundID = [[SimpleAudioEngine sharedEngine] playEffect:soundEffectName];
    }
    else {
        CCLOG(@"GameMgr: Sound Manager is not ready, cannot play %@", soundEffectName);
    }
    return soundID;
}

-(void) initDefaultAllAnimationInScene
{
    NSString *fn_noext = [NSString stringWithFormat:@"animate_all"];
    NSString *fn = [NSString stringWithFormat:@"animate_all.plist"];
    
    //从documents目录下进行查找plist
    NSString *rootpath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *plistpath = [rootpath stringByAppendingPathComponent:fn];
    //如果未找到，则从bundle里查找
    if (![[NSFileManager defaultManager] fileExistsAtPath:plistpath]) {
        plistpath = [[NSBundle mainBundle] pathForResource:fn_noext ofType:@"plist"];
    }
    NSDictionary *animationSettings = [NSDictionary dictionaryWithContentsOfFile:plistpath];
    //
    //NSString *key = [NSString stringWithFormat:@"%d",sceneID];
    NSString *key = @"10";
    NSArray *animationList = [animationSettings objectForKey:key];
    for (NSDictionary *ani in animationList) {
        NSString *animate_name = [ani objectForKey:@"animate_name"];
        NSString *filename = [ani objectForKey:@"filename"];
        NSString *fileext = [ani objectForKey:@"fileext"];
        float delay = [[ani objectForKey:@"delay"] floatValue];
        CCAnimation *an = [CCAnimation animation];
        NSString *animateFrames = [ani objectForKey:@"frames"];
        NSArray *animateArray = [animateFrames componentsSeparatedByString:@","];
        for (NSString *frameNumber in animateArray) {
            NSString *animateFileName = [NSString stringWithFormat:@"%@%@%@.png",filename,frameNumber,fileext];
            [an addSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:animateFileName]];
        }
        [an setDelayPerUnit:delay];
        [[CCAnimationCache sharedAnimationCache] addAnimation:an name:animate_name];
        //add to loading animate list
        //[loadingAnimateList addObject:[animate_name retain]];
    }
    
}

-(id) addLabelWithString:(NSString*)text dimension:(CGRect)rect normalColor:(UIColor*)nc highColor:(UIColor*)hc nrange:(NSString*)nr hrange:(NSString*)hr
{
    //get a smaller rect
    //CGRect labelRect = CGRectMake(rect.origin.x + rect.size.width*0.1 , rect.origin.y + rect.size.height*0.1, rect.size.width*1.8, rect.size.height*1.8);
    CGRect labelRect = CGRectMake(20, -30, rect.size.width, rect.size.height);
    CCLOG(@"addlabel in rect: %f,%f,%f,%f",labelRect.origin.x,labelRect.origin.y,labelRect.size.width,labelRect.size.height);
    
    //add a uilabel
    UILabel *label = [[[UILabel alloc] initWithFrame:labelRect] autorelease];
    label.font = [UIFont boldSystemFontOfSize:16];
    label.backgroundColor = [UIColor clearColor];
    label.lineBreakMode = NSLineBreakByWordWrapping;
    
    NSMutableAttributedString *ntxt = [[[NSMutableAttributedString alloc] initWithString:text] autorelease];
    
    //generate normal range
    NSArray *narray = [nr componentsSeparatedByString:@","];
    int nlen = (int)[narray count];
    for (int i=0; i<nlen; i+=2) {
        NSString* s1 = [narray objectAtIndex:i];
        NSString* s2 = [narray objectAtIndex:i+1];
        int st1 = [s1 intValue];
        int st2 = [s2 intValue];
        NSRange nr = NSMakeRange(st1, st2);
        [ntxt addAttribute:NSForegroundColorAttributeName value:nc range:nr];
    }
    
    NSArray *harray = [hr componentsSeparatedByString:@","];
    nlen = (int)[harray count];
    for (int i=0; i<nlen; i+=2) {
        NSString* s1 = [harray objectAtIndex:i];
        NSString* s2 = [harray objectAtIndex:i+1];
        int st1 = [s1 intValue];
        int st2 = [s2 intValue];
        NSRange hr = NSMakeRange(st1, st2);
        [ntxt addAttribute:NSForegroundColorAttributeName value:hc range:hr];
    }
    
    label.attributedText = ntxt;
    return label;
    
}

-(void) initNewGameDBWithKingID:(int)king_id
{
    //copy the sanguo.db from bundle to the document dir
    
    //copy the db to a new temp dbfile for save
    NSString* sfile = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"sanguo.db"];
    
    NSString *rootpath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *curdb = [rootpath stringByAppendingPathComponent:@"current.db"];
    CCLOG(@"current db path:%@",curdb);
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:curdb isDirectory:NO]) {
        CCLOG(@"current db is exist, now remove it....");
        [[NSFileManager defaultManager] removeItemAtPath:curdb error:nil];
    }
    [[NSFileManager defaultManager] createFileAtPath:curdb contents:nil attributes:nil];
    NSFileHandle *outFileHandle = [NSFileHandle fileHandleForWritingAtPath:curdb];//写管道
    NSFileHandle *inFileHandle = [NSFileHandle fileHandleForReadingAtPath:sfile];//读管道
    NSData *data =[inFileHandle readDataToEndOfFile];
    [outFileHandle writeData:data];
    [outFileHandle closeFile];
    [inFileHandle closeFile];
    
    
    sqlite3* _database;
    if (sqlite3_open([curdb UTF8String], &_database) != SQLITE_OK) {
        CCLOG(@"Failed to open database!");
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"发生错误"
                                  message:@"手机空间不足，无法创建游戏档案！"
                                  delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
        [alertView show];
        return;
    }
    
    //insert into db , player select king id , and difficulty
    
    sqlite3_stmt *statement;
    int initCityCount;
    
    NSTimeInterval nt = [[NSDate date] timeIntervalSince1970];
    NSString* savetime = [NSString stringWithFormat:@"%lf",nt];
    
    NSString* query = [NSString stringWithFormat:@"select gold,lumber,iron,cityCount from kingInit where kingid=%d",king_id];
    if (sqlite3_prepare_v2(_database, [query UTF8String], -1, &statement, nil) == SQLITE_OK) {
        sqlite3_step(statement);
        _gold = (int) sqlite3_column_int(statement, 0);
        _wood = (int) sqlite3_column_int(statement, 1);
        _iron = (int) sqlite3_column_int(statement, 2);
        initCityCount = (int) sqlite3_column_int(statement, 3);
        
    }
    sqlite3_finalize(statement);
    
    //insert into table playerInfo (kingID, year, month, day , savedate, gold, lumber, iron , inBattle 0, difficulty , cityCount)
    query = [NSString stringWithFormat:@"insert into playerInfo values(%d,189,1,1,'%@',%d,%d,%d,0,%d,%d",king_id,savetime,_gold,_wood,_iron,_gameDifficulty,initCityCount];
    sqlite3_exec(_database, [query UTF8String], nil, nil, nil);
    
    query = [NSString stringWithFormat:@"update city set tower1=1,tower2=1,tower3=1,tower4=1 where flag<>%d and flag<>99",king_id];
    sqlite3_exec(_database, [query UTF8String], nil, nil, nil);
    
    sqlite3_close(_database);

    
}

-(NSArray*) selectAllHero:(int)king_id
{
    return nil;
    
}


-(int) getTheCapitalCityWithKingID:(int)king_id
{
    NSString *rootpath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *curdb = [rootpath stringByAppendingPathComponent:@"current.db"];
    sqlite3* _database;
    sqlite3_open([curdb UTF8String], &_database);
    
    int result = 1;
    //insert into db , player select king id , and difficulty
    
    sqlite3_stmt *statement;
    
    NSString* query = [NSString stringWithFormat:@"select id from city where flag=%d and capital=1",king_id];
    if (sqlite3_prepare_v2(_database, [query UTF8String], -1, &statement, nil) == SQLITE_OK) {
        sqlite3_step(statement);
        result = (int) sqlite3_column_int(statement, 0);
    }
    sqlite3_finalize(statement);
    
    sqlite3_close(_database);
    
    return result;
}

-(int) getCityHeroCount:(int)cityID withKingID:(int)kingid
{
    NSString *rootpath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *curdb = [rootpath stringByAppendingPathComponent:@"current.db"];
    sqlite3* _database;
    sqlite3_open([curdb UTF8String], &_database);
    
    int result = 0;
    //insert into db , player select king id , and difficulty
    
    sqlite3_stmt *statement;
    
    NSString* query = [NSString stringWithFormat:@"select count(*) from hero where owner=%d and city=%d",kingid,cityID];
    if (sqlite3_prepare_v2(_database, [query UTF8String], -1, &statement, nil) == SQLITE_OK) {
        sqlite3_step(statement);
        result = (int) sqlite3_column_int(statement, 0);
    }
    sqlite3_finalize(statement);
    
    sqlite3_close(_database);
    
    return result;
}

-(int) getCityKingID:(int)cityID
{
    NSString *rootpath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *curdb = [rootpath stringByAppendingPathComponent:@"current.db"];
    sqlite3* _database;
    sqlite3_open([curdb UTF8String], &_database);
    
    int result = 0;
    //insert into db , player select king id , and difficulty
    
    sqlite3_stmt *statement;
    
    NSString* query = [NSString stringWithFormat:@"select flag from city where id=%d",cityID];
    if (sqlite3_prepare_v2(_database, [query UTF8String], -1, &statement, nil) == SQLITE_OK) {
        sqlite3_step(statement);
        result = (int) sqlite3_column_int(statement, 0);
    }
    sqlite3_finalize(statement);
    
    sqlite3_close(_database);
    
    return result;
}

-(CityInfoObject*) getCityInfoObjectFromID:(int)cityID
{
    NSString *rootpath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *curdb = [rootpath stringByAppendingPathComponent:@"current.db"];
    sqlite3* _database;
    sqlite3_open([curdb UTF8String], &_database);
    
    CityInfoObject* cio = [[[CityInfoObject alloc] init] autorelease];
    //insert into db , player select king id , and difficulty
    
    sqlite3_stmt *statement;
    
    NSString* query = [NSString stringWithFormat:@"select cname,level,warriorCount,archerCount,cavalryCount,wizardCount,ballistaCount from city  where id=%d",cityID];
    if (sqlite3_prepare_v2(_database, [query UTF8String], -1, &statement, nil) == SQLITE_OK) {
        sqlite3_step(statement);
        char *cname = (char *) sqlite3_column_text(statement, 0);
        NSString *cname2 = [[NSString alloc] initWithUTF8String:cname];
        int level = (int) sqlite3_column_int(statement, 1);
        int wc = (int) sqlite3_column_int(statement, 2);
        int ac = (int) sqlite3_column_int(statement, 3);
        int cc = (int) sqlite3_column_int(statement, 4);
        int wic = (int) sqlite3_column_int(statement, 5);
        int bc = (int) sqlite3_column_int(statement, 6);
        
        cio.cnName = cname2;
        cio.level = level;
        cio.warriorCount = wc;
        cio.archerCount = ac;
        cio.cavalryCount = cc;
        cio.wizardCount = wic;
        cio.ballistaCount = bc;
        
        CCLOG(@"GET city info from db: %d,%d,%d,%d,%d",wc,ac,cc,wic,bc);
        
    }
    sqlite3_finalize(statement);
    
    sqlite3_close(_database);
    
    return cio;
}


@end
