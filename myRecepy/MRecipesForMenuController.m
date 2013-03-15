//
//  MRecipesForMenuController.m
//  myRecipeList
//
//  Created by Eduard Kantsevich on 3/12/13.
//  Copyright (c) 2013 Med. All rights reserved.
//

#import "MRecipesForMenuController.h"

@interface MRecipesForMenuController ()
{
    NSArray* recipesForThisMenu;
    MMenu* currentMenu;
}
@end

@implementation MRecipesForMenuController

static NSString *CellIdentifier = @"Cell";

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil MenuId:(NSInteger)MenuId
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self->currentMenu = [[MMenus Instance] getMenu:MenuId];
        self->recipesForThisMenu = [[MMenus Instance] getRecipesForMenuId:MenuId];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationBar.topItem.title = self->currentMenu.Name;
    self.lblDescription.text = self->currentMenu.Description;
    
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
    return [self->recipesForThisMenu count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.text = [[self->recipesForThisMenu objectAtIndex:indexPath.row] Name];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MRecipe* recipe = [recipesForThisMenu objectAtIndex:indexPath.row];
    //Initialize new viewController
    MRecipeDetailsController *detailsController = [[MRecipeDetailsController alloc] initWithNibName:@"MRecipeDetailsController" bundle:nil RecipeId:recipe.Id];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    //Push new view to navigationController stack
    [self.navigationController pushViewController:detailsController animated:YES];
}

- (void) AddExistingRecipe {
    MRecipeListController *addExistingRecipe = [[MRecipeListController alloc] initWithNibName:@"MRecipeListController"
                                                                                       bundle:nil
                                                                                       MenuId:self->currentMenu.Id
                                                                                       Parent:self];
    [self.navigationController pushViewController:addExistingRecipe animated:YES];
}

- (void) ShowShoppingBag {
    NSLog(@"%@", @"Need to show shopping bag here");
}
- (IBAction)toMenuListClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void) ChildIsUnloading
{
    self->recipesForThisMenu = [[MMenus Instance] getRecipesForMenuId:currentMenu.Id];
    [self.tableView reloadData];
}

@end
