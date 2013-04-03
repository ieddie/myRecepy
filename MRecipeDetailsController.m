//
//  MRecipeDetailsController.m
//  myRecipeList
//
//  Created by Eduard Kantsevich on 3/3/13.
//  Copyright (c) 2013 Med. All rights reserved.
//

#import "MRecipeDetailsController.h"
#import "MRecipes.h"

@interface MRecipeDetailsController ()
{
    MRecipeWithIngredients* recipe;
    MIngredient* ingredientInProgress;
    MMeasurement* measurementInProgree;
    double amountInProgress;
    BOOL isNewRecipeBeingAdded;
    BOOL currentIsFav;
}

@end

@implementation MRecipeDetailsController

static NSString *CellIdentifier = @"Cell";

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil RecipeId:(NSInteger)RecipeId
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self->recipe = [[MRecipes Instance] getRecipeWithIngredientsForId:RecipeId];
        self.ingredientToAddId = 0;
        self->isNewRecipeBeingAdded = FALSE;
        self->currentIsFav = self->recipe.RecipeDetails.IsFavorite;
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.ingredientToAddId = 0;
        self->isNewRecipeBeingAdded = TRUE;
        self->currentIsFav = FALSE;
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
    
    if(self->isNewRecipeBeingAdded) {
        [self.btnback setTitle:@"Add" forState:UIControlStateNormal];
    } else {
        [self.btnback setTitle:@"Close" forState:UIControlStateNormal];
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

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField {
    if(textField.tag == 10) {
        textField.text = self->recipe.RecipeDetails.Name;
    } else if(textField.tag == 11) {
        textField.text = self->recipe.RecipeDetails.Description;
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if(textField.tag == 10) {
        [[MRecipes Instance] updateRecipeName:textField.text InRecipe:self->recipe.RecipeDetails.Id];
    } else if(textField.tag == 11) {
        [[MRecipes Instance] updateRecipeDescription:textField.text InRecipe:self->recipe.RecipeDetails.Id];
    }
}

- (IBAction)CloseRecipe:(id)sender {
    // if this is a "add new recipe" - run the add operation on db
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)addNewIngredientClick:(id)sender {
    MIngredientsController *listOfIngredientsController = [[MIngredientsController alloc] initWithNibName:@"MListOfIngridients"
                                                                                                   bundle:nil
                                                                                                   Parent:self
                                                                                                   Recipe:self->recipe.RecipeDetails.Id];
    //Push new view to navigationController stack
    [self.navigationController pushViewController:listOfIngredientsController animated:YES];
}

- (IBAction)setFav:(id)sender {
    if(!isNewRecipeBeingAdded)
    {
        NSInteger recipeId = self->recipe.RecipeDetails.Id;
        if (recipe.RecipeDetails.IsFavorite) {
            [[MRecipes Instance] unmarkRecipeAsFavorite:recipeId];
        }
        else {
            [[MRecipes Instance] markRecipeAsFavorite:recipeId];
        }
        self->recipe = [[MRecipes Instance] getRecipeWithIngredientsForId:recipeId];
    }
    self->currentIsFav = !self->currentIsFav;
    [self setIsFavImage];
}

-(void) setIsFavImage
{
    if(self->currentIsFav) {
        [self.isFavButton setBackgroundImage:[UIImage imageNamed: @"star_enabled_brushed.png"] forState:UIControlStateNormal];
    } else {
        [self.isFavButton setBackgroundImage:[UIImage imageNamed: @"star_disabled_brushed.png"] forState:UIControlStateNormal];
    }
}

- (void)viewDidUnload {
    [self setBtnback:nil];
    [self setIngredientsTable:nil];
    [super viewDidUnload];
}

- (void) ChildIsUnloading
{
    self->recipe = [[MRecipes Instance] getRecipeWithIngredientsForId:self->recipe.RecipeDetails.Id];
    [self.ingredientsTable reloadData];
}

@end
