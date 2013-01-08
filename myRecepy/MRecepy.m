//
//  MRecepy.m
//  myRecepy
//
//  Created by Eduard Kantsevich on 1/7/13.
//  Copyright (c) 2013 Med. All rights reserved.
//

#import "MRecepy.h"

@interface MRecepy ()
{
    NSMutableArray* ingredients;
}
@end

@implementation MRecepy

-(id) initWithName:(NSString*)name {
    self = [super init];
    if(self) {
        ingredients = [[NSMutableArray alloc] init];
        [self setName:[NSString stringWithString:name]];
    }
    return self;
}


-(id) initWithname:(NSString*)name andIngredient:(NSString*) firstIngredient {
    self = [super init];
    if(self) {
        //[self setName:name];
        [self setName:[NSString stringWithString:name]];
        [ingredients addObject:[NSString stringWithString:firstIngredient]];
    }
    return self;
}

// return non-muable version of curent list of ingredients
-(NSArray *) getCurrentIngredients {
    if(ingredients) {
        return [NSArray arrayWithArray:ingredients];
    }
    else {
        return nil;
    }
}

-(NSString*) getIngredientAtIndex:(NSInteger) index {
    NSInteger length = [ingredients count];
    if(length <= index) {
        // no such index exists
        return @"";
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

-(void) addIngredient:(NSString *)ingredientText{
    if (ingredientText == (id)[NSNull null] || ingredientText.length == 0 ) {
        [NSException raise:@"Empty ingredient" format:@"Ingredient text is empty"];
    }
    [ingredients addObject:[NSString stringWithString:ingredientText]];
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
