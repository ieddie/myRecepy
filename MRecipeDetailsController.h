//
//  MRecipeDetailsController.h
//  myRecipeList
//
//  Created by Eduard Kantsevich on 3/3/13.
//  Copyright (c) 2013 Med. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MEnumerations.h"
#import "MRecipes.h"
#import "MIngredientsController.h"

@interface MRecipeDetailsController : UIViewController <UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource, MNavigationParent>

@property (weak, nonatomic) IBOutlet UITextField *txfName;
@property (weak, nonatomic) IBOutlet UITextField *txfDescription;

@property (weak, nonatomic) IBOutlet UINavigationBar *navBar;
@property (weak, nonatomic) IBOutlet UIButton *isFavButton;
@property (nonatomic) NSInteger ingredientToAddId;
@property (weak, nonatomic) IBOutlet UIButton *btnback;
@property (weak, nonatomic) IBOutlet UITableView *ingredientsTable;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil RecipeId:(NSInteger)RecipeId;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil;

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
- (IBAction)CloseRecipe:(id)sender;
- (IBAction)setFav:(id)sender;

- (void) ChildIsUnloading;

@end
