//
//  MRecepy.h
//  myRecepy
//
//  Created by Eduard Kantsevich on 1/7/13.
//  Copyright (c) 2013 Med. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MRecepy : NSObject

-(id) initWithName:(NSString*)name;
-(id) initWithname:(NSString*)name andIngredient:(NSString*) firstIngredient;

@property (strong, nonatomic) NSString* name;

-(NSInteger) getNumberOfIngridients;

-(NSArray *) getCurrentIngredients;
-(NSString*) getIngredientAtIndex:(NSInteger) index;

-(void) addIngredient:(NSString *)ingredientText;

-(void) removeIngredientWithText:(NSString *)ingredientText;
-(void) removeIngredientWithIndex:(NSInteger)index;
@end
