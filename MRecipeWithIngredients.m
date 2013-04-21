//
//  MRecipeWithIngredients.m
//  myRecipeList
//
//  Created by Eduard Kantsevich on 1/24/13.
//  Copyright (c) 2013 Med. All rights reserved.
//

#import "MRecipeWithIngredients.h"

@interface MRecipeWithIngredients ()
{
    NSMutableArray* ingredientsWithAmount;
}
@end

@implementation MRecipeWithIngredients

-(id) initWithRecipeDetails:(MRecipe *)recipeDetails
{
    self = [super init];
    if(self) {
        self.RecipeDetails = recipeDetails;
        self->ingredientsWithAmount = [[NSMutableArray alloc] init];
    }
    return self;
}


// return non-muable version of curent list of ingredients
-(NSArray *) Ingredients {
    if(ingredientsWithAmount) {
        return [NSArray arrayWithArray:ingredientsWithAmount];
    }
    else {
        return nil;
    }
}

-(MIngredientWithAmount*) IngredientWithAmountAtIndex:(NSInteger) index {
    NSInteger count = [ingredientsWithAmount count];
    if(count <= index) {
        // no such index exists
        return nil;
    }
    else {
        return (MIngredientWithAmount *)[ingredientsWithAmount objectAtIndex:index];
    }
}

-(NSInteger) IngridientsCount {
    if(ingredientsWithAmount) {
        return [ingredientsWithAmount count];
    }
    else {
        return 0;
    }
}

-(void) addIngredient:(MIngredientWithAmount *)ingredient{
    if (ingredient == nil) {
        [NSException raise:@"Empty ingredient" format:@"Ingredient is empty"];
    }
    [ingredientsWithAmount addObject:ingredient];
}

-(void) removeIngredientWithIndex:(NSInteger)index {
    NSInteger length = [ingredientsWithAmount count];
    if(length <= index) {
        // no such index exists
    }
    else {
        [ingredientsWithAmount removeObjectAtIndex:index];
    }
}

@end
