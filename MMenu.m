//
//  MMenu.m
//  myRecipeList
//
//  Created by Eduard Kantsevich on 1/11/13.
//  Copyright (c) 2013 Med. All rights reserved.
//

#import "MMenu.h"

@implementation MMenu

-(id) initWithId:(NSInteger)Id Name:(NSString*)name Description:(NSString*)description
{
    self = [super init];
    if(self) {
        [self setId:Id];
        [self setName:[NSString stringWithString:name]];
        [self setDescription:[NSString stringWithString:description]];
    }
    return self;
}

@end
