//
//  MRecipes.m
//  myRecipeList
//
//  Created by Eduard Kantsevich on 1/24/13.
//  Copyright (c) 2013 Med. All rights reserved.
//

#import "MRecipes.h"
#import "MMenus.h"

@interface MRecipes()
@property (readwrite, strong, nonatomic) NSMutableDictionary* allRecipesDictionary;
@end

@implementation MRecipes

static MRecipes* sharedSingleton = nil;

static NSString *selectAllQuery = @"SELECT id, name, description, isFavorite FROM recipes";

static NSString *insertNewQuery = @"Insert into recipes (name, decription, isFavorite) values (?, ?, ?)";

static NSString *updateQuery = @"Update recipes set name=?, Description=?, IsFavorite=? where id=?";
static NSString *updateNameQuery = @"Update recipes set name=? where id=?";
static NSString *updateDescritionQuery = @"Update recipes set Description=? where id=?";

static NSString *deleteQuery = @"Delete from recipes where id=?";

static NSString *AddIngredientQuery = @"Insert into recipe_ingredients (recipe, ingredient, measurement, amount) values (?, ?, ?, ?)";
static NSString *RemoveIngredientQuery = @"Delete from recipe_ingredients where recipe=? and ingredient=? and measurement=? and amount=?";

static NSString *changeFavoriteFlagQuery = @"Update recipes set isFavorite=? where Id=?";

static NSString *getIngredientsForRecipeQuery = @"Select ingr.Id, ingr.Name, meas.Id, meas.Name, r_i.amount from recipe_ingredients r_i JOIN Ingredients ingr on r_i.ingredient = ingr.Id JOIN Measurements meas on r_i.measurement = meas.Id where r_i.recipe = ?";

+ (MRecipes *)Instance {
    if(sharedSingleton == nil)
    {
        sharedSingleton = [[MRecipes alloc] initOnce];
    }
    return sharedSingleton;
}

- (id) initOnce
{
    self = [super init];
    if(self) {
        sqlite3* databaseLocal = [MDatabase OpenDbConnection];
        if(databaseLocal != nil)
        {
            [self readAllRecipesfromDB:databaseLocal];
        }
        sqlite3_close(databaseLocal);
    }
    return self;
}

- (NSArray*) AvailableRecipes
{
    NSMutableArray *mutableArray = [NSMutableArray arrayWithCapacity:self.allRecipesDictionary.count];
    for (NSString* key in self.allRecipesDictionary) {
        id item = [self.allRecipesDictionary objectForKey:key];
        [mutableArray addObject:item];
    }
    return [NSArray arrayWithArray:mutableArray];
}

- (MResultCode) readAllRecipesfromDB:(sqlite3*) databaseLocal
{
    sqlite3_stmt *statement;
    
    int resultCode = sqlite3_prepare_v2(databaseLocal, [selectAllQuery UTF8String], -1, &statement, nil);
    if(resultCode != SQLITE_OK)
    {
        NSLog(@"Failed to prepare SQLite statement for get all recipes. Error code %d", resultCode);
        return GenericDBError;
    }
    
    // create an temporary array to hold incoming measurements
    self.allRecipesDictionary = [NSMutableDictionary dictionary];
    while (sqlite3_step(statement) == SQLITE_ROW)
    {
        int recipeId = sqlite3_column_int(statement, 0);
        char *recipeName = (char *)sqlite3_column_text(statement, 1);
        char *recipeDecription = (char *)sqlite3_column_text(statement, 2);
        int isFavoriteInt = sqlite3_column_int(statement, 3);
        
        NSString *name = [[NSString alloc] initWithUTF8String:recipeName];
        NSString *description = [[NSString alloc] initWithUTF8String:recipeDecription];
        
        MRecipe* recipeMetadataToAdd = [[MRecipe alloc] initWithId:recipeId
                                                             Name:name
                                                      Description:description
                                                       IsFavorite:isFavoriteInt];
        [self.allRecipesDictionary setObject:recipeMetadataToAdd forKey:[NSNumber numberWithInt:recipeId]];
    }
    
        
    // finalize (close) the sqlite statement
    resultCode = sqlite3_finalize(statement);
    if(resultCode != SQLITE_OK)
    {
        // something went wrong during sql query
        NSLog(@"Error during fninlizing get all measurements statement: %d", resultCode);
        return GenericDBError;
    }
    return Success;
}

