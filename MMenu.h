//
//  MMenu.h
//  myRecipeList
//
//  Created by Eduard Kantsevich on 1/11/13.
//  Copyright (c) 2013 Med. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MRecipe.h"

@interface MMenu : NSObject

-(void) addRecipe:(MRecepy*) recipeToAdd;

-(NSArray *) getRecipies;
-(MRecepy *) getRecipeById:(NSUUID *)Id;
-(MRecepy *) getRecipeByIndex:(NSInteger)Index;

-(void) markIngredientAsBoughtWithId:(NSUUID*) Id;
-(void) markIngredientAsBoughtWithNotBoughtIndex:(NSInteger) Index;

-(void) markInredientAsToBuyWithId:(NSUUID*) Id;
-(void) markInredientAsToBuyWithIndex:(NSInteger) Index;

@end
