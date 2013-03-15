//
//  MMenus.m
//  myRecipeList
//
//  Created by Eduard Kantsevich on 3/6/13.
//  Copyright (c) 2013 Med. All rights reserved.
//

#import "MMenus.h"

@implementation MMenus

static MMenus* sharedSingleton = nil;

static NSString *selectAllMenus = @"SELECT id, name, description FROM menus";
static NSString *selectMenuById = @"SELECT name, description FROM menus where id=?";
static NSString *insertNewMenu = @"Insert into menus (name, decription) values (?, ?)";

static NSString *updateNameMenu = @"Update menus set name=? where id=?";
static NSString *updateDescriptionMenu = @"Update menus set descrition=? where id=?";

static NSString *deleteMenu = @"Delete from menus where id=?";
static NSString *addRecipeToMenu = @"Insert into menu_recipes (menu, recipe) values (?, ?)";

static NSString *getRecipesNotInMenu = @"Select Id, Name, Description, IsFavorite from recipes where Id not in (Select distinct recipe from menu_recipes where menu=?)";

static NSString *getRecipesForMenu = @"Select r.Id, r.name, r.description, r.isFavorite from menu_recipes m_r JOIN recipes r on m_r.recipe = r.Id where m_r.menu=?";


static NSString *getIngredientForMenu = @"Select m.Id, m.Name, i.Id, i.Name, r_i.amount, m_r.id from shoppingList sl Join menu_recipes m_r on sl.menu_recipe=m_r.Id Join recipe_ingredient r_i on sl.recipe_ingredient=r_i.id Join measurements m on r_i.measurement=m join ingredients i on r_i.ingredient=i.id where sl.isBought=? and m_r.menu=?";

static NSString *markIngredientForMenu = @"Update shoppingList set isBought=? where menu_recipe=? and recipe_ingredient=?";

+ (MMenus *)Instance {
    if(sharedSingleton == nil)
    {
        sharedSingleton = [[MMenus alloc] initOnce];
    }
    return sharedSingleton;
}

- (id) initOnce
{
    self = [super init];
    // nothing else to do
    return self;
}

- (NSArray*) AvailableMenus
{
    sqlite3* databaseLocal = [MDatabase OpenDbConnection];
    if(databaseLocal == nil)
    {
        NSLog(@"%@", @"Couldn't open db connection to get all menus");
        return nil;
    }
    
    sqlite3_stmt *statement;
    int resultCode = sqlite3_prepare_v2(databaseLocal, [selectAllMenus UTF8String], -1, &statement, nil);
    if(resultCode != SQLITE_OK)
    {
        NSLog(@"Failed to prepare SQLite statement for get all menus. Error code %d", resultCode);
        return nil;
    }
    
    NSMutableArray* menus = [[NSMutableArray alloc] init];
    while (sqlite3_step(statement) == SQLITE_ROW)
    {
        int menuId = sqlite3_column_int(statement, 0);
        char* menuName = (char *)sqlite3_column_text(statement, 1);
        char* menuDescription = (char *)sqlite3_column_text(statement, 2);
        
        NSString *name = [[NSString alloc] initWithUTF8String:menuName];
        NSString *description = [[NSString alloc] initWithUTF8String:menuDescription];
        
        MMenu* menu = [[MMenu alloc] initWithId:menuId
                                           Name:name
                                    Description:description];
        [menus addObject:menu];
    }
    
    // finalize (close) the sqlite statement
    resultCode = sqlite3_finalize(statement);
    if(resultCode != SQLITE_OK)
    {
        // something went wrong during sql query
        NSLog(@"Error during fnilizing get all menus statement: %d", resultCode);
        return nil;
    }
    
    sqlite3_close(databaseLocal);
    return [NSArray arrayWithArray:menus];
}