- (MRecipeWithIngredients*) getRecipeWithIngredientsForId:(NSInteger)recipeId {
    sqlite3* databaseLocal = [MDatabase OpenDbConnection];
    if(self.allRecipesDictionary == nil)
    {
        [self readAllRecipesfromDB:databaseLocal];
    }
    MRecipeWithIngredients* fullRecipe = [[MRecipeWithIngredients alloc] initWithRecipeDetails:[self.allRecipesDictionary objectForKey:[NSNumber numberWithInt:recipeId]]];
    
    // now need to look up the ingredients for this recipe
    int resultCode = [self getIngredientsForRecipe:&fullRecipe fromDB:databaseLocal];
    if(resultCode != Success)
    {
        // something went wrong, inform the user
    }
    sqlite3_close(databaseLocal);
    return fullRecipe;
}

- (MResultCode) getIngredientsForRecipe:(MRecipeWithIngredients**) recipeToAddIngredients fromDB:(sqlite3*) database
{
    sqlite3_stmt *statement;
    
    int resultCode = sqlite3_prepare_v2(database, [getIngredientsForRecipeQuery UTF8String], -1, &statement, nil);
    if(resultCode != SQLITE_OK)
    {
        NSLog(@"Failed to prepare SQLite statement for get ingredients for recipe. Error code %d", resultCode);
        return GenericDBError;
    }
    
    resultCode = sqlite3_bind_int(statement, 1, (*recipeToAddIngredients).RecipeDetails.Id);
    
    while (sqlite3_step(statement) == SQLITE_ROW)
    {
        int ingredientId = sqlite3_column_int(statement, 0);
        char *ingredientName = (char *)sqlite3_column_text(statement, 1);
        int measurementId = sqlite3_column_int(statement, 2);
        char *measurementName = (char *)sqlite3_column_text(statement, 3);
        double amount = sqlite3_column_double(statement, 4);
        NSString *IngredientName = [[NSString alloc] initWithUTF8String:ingredientName];
        NSString *MeasurementName = [[NSString alloc] initWithUTF8String:measurementName];
        
        MIngredient* ingredient = [[MIngredient alloc] initWithId:ingredientId Name:IngredientName];
        MMeasurement* measurement = [[MMeasurement alloc] initWithId:measurementId Name:MeasurementName];

        [(*recipeToAddIngredients) addIngredient:[[MIngredientWithAmount alloc] initWithIngredient:ingredient Amount:amount Measurement:measurement]];
    }
    
    // finalize (close) the sqlite statement
    resultCode = sqlite3_finalize(statement);
    if(resultCode != SQLITE_OK)
    {
        // something went wrong during sql query
        NSLog(@"Error during fninlizing get all measurements statement: %d", resultCode);
        return GenericDBError;
    }
    return Success;
}

- (MResultCode) addNewRecipe:(MRecipe *)newRecipe;
{
    MResultCode result = GenericDBError;
    sqlite3* databaseLocal = [MDatabase OpenDbConnection];
    if(databaseLocal != nil)
    {
        int addResult = [self addNewRecipe:newRecipe ToDB:databaseLocal];
        if(addResult != SQLITE_OK)
        {
            // something went wrong, inform the user
            if(addResult == SQLITE_CONSTRAINT)
            {
                result = ContraintViolation;
            }
        }
        else
        {
            if(self.allRecipesDictionary == nil)
            {
                [self readAllRecipesfromDB:databaseLocal];
            }
            else
            {
                // update the in-memory version with new recipe
                [self.allRecipesDictionary setObject:newRecipe forKey:[NSNumber numberWithInteger:newRecipe.Id]];
            }
            result = Success;
        }
    }
    sqlite3_close(databaseLocal);
    return result;
}

