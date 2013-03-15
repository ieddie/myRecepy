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
#import "MIngredient.h"

@interface MRecipes : NSObject
+ (MRecipes*)Instance;

- (NSArray*) AvailableRecipes;

- (MRecipeWithIngredients*) getRecipeWithIngredientsForId:(NSInteger)recipeId;

- (MResultCode) addNewRecipe:(MRecipe *)recipeToAdd;
- (BOOL) updateRecipe:(MRecipe*) recipeToUpdate;
- (BOOL) removeRecipe:(NSInteger)recipeToRemove;

- (MRecipeWithIngredients*) addIngredient:(MIngredientWithAmount *)newIngredient toRecipeWithId:(NSInteger) recipeId;
- (MRecipeWithIngredients*) removeIngredient:(MIngredientWithAmount*)ingredientToRemove fromRecipeWithId:(NSInteger) recipeId;

- (MResultCode) markRecipeAsFavorite:(NSInteger) recipeId;
- (MResultCode) unmarkRecipeAsFavorite:(NSInteger) recipeId;

@end