-(MMenu*) getMenu:(NSInteger) menuId
{
    sqlite3* databaseLocal = [MDatabase OpenDbConnection];
    if(databaseLocal == nil)
    {
        NSLog(@"%@", @"Couldn't open db connection to get menu");
        return nil;
    }
    
    sqlite3_stmt *statement;
    
    int resultCode = sqlite3_prepare_v2(databaseLocal, [selectMenuById UTF8String], -1, &statement, nil);
    if(resultCode != SQLITE_OK)
    {
        NSLog(@"Failed to prepare SQLite statement for get menu. Error code %d", resultCode);
        return nil;
    }
    
    resultCode = sqlite3_bind_int(statement, 1, menuId);
    if(resultCode != SQLITE_OK)
    {
        NSLog(@"Failed to bind the parameter to SQLite statement for get menu. Error code %d", resultCode);
        return nil;
    }
    
    resultCode = sqlite3_step(statement);
    if(resultCode != SQLITE_ROW)
    {
        NSLog(@"No rows found in menus table that match menu Id %d. Result code %d", menuId, resultCode);
        return nil;
    }
    
    char* menuName = (char *)sqlite3_column_text(statement, 0);
    char* menuDescription = (char *)sqlite3_column_text(statement, 1);
    
    NSString *name = [[NSString alloc] initWithUTF8String:menuName];
    NSString *description = [[NSString alloc] initWithUTF8String:menuDescription];
    
    MMenu* menu = [[MMenu alloc] initWithId:menuId
                                       Name:name
                                Description:description];
    
    resultCode = sqlite3_step(statement);
    if(resultCode != SQLITE_DONE)
    {
        NSLog(@"More than one row available for get menu by Id %d. Result code %d", menuId, resultCode);
        return nil;
    }

    
    // finalize (close) the sqlite statement
    resultCode = sqlite3_finalize(statement);
    if(resultCode != SQLITE_OK)
    {
        // something went wrong during sql query
        NSLog(@"Error during fnilizing add new menu statement: %d", resultCode);
    }
    sqlite3_close(databaseLocal);
    return menu;
}

-(void) addNewMenuWithName:(NSString *)Name Desctiption:(NSString*)Description
{
    sqlite3* databaseLocal = [MDatabase OpenDbConnection];
    if(databaseLocal == nil)
    {
        NSLog(@"%@", @"Couldn't open db connection to get all menus");
        return;
    }
    
    sqlite3_stmt *statement;
    
    int resultCode = sqlite3_prepare_v2(databaseLocal, [insertNewMenu UTF8String], -1, &statement, nil);
    if(resultCode != SQLITE_OK)
    {
        NSLog(@"Failed to prepare SQLite statement for get all recipes. Error code %d", resultCode);
        return;
    }
    
    resultCode = sqlite3_bind_text(statement, 1, [Name UTF8String], -1, SQLITE_TRANSIENT);
    if(resultCode != SQLITE_OK)
    {
        NSLog(@"Failed to bind the parameter to SQLite statement for add new menu. Error code %d", resultCode);
        return;
    }
    resultCode = sqlite3_bind_text(statement, 2, [Description UTF8String], -1, SQLITE_TRANSIENT);
    if(resultCode != SQLITE_OK)
    {
        NSLog(@"Failed to bind the parameter to SQLite statement for add new menu. Error code %d", resultCode);
        return;
    }

    resultCode = sqlite3_step(statement);
    if(resultCode != SQLITE_DONE)
    {
        NSLog(@"Result code for execution of add new menu was %d", resultCode);
        return;
    }
    
    // finalize (close) the sqlite statement
    resultCode = sqlite3_finalize(statement);
    if(resultCode != SQLITE_OK)
    {
        // something went wrong during sql query
        NSLog(@"Error during fnilizing add new menu statement: %d", resultCode);
        return;
    }
    sqlite3_close(databaseLocal);
}

