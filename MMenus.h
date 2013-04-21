//
//  MMenus.h
//  myRecipeList
//
//  Created by Eduard Kantsevich on 3/6/13.
//  Copyright (c) 2013 Med. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MMenu.h"
#import "MRecipeWithIngredients.h"
#import "MDatabase.h"
#import "MIngredientFromRecipeInMenu.h"

@interface MMenus : NSObject

+(MMenus *)Instance;

-(NSArray*) AvailableMenus;

-(MMenu*) getMenu:(NSInteger) menuId;

-(void) addNewMenuWithName:(NSString *)name Desctiption:(NSString*)Description;
-(void) deleteMenuWithId:(NSInteger)menuId;

-(void) updateMenuWithId:(NSInteger)menuId SetNewName:(NSString *)name;
-(void) updateMenuWithId:(NSInteger)menuId SetNewDesctiption:(NSString*)Description;

-(void) addRecipe:(NSInteger)recipeIdToAdd ToMenu:(NSInteger)menuId;

-(NSArray*) getRecipesForMenuId:(NSInteger)menuId;
-(NSArray*) getRecipesNotInMenu:(NSInteger)menuId;

-(NSArray*) getBoughtIngredientsForMenuId:(NSInteger)menuId;
-(NSArray*) getNotBoughtIngredientsForMenuId:(NSInteger)menuId;

-(void) markAsBought:(BOOL)isBought RecipeIngredientId:(NSInteger)recipeIngredientId MenuRecipeId:(NSInteger)menuRecipeId;

@end
