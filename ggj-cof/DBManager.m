//
//  DBManager.m
//  ggj-cof
//
//  Created by Sam Christian Lee on 3/17/14.
//  Copyright 2014 GroovyVision. All rights reserved.
//

#import "DBManager.h"
#import "ScoreMessage.h"

static DBManager *sharedInstance = nil;
static sqlite3 *database = nil;
static sqlite3_stmt *statement = nil;

@implementation DBManager

+(DBManager *)getSharedInstance {
    if (!sharedInstance) {
        sharedInstance = [[super allocWithZone:NULL]init];
        [sharedInstance createDB];
    }
    return sharedInstance;
}

-(BOOL)createDB {
    NSString *docsDir;
    NSArray *dirPaths;
    
    //Get the documents directory
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir = dirPaths[0];
    
    //Build path to database file
    databasePath = [[NSString alloc] initWithString:[docsDir stringByAppendingPathComponent:@"groovy_hungrycards.db"]];
    
    BOOL isSuccess = YES;
    NSFileManager *filemgr = [NSFileManager defaultManager];
    if ([filemgr fileExistsAtPath:databasePath] == NO)
    {
        const char *dbpath = [databasePath UTF8String];
        if (sqlite3_open(dbpath, &database) == SQLITE_OK)
        {
            char *errMsg;
            const char *sql_stmt_message = "CREATE TABLE IF NOT EXISTS scoreMessage(id integer primary key, lower_limit integer, upper_limit integer, message text)";
            const char *sql_stmt_board = "CREATE TABLE IF NOT EXISTS scoreBoard(id integer primary key autoincrement, score integer)";
            
            const char *sql_stmt_version = "CREATE TABLE IF NOT EXISTS cardsVersion(id integer primary key autoincrement, version integer)";
            
            if (sqlite3_exec(database, sql_stmt_message, NULL, NULL, &errMsg) != SQLITE_OK)
            {
                isSuccess = NO;
                CCLOG(@"DB Error: Failed to create table scoreMessage");
            }
            
            if (sqlite3_exec(database, sql_stmt_board, NULL, NULL, &errMsg) != SQLITE_OK)
            {
                isSuccess = NO;
                CCLOG(@"DB Error: Failed to create table scoreBoard");
            }
            
            if (sqlite3_exec(database, sql_stmt_version, NULL, NULL, &errMsg) != SQLITE_OK)
            {
                isSuccess = NO;
                CCLOG(@"DB Error: Failed to create table cardsVersion");
            }
            
            sqlite3_close(database);
            return isSuccess;
        }
        else {
            isSuccess = NO;
            CCLOG(@"DB Error: Failed to open/create database groovy_hungrycards");
        }
    }
    return isSuccess;
}

-(BOOL)createMessages {
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
        // delete messages first
        const char *sqlDeleteMessages = "DELETE FROM scoreMessage";
        sqlite3_stmt *deleteStatement = nil;
        sqlite3_prepare_v2(database, sqlDeleteMessages, -1, &deleteStatement, NULL);
        sqlite3_step(deleteStatement);
        
        const char *sqlStatement = "insert into scoreMessage (id, lower_limit, upper_limit, message) VALUES (?, ?, ?, ?)";

        if(sqlite3_prepare_v2(database, sqlStatement, -1, &statement, NULL) == SQLITE_OK)
        {
            sqlite3_bind_int(statement, 1, 1);
            sqlite3_bind_int(statement, 2, 0);
            sqlite3_bind_int(statement, 3, 2);
            sqlite3_bind_text(statement, 4, "amateur", -1, NULL);
            
            if (sqlite3_step(statement) == SQLITE_DONE) {
                sqlite3_reset(statement);
            }
            else {
                CCLOG(@"row insertion error");
            }
            
            sqlite3_bind_int(statement, 1, 2);
            sqlite3_bind_int(statement, 2, 3);
            sqlite3_bind_int(statement, 3, 5);
            sqlite3_bind_text(statement, 4, "getting lucky", -1, NULL);
            
            if (sqlite3_step(statement) == SQLITE_DONE) {
                sqlite3_reset(statement);
            }
            else {
                CCLOG(@"row insertion error");
            }
            
            sqlite3_bind_int(statement, 1, 3);
            sqlite3_bind_int(statement, 2, 6);
            sqlite3_bind_int(statement, 3, 10);
            sqlite3_bind_text(statement, 4, "guru", -1, NULL);
            
            if (sqlite3_step(statement) == SQLITE_DONE) {
                sqlite3_reset(statement);
            }
            else {
                CCLOG(@"row insertion error");
            }
        }
        sqlite3_reset(statement);
    }
    return NO;
}

-(BOOL)saveScore:(int)newScore {
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
        NSString *insertSQL = [NSString stringWithFormat:@"INSERT INTO scoreBoard (score) VALUES (%d)", newScore];
        const char *insert_stmt = [insertSQL UTF8String];
        sqlite3_prepare_v2(database, insert_stmt, -1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            return YES;
        }
        else {
            return NO;
        }
        sqlite3_reset(statement);
    }
    return NO;
}

-(NSMutableArray*)getTopScores:(int)topList {
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK) {
        NSString *querySQL = [NSString stringWithFormat:@"SELECT scoreBoard.score, scoreMessage.message FROM scoreBoard, scoreMessage WHERE scoreBoard.score >= scoreMessage.lower_limit AND scoreBoard.score <= scoreMessage.upper_limit ORDER BY scoreBoard.score DESC LIMIT %d", topList];

        const char *query_stmt = [querySQL UTF8String];
        NSMutableArray *resultArray = [[NSMutableArray alloc]init];
        
        if (sqlite3_prepare_v2(database, query_stmt, -1, &statement, NULL) == SQLITE_OK) {
            while (sqlite3_step(statement) == SQLITE_ROW) {
                ScoreMessage *scoreMessage = [[ScoreMessage alloc] init];
                scoreMessage.score = (int)sqlite3_column_int(statement, 0);
                scoreMessage.message = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 1)];
                [resultArray addObject:scoreMessage];
            }
            return resultArray;
            sqlite3_reset(statement);
        }
    }
    return nil;
}

@end