-(void) deleteMenuWithId:(NSInteger)menuId
{
    sqlite3* databaseLocal = [MDatabase OpenDbConnection];
    if(databaseLocal == nil)
    {
        NSLog(@"%@", @"Couldn't open db connection to delete menu");
        return;
    }
    
    sqlite3_stmt *statement;
    
    int resultCode = sqlite3_prepare_v2(databaseLocal, [deleteMenu UTF8String], -1, &statement, nil);
    if(resultCode != SQLITE_OK)
    {
        NSLog(@"Failed to prepare SQLite statement for delete recipes. Error code %d", resultCode);
        return;
    }
    
    resultCode = sqlite3_bind_int(statement, 1, menuId);
    if(resultCode != SQLITE_OK)
    {
        NSLog(@"Failed to bind the parameter to SQLite statement for delete menu. Error code %d", resultCode);
        return;
    }
    
    resultCode = sqlite3_step(statement);
    if(resultCode != SQLITE_DONE)
    {
        NSLog(@"Result code for execution of delete menu was %d", resultCode);
        return;
    }
    
    // finalize (close) the sqlite statement
    resultCode = sqlite3_finalize(statement);
    if(resultCode != SQLITE_OK)
    {
        // something went wrong during sql query
        NSLog(@"Error during fnilizing delete menu statement: %d", resultCode);
        return;
    }
    sqlite3_close(databaseLocal);
}

-(void) updateMenuWithId:(NSInteger)menuId SetNewName:(NSString *)name
{
    sqlite3* databaseLocal = [MDatabase OpenDbConnection];
    if(databaseLocal == nil)
    {
        NSLog(@"%@", @"Couldn't open db connection to update menu");
        return;
    }
    
    sqlite3_stmt *statement;
    
    int resultCode = sqlite3_prepare_v2(databaseLocal, [updateNameMenu UTF8String], -1, &statement, nil);
    if(resultCode != SQLITE_OK)
    {
        NSLog(@"Failed to prepare SQLite statement for update menu. Error code %d", resultCode);
        return;
    }
    
    resultCode = sqlite3_bind_text(statement, 1, [name UTF8String], -1, SQLITE_TRANSIENT);
    if(resultCode != SQLITE_OK)
    {
        NSLog(@"Failed to bind the parameter to SQLite statement for update menu. Error code %d", resultCode);
        return;
    }
    resultCode = sqlite3_bind_int(statement, 2, menuId);
    if(resultCode != SQLITE_OK)
    {
        NSLog(@"Failed to bind the parameter to SQLite statement for update menu. Error code %d", resultCode);
        return;
    }
    
    resultCode = sqlite3_step(statement);
    if(resultCode != SQLITE_DONE)
    {
        NSLog(@"Result code for execution of update menu was %d", resultCode);
        return;
    }
    
    // finalize (close) the sqlite statement
    resultCode = sqlite3_finalize(statement);
    if(resultCode != SQLITE_OK)
    {
        // something went wrong during sql query
        NSLog(@"Error during fnilizing update menu statement: %d", resultCode);
        return;
    }
    sqlite3_close(databaseLocal);
}

-(void) updateMenuWithId:(NSInteger)menuId SetNewDesctiption:(NSString*)Description
{
    sqlite3* databaseLocal = [MDatabase OpenDbConnection];
    if(databaseLocal == nil)
    {
        NSLog(@"%@", @"Couldn't open db connection to update menu");
        return;
    }
    
    sqlite3_stmt *statement;
    
    int resultCode = sqlite3_prepare_v2(databaseLocal, [updateDescriptionMenu UTF8String], -1, &statement, nil);
    if(resultCode != SQLITE_OK)
    {
        NSLog(@"Failed to prepare SQLite statement for update menu. Error code %d", resultCode);
        return;
    }
    
    resultCode = sqlite3_bind_text(statement, 1, [Description UTF8String], -1, SQLITE_TRANSIENT);
    if(resultCode != SQLITE_OK)
    {
        NSLog(@"Failed to bind the parameter to SQLite statement for update menu. Error code %d", resultCode);
        return;
    }
    resultCode = sqlite3_bind_int(statement, 2, menuId);
    if(resultCode != SQLITE_OK)
    {
        NSLog(@"Failed to bind the parameter to SQLite statement for update menu. Error code %d", resultCode);
        return;
    }
    
    resultCode = sqlite3_step(statement);
    if(resultCode != SQLITE_DONE)
    {
        NSLog(@"Result code for execution of update menu was %d", resultCode);
        return;
    }
    
    // finalize (close) the sqlite statement
    resultCode = sqlite3_finalize(statement);
    if(resultCode != SQLITE_OK)
    {
        // something went wrong during sql query
        NSLog(@"Error during fnilizing update menu statement: %d", resultCode);
        return;
    }
    sqlite3_close(databaseLocal);
}

