//
//  MRecipeWithIngredients.h
//  myRecipeList
//
//  Created by Eduard Kantsevich on 1/24/13.
//  Copyright (c) 2013 Med. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MRecipe.h"
#import "MIngredientWithAmount.h"

@interface MRecipeWithIngredients : NSObject

@property (strong, nonatomic) MRecipe* RecipeDetails;

-(id) initWithRecipeDetails:(MRecipe*) recipeDetails;

-(NSInteger) IngridientsCount;

-(NSArray *) Ingredients;
-(MIngredientWithAmount*) IngredientWithAmountAtIndex:(NSInteger) index;

-(void) addIngredient:(MIngredientWithAmount *)newIngredient;

-(void) removeIngredientWithIndex:(NSInteger)index;
@end
