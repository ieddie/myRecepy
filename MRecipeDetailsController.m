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
    MRecipe* recipe;
    NSMutableArray* ingredientsForRecipe;
    MMeasurement* measurementInProgree;
    double amountInProgress;
    BOOL isNewRecipeBeingAdded;
    BOOL currentIsFav;
}

@end

@implementation MRecipeDetailsController

static NSString *CellIdentifier = @"Cell";

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil Parent:(id<MNavigationParent>)parent RecipeId:(NSInteger)RecipeId
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        MRecipeWithIngredients* completeRecipe = [[MRecipes Instance] getRecipeWithIngredientsForId:RecipeId];
        self->ingredientsForRecipe = [NSMutableArray arrayWithArray:completeRecipe.Ingredients];
        self->recipe = completeRecipe.RecipeDetails;

        self->currentIsFav = self->recipe.IsFavorite;
        self->isNewRecipeBeingAdded = FALSE;
        self.Parent = parent;
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil Parent:(id<MNavigationParent>)parent
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self->recipe = [[MRecipe alloc] init];
        self->ingredientsForRecipe = [[NSMutableArray alloc] init];

        self->isNewRecipeBeingAdded = TRUE;
        self->currentIsFav = FALSE;
        self.Parent = parent;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.txfName.text = self->recipe.Name;
    self.txfName.clearsOnBeginEditing = FALSE;
    self.txfDescription.text = self->recipe.Description;
    self.txfDescription.clearsOnBeginEditing = FALSE;
    [self setIsFavImage];
    

    
    if(self->isNewRecipeBeingAdded) {
        [self.btnback setTitle:@"Add" forState:UIControlStateNormal];
    } else {
        [self.btnback setTitle:@"Close" forState:UIControlStateNormal];
    }
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
}
-(void)dismissKeyboard {
    [self.txfName resignFirstResponder];
    [self.txfDescription resignFirstResponder];
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
    return [ingredientsForRecipe count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:CellIdentifier];
    }
    MIngredientWithAmount* ingredient = [ingredientsForRecipe objectAtIndex:indexPath.row] ;
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

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if(textField.tag == 10) {
        if(!isNewRecipeBeingAdded) {
            [[MRecipes Instance] updateRecipeName:textField.text InRecipe:self->recipe.Id];
        }
    } else if(textField.tag == 11) {
        if(!isNewRecipeBeingAdded) {
            [[MRecipes Instance] updateRecipeDescription:textField.text InRecipe:self->recipe.Id];
        }	
    }
}

- (IBAction)CloseRecipe:(id)sender {
    if(self->isNewRecipeBeingAdded) {
        NSInteger newRecipeId = [[MRecipes Instance] addNewRecipe:[[MRecipe alloc] initWithName:self.txfName.text
                                                                                   Description:self.txfDescription.text
                                                                                    IsFavorite:self->currentIsFav]];
        if(self->ingredientsForRecipe != nil && [self->ingredientsForRecipe count] > 0) {
            for (MIngredientWithAmount* ingredient in self->ingredientsForRecipe) {
                [[MRecipes Instance] addIngredient:ingredient toRecipeWithId:newRecipeId];
            }
        }
        [self.Parent ChildIsUnloading];
    }
    // if this is a "add new recipe" - run the add operation on db
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)addNewIngredientClick:(id)sender {
    MIngredientsController *listOfIngredientsController = [[MIngredientsController alloc] initWithNibName:@"MListOfIngridients"
                                                                                                   bundle:nil
                                                                                                   Parent:self];
    //Push new view to navigationController stack
    [self.navigationController pushViewController:listOfIngredientsController animated:YES];
}

- (IBAction)setFav:(id)sender {
    if(!isNewRecipeBeingAdded)
    {
        NSInteger recipeId = self->recipe.Id;
        if (recipe.IsFavorite) {
            [[MRecipes Instance] unmarkRecipeAsFavorite:recipeId];
        }
        else {
            [[MRecipes Instance] markRecipeAsFavorite:recipeId];
        }
    }
    self->currentIsFav = !self->currentIsFav;
    self->recipe.IsFavorite = self->currentIsFav;
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

- (void) AddNewIngredient:(id)ingredient
{
    if(!isNewRecipeBeingAdded) {
        [[MRecipes Instance] addIngredient:ingredient toRecipeWithId:self->recipe.Id];
    }
    else {
        [self->ingredientsForRecipe addObject:ingredient];
    }
    [self.ingredientsTable reloadData];
}

@end
