//
//  MIngredients.m
//  myRecipeList
//
//  Created by Eduard Kantsevich on 1/22/13.
//  Copyright (c) 2013 Med. All rights reserved.
//

#import "MIngredients.h"

@interface MIngredients()
@property (readwrite, strong, nonatomic) NSArray* availableIngredients;
@end

@implementation MIngredients

static MIngredients* sharedSingleton = nil;

static NSString *selectAllQuery = @"SELECT id, name FROM ingredients";
static NSString *insertNewQuery = @"Insert into ingredients (name) values (?)";
static NSString *updateExistingQuery = @"Update ingredients set name=? where id=?NNN";

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
        sqlite3* databaseLocal = [MDatabase OpenDbConnection];
        if(databaseLocal != nil)
        {
            int resultCode = [self readAllIngredientsfromDB:databaseLocal];
            sqlite3_close(databaseLocal);
            if(resultCode == SQLITE_OK) {
                return self;
            }
        }
    }
    return nil;
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
    self.availableIngredients = [NSArray arrayWithArray:allIngedients];
    
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
    sqlite3* databaseLocal = [MDatabase OpenDbConnection];
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

- (int) addNewIngredient:(NSString*)ingredientText ToDB:(sqlite3*)databaseLocal
{
    sqlite3_stmt *statement;
    
    int resultCode = sqlite3_prepare_v2(databaseLocal, [insertNewQuery UTF8String], -1, &statement, nil);
    if(resultCode != SQLITE_OK)
    {
        NSLog(@"Failed to prepare SQLite statement for add new ingredient. Error code %d", resultCode);
        return resultCode;
    }
    
    resultCode = sqlite3_bind_text(statement, 1, [ingredientText UTF8String], -1, SQLITE_TRANSIENT);
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

- (MResultCode) updateExistingIngredientAtId:(NSInteger)ingredientId withText:(NSString *)newIngredientName
{
    MResultCode result = GenericDBError;
    sqlite3* databaseLocal = [MDatabase OpenDbConnection];
    if(databaseLocal != nil)
    {
        int addResult = [self updateIngredientAtId:ingredientId WithText:newIngredientName InDB:databaseLocal];
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

- (int) updateIngredientAtId:(NSInteger)ingredientId WithText:(NSString*)ingredientText InDB:(sqlite3*)databaseLocal
{
    sqlite3_stmt *statement;
    
    int resultCode = sqlite3_prepare_v2(databaseLocal, [updateExistingQuery UTF8String], -1, &statement, nil);
    if(resultCode != SQLITE_OK)
    {
        NSLog(@"Failed to prepare SQLite statement for update existing ingredient. Error code %d", resultCode);
        return resultCode;
    }
    
    resultCode = sqlite3_bind_text(statement, 1, [ingredientText UTF8String], -1, SQLITE_TRANSIENT);
    if(resultCode != SQLITE_OK)
    {
        NSLog(@"Failed to bind the text parameter to SQLite statement for update ingredient. Error code %d", resultCode);
        return resultCode;
    }
    
    resultCode = sqlite3_bind_int(statement, 2, ingredientId);
    if(resultCode != SQLITE_OK)
    {
        NSLog(@"Failed to bind the text parameter to SQLite statement for update ingredient. Error code %d", resultCode);
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



@end
