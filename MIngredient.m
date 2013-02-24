//
//  MIngredient.m
//  myRecepy
//
//  Created by Eduard Kantsevich on 1/11/13.
//  Copyright (c) 2013 Med. All rights reserved.
//

#import "MIngredient.h"

@implementation MIngredient

- (id)initWithId:(NSInteger)ID Name:(NSString*)name {
    self = [super init];
    if(self) {
        self.Id = ID;
        self.Name = name;
    }
    return self;
}

@end
