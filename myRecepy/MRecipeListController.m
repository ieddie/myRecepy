//
//  MRecipeListController.m
//  myRecipeList
//
//  Created by Eduard Kantsevich on 3/3/13.
//  Copyright (c) 2013 Med. All rights reserved.
//

#import "MRecipeListController.h"

@interface MRecipeListController ()
{
    NSArray* recipes;
}
@end

@implementation MRecipeListController

static NSString *CellIdentifier = @"Cell";

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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
    return [[[MRecipes Instance] AvailableRecipes] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.text = [[[[MRecipes Instance] AvailableRecipes] objectAtIndex:indexPath.row] Name];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MRecipe* recipe = [[[MRecipes Instance] AvailableRecipes] objectAtIndex:indexPath.row];
       //Initialize new viewController
    MRecipeDetailsController *detailsController = [[MRecipeDetailsController alloc] initWithNibName:@"MRecipeDetailsController" bundle:nil RecipeId:recipe.Id];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    //Push new view to navigationController stack
    [self.navigationController pushViewController:detailsController animated:YES];
}


@end
