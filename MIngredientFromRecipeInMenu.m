//
//  MIngredientFromRecipeInMenu.m
//  myRecipeList
//
//  Created by Eduard Kantsevich on 3/9/13.
//  Copyright (c) 2013 Med. All rights reserved.
//

#import "MIngredientFromRecipeInMenu.h"

@implementation MIngredientFromRecipeInMenu

-(id) initWithIngredient:(MIngredientWithAmount*)ingredient RecipeMenuId:(NSInteger)recipeInMenuId RecipeIngredientId:(NSInteger)recipeIngredientId
{
    self = [super init];
    if(self) {
        [self setIngredient:ingredient];
        [self setRecipeIngredientId:recipeIngredientId];
        [self setRecipeMenuId:recipeInMenuId];
    }
    return self;
}

@end