-(void) addRecipe:(NSInteger)recipeIdToAdd ToMenu:(NSInteger)menuId
{
    sqlite3* databaseLocal = [MDatabase OpenDbConnection];
    if(databaseLocal == nil)
    {
        NSLog(@"%@", @"Couldn't open db connection to update menu");
        return;
    }
    
    sqlite3_stmt *statement;
    
    int resultCode = sqlite3_prepare_v2(databaseLocal, [addRecipeToMenu UTF8String], -1, &statement, nil);
    if(resultCode != SQLITE_OK)
    {
        NSLog(@"Failed to prepare SQLite statement for add recipe to menu. Error code %d", resultCode);
        return;
    }
    
    resultCode = sqlite3_bind_int(statement, 1, menuId);
    if(resultCode != SQLITE_OK)
    {
        NSLog(@"Failed to bind the parameter to SQLite statement for add recipe to menu. Error code %d", resultCode);
        return;
    }
    resultCode = sqlite3_bind_int(statement, 2, recipeIdToAdd);
    if(resultCode != SQLITE_OK)
    {
        NSLog(@"Failed to bind the parameter to SQLite statement for add recipe to menu. Error code %d", resultCode);
        return;
    }
    
    resultCode = sqlite3_step(statement);
    if(resultCode != SQLITE_DONE)
    {
        NSLog(@"Result code for execution of add recipe to menu was %d", resultCode);
        return;
    }
    
    // finalize (close) the sqlite statement
    resultCode = sqlite3_finalize(statement);
    if(resultCode != SQLITE_OK)
    {
        // something went wrong during sql query
        NSLog(@"Error during fnilizing add recipe to menu statement: %d", resultCode);
        return;
    }
    sqlite3_close(databaseLocal);
}

-(NSArray*) getRecipesForMenuId:(NSInteger)menuId
{
    sqlite3* databaseLocal = [MDatabase OpenDbConnection];
    if(databaseLocal == nil)
    {
        NSLog(@"%@", @"Couldn't open db connection to get recipe from menu");
        return nil;
    }
    
    sqlite3_stmt *statement;
    
    int resultCode = sqlite3_prepare_v2(databaseLocal, [getRecipesForMenu UTF8String], -1, &statement, nil);
    if(resultCode != SQLITE_OK)
    {
        NSLog(@"Failed to prepare SQLite statement for get recipe from menu. Error code %d", resultCode);
        return nil;
    }
    
    resultCode = sqlite3_bind_int(statement, 1, menuId);
    if(resultCode != SQLITE_OK)
    {
        NSLog(@"Failed to bind the parameter to SQLite statement for get recipe from  menu. Error code %d", resultCode);
        return nil;
    }
    
    NSMutableArray* recipes = [[NSMutableArray alloc] init];
    while (sqlite3_step(statement) == SQLITE_ROW)
    {
        int recipeId = sqlite3_column_int(statement, 0);
        char *recipeName = (char *)sqlite3_column_text(statement, 1);
        char *recipeDecription = (char *)sqlite3_column_text(statement, 2);
        int isFavoriteInt = sqlite3_column_int(statement, 3);
        
        NSString *name = [[NSString alloc] initWithUTF8String:recipeName];
        NSString *description = [[NSString alloc] initWithUTF8String:recipeDecription];
        
        MRecipe* recipe = [[MRecipe alloc] initWithId:recipeId
                                                 Name:name
                                          Description:description
                                           IsFavorite:isFavoriteInt];
        [recipes addObject:recipe];
    }
    
    // finalize (close) the sqlite statement
    resultCode = sqlite3_finalize(statement);
    if(resultCode != SQLITE_OK)
    {
        // something went wrong during sql query
        NSLog(@"Error during fnilizing get recipe from  menu statement: %d", resultCode);
        return nil;
    }
    sqlite3_close(databaseLocal);
    return [NSArray arrayWithArray:recipes];
}

