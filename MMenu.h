//
//  MMenu.h
//  myRecipeList
//
//  Created by Eduard Kantsevich on 1/11/13.
//  Copyright (c) 2013 Med. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MRecipe.h"
#import "MRecipeWithIngredients.h"

@interface MMenu : NSObject

@property (nonatomic) NSInteger Id;
@property (strong, nonatomic) NSString* Name;
@property (strong, nonatomic) NSString* Description;

-(id) initWithId:(NSInteger)Id Name:(NSString*)name Description:(NSString*)description;
@end
