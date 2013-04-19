//
//  MIngredients.h
//  myRecipeList
//
//  Created by Eduard Kantsevich on 1/19/13.
//  Copyright (c) 2013 Med. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "sqlite3.h"
#import "MIngredient.h"
#import "MEnumerations.h"
#import "MDatabase.h"

@interface MIngredients : NSObject
+ (MIngredients *)Instance;

@property (readonly, strong, nonatomic) NSArray* availableIngredients;

- (MResultCode) addNewIngredient:(NSString *) ingredientText;
- (MResultCode) updateExistingIngredientAtId:(NSInteger) ingredientId withText:(NSString *)newIngredientName;

@end

