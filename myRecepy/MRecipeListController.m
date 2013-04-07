//
//  MRecipeListController.m
//  myRecipeList
//
//  Created by Eduard Kantsevich on 3/3/13.
//  Copyright (c) 2013 Med. All rights reserved.
//

#import "MRecipeListController.h"
#import "MRecipes.h"

@interface MRecipeListController ()
{
    NSArray* recipes;
    NSInteger CurrentMenuId;
    BOOL addingToMenu;
}
@end

@implementation MRecipeListController

static NSString *CellIdentifier = @"Cell";

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self->recipes = [[MRecipes Instance] AvailableRecipes];
        addingToMenu = FALSE;
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil Parent:(id<MNavigationParent>)Parent AddToMenu:(NSInteger) menuId
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self->recipes = [[MRecipes Instance] AvailableRecipes];
        self.parent = Parent;
        addingToMenu = TRUE;
        self->CurrentMenuId = menuId;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationBar.topItem.title = @"Recipes";

    // these numbers would not work for iPad, need to take idiom into effect
    UIToolbar *tools = [[UIToolbar alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 40.0f, 44.0f)];
    tools.clearsContextBeforeDrawing = NO;
    tools.clipsToBounds = NO;
    tools.barStyle = -1; // clear background
    
    NSMutableArray *buttons = [[NSMutableArray alloc] initWithCapacity:3];
    
    UIBarButtonItem* buttonPlus = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                                target:self
                                                                                action:@selector(AddNewRecipe)];
    [buttons addObject:buttonPlus];
    /* For now removing shopping bag from this view. change size of rectangle to 0, 0, 80, 40
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
     */
    
    // Add buttons to toolbar and toolbar to nav bar.
    [tools setItems:buttons animated:NO];
    
    UIBarButtonItem *allButtonsInOne = [[UIBarButtonItem alloc] initWithCustomView:tools];
    UINavigationItem* currentItem = [self.navigationBar.items objectAtIndex:0];
    currentItem.rightBarButtonItem = allButtonsInOne;
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
    return [self->recipes count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.text = [[self->recipes objectAtIndex:indexPath.row] Name];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MRecipe* recipe = [self->recipes objectAtIndex:indexPath.row];
    if(!addingToMenu) {
        MRecipeDetailsController *detailsController = [[MRecipeDetailsController alloc] initWithNibName:@"MRecipeDetailsController"
                                                                                                 bundle:nil
                                                                                                 Parent:self
                                                                                               RecipeId:recipe.Id];
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
        [self.navigationController pushViewController:detailsController animated:YES];
    } else {
        [[MMenus Instance] addRecipe:recipe.Id ToMenu:self->CurrentMenuId];
        [self.parent ChildIsUnloading];
        [self.navigationController popViewControllerAnimated:TRUE];
    }
}

- (void) AddNewRecipe {
    MRecipeDetailsController *addNewRecipeController = [[MRecipeDetailsController alloc] initWithNibName:@"MRecipeDetailsController"
                                                                                                  bundle:nil
                                                                                                  Parent:self];
    [self.navigationController pushViewController:addNewRecipeController
                                         animated:YES];
}

- (IBAction)BackClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) ShowShoppingBag {
    NSLog(@"%@", @"Need to show shopping bag here");
}

-(void) ChildIsUnloading {
    self->recipes = [[MRecipes Instance] AvailableRecipes];
    [self.RecipeListTableView reloadData];
}

- (void)viewDidUnload {
    [self setRecipeListTableView:nil];
    [super viewDidUnload];
}
@end
