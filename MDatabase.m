//
//  MDatabase.m
//  myRecipeList
//
//  Created by Eduard Kantsevich on 1/22/13.
//  Copyright (c) 2013 Med. All rights reserved.
//

#import "MDatabase.h"
#ifdef __APPLE__
    #include "TargetConditionals.h"
#endif

@implementation MDatabase

+ (NSString*) Path {
    NSString* path;
#if (TARGET_IPHONE_SIMULATOR)
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    path =[[bundle resourcePath] stringByAppendingPathComponent:@"Menus.sql"];
#else
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory , NSUserDomainMask, YES);
    NSString *documentsDir = [paths objectAtIndex:0];
    path = [documentsDir stringByAppendingPathComponent:@"Menus.sql"];
#endif
    //NSLog(@"Current db path: %@", path);
    return path;
}

+(sqlite3*) OpenDbConnection
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
