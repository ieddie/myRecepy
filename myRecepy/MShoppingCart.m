//
//  MShoppingCart.m
//  myRecipeList
//
//  Created by Eduard Kantsevich on 3/18/13.
//  Copyright (c) 2013 Med. All rights reserved.
//

#import "MShoppingCart.h"
#import "MMenus.h"

@interface MShoppingCart ()
{
    NSInteger menuId;
    NSArray* bought;
    NSArray* notBought;
}
@end

@implementation MShoppingCart

static NSString *CellIdentifier = @"Cell";

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil Menu:(NSInteger)MenuId
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self->menuId = MenuId;
        self->bought = [[MMenus Instance] getBoughtIngredientsForMenuId:menuId];
        self->notBought = [[MMenus Instance] getNotBoughtIngredientsForMenuId:menuId];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setShoppingCartTableView:nil];
    [super viewDidUnload];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0) {
        return [self->notBought count];
    } else {
        return [self->bought count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:CellIdentifier];
    }
    MIngredientFromRecipeInMenu* ingredient = nil;
    if(indexPath.section == 0) {
        ingredient = [self->notBought objectAtIndex:indexPath.row];
    } else  {
        ingredient = [self->bought objectAtIndex:indexPath.row];
    }
    if(ingredient != nil)
    {
        cell.textLabel.text = ingredient.Ingredient.Ingredient.Name;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BOOL markAsBought;
    MIngredientFromRecipeInMenu* itemWasInToBuySection = nil;
    if(indexPath.section == 0) {
        // clicked in the "products to Buy" section
        // need to mark ingredient as bought
        itemWasInToBuySection = [self->notBought objectAtIndex:indexPath.row];
        markAsBought = TRUE;
        
    } else {
        // clicked in the "already bought" section
        // need to mark ingredient as "to buy"
        itemWasInToBuySection = [self->bought objectAtIndex:indexPath.row];
        markAsBought = FALSE;

    }
    [[MMenus Instance] markAsBought:markAsBought RecipeIngredientId:itemWasInToBuySection.RecipeIngredientId MenuRecipeId:itemWasInToBuySection.RecipeMenuId];
    self->bought = [[MMenus Instance] getBoughtIngredientsForMenuId:self->menuId];
    self->notBought = [[MMenus Instance] getNotBoughtIngredientsForMenuId:self->menuId];
    [self.shoppingCartTableView reloadData];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if(section == 0) {
        return @"Products to Buy";
    } else {
        return @"Already Bought";
    }
}
- (IBAction)backButtonClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
