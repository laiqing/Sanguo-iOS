//
//  ShareGameManager.m
//  sanguo
//
//  Created by lai qing on 15/1/27.
//  Copyright (c) 2015年 qing lai. All rights reserved.
//

#import "ShareGameManager.h"

NSString* const skillnames[] = {@"冶炼",@"土豪",@"伐木",@"伏兵",@"箭术",@"刺杀",@"强攻",@"砲术",@"沉着",@"冲锋",@"水神",@"助火",@"反制",@"残酷",@"驱散",@"医师",@"爆击",@"激怒",@"反馈",@"火计",@"火箭",@"治疗",@"威压",@"恐惧",@"铁壁",@"合击",@"诏书",@"雷击",@"机甲",@"仁义",@"迷魂",@"误导",@"解毒",@"毒术",@"雨天",@"援兵",@"反计",@"复仇",@"谣言",@"疾行",@"地道",@"治安",@"晴天",@"雷神",@"陷阱",@"群射",@"治水",@"水计"};

NSString* const trooptypes[] = {@"",@"步兵",@"弓兵",@"骑兵",@"策士",@"弩车"};

NSString* const citynames[] = {@"",@"酒泉",@"张掖",@"武威",@"西海",@"天水",@"陇西",@"汉中",@"巴西",@"梓潼",@"巴郡",@"广汉",@"成都",@"江阳",@"永安",@"江州",@"建宁",@"云南",@"交趾",@"郁林",@"扶风",@"京兆",@"长安",@"上庸",@"武陵",@"零陵",@"桂阳",@"苍梧",@"合浦",@"晋阳",@"平阳",@"弘农",@"襄阳",@"雁门",@"常山",@"洛阳",@"宛城",@"新野",@"江陵",@"长沙",@"南海",@"朱崖",@"上谷",@"范阳",@"代郡",@"邺城",@"巨鹿",@"河内",@"濮阳",@"颖川",@"许昌",@"陈留",@"汝南",@"寿春",@"江夏",@"庐江",@"柴桑",@"鄱阳",@"豫章",@"建安",@"庐陵",@"蓟城",@"渔阳",@"清河",@"泰山",@"平原",@"北平",@"辽西",@"襄平",@"乐浪",@"南皮",@"东莱",@"北海",@"小沛",@"琅邪",@"东海",@"徐州",@"下邳",@"广陵",@"建业",@"毗陵",@"吴郡",@"会稽",@"临海",@"夷州"};

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
    int result = 0;
    if (kingid==99) return result;
    
    NSString *rootpath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *curdb = [rootpath stringByAppendingPathComponent:@"current.db"];
    sqlite3* _database;
    sqlite3_open([curdb UTF8String], &_database);
    
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

-(NSArray*) selectHeroForDiaoDong:(int)king_id targetCityID:(int)cid
{
    NSMutableArray* herolist = [[[NSMutableArray alloc] init] autorelease];
    
    NSString *rootpath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *curdb = [rootpath stringByAppendingPathComponent:@"current.db"];
    sqlite3* _database;
    sqlite3_open([curdb UTF8String], &_database);

    sqlite3_stmt *statement;
    
    NSString* query = [NSString stringWithFormat:@"select id,cname,city,headImage,strength,intelligence,level,skill1,skill2,skill3,troopAttack,troopMental,troopType,troopCount from hero  where owner=%d and city<>%d",king_id,cid];
    if (sqlite3_prepare_v2(_database, [query UTF8String], -1, &statement, nil) == SQLITE_OK) {
        while (sqlite3_step(statement) == SQLITE_ROW) {
            int hid = (int) sqlite3_column_int(statement, 0);
            char *cname = (char *) sqlite3_column_text(statement, 1);
            NSString *cname2 = [[NSString alloc] initWithUTF8String:cname];
            int currentCity = (int) sqlite3_column_int(statement, 2);
            int headImageID = (int) sqlite3_column_int(statement, 3);
            int strength = (int) sqlite3_column_int(statement, 4);
            int intelligence = (int) sqlite3_column_int(statement, 5);
            int level = (int) sqlite3_column_int(statement, 6);
            int skill1 = (int) sqlite3_column_int(statement, 7);
            int skill2 = (int) sqlite3_column_int(statement, 8);
            int skill3 = (int) sqlite3_column_int(statement, 9);
            int tatt = (int) sqlite3_column_int(statement, 10);
            int tmental = (int) sqlite3_column_int(statement, 11);
            int ttype = (int) sqlite3_column_int(statement, 12);
            int tcount = (int) sqlite3_column_int(statement, 13);
            
            HeroObject* ho = [[HeroObject alloc] init];
            ho.cname = cname2;
            ho.heroID = hid;
            ho.cityID = currentCity;
            ho.headImageID = headImageID;
            ho.strength = strength;
            ho.intelligence = intelligence;
            ho.level = level;
            ho.skill1 = skill1;
            ho.skill2 = skill2;
            ho.skill3 = skill3;
            ho.troopAttack = tatt;
            ho.troopMental = tmental;
            ho.troopType = ttype;
            ho.troopCount = tcount;
            
            [herolist addObject:ho];
            
            
            
            [cname2 release];
        }
        
    }
    
    sqlite3_finalize(statement);
    
    sqlite3_close(_database);
    return herolist;
}

