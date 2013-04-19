//
//  MRecipe.h
//  myRecepy
//
//  Created by Eduard Kantsevich on 1/7/13.
//  Copyright (c) 2013 Med. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MIngredient.h"

@interface MRecipe : NSObject

-(id) initWithName:(NSString*)name Description:(NSString*)description IsFavorite:(NSInteger) isFavorite;
-(id) initWithId:(NSInteger)Id Name:(NSString*)name Description:(NSString*)description IsFavorite:(NSInteger) isFavorite;

@property (nonatomic) NSInteger Id;
@property (nonatomic) BOOL IsFavorite;
@property (strong, nonatomic) NSString* Name;
@property (strong, nonatomic) NSString* Description;

@end
