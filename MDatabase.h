//
//  MDatabase.h
//  myRecipeList
//
//  Created by Eduard Kantsevich on 1/22/13.
//  Copyright (c) 2013 Med. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "sqlite3.h"

@interface MDatabase : NSObject
+ (NSString*) Path;
+ (NSString*) Name;
+ (sqlite3*) OpenDbConnection;

@end
