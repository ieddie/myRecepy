//
//  MIngredients.m
//  myRecipeList
//
//  Created by Eduard Kantsevich on 1/22/13.
//  Copyright (c) 2013 Med. All rights reserved.
//

#import "MIngredients.h"

@interface MIngredients()
@property (readwrite, strong, nonatomic) NSArray* currentIngredients;
@end

@implementation MIngredients

static MIngredients* sharedSingleton = nil;

static NSString *selectAllQuery = @"SELECT id, name FROM ingredients";
static NSString *insertNewQuery = @"Insert into ingredients (name) values (?)";

+ (MIngredients *)Instance;
{
    if(sharedSingleton == nil)
    {
        sharedSingleton = [[MIngredients alloc] initOnce];
    }
    return sharedSingleton;
}

- (id) initOnce
{
    self = [super init];
    if(self) {
        sqlite3* databaseLocal = [self openDBConnection];
        if(databaseLocal != nil)
        {
            [self readAllIngredientsfromDB:databaseLocal];
        }
        sqlite3_close(databaseLocal);
    }
    return self;
}

- (int) readAllIngredientsfromDB:(sqlite3*) databaseLocal
{
    sqlite3_stmt *statement;
    
    int resultCode = sqlite3_prepare_v2(databaseLocal, [selectAllQuery UTF8String], -1, &statement, nil);
    if(resultCode != SQLITE_OK)
    {
        NSLog(@"Failed to prepare SQLite statement for get all measurements. Error code %d", resultCode);
        return resultCode;
    }
    
    // create an temporary array to hold incoming measurements
    NSMutableArray* allIngedients = [[NSMutableArray alloc]init];
    while (sqlite3_step(statement) == SQLITE_ROW)
    {
        int ingredientId = sqlite3_column_int(statement, 0);
        char *ingredientName = (char *)sqlite3_column_text(statement, 1);
        NSString *name = [[NSString alloc] initWithUTF8String:ingredientName];
        [allIngedients addObject:[[MIngredient alloc] initWithId:ingredientId Name:name]];
    }
    
    // now populate ivar with temporary array
    self.currentIngredients = [NSArray arrayWithArray:allIngedients];
    
    // finalize (close) the sqlite statement
    resultCode = sqlite3_finalize(statement);
    if(resultCode != SQLITE_OK)
    {
        // something went wrong during sql query
        NSLog(@"Error during fninlizing get all measurements statement: %d", resultCode);
    }
    return resultCode;
}

- (MResultCode) addNewIngredient:(NSString *) ingredientText
{
    MResultCode result = GenericDBError;
    sqlite3* databaseLocal = [self openDBConnection];
    if(databaseLocal != nil)
    {
        int addResult = [self addNewIngredient:ingredientText ToDB:databaseLocal];
        if(addResult != SQLITE_OK)
        {
            if(addResult == SQLITE_CONSTRAINT)
            {
                result = ContraintViolation;
            }
        }
        else
        {
            [self readAllIngredientsfromDB:databaseLocal];
            result = Success;
        }
    }
    sqlite3_close(databaseLocal);
    return result;
}

- (int) addNewIngredient:(NSString*)measurement ToDB:(sqlite3*)databaseLocal
{
    sqlite3_stmt *statement;
    
    int resultCode = sqlite3_prepare_v2(databaseLocal, [insertNewQuery UTF8String], -1, &statement, nil);
    if(resultCode != SQLITE_OK)
    {
        NSLog(@"Failed to prepare SQLite statement for add new ingredient. Error code %d", resultCode);
        return resultCode;
    }
    
    resultCode = sqlite3_bind_text(statement, 1, [measurement UTF8String], -1, SQLITE_TRANSIENT);
    if(resultCode != SQLITE_OK)
    {
        NSLog(@"Failed to bind the parameter to SQLite statement for add new ingredient. Error code %d", resultCode);
        return resultCode;
    }
    
    resultCode = sqlite3_step(statement);
    if(resultCode != SQLITE_DONE)
    {
        NSLog(@"Result code for execution of add new ingredient was %d", resultCode);
        return resultCode;
    }
    
    // finalize (close) the sqlite statement
    resultCode = sqlite3_finalize(statement);
    if(resultCode != SQLITE_OK)
    {
        // something went wrong during sql query
        NSLog(@"Error during finilizing add new ingredient statement: %d", resultCode);
    }
    return resultCode;
}

-(sqlite3*) openDBConnection
{
    sqlite3* database;
    NSInteger openCode = sqlite3_open([[MDatabase Path] UTF8String], &database);
    if (openCode != SQLITE_OK )
    {
        sqlite3_close(database);
        NSLog(@"Database failed to open. Error code %d", openCode);
        return nil;
    }
    return database;
}
@end