- (int) addNewRecipe:(MRecipe*)recipeToAdd ToDB:(sqlite3*)databaseLocal
{
    sqlite3_stmt *statement;
    
    int resultCode = sqlite3_prepare_v2(databaseLocal, [insertNewQuery UTF8String], -1, &statement, nil);
    if(resultCode != SQLITE_OK)
    {
        NSLog(@"Failed to prepare SQLite statement for add new recipe. Error code %d", resultCode);
        return resultCode;
    }
    
    int isFavoriteInt = recipeToAdd.IsFavorite ? 1 : 0;
    
    resultCode = sqlite3_bind_text(statement, 1, [recipeToAdd.Name UTF8String], -1, SQLITE_TRANSIENT);
    if(resultCode != SQLITE_OK)
    {
        NSLog(@"Failed to bind the parameter to SQLite statement for add new recipe. Error code %d", resultCode);
        return resultCode;
    }

    resultCode = sqlite3_bind_text(statement, 2, [recipeToAdd.Description UTF8String], -1, SQLITE_TRANSIENT);
    if(resultCode != SQLITE_OK)
    {
        NSLog(@"Failed to bind the parameter to SQLite statement for add new recipe. Error code %d", resultCode);
        return resultCode;
    }

    resultCode = sqlite3_bind_int(statement, 3, isFavoriteInt);
    if(resultCode != SQLITE_OK)
    {
        NSLog(@"Failed to bind the parameter to SQLite statement for add new recipe. Error code %d", resultCode);
        return resultCode;
    }
    
    resultCode = sqlite3_step(statement);
    if(resultCode != SQLITE_DONE)
    {
        NSLog(@"Result code for execution of add new recipe was %d", resultCode);
        return resultCode;
    }
    
    // finalize (close) the sqlite statement
    resultCode = sqlite3_finalize(statement);
    if(resultCode != SQLITE_OK)
    {
        // something went wrong during sql query
        NSLog(@"Error during finilizing add new recipe statement: %d", resultCode);
    }
    return resultCode;
}

- (BOOL) updateRecipe:(MRecipe*) recipeToUpdate
{
    MResultCode result = GenericDBError;
    sqlite3* databaseLocal = [MDatabase OpenDbConnection];
    if(databaseLocal != nil)
    {
        int addResult = [self UpdateRecipe:recipeToUpdate inDB:databaseLocal];
        if(addResult != SQLITE_OK)
        {
            // something went wrong, inform the user
        }
        else
        {
            if(self.allRecipesDictionary == nil)
            {
                [self readAllRecipesfromDB:databaseLocal];
            }
            else
            {
                // update the in-memory version with new recipe
                [self.allRecipesDictionary setObject:recipeToUpdate forKey:[NSNumber numberWithInteger:recipeToUpdate.Id]];
            }
            result = Success;
        }
    }
    sqlite3_close(databaseLocal);
    return result == Success;
}

- (BOOL) updateRecipeName:(NSString*) newName InRecipe:(NSInteger)recipeId
{
    MResultCode result = GenericDBError;
    sqlite3* databaseLocal = [MDatabase OpenDbConnection];
    if(databaseLocal != nil)
    {
        int addResult = [self UpdateRecipeName:newName forRecipeId:recipeId inDB:databaseLocal];
        if(addResult != SQLITE_OK)
        {
            // something went wrong, inform the user
        }
        else
        {
            if(self.allRecipesDictionary == nil)
            {
                [self readAllRecipesfromDB:databaseLocal];
            }
            else
            {
                MRecipe* recipeToUpdate = [self.allRecipesDictionary objectForKey:[NSNumber numberWithInteger:recipeId]];
                recipeToUpdate.Name = newName;
                [self.allRecipesDictionary setObject:recipeToUpdate forKey:[NSNumber numberWithInteger:recipeId]];
            }
            result = Success;
        }
    }
    sqlite3_close(databaseLocal);
    return result == Success;

}

- (BOOL) updateRecipeDescription:(NSString*) newDescription InRecipe:(NSInteger)recipeId
{
    MResultCode result = GenericDBError;
    sqlite3* databaseLocal = [MDatabase OpenDbConnection];
    if(databaseLocal != nil)
    {
        int addResult = [self UpdateRecipeDescription:newDescription forRecipeId:recipeId inDB:databaseLocal];
        if(addResult != SQLITE_OK)
        {
            // something went wrong, inform the user
        }
        else
        {
            if(self.allRecipesDictionary == nil)
            {
                [self readAllRecipesfromDB:databaseLocal];
            }
            else
            {
                MRecipe* recipeToUpdate = [self.allRecipesDictionary objectForKey:[NSNumber numberWithInteger:recipeId]];
                recipeToUpdate.Description = newDescription;
                [self.allRecipesDictionary setObject:recipeToUpdate forKey:[NSNumber numberWithInteger:recipeId]];
            }
            result = Success;
        }
    }
    sqlite3_close(databaseLocal);
    return result == Success;
}

