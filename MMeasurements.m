//
//  MMeasurements.m
//  myRecipeList
//
//  Created by Eduard Kantsevich on 1/19/13.
//  Copyright (c) 2013 Med. All rights reserved.
//

#import "MMeasurements.h"
#import "MDatabase.h"

@interface MMeasurements()
@property (readwrite, strong, nonatomic) NSArray* currentMeasurements;
@end

@implementation MMeasurements

static MMeasurements* sharedSingleton = nil;

static NSString *selectAllQuery = @"SELECT id, name FROM measurements";
static NSString *insertNewQuery = @"Insert into measurements (name) values (?)";

+ (MMeasurements *)Instance {
    if(sharedSingleton == nil)
    {
        sharedSingleton = [[MMeasurements alloc] initOnce];
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
            [self readAllMeasurementsfromDB:databaseLocal];
        }
        sqlite3_close(databaseLocal);
    }
    return self;
}

- (int) readAllMeasurementsfromDB:(sqlite3*) databaseLocal
{
    sqlite3_stmt *statement;
    
    int resultCode = sqlite3_prepare_v2(databaseLocal, [selectAllQuery UTF8String], -1, &statement, nil);
    if(resultCode != SQLITE_OK)
    {
        NSLog(@"Failed to prepare SQLite statement for get all measurements. Error code %d", resultCode);
        return resultCode;
    }

    // create an temporary array to hold incoming measurements
    NSMutableArray* allMeasurements = [[NSMutableArray alloc]init];
    while (sqlite3_step(statement) == SQLITE_ROW)
    {
        int measurementId = sqlite3_column_int(statement, 0);
        char *measurementName = (char *)sqlite3_column_text(statement, 1);
        NSString *name = [[NSString alloc] initWithUTF8String:measurementName];
        [allMeasurements addObject:[[MMeasurement alloc] initWithId:measurementId Name:name]];
    }
    
    // now populate ivar with temporary array
    self.currentMeasurements = [NSArray arrayWithArray:allMeasurements];
    
    // finalize (close) the sqlite statement
    resultCode = sqlite3_finalize(statement);
    if(resultCode != SQLITE_OK)
    {
        // something went wrong during sql query
        NSLog(@"Error during fninlizing get all measurements statement: %d", resultCode);
    }
    return resultCode;
}

- (MResultCode) addNewMeasurement:(NSString *) measurement
{
    MResultCode result = GenericDBError;
    sqlite3* databaseLocal = [self openDBConnection];
    if(databaseLocal != nil)
    {
        int addResult = [self addNewMeasurement:measurement ToDB:databaseLocal];
        if(addResult != SQLITE_OK)
        {
            if(addResult == SQLITE_CONSTRAINT)
            {
                result = ContraintViolation;
            }
        }
        else
        {
            [self readAllMeasurementsfromDB:databaseLocal];
            result = Success;
        }
    }
    sqlite3_close(databaseLocal);
    return result;
}

- (int) addNewMeasurement:(NSString*)measurement ToDB:(sqlite3*)databaseLocal
{
    sqlite3_stmt *statement;
    
    int resultCode = sqlite3_prepare_v2(databaseLocal, [insertNewQuery UTF8String], -1, &statement, nil);
    if(resultCode != SQLITE_OK)
    {
        NSLog(@"Failed to prepare SQLite statement for add new measurements. Error code %d", resultCode);
        return resultCode;
    }
    
    resultCode = sqlite3_bind_text(statement, 1, [measurement UTF8String], -1, SQLITE_TRANSIENT);
    if(resultCode != SQLITE_OK)
    {
        NSLog(@"Failed to bind the parameter to SQLite statement for add new measurements. Error code %d", resultCode);
        return resultCode;
    }
    
    resultCode = sqlite3_step(statement);
    if(resultCode != SQLITE_DONE)
    {
        NSLog(@"Result code for execution of add new measument was %d", resultCode);
        return resultCode;
    }

    // finalize (close) the sqlite statement
    resultCode = sqlite3_finalize(statement);
    if(resultCode != SQLITE_OK)
    {
        // something went wrong during sql query
        NSLog(@"Error during finilizing add new measurements statement: %d", resultCode);
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
