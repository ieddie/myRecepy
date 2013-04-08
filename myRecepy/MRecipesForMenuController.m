//
//  MRecipesForMenuController.m
//  myRecipeList
//
//  Created by Eduard Kantsevich on 3/12/13.
//  Copyright (c) 2013 Med. All rights reserved.
//

#import "MRecipesForMenuController.h"
#import "MMenuController.h"
#import "MShoppingCart.h"

@interface MRecipesForMenuController ()
{
    NSArray* recipesForThisMenu;
    MMenu* currentMenu;
    
    NSArray* menus;
    BOOL topLayerHidden;
    
    BOOL hidingNavItemsForFavorites;
}
@end

@implementation MRecipesForMenuController

static NSString *CellIdentifier = @"Cell";

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        topLayerHidden = FALSE;
        [self getAllMenus];
        if(menus.count > 1)
        {
            self->currentMenu = [menus objectAtIndex:0];
            self->recipesForThisMenu = [[MMenus Instance] getRecipesForMenuId:currentMenu.Id];
        }
    }
    return self;
}

- (void)viewDidUnload {
    [self setTopLayer:nil];
    [self setRecipesTableView:nil];
    [super viewDidUnload];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationBar.topItem.title = self->currentMenu.Name;
    self.lblDescription.text = self->currentMenu.Description;
    
    [self addNavigationButtons];
    
    }

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // later may want to dispose of Menus array, but I doubt it's a big deal
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView.tag == 11) {
        return [self->menus count];
    } else if(tableView.tag == 10) {
        return [self->recipesForThisMenu count];
    }
    else {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:CellIdentifier];
    }
    if(tableView.tag == 11) {
        cell.textLabel.text = [[self->menus objectAtIndex:indexPath.row] Name];
    } else if(tableView.tag == 10) {
        cell.textLabel.text = [[self->recipesForThisMenu objectAtIndex:indexPath.row] Name];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView.tag == 11) {
        [self animateLayer:0];
        topLayerHidden = FALSE;
        
        
        self->currentMenu = [menus objectAtIndex:indexPath.row];
        if(self->currentMenu.Id == -1) {
            self->hidingNavItemsForFavorites = TRUE;
            UINavigationItem* currentItem = [self.navigationBar.items objectAtIndex:0];
            currentItem.rightBarButtonItem = nil;
            self->recipesForThisMenu = [[MRecipes Instance] FavoriteRecipes];
        } else {
            if(self->hidingNavItemsForFavorites)
            {
                [self addNavigationButtons];
                self->hidingNavItemsForFavorites = FALSE;
            }
            self->recipesForThisMenu = [[MMenus Instance] getRecipesForMenuId:self->currentMenu.Id];
        }
        self.navigationBar.topItem.title = self->currentMenu.Name;
        self.lblDescription.text = self->currentMenu.Description;

        [self.recipesTableView reloadData];
    } else {
        MRecipe* recipe = [self->recipesForThisMenu objectAtIndex:indexPath.row];
        //Initialize new viewController
        MRecipeDetailsController *detailsController = [[MRecipeDetailsController alloc] initWithNibName:@"MRecipeDetailsController"
                                                                                                 bundle:nil
                                                                                                 Parent:self
                                                                                               RecipeId:recipe.Id];
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
        //Push new view to navigationController stack
        [self.navigationController pushViewController:detailsController animated:YES];
    }   
}

- (void) AddExistingRecipe {
    MRecipeListController *addExistingRecipe = [[MRecipeListController alloc] initWithNibName:@"MRecipeListController"
                                                                                       bundle:nil
                                                                                       Parent:self
                                                                                    AddToMenu:self->currentMenu.Id];
    [self.navigationController pushViewController:addExistingRecipe animated:YES];
}

- (void) ShowShoppingBag {
    MShoppingCart* shoppingCart = [[MShoppingCart alloc] initWithNibName:@"MShoppingCart" bundle:nil Menu:self->currentMenu.Id];
    [self.navigationController pushViewController:shoppingCart animated:YES];
}
- (IBAction)toMenuListClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void) ChildIsUnloading
{
    self->recipesForThisMenu = [[MMenus Instance] getRecipesForMenuId:currentMenu.Id];
    [self getAllMenus];
    [self.recipesTableView reloadData];
    [self.menusTableView reloadData];
}

-(void) animateLayer:(int)x
{
    [UIView animateWithDuration:0.3
                          delay:0
                        options:UIViewAnimationCurveEaseOut
                     animations:^{
                         CGRect topLayerFrame = self.topLayer.frame;
                         topLayerFrame.origin.x = x;
                         self.topLayer.frame = topLayerFrame;}
                     completion:^(BOOL 	finished) {
                         
                     }
     ];
}

-(void) addNavigationButtons
{
    // these numbers would not work for iPad, need to take idiom into effect
    UIToolbar *tools = [[UIToolbar alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 80.0f, 44.0f)];
    tools.clearsContextBeforeDrawing = NO;
    tools.clipsToBounds = NO;
    tools.barStyle = -1; // clear background
    
    NSMutableArray *buttons = [[NSMutableArray alloc] initWithCapacity:3];
    
    UIBarButtonItem* buttonPlus = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                                target:self
                                                                                action:@selector(AddExistingRecipe)];
    [buttons addObject:buttonPlus];
    
    // Create a spacer.
    UIBarButtonItem* spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                            target:nil
                                                                            action:nil];
    spacer.width = 12.0f;
    [buttons addObject:spacer];
    
    UIBarButtonItem *buttonShoppingBag = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"shopping_bag.png"]
                                                                          style:UIBarButtonItemStylePlain
                                                                         target:self
                                                                         action:@selector(ShowShoppingBag)];
    [buttons addObject:buttonShoppingBag];
    
    // Add buttons to toolbar and toolbar to nav bar.
    [tools setItems:buttons animated:NO];
    
    UIBarButtonItem *allButtonsInOne = [[UIBarButtonItem alloc] initWithCustomView:tools];
    UINavigationItem* currentItem = [self.navigationBar.items objectAtIndex:0];
    currentItem.rightBarButtonItem = allButtonsInOne;
}

- (IBAction)AddMenuClicked:(id)sender {
    MMenuController* addMenu = [[MMenuController alloc] initWithNibName:@"MMenuController" bundle:nil];
    addMenu.parent = self;
    [self.navigationController pushViewController:addMenu animated:YES];
}
- (IBAction)FaceButtonClicked:(id)sender {
    if(topLayerHidden) {
        [self animateLayer:0];
    } else {
        [self animateLayer:230];
    }
    topLayerHidden = !topLayerHidden;
}

- (void) getAllMenus
{
    NSMutableArray* allMenusWithFavorites = [NSMutableArray arrayWithArray:[[MMenus Instance] AvailableMenus]];
    [allMenusWithFavorites addObject:[[MMenu alloc] initWithId:-1 Name:@"Favorite Recipes" Description:@""]];
    self->menus = [NSArray arrayWithArray:allMenusWithFavorites];
}

@end
