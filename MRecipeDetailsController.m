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
    BOOL currentlyEditingName;
    BOOL currentlyEditingDesc;
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
        self->currentlyEditingName = FALSE;
        self->currentlyEditingDesc = FALSE;
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
        self->currentlyEditingName = FALSE;
        self->currentlyEditingDesc = FALSE;
    }
    return self;
}
-(void) textFieldDidBeginEditing:(UITextField *)textField {
    self->currentlyEditingName = TRUE;
    self->currentlyEditingDesc = TRUE;
}
-(void) textViewDidBeginEditing:(UITextView *)textView {
    self->currentlyEditingName = TRUE;
    self->currentlyEditingDesc = TRUE;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.txfName.text = self->recipe.Name;
    self.txfName.clearsOnBeginEditing = FALSE;
    self.txfDescription.text = self->recipe.Description;

    self.txfDescription.contentInset = UIEdgeInsetsMake(-7,-7,-7,-7);
    
    UIColor *background = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"body-bg.png"]];
    self.view.backgroundColor = background;
    
    if(self->isNewRecipeBeingAdded) {
        UIButton *addButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [addButton setTitle:@"Add Recipe" forState:UIControlStateNormal];
        [addButton addTarget:self
                      action:@selector(AddRecipe)
            forControlEvents:UIControlEventTouchUpInside];
        [addButton setFrame:CGRectMake(0, 0, 80, 35)];
        self.navBar.titleView = addButton;
    }
    

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    [self addButtons];
    [self setIsFavImage];
}
-(void)addButtons {
    float xCloseRecipe = self->isNewRecipeBeingAdded ? 80.0 : 20.0;
    UIImage *plusButtonBgImage = [[UIImage imageNamed:@"button-transparent-bg.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 6, 0, 6)];
    
    //addRecipe button
    if (self->isNewRecipeBeingAdded) {
        UIButton *buttonAddRecipe = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [buttonAddRecipe addTarget:self action:@selector(AddRecipe) forControlEvents:UIControlEventTouchDown];
        [buttonAddRecipe setBackgroundImage:plusButtonBgImage forState:UIControlStateNormal];
        [buttonAddRecipe setTitle:@"add" forState:UIControlStateNormal];
        [buttonAddRecipe setTitleColor:[UIColor colorWithRed:132.0/255.0f green:132.0/255.0f blue:132.0/255.0f alpha:1] forState:UIControlStateNormal];
        [buttonAddRecipe setTitleShadowColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [buttonAddRecipe.titleLabel setShadowOffset:CGSizeMake(0.0f, 1.0f) ];
        buttonAddRecipe.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:12];
        buttonAddRecipe.frame = CGRectMake(20.0, 10.0, 50.0, 30.0);
        [self.view addSubview:buttonAddRecipe];
    }
    
    //add close button
    UIButton *buttonClose = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [buttonClose addTarget:self action:@selector(CloseRecipe) forControlEvents:UIControlEventTouchDown];
    [buttonClose setBackgroundImage:plusButtonBgImage forState:UIControlStateNormal];
    [buttonClose setTitle:@"close" forState:UIControlStateNormal];
    [buttonClose setTitleColor:[UIColor colorWithRed:132.0/255.0f green:132.0/255.0f blue:132.0/255.0f alpha:1] forState:UIControlStateNormal];
    [buttonClose setTitleShadowColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [buttonClose.titleLabel setShadowOffset:CGSizeMake(0.0f, 1.0f) ];
    buttonClose.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:12];
    buttonClose.frame = CGRectMake(xCloseRecipe, 10.0, 50.0, 30.0);
    [self.view addSubview:buttonClose];
    
    //fav button
    self.favIconBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.favIconBtn addTarget:self action:@selector(setFav) forControlEvents:UIControlEventTouchDown];
    self.favIconBtn.frame = CGRectMake(278.0, 18.5, 17.5, 17.5);
    //favIconBtn.backgroundColor = [UIColor colorWithPatternImage: [UIImage imageNamed:@"star_disabled_brushed.png"]];
    UIImage *favIconImageNormal = [UIImage imageNamed:@"star_disabled_brushed.png"];
    UIImage *favIconImagePressed = [UIImage imageNamed:@"star_enabled_brushed.png"];
    [self.favIconBtn setBackgroundImage:favIconImageNormal forState:UIControlStateNormal];
    [self.favIconBtn setBackgroundImage:favIconImagePressed forState:UIControlStateSelected];

    [self.view addSubview:self.favIconBtn];
  
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(20.0, 50.0, 280.0, 1)];
    [line setBackgroundColor:[UIColor colorWithRed:0.0/255.0f green:0.0/255.0f blue:0.0/255.0f alpha:0.1]];
    [self.view addSubview:line];
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
    tableView.separatorColor = [UIColor colorWithRed:219.0/255.0f green:219.0/255.0f blue:219.0/255.0f alpha:0.5];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:CellIdentifier];
        cell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"table-products-bg.png"]];
        cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:14];
    }
    MIngredientWithAmount* ingredient = [ingredientsForRecipe objectAtIndex:indexPath.row] ;
    cell.textLabel.text = [[ingredient Ingredient] Name];
    return cell;
}

