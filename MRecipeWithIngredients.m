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
    NSMutableArray* ingredients;
}
@end

@implementation MRecipeWithIngredients

// return non-muable version of curent list of ingredients
-(NSArray *) getCurrentIngredients {
    if(ingredients) {
        return [NSArray arrayWithArray:ingredients];
    }
    else {
        return nil;
    }
}

-(MIngredientWithAmount*) getIngredientAtIndex:(NSInteger) index {
    NSInteger length = [ingredients count];
    if(length <= index) {
        // no such index exists
        return nil;
    }
    else {
        return [ingredients objectAtIndex:index];
    }
}

-(NSInteger) getNumberOfIngridients {
    if(ingredients) {
        return [ingredients count];
    }
    else {
        return 0;
    }
}

-(void) addIngredient:(MIngredientWithAmount *)ingredient{
    if (ingredient == nil) {
        [NSException raise:@"Empty ingredient" format:@"Ingredient is empty"];
    }
    [ingredients addObject:ingredient];
}

-(void) removeIngredientWithIndex:(NSInteger)index {
    NSInteger length = [ingredients count];
    if(length <= index) {
        // no such index exists
    }
    else {
        [ingredients removeObjectAtIndex:index];
    }
}

@end