- (int) UpdateRecipeName:(NSString*)newName forRecipeId:(NSInteger)recipeId inDB:(sqlite3*)databaseLocal
{
    sqlite3_stmt *statement;
    
    int resultCode = sqlite3_prepare_v2(databaseLocal, [updateNameQuery UTF8String], -1, &statement, nil);
    if(resultCode != SQLITE_OK)
    {
        NSLog(@"Failed to prepare SQLite statement for update recipe name. Error code %d", resultCode);
        return resultCode;
    }
    
    resultCode = sqlite3_bind_text(statement, 1, [newName UTF8String], -1, SQLITE_TRANSIENT);
    if(resultCode != SQLITE_OK)
    {
        NSLog(@"Failed to bind the parameter to SQLite statement for update recipe name. Error code %d", resultCode);
        return resultCode;
    }
    
    resultCode = sqlite3_bind_int(statement, 2, recipeId);
    if(resultCode != SQLITE_OK)
    {
        NSLog(@"Failed to bind the parameter to SQLite statement for update recipe name. Error code %d", resultCode);
        return resultCode;
    }
    
    resultCode = sqlite3_step(statement);
    if(resultCode != SQLITE_DONE)
    {
        NSLog(@"Result code for execution of update recipe name was %d", resultCode);
        return resultCode;
    }
    
    // finalize (close) the sqlite statement
    resultCode = sqlite3_finalize(statement);
    if(resultCode != SQLITE_OK)
    {
        // something went wrong during sql query
        NSLog(@"Error during finilizing update recipe name statement: %d", resultCode);
    }
    return resultCode;
}

- (int) UpdateRecipeDescription:(NSString*)newDescription forRecipeId:(NSInteger)recipeId inDB:(sqlite3*)databaseLocal
{
    sqlite3_stmt *statement;
    
    int resultCode = sqlite3_prepare_v2(databaseLocal, [updateDescritionQuery UTF8String], -1, &statement, nil);
    if(resultCode != SQLITE_OK)
    {
        NSLog(@"Failed to prepare SQLite statement for update recipe description. Error code %d", resultCode);
        return resultCode;
    }
    
    resultCode = sqlite3_bind_text(statement, 1, [newDescription UTF8String], -1, SQLITE_TRANSIENT);
    if(resultCode != SQLITE_OK)
    {
        NSLog(@"Failed to bind the parameter to SQLite statement for update recipe description. Error code %d", resultCode);
        return resultCode;
    }
    
    resultCode = sqlite3_bind_int(statement, 2, recipeId);
    if(resultCode != SQLITE_OK)
    {
        NSLog(@"Failed to bind the parameter to SQLite statement for update recipe description. Error code %d", resultCode);
        return resultCode;
    }
    
    resultCode = sqlite3_step(statement);
    if(resultCode != SQLITE_DONE)
    {
        NSLog(@"Result code for execution of update recipe description was %d", resultCode);
        return resultCode;
    }
    
    // finalize (close) the sqlite statement
    resultCode = sqlite3_finalize(statement);
    if(resultCode != SQLITE_OK)
    {
        // something went wrong during sql query
        NSLog(@"Error during finilizing update recipe description statement: %d", resultCode);
    }
    return resultCode;
}