-(NSArray*) selectAllHeroForAttack:(int)king_id targetCityID:(int)cid
{
    NSMutableArray* herolist = [[[NSMutableArray alloc] init] autorelease];
    
    NSString *rootpath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *curdb = [rootpath stringByAppendingPathComponent:@"current.db"];
    sqlite3* _database;
    sqlite3_open([curdb UTF8String], &_database);
    
    sqlite3_stmt *statement;
    
    NSString* query = [NSString stringWithFormat:@"select id,cname,city,headImage,strength,intelligence,level,skill1,skill2,skill3,troopAttack,troopMental,troopType,troopCount from hero  where owner=%d",king_id];
    if (sqlite3_prepare_v2(_database, [query UTF8String], -1, &statement, nil) == SQLITE_OK) {
        while (sqlite3_step(statement) == SQLITE_ROW) {
            int hid = (int) sqlite3_column_int(statement, 0);
            char *cname = (char *) sqlite3_column_text(statement, 1);
            NSString *cname2 = [[NSString alloc] initWithUTF8String:cname];
            int currentCity = (int) sqlite3_column_int(statement, 2);
            int headImageID = (int) sqlite3_column_int(statement, 3);
            int strength = (int) sqlite3_column_int(statement, 4);
            int intelligence = (int) sqlite3_column_int(statement, 5);
            int level = (int) sqlite3_column_int(statement, 6);
            int skill1 = (int) sqlite3_column_int(statement, 7);
            int skill2 = (int) sqlite3_column_int(statement, 8);
            int skill3 = (int) sqlite3_column_int(statement, 9);
            int tatt = (int) sqlite3_column_int(statement, 10);
            int tmental = (int) sqlite3_column_int(statement, 11);
            int ttype = (int) sqlite3_column_int(statement, 12);
            int tcount = (int) sqlite3_column_int(statement, 13);
            
            HeroObject* ho = [[HeroObject alloc] init];
            ho.cname = cname2;
            ho.heroID = hid;
            ho.cityID = currentCity;
            ho.headImageID = headImageID;
            ho.strength = strength;
            ho.intelligence = intelligence;
            ho.level = level;
            ho.skill1 = skill1;
            ho.skill2 = skill2;
            ho.skill3 = skill3;
            ho.troopAttack = tatt;
            ho.troopMental = tmental;
            ho.troopType = ttype;
            ho.troopCount = tcount;
            
            [herolist addObject:ho];
            
            
            
            [cname2 release];
        }
        
    }
    
    sqlite3_finalize(statement);
    
    sqlite3_close(_database);
    return herolist;
}

-(void) saveGameToRecord:(int)recID
{
    NSString *rootpath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *curdb = [rootpath stringByAppendingPathComponent:@"current.db"];
    CCLOG(@"current db path:%@",curdb);
    
    NSString *f = [NSString stringWithFormat:@"save%d.db",recID];
    NSString *savefile = [rootpath stringByAppendingPathComponent:f];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:savefile isDirectory:NO]) {
        CCLOG(@"remove old save file....");
        [[NSFileManager defaultManager] removeItemAtPath:savefile error:nil];
    }
    [[NSFileManager defaultManager] createFileAtPath:curdb contents:nil attributes:nil];
    NSFileHandle *outFileHandle = [NSFileHandle fileHandleForWritingAtPath:savefile];//写管道
    NSFileHandle *inFileHandle = [NSFileHandle fileHandleForReadingAtPath:curdb];//读管道
    NSData *data =[inFileHandle readDataToEndOfFile];
    [outFileHandle writeData:data];
    [outFileHandle closeFile];
    [inFileHandle closeFile];
}


//---------------------------
//  the save file must exist, not check if it's exist here
//---------------------------
-(void) loadGameFromRecord:(int)recID
{
    NSString *rootpath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *curdb = [rootpath stringByAppendingPathComponent:@"current.db"];
    
    NSString *f = [NSString stringWithFormat:@"save%d.db",recID];
    NSString *savefile = [rootpath stringByAppendingPathComponent:f];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:savefile isDirectory:NO] == NO) {
        CCLOG(@"save file not exist....");
        return;
    }
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:curdb isDirectory:NO]) {
        CCLOG(@"remove curdb file....");
        [[NSFileManager defaultManager] removeItemAtPath:curdb error:nil];
    }
    
    [[NSFileManager defaultManager] createFileAtPath:curdb contents:nil attributes:nil];
    NSFileHandle *outFileHandle = [NSFileHandle fileHandleForWritingAtPath:curdb];//写管道
    NSFileHandle *inFileHandle = [NSFileHandle fileHandleForReadingAtPath:savefile];//读管道
    NSData *data =[inFileHandle readDataToEndOfFile];
    [outFileHandle writeData:data];
    [outFileHandle closeFile];
    [inFileHandle closeFile];
}

-(void) autoSaveCurrentDB
{
    NSString *rootpath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *curdb = [rootpath stringByAppendingPathComponent:@"current.db"];
    
    NSString *savefile = [rootpath stringByAppendingPathComponent:@"autosave.db"];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:savefile isDirectory:NO]) {
        CCLOG(@"save file removing....");
        [[NSFileManager defaultManager] removeItemAtPath:savefile error:nil];
        return;
    }
    
    [[NSFileManager defaultManager] createFileAtPath:curdb contents:nil attributes:nil];
    NSFileHandle *outFileHandle = [NSFileHandle fileHandleForWritingAtPath:savefile];//写管道
    NSFileHandle *inFileHandle = [NSFileHandle fileHandleForReadingAtPath:curdb];//读管道
    NSData *data =[inFileHandle readDataToEndOfFile];
    [outFileHandle writeData:data];
    [outFileHandle closeFile];
    [inFileHandle closeFile];
}


@end