-(NSArray*) getRecipesNotInMenu:(NSInteger)menuId
{
    sqlite3* databaseLocal = [MDatabase OpenDbConnection];
    if(databaseLocal == nil)
    {
        NSLog(@"%@", @"Couldn't open db connection to get recipe from menu");
        return nil;
    }
    
    sqlite3_stmt *statement;
    
    int resultCode = sqlite3_prepare_v2(databaseLocal, [getRecipesNotInMenu UTF8String], -1, &statement, nil);
    if(resultCode != SQLITE_OK)
    {
        NSLog(@"Failed to prepare SQLite statement for get recipe from menu. Error code %d", resultCode);
        return nil;
    }
    
    resultCode = sqlite3_bind_int(statement, 1, menuId);
    if(resultCode != SQLITE_OK)
    {
        NSLog(@"Failed to bind the parameter to SQLite statement for get recipe from  menu. Error code %d", resultCode);
        return nil;
    }
    
    NSMutableArray* recipes = [[NSMutableArray alloc] init];
    while (sqlite3_step(statement) == SQLITE_ROW)
    {
        int recipeId = sqlite3_column_int(statement, 0);
        char *recipeName = (char *)sqlite3_column_text(statement, 1);
        char *recipeDecription = (char *)sqlite3_column_text(statement, 2);
        int isFavoriteInt = sqlite3_column_int(statement, 3);
        
        NSString *name = [[NSString alloc] initWithUTF8String:recipeName];
        NSString *description = [[NSString alloc] initWithUTF8String:recipeDecription];
        
        MRecipe* recipe = [[MRecipe alloc] initWithId:recipeId
                                                 Name:name
                                          Description:description
                                           IsFavorite:isFavoriteInt];
        [recipes addObject:recipe];
    }
    
    // finalize (close) the sqlite statement
    resultCode = sqlite3_finalize(statement);
    if(resultCode != SQLITE_OK)
    {
        // something went wrong during sql query
        NSLog(@"Error during fnilizing get recipe from  menu statement: %d", resultCode);
        return nil;
    }
    sqlite3_close(databaseLocal);
    return [NSArray arrayWithArray:recipes];
}


-(NSArray*) getBoughtIngredientsForMenuId:(NSInteger)menuId
{
    return [self getIngredientsForMenu:menuId ThatAreBought:TRUE];
}

-(NSArray*) getNotBoughtIngredientsForMenuId:(NSInteger)menuId
{
    return [self getIngredientsForMenu:menuId ThatAreBought:FALSE];
}