- (int) UpdateRecipe:(MRecipe*)recipeToUpdate inDB:(sqlite3*)databaseLocal
{
    sqlite3_stmt *statement;
    
    int resultCode = sqlite3_prepare_v2(databaseLocal, [updateQuery UTF8String], -1, &statement, nil);
    if(resultCode != SQLITE_OK)
    {
        NSLog(@"Failed to prepare SQLite statement for update recipe. Error code %d", resultCode);
        return resultCode;
    }
    
    int isFavoriteInt = recipeToUpdate.IsFavorite ? 1 : 0;
    
    resultCode = sqlite3_bind_text(statement, 1, [recipeToUpdate.Name UTF8String], -1, SQLITE_TRANSIENT);
    if(resultCode != SQLITE_OK)
    {
        NSLog(@"Failed to bind the parameter to SQLite statement for update recipe. Error code %d", resultCode);
        return resultCode;
    }
    
    resultCode = sqlite3_bind_text(statement, 2, [recipeToUpdate.Description UTF8String], -1, SQLITE_TRANSIENT);
    if(resultCode != SQLITE_OK)
    {
        NSLog(@"Failed to bind the parameter to SQLite statement for update recipe. Error code %d", resultCode);
        return resultCode;
    }
    
    resultCode = sqlite3_bind_int(statement, 3, isFavoriteInt);
    if(resultCode != SQLITE_OK)
    {
        NSLog(@"Failed to bind the parameter to SQLite statement for update recipe. Error code %d", resultCode);
        return resultCode;
    }
    
    resultCode = sqlite3_bind_int(statement, 4, recipeToUpdate.Id);
    if(resultCode != SQLITE_OK)
    {
        NSLog(@"Failed to bind the parameter to SQLite statement for update recipe. Error code %d", resultCode);
        return resultCode;
    }
    
    resultCode = sqlite3_step(statement);
    if(resultCode != SQLITE_DONE)
    {
        NSLog(@"Result code for execution of update recipe was %d", resultCode);
        return resultCode;
    }
    
    // finalize (close) the sqlite statement
    resultCode = sqlite3_finalize(statement);
    if(resultCode != SQLITE_OK)
    {
        // something went wrong during sql query
        NSLog(@"Error during finilizing update recipe statement: %d", resultCode);
    }
    return resultCode;
}

- (BOOL) removeRecipe:(NSInteger)recipeId
{
    BOOL result = FALSE;
    sqlite3* databaseLocal = [MDatabase OpenDbConnection];
    if(databaseLocal != nil)
    {
        if([self DeleteRecipeWithId:recipeId inDB:databaseLocal] != SQLITE_OK)
        {
            // something went wrong, inform the user
        }
        else
        {
            if(self.allRecipesDictionary == nil)
            {
                [self readAllRecipesfromDB:databaseLocal];
            }
            result = TRUE;
        }
    }
    sqlite3_close(databaseLocal);
    return result;
}
- (int) DeleteRecipeWithId:(NSInteger)recipeId inDB:(sqlite3*)databaseLocal
{
    sqlite3_stmt *statement;
    
    int resultCode = sqlite3_prepare_v2(databaseLocal, [updateQuery UTF8String], -1, &statement, nil);
    if(resultCode != SQLITE_OK)
    {
        NSLog(@"Failed to prepare SQLite statement for delete recipe. Error code %d", resultCode);
        return resultCode;
    }
    
    resultCode = sqlite3_bind_int(statement, 1, recipeId);
    if(resultCode != SQLITE_OK)
    {
        NSLog(@"Failed to bind the parameter to SQLite statement for delete recipe. Error code %d", resultCode);
        return resultCode;
    }
    
    resultCode = sqlite3_step(statement);
    if(resultCode != SQLITE_DONE)
    {
        NSLog(@"Result code for execution of delete recipe was %d", resultCode);
        return resultCode;
    }
    
    // finalize (close) the sqlite statement
    resultCode = sqlite3_finalize(statement);
    if(resultCode != SQLITE_OK)
    {
        // something went wrong during sql query
        NSLog(@"Error during finilizing delete recipe statement: %d", resultCode);
    }
    return resultCode;
}


