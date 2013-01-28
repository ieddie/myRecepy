//
//  MDatabase.m
//  myRecipeList
//
//  Created by Eduard Kantsevich on 1/22/13.
//  Copyright (c) 2013 Med. All rights reserved.
//

#import "MDatabase.h"

@implementation MDatabase

+ (NSString*) Path {
    return [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Menus.sql"];
}

@end
