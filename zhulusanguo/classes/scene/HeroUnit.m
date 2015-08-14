//
//  HeroUnit.m
//  zhulusanguo
//
//  Created by qing on 15/4/13.
//  Copyright 2015年 qing lai. All rights reserved.
//

#import "HeroUnit.h"


@implementation HeroUnit

-(void) initAll
{
    _ho = [[[ShareGameManager shareGameManager] getHeroInfoFromID:_heroID] retain];
    [self initArticleEffect];
    
}

-(void) initArticleEffect
{
    int article1 = _ho.article1;
    int article2 = _ho.article2;
    
    //select hero from db, get article1 and 2, get the effect
    
    NSString *rootpath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *curdb = [rootpath stringByAppendingPathComponent:@"current.db"];
    sqlite3* _database;
    sqlite3_open([curdb UTF8String], &_database);
    NSString* query;
    sqlite3_stmt *statement;
    
    if (article1 != 0) {
        query = [NSString stringWithFormat:@"select attack,hp,mp,attackRange,moveRange,multiAttack,doubleAttack from articleList where id=%d",article1];
        if (sqlite3_prepare_v2(_database, [query UTF8String], -1, &statement, nil) == SQLITE_OK) {
            if (sqlite3_step(statement) == SQLITE_ROW) {
                _articleAttackEffect += sqlite3_column_int(statement, 0);
                _articleHPEffect += sqlite3_column_int(statement, 1);
                _articleMPEffect += sqlite3_column_int(statement, 2);
                _articleAttackRangeEffect += sqlite3_column_int(statement, 3);
                _articleMoveEffect += sqlite3_column_int(statement, 4);
                _multiAttack += sqlite3_column_int(statement, 5);
                _doubleAttack += sqlite3_column_int(statement, 6);
            }
        }
        sqlite3_finalize(statement);
    }
    if (article2 != 0) {
        query = [NSString stringWithFormat:@"select attack,hp,mp,attackRange,moveRange,multiAttack,doubleAttack from articleList where id=%d",article2];
        if (sqlite3_prepare_v2(_database, [query UTF8String], -1, &statement, nil) == SQLITE_OK) {
            if (sqlite3_step(statement) == SQLITE_ROW) {
                _articleAttackEffect += sqlite3_column_int(statement, 0);
                _articleHPEffect += sqlite3_column_int(statement, 1);
                _articleMPEffect += sqlite3_column_int(statement, 2);
                _articleAttackRangeEffect += sqlite3_column_int(statement, 3);
                _articleMoveEffect += sqlite3_column_int(statement, 4);
                _multiAttack += sqlite3_column_int(statement, 5);
                _doubleAttack += sqlite3_column_int(statement, 6);
            }
        }
        sqlite3_finalize(statement);
    }
    
    sqlite3_close(_database);
    
}

-(TroopUnit*) initTroopUnit:(int)whichside
{
    int troopID = _ho.troopType;
    int troopAttack = _ho.troopAttack;
    int troopMental = _ho.troopMental;
    int troopCount = _ho.troopCount;
    TroopUnit* result = nil;
    if (whichside==1) {
        //allies
        switch (troopID) {
            case 1:
                result = [TroopUnit spriteWithSpriteFrameName:@"troop1_right_01.png"];
                break;
            case 2:
                result = [TroopUnit spriteWithSpriteFrameName:@"troop1_right_03.png"];
                break;
            case 3:
                result = [TroopUnit spriteWithSpriteFrameName:@"troop1_right_05.png"];
                break;
            case 4:
                result = [TroopUnit spriteWithSpriteFrameName:@"troop1_right_07.png"];
                break;
            case 5:
                result = [TroopUnit spriteWithSpriteFrameName:@"troop1_right_09.png"];
                break;
            default:
                break;
        }
        
    }
    else {
        //enemy bot
        switch (troopID) {
            case 1:
                result = [TroopUnit spriteWithSpriteFrameName:@"troop1_right_02.png"];
                result.flipX = YES;
                break;
            case 2:
                result = [TroopUnit spriteWithSpriteFrameName:@"troop1_right_04.png"];
                result.flipX = YES;
                break;
            case 3:
                result = [TroopUnit spriteWithSpriteFrameName:@"troop1_right_06.png"];
                result.flipX = YES;
                break;
            case 4:
                result = [TroopUnit spriteWithSpriteFrameName:@"troop1_right_08.png"];
                result.flipX = YES;
                break;
            case 5:
                result = [TroopUnit spriteWithSpriteFrameName:@"troop1_right_10.png"];
                result.flipX = YES;
                break;
            default:
                break;
        }
    }
    return result;
}

@end
