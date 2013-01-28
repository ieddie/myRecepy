//
//  MMeasurement.m
//  myRecipeList
//
//  Created by Eduard Kantsevich on 1/19/13.
//  Copyright (c) 2013 Med. All rights reserved.
//

#import "MMeasurement.h"

@implementation MMeasurement

- (id)initWithId:(NSInteger)ID Name:(NSString*)name
{
    self = [super init];
    if(self) {
        self.Id = ID;
        self.Name = name;
    }
    return self;
}
@end
