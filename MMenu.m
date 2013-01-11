//
//  MMenu.m
//  myRecipeList
//
//  Created by Eduard Kantsevich on 1/11/13.
//  Copyright (c) 2013 Med. All rights reserved.
//

#import "MMenu.h"

@interface MMenu()
{
    NSMutableArray* recipies;

    NSMutableArray* toBuyIngredients;
    NSMutableArray* alreadyBoughtIngredients;
}
@end

@implementation MMenu

-(void) markIngredientAsBoughtWithId:(NSUUID*) Id {
    // implement via removeObjectIdenticalTo or turn NSMutableArray into NSDictionary?
}

-(void) markIngredientAsBoughtWithNotBoughtIndex:(NSInteger) Index {
    // this will need to be reimplemented if we turn NSMutableArray into NSDictionary
    NSUUID* Id = [toBuyIngredients objectAtIndex:Index];
    [toBuyIngredients removeObjectAtIndex:Index];
    [alreadyBoughtIngredients addObject:Id];
}

-(void) markInredientAsToBuyWithId:(NSUUID*) Id {
    // implement via removeObjectIdenticalTo or turn NSMutableArray into NSDictionary?    
}

-(void) markInredientAsToBuyWithIndex:(NSInteger) Index {
    // this will need to be reimplemented if we turn NSMutableArray into NSDictionary
    NSUUID* Id = [alreadyBoughtIngredients objectAtIndex:Index];
    [alreadyBoughtIngredients removeObjectAtIndex:Index];
    [toBuyIngredients addObject:Id];
}

-(void) addRecipe:(MRecepy*) recipeToAdd {
    if(recipeToAdd != nil) {
        [recipies addObject:recipeToAdd];
    }
}

-(NSArray *) getRecipies {
    return [NSArray arrayWithArray:recipies];
}

-(MRecepy *) getRecipeById:(NSUUID *)Id {
    if (Id != nil) {
        // this will need to be reimplemented if we turn NSMutableArray into NSDictionary
        return nil;
    }
    else {
        return nil;
    }
}

-(MRecepy *) getRecipeByIndex:(NSInteger)Index {
    return nil;
}

@end
