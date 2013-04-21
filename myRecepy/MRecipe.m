//
//  MRecipe.m
//  myRecepy
//
//  Created by Eduard Kantsevich on 1/7/13.
//  Copyright (c) 2013 Med. All rights reserved.
//

#import "MRecipe.h"

@implementation MRecipe

-(id) initWithId:(NSInteger)Id Name:(NSString*)name Description:(NSString*)description IsFavorite:(NSInteger) isFavorite{
    self = [super init];
    if(self) {
        [self setId:Id];
        [self setName:[NSString stringWithString:name]];
        [self setDescription:[NSString stringWithString:description]];
        BOOL isFavoriteBool = TRUE;
        if (isFavorite != 1) {
            isFavoriteBool = FALSE;
        }
        [self setIsFavorite:isFavoriteBool];
    }
    return self;
}

-(id) initWithName:(NSString*)name Description:(NSString*)description IsFavorite:(NSInteger) isFavorite
{
    self = [super init];
    if(self) {
        [self setName:[NSString stringWithString:name]];
        [self setDescription:[NSString stringWithString:description]];
        BOOL isFavoriteBool = TRUE;
        if (isFavorite != 1) {
            isFavoriteBool = FALSE;
        }
        [self setIsFavorite:isFavoriteBool];
    }
    return self;
}

@end
