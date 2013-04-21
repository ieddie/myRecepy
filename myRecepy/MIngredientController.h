//
//  MIngredientController.h
//  myRecipeList
//
//  Created by Eduard Kantsevich on 3/3/13.
//  Copyright (c) 2013 Med. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MIngredients.h"
#import "MIngredientsController.h"

@interface MIngredientController : UIViewController <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *IngredientName;
@property (strong, nonatomic) id delegate;
@end