-(NSArray*) getIngredientsForMenu:(NSInteger)menuId ThatAreBought:(BOOL) areBought
{
    sqlite3* databaseLocal = [MDatabase OpenDbConnection];
    if(databaseLocal == nil)
    {
        NSLog(@"%@", @"Couldn't open db connection to get recipe from menu");
        return nil;
    }
    
    sqlite3_stmt *statement;
    
    int resultCode = sqlite3_prepare_v2(databaseLocal, [getIngredientForMenu UTF8String], -1, &statement, nil);
    if(resultCode != SQLITE_OK)
    {
        NSLog(@"Failed to prepare SQLite statement for get ingredient fro menu bought/unbought. Error code %d", resultCode);
        return nil;
    }
    
    int areBoughtInt = areBought ? 1 : 0;
    resultCode = sqlite3_bind_int(statement, 1, areBoughtInt);
    resultCode = sqlite3_bind_int(statement, 2, menuId);
    if(resultCode != SQLITE_OK)
    {
        NSLog(@"Failed to bind the parameter to SQLite statement for get recipe from  menu. Error code %d", resultCode);
        return nil;
    }
    
    NSMutableArray* ingredientsFromRecipesInMenu = [[NSMutableArray alloc] init];
    while (sqlite3_step(statement) == SQLITE_ROW)
    {
        int measurementId = sqlite3_column_int(statement, 0);
        char *measurementName = (char *)sqlite3_column_text(statement, 1);
        
        int ingredientId = sqlite3_column_int(statement, 2);
        char* ingredientName = (char *)sqlite3_column_text(statement, 3);
        
        double amount = sqlite3_column_double(statement, 4);
        
        int menuRecipe = sqlite3_column_int(statement, 5);
        int recipeIngredient = sqlite3_column_int(statement, 5);
        
        NSString *IngredientName = [[NSString alloc] initWithUTF8String:ingredientName];
        NSString *MeasurementName = [[NSString alloc] initWithUTF8String:measurementName];
        
        MIngredient* ingredient = [[MIngredient alloc] initWithId:ingredientId Name:IngredientName];
        MMeasurement* measurement = [[MMeasurement alloc] initWithId:measurementId Name:MeasurementName];
        
        MIngredientWithAmount* ingredientWithAmount = [[MIngredientWithAmount alloc] initWithIngredient:ingredient
                                                                                                 Amount:amount
                                                                                            Measurement:measurement];
        
        MIngredientFromRecipeInMenu* ingredientFromRecipe = [[MIngredientFromRecipeInMenu alloc] initWithIngredient:ingredientWithAmount
                                                                                                       RecipeMenuId:menuRecipe
                                                                                                 RecipeIngredientId:recipeIngredient];
        
        [ingredientsFromRecipesInMenu addObject:ingredientFromRecipe];
    }
    
    // finalize (close) the sqlite statement
    resultCode = sqlite3_finalize(statement);
    if(resultCode != SQLITE_OK)
    {
        // something went wrong during sql query
        NSLog(@"Error during fnilizing get recipe from  menu statement: %d", resultCode);
        return nil;
    }
    sqlite3_close(databaseLocal);
    return [NSArray arrayWithArray:ingredientsFromRecipesInMenu];
}

-(void) markAsBought:(BOOL)isBought RecipeIngredientId:(NSInteger)recipeIngredientId MenuRecipeId:(NSInteger)menuRecipeId
{
    sqlite3* databaseLocal = [MDatabase OpenDbConnection];
    if(databaseLocal == nil)
    {
        NSLog(@"%@", @"Couldn't open db connection to mark ingredient in shopping list");
        return;
    }
    
    sqlite3_stmt *statement;
    
    int resultCode = sqlite3_prepare_v2(databaseLocal, [markIngredientForMenu UTF8String], -1, &statement, nil);
    if(resultCode != SQLITE_OK)
    {
        NSLog(@"Failed to prepare SQLite statement for mark ingredient in shopping list. Error code %d", resultCode);
        return;
    }
    
    int isBoughtInt = isBought ? 1 : 0;
    resultCode = sqlite3_bind_int(statement, 1, isBoughtInt);
    resultCode = sqlite3_bind_int(statement, 2, menuRecipeId);
    resultCode = sqlite3_bind_int(statement, 3, recipeIngredientId);
    if(resultCode != SQLITE_OK)
    {
        NSLog(@"Failed to bind the parameter to SQLite statement for mark ingredient in shopping list. Error code %d", resultCode);
        return;
    }
    
    resultCode = sqlite3_step(statement);
    if(resultCode != SQLITE_DONE)
    {
        NSLog(@"Result code for execution of mark ingredient in shopping list was %d", resultCode);
        return;
    }
    
    // finalize (close) the sqlite statement
    resultCode = sqlite3_finalize(statement);
    if(resultCode != SQLITE_OK)
    {
        // something went wrong during sql query
        NSLog(@"Error during fnilizing mark ingredient in shopping list statement: %d", resultCode);
        return;
    }
    sqlite3_close(databaseLocal);
}

@end
