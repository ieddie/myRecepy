//
//  MMenuController.h
//  myRecipeList
//
//  Created by Eduard Kantsevich on 3/6/13.
//  Copyright (c) 2013 Med. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MRecipes.h"
#import "MMenus.h"
#import "MRecipeDetailsController.h"
#import "MRecipesForMenuController.h"
#import "MEnumerations.h"

@interface MMenuController : UIViewController <UITextFieldDelegate>

@property (strong, nonatomic) id<MNavigationParent> parent;
@property (weak, nonatomic) IBOutlet UITextField *nameTxtFld;
@property (weak, nonatomic) IBOutlet UITextField *descriptionTxtFld;


@end
