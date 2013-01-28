//
//  MIngredientWithAmount.m
//  myRecipeList
//
//  Created by Eduard Kantsevich on 1/18/13.
//  Copyright (c) 2013 Med. All rights reserved.
//

#import "MIngredientWithAmount.h"

@implementation MIngredientWithAmount

-(id) initWithIngredient:(MIngredient*)ingredient Amount:(float)amount Measurement:(MMeasurement *) measurement
{
    self = [super init];
    if (self) {
        self.Ingredient = ingredient;
        self.Amount = amount;
        self.Measurement = measurement;
    }
    return self;
}
@end
