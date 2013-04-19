//
//  MMeasurement.h
//  myRecipeList
//
//  Created by Eduard Kantsevich on 1/19/13.
//  Copyright (c) 2013 Med. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MMeasurement : NSObject

@property (nonatomic) NSInteger Id;
@property (nonatomic) NSString* Name;

- (id)initWithId:(NSInteger)ID;
- (id)initWithId:(NSInteger)ID Name:(NSString*)name;

@end
