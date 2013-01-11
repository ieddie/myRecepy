//
//  MRecepy.h
//  myRecepy
//
//  Created by Eduard Kantsevich on 1/7/13.
//  Copyright (c) 2013 Med. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MIngredient.h"

@interface MRecepy : NSObject

-(id) initWithName:(NSString*)name;
-(id) initWithName:(NSString*)name Description:(NSString*)description;
-(id) initWithName:(NSString*)name FirstIngredient:(NSString*) firstIngredient;

@property (strong, nonatomic) NSUUID* Id;
@property (nonatomic) BOOL IsFavorite;
@property (strong, nonatomic) NSString* Name;
@property (strong, nonatomic) NSString* Description;

-(NSInteger) getNumberOfIngridients;

-(NSArray *) getCurrentIngredients;
-(MIngredient*) getIngredientAtIndex:(NSInteger) index;

-(void) addIngredient:(NSString *)ingredientText;

-(void) removeIngredientWithText:(NSString *)ingredientText;
-(void) removeIngredientWithIndex:(NSInteger)index;
@end
