//
//  MRecipeListController.m
//  myRecipeList
//
//  Created by Eduard Kantsevich on 3/3/13.
//  Copyright (c) 2013 Med. All rights reserved.
//

#import "MMenuController.h"
#import "MIngredients.h"

@interface MMenuController ()
{
    NSArray* menus;
    BOOL topLayerHidden;
    NSArray* lowerList;
}
@end

@implementation MMenuController

static NSString *CellIdentifier = @"Cell";

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        topLayerHidden = FALSE;
        menus = [[MMenus Instance] AvailableMenus];
        lowerList = [[MRecipes Instance] AvailableRecipes];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // these numbers would not work for iPad, need to take idiom of the device into effect
    UIToolbar *tools = [[UIToolbar alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 80.0f, 44.0f)];
    tools.clearsContextBeforeDrawing = NO;
    tools.clipsToBounds = NO;
    tools.barStyle = -1; // clear background
    
    NSMutableArray *buttons = [[NSMutableArray alloc] initWithCapacity:3];
    
    UIBarButtonItem* buttonPlus = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                                target:self
                                                                                action:@selector(AddNewMenu)];
    [buttons addObject:buttonPlus];
    
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
    if(tableView.tag == 11) {
        return [menus count];
    } else if(tableView.tag == 10) {
        return [lowerList count];
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
        cell.textLabel.text = [[menus objectAtIndex:indexPath.row] Name];
    } else if(tableView.tag == 10) {
        cell.textLabel.text = [[lowerList objectAtIndex:indexPath.row] Name];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView.tag == 11) {
    MMenu* selectedMenu = [menus objectAtIndex:indexPath.row];
    //Initialize new viewController
    MRecipesForMenuController *detailsController = [[MRecipesForMenuController alloc] initWithNibName:@"MRecipesForMenuController"
                                                                                               bundle:nil
                                                                                               MenuId:selectedMenu.Id];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    //Push new view to navigationController stack
    [self.navigationController pushViewController:detailsController animated:YES];
    }
}

- (void) AddNewMenu {
    // tbd
    NSLog(@"Add new menu was clicked");
}


- (IBAction)FacebookButtonClicked:(id)sender {
    if(topLayerHidden) {
        [self animateLayer:0];
    } else {
        [self animateLayer:230];
    }
    topLayerHidden = !topLayerHidden;
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
- (IBAction)IngredientsClicked:(id)sender {
    self->lowerList = [[MIngredients Instance] availableIngredients];
    [self.lowerTableView reloadData];
}

- (IBAction)RecipesClicked:(id)sender {
    self->lowerList = [[MRecipes Instance] AvailableRecipes];
    [self.lowerTableView reloadData];
}

@end
