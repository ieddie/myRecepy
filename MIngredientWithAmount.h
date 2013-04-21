//
//  MIngredientWithAmount.h
//  myRecipeList
//
//  Created by Eduard Kantsevich on 1/18/13.
//  Copyright (c) 2013 Med. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MIngredient.h"
#import "MMeasurements.h"
#import "MMeasurement.h"

@interface MIngredientWithAmount : NSObject

-(id) initWithIngredient:(MIngredient*)ingredient Amount:(double)amount Measurement:(MMeasurement *)measurementId;

@property (strong, nonatomic) MIngredient* Ingredient;
@property (nonatomic) double Amount;
@property (strong, nonatomic) MMeasurement* Measurement;

@end
