//
//  MRecipe.m
//  myRecepy
//
//  Created by Eduard Kantsevich on 1/7/13.
//  Copyright (c) 2013 Med. All rights reserved.
//

#import "MRecipe.h"



@implementation MRecipe

-(id) initWithName:(NSString*)name {
    self = [super init];
    if(self) {
        [self setName:[NSString stringWithString:name]];
    }
    return self;
}

-(id) initWithName:(NSString*)name Description:(NSString*)description {
    self = [super init];
    if(self) {
        [self setName:[NSString stringWithString:name]];
        self.Description = description;
    }
    return self;
}


-(id) initWithName:(NSString*)name FirstIngredient:(NSString*) firstIngredient {
    self = [super init];
    if(self) {
        [self setName:[NSString stringWithString:name]];
    }
    return self;
}

@end
