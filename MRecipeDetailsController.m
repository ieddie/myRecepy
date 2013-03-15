//
//  MRecipeDetailsController.m
//  myRecipeList
//
//  Created by Eduard Kantsevich on 3/3/13.
//  Copyright (c) 2013 Med. All rights reserved.
//

#import "MRecipeDetailsController.h"

@interface MRecipeDetailsController ()
{
    MRecipeWithIngredients* recipe;
    MIngredient* ingredientInProgress;
    MMeasurement* measurementInProgree;
    double amountInProgress;
    BOOL showAddButton;
}

@end

@implementation MRecipeDetailsController

static NSString *CellIdentifier = @"Cell";

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil RecipeId:(NSInteger)recipeId
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self->recipe = [[MRecipes Instance] getRecipeWithIngredientsForId:recipeId];
        self.ingredientToAddId = 0;
        self->showAddButton = FALSE;
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.ingredientToAddId = 0;
        self->showAddButton = TRUE;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.txfName.text = self->recipe.RecipeDetails.Name;
    self.txfDescription.text = self->recipe.RecipeDetails.Description;
    [self setIsFavImage];
    
    if(self.ingredientToAddId != 0)
    {
        // push controller to select measurement
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [recipe IngridientsCount];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:CellIdentifier];
    }
    MIngredientWithAmount* ingredient = [recipe IngredientWithAmountAtIndex:indexPath.row] ;
    cell.textLabel.text = [[ingredient Ingredient] Name];
    return cell;
}

- (float)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    // Creates an "invisible" footer
    return 0.01f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [UIView new];
}

- (IBAction)CloseRecipe:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)addNewIngredientClick:(id)sender {
    MIngredientsController *listOfIngredientsController = [[MIngredientsController alloc] initWithNibName:@"MListOfIngridients" bundle:nil];
    listOfIngredientsController.delegate = self;
    //Push new view to navigationController stack
    [self.navigationController pushViewController:listOfIngredientsController animated:YES];
}

- (IBAction)setFav:(id)sender {
    NSInteger recipeId = recipe.RecipeDetails.Id;
    if (recipe.RecipeDetails.IsFavorite) {
        [[MRecipes Instance] unmarkRecipeAsFavorite:recipeId];
    }
    else {
        [[MRecipes Instance] markRecipeAsFavorite:recipeId];
    }
    self->recipe = [[MRecipes Instance] getRecipeWithIngredientsForId:recipeId];
    [self setIsFavImage];
}

-(void) setIsFavImage
{
    if(self->recipe.RecipeDetails.IsFavorite) {
        [self.isFavButton setBackgroundImage:[UIImage imageNamed: @"star_enabled_brushed.png"] forState:UIControlStateNormal];
    } else {
        [self.isFavButton setBackgroundImage:[UIImage imageNamed: @"star_disabled_brushed.png"] forState:UIControlStateNormal];
    }
}

@end
