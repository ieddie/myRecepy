//
//  MIngredientFromRecipeInMenu.h
//  myRecipeList
//
//  Created by Eduard Kantsevich on 3/9/13.
//  Copyright (c) 2013 Med. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MRecipe.h"
#import "MMenu.h"
#import "MIngredientWithAmount.h"

@interface MIngredientFromRecipeInMenu : NSObject

-(id) initWithIngredient:(MIngredientWithAmount*)ingredient RecipeMenuId:(NSInteger)recipeInMenuId RecipeIngredientId:(NSInteger)recipeIngredientId;

@property (strong, nonatomic) MIngredientWithAmount* Ingredient;
@property (nonatomic) int RecipeMenuId;
@property (nonatomic) int RecipeIngredientId;

@end