- (MRecipeWithIngredients*) addIngredient:(MIngredientWithAmount *)newIngredient toRecipeWithId:(NSInteger) recipeId
{
    MRecipeWithIngredients* result = nil;
    sqlite3* databaseLocal = [MDatabase OpenDbConnection];
    if(databaseLocal != nil)
    {
        int addResult = [self addIngredient:newIngredient toRecipeWithId:recipeId inDB:databaseLocal];
        if(addResult != SQLITE_OK)
        {
            // something went wrong, inform the user
        }
        else
        {
            MRecipe* recipe = [self.allRecipesDictionary objectForKey:[NSNumber numberWithInt:recipeId]];
            MRecipeWithIngredients* fullRecipe = [[MRecipeWithIngredients alloc] init];
            fullRecipe.RecipeDetails = recipe;
            
            // now need to look up the ingredients for this recipe
            if([self getIngredientsForRecipe:&fullRecipe fromDB:databaseLocal] != Success)
            {
                // something went wrong, inform the user
            }
        }
    }
    sqlite3_close(databaseLocal);
    return result;
}
- (int) addIngredient:(MIngredientWithAmount*)ingredientToAdd toRecipeWithId:(NSInteger) recipeId inDB:(sqlite3*)databaseLocal
{
    sqlite3_stmt *statement;
    
    int resultCode = sqlite3_prepare_v2(databaseLocal, [AddIngredientQuery UTF8String], -1, &statement, nil);
    if(resultCode != SQLITE_OK)
    {
        NSLog(@"Failed to prepare SQLite statement for add ingredient to update recipe. Error code %d", resultCode);
        return resultCode;
    }
    
    resultCode = sqlite3_bind_int(statement, 1, recipeId);
    if(resultCode != SQLITE_OK)
    {
        NSLog(@"Failed to bind the parameter to SQLite statement for add ingredient to recipe. Error code %d", resultCode);
        return resultCode;
    }
    
    resultCode = sqlite3_bind_int(statement, 2, ingredientToAdd.Ingredient.Id);
    if(resultCode != SQLITE_OK)
    {
        NSLog(@"Failed to bind the parameter to SQLite statement for add ingredient to recipe. Error code %d", resultCode);
        return resultCode;
    }
    
    resultCode = sqlite3_bind_int(statement, 3, ingredientToAdd.Measurement.Id);
    if(resultCode != SQLITE_OK)
    {
        NSLog(@"Failed to bind the parameter to SQLite statement for add ingredient to recipe. Error code %d", resultCode);
        return resultCode;
    }
    
    resultCode = sqlite3_bind_double(statement, 4, ingredientToAdd.Amount);
    if(resultCode != SQLITE_OK)
    {
        NSLog(@"Failed to bind the parameter to SQLite statement for add ingredient to recipe. Error code %d", resultCode);
        return resultCode;
    }
    
    resultCode = sqlite3_step(statement);
    if(resultCode != SQLITE_DONE)
    {
        NSLog(@"Result code for execution of add ingredient to recipe was %d", resultCode);
        return resultCode;
    }
    
    // finalize (close) the sqlite statement
    resultCode = sqlite3_finalize(statement);
    if(resultCode != SQLITE_OK)
    {
        // something went wrong during sql query
        NSLog(@"Error during finilizing add ingredient to recipe statement: %d", resultCode);
    }
    return resultCode;
}

- (MRecipeWithIngredients*) removeIngredient:(MIngredientWithAmount *)ingredientToRemove fromRecipeWithId:(NSInteger)recipeId
{
    MRecipeWithIngredients* result = nil;
    sqlite3* databaseLocal = [MDatabase OpenDbConnection];
    if(databaseLocal != nil)
    {
        if([self removeIngredient:ingredientToRemove fromRecipeId:recipeId inDB:databaseLocal] != SQLITE_OK)
        {
            // something went wrong, inform the user
        }
        else
        {
            MRecipe* recipe = [self.allRecipesDictionary objectForKey:[NSNumber numberWithInt:recipeId]];
            MRecipeWithIngredients* fullRecipe = [[MRecipeWithIngredients alloc] init];
            fullRecipe.RecipeDetails = recipe;
            
            // now need to look up the ingredients for this recipe
            if([self getIngredientsForRecipe:&fullRecipe fromDB:databaseLocal] != Success)
            {
                // something went wrong, inform the user
            }
        }
    }
    sqlite3_close(databaseLocal);
    return result;
}

