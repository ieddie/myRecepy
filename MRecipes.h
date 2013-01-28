//
//  MRecipes.h
//  myRecipeList
//
//  Created by Eduard Kantsevich on 1/24/13.
//  Copyright (c) 2013 Med. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "sqlite3.h"
#import "MRecipe.h"
#import "MRecipeWithIngredients.h"
#import "MEnumerations.h"
#import "MDatabase.h"

@interface MRecipes : NSObject
+ (MRecipes *)Instance;

@property (readonly, strong, nonatomic) NSArray* currentRecipes;

- (MRecipeWithIngredients*) getRecipeWithIngredientForId:(NSInteger)recipeId;
- (MResultCode) addBlankRecipe:(MRecipe *) newRecipe;
- (MResultCode) addRecipeWithIngredients:(MRecipeWithIngredients *)newRecipeWithIngredients;
- (MResultCode) addIngredient:(MIngredientWithAmount *)newIngredient toRecipeWithId:(NSInteger) recipeId;
- (MResultCode) removeIngredientWithIndex:(NSInteger *)ingredientIndex fromRecipeWithId:(NSInteger) recipeId;

- (MResultCode) markRecipeAsFavorite:(NSInteger) recipeId;
- (MResultCode) unmarkRecipeAsFavorite:(NSInteger) recipeId;

@end
