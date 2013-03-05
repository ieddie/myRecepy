//
//  MRecipeDetailsController.h
//  myRecipeList
//
//  Created by Eduard Kantsevich on 3/3/13.
//  Copyright (c) 2013 Med. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MRecipes.h"
#import "MIngredientsController.h"

@interface MRecipeDetailsController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblDescription;
@property (weak, nonatomic) IBOutlet UINavigationBar *navBar;
@property (weak, nonatomic) IBOutlet UIButton *isFavButton;
@property (nonatomic) NSInteger ingredientToAddId;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil RecipeId:(NSInteger)recipeId;

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
- (IBAction)CloseRecipe:(id)sender;
- (IBAction)setFav:(id)sender;

@end