- (int) removeIngredient:(MIngredientWithAmount*)Ingredient fromRecipeId:(NSInteger)recipeId inDB:(sqlite3*)databaseLocal
{
    sqlite3_stmt *statement;
    
    int resultCode = sqlite3_prepare_v2(databaseLocal, [RemoveIngredientQuery UTF8String], -1, &statement, nil);
    if(resultCode != SQLITE_OK)
    {
        NSLog(@"Failed to prepare SQLite statement for remove ingredient from recipe. Error code %d", resultCode);
        return resultCode;
    }
    
    resultCode = sqlite3_bind_int(statement, 1, recipeId);
    if(resultCode != SQLITE_OK)
    {
        NSLog(@"Failed to bind the parameter to SQLite statement for remove ingredient from recipe. Error code %d", resultCode);
        return resultCode;
    }
    
    resultCode = sqlite3_bind_int(statement, 2, Ingredient.Ingredient.Id);
    if(resultCode != SQLITE_OK)
    {
        NSLog(@"Failed to bind the parameter to SQLite statement for remove ingredient from recipe. Error code %d", resultCode);
        return resultCode;
    }
    
    resultCode = sqlite3_bind_int(statement, 3, Ingredient.Measurement.Id);
    if(resultCode != SQLITE_OK)
    {
        NSLog(@"Failed to bind the parameter to SQLite statement for remove ingredient from recipe. Error code %d", resultCode);
        return resultCode;
    }
    resultCode = sqlite3_bind_double(statement, 4, Ingredient.Amount);
    if(resultCode != SQLITE_OK)
    {
        NSLog(@"Failed to bind the parameter to SQLite statement for remove ingredient from recipe. Error code %d", resultCode);
        return resultCode;
    }

    resultCode = sqlite3_step(statement);
    if(resultCode != SQLITE_DONE)
    {
        NSLog(@"Result code for execution of remove ingredient from recipe was %d", resultCode);
        return resultCode;
    }
    
    // finalize (close) the sqlite statement
    resultCode = sqlite3_finalize(statement);
    if(resultCode != SQLITE_OK)
    {
        // something went wrong during sql query
        NSLog(@"Error during finilizing remove ingredient from recipe statement: %d", resultCode);
    }
    return resultCode;
}


- (MResultCode) markRecipeAsFavorite:(NSInteger) recipeId
{
    sqlite3* databaseLocal = [MDatabase OpenDbConnection];
    if([self setFavoriteFlagTo:1 forRecipeId:recipeId inDB:databaseLocal] != SQLITE_OK)
    {
        // something went wrong, inform the user
    }
    else
    {
        MRecipe* recipe = [self.allRecipesDictionary objectForKey:[NSNumber numberWithInt:recipeId]];
        recipe.IsFavorite = TRUE;
        [self.allRecipesDictionary setObject:recipe forKey:[NSNumber numberWithInteger:recipeId]];
        if(self.allRecipesDictionary == nil)
        {
            [self readAllRecipesfromDB:databaseLocal];
        }
    }
    sqlite3_close(databaseLocal);
    return Success;
}
- (MResultCode) unmarkRecipeAsFavorite:(NSInteger) recipeId
{
    sqlite3* databaseLocal = [MDatabase OpenDbConnection];
    if([self setFavoriteFlagTo:0 forRecipeId:recipeId inDB:databaseLocal] != SQLITE_OK)
    {
        // something went wrong, inform the user
    }
    else{
        MRecipe* recipe = [self.allRecipesDictionary objectForKey:[NSNumber numberWithInt:recipeId]];
        recipe.IsFavorite = FALSE;
        [self.allRecipesDictionary setObject:recipe forKey:[NSNumber numberWithInteger:recipeId]];
        if(self.allRecipesDictionary == nil)
        {
            [self readAllRecipesfromDB:databaseLocal];
        }
    }
    sqlite3_close(databaseLocal);
    return Success;
}

-(MResultCode) setFavoriteFlagTo:(int)isFavorite forRecipeId:(NSInteger)RecipeId inDB:(sqlite3*) database
{
    sqlite3_stmt *statement;
    
    int resultCode = sqlite3_prepare_v2(database, [changeFavoriteFlagQuery UTF8String], -1, &statement, nil);
    if(resultCode != SQLITE_OK)
    {
        NSLog(@"Failed to prepare SQLite statement for updating the isFavorite flag for recipe. Error code %d", resultCode);
        return GenericDBError;
    }
    
    resultCode = sqlite3_bind_int(statement, 1, isFavorite);
    resultCode = sqlite3_bind_int(statement, 2, RecipeId);
    
    resultCode = sqlite3_step(statement);
    if(resultCode != SQLITE_DONE)
    {
        NSLog(@"Result code for execution of updating the isFavorite flag was %d", resultCode);
        return resultCode;
    }
    
    // finalize (close) the sqlite statement
    resultCode = sqlite3_finalize(statement);
    if(resultCode != SQLITE_OK)
    {
        // something went wrong during sql query
        NSLog(@"Error during finilizing updating the isFavorite flag statement: %d", resultCode);
    }
    return resultCode;
}

@end