- (IBAction)editAction:(id)sender {
    [self.ingredientsTable setEditing:YES animated:YES];
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

- (void) updateName
{
    if(self->currentlyEditingName)
    {
        self->currentlyEditingName = FALSE;
            if(!isNewRecipeBeingAdded)
            {
                [[MRecipes Instance] updateRecipeName:self.txfName.text InRecipe:self->recipe.Id];
            }
    }
}

-(void) updateDesc
{
    if(self->currentlyEditingDesc) {
        self->currentlyEditingDesc = FALSE;
            if(!isNewRecipeBeingAdded)
            {
                [[MRecipes Instance] updateRecipeDescription:self.txfDescription.text InRecipe:self->recipe.Id];
    }
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [self updateName];
    
}
- (void)textViewDidEndEditing:(UITextView *)textView {
    [self updateDesc];
    }
- (void)AddRecipe {
    if(self->isNewRecipeBeingAdded) {
        if(self.txfName.text.length == 0) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Name field error"
                                                            message:@"Recipe name can't be blank"
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            return;
        }
        if (self.txfDescription.text.length == 0) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Description field error"
                                                            message:@"Recipe description can't be blank"
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            return;
        }
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

- (void)CloseRecipe {
    
    if (self->currentlyEditingName == TRUE) {
        [self updateName];
    }
    if (self->currentlyEditingDesc == TRUE) {
        [self updateDesc];
    }
    NSLog(@"Name state %d", self.txfName.state);
    [self.navigationController popViewControllerAnimated:YES];
    [self.Parent ChildIsUnloading];
}
- (IBAction)addNewIngredientClick:(id)sender {
    [self dismissKeyboard];
    MIngredientsController *listOfIngredientsController = [[MIngredientsController alloc] initWithNibName:@"MListOfIngridients"
                                                                                                   bundle:nil
                                                                                                   Parent:self];
    //Push new view to navigationController stack
    [self.navigationController pushViewController:listOfIngredientsController animated:YES];

}

- (void)setFav {
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
    self.favIconBtn.selected = self->currentIsFav;
}

- (void)viewDidUnload {
    [self setBtnback:nil];
    [self setIngredientsTable:nil];
    [self setNavBar:nil];
    [super viewDidUnload];
}

- (void) AddNewIngredient:(id)ingredient
{
    if(!isNewRecipeBeingAdded) {
        [[MRecipes Instance] addIngredient:ingredient toRecipeWithId:self->recipe.Id];
        self->ingredientsForRecipe = [NSMutableArray arrayWithArray:[[MRecipes Instance] getRecipeWithIngredientsForId:recipe.Id].Ingredients];
    }
    else {
        [self->ingredientsForRecipe addObject:ingredient];
    }
    [self.ingredientsTable reloadData];
}

@end
