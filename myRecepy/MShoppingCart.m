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
    [self addNavigationButtons];
    
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
    tableView.separatorColor = [UIColor colorWithRed:219.0/255.0f green:219.0/255.0f blue:219.0/255.0f alpha:0.5];
    //tableView.separatorColor = [UIColor clearColor];
    NSDictionary* strikeThrough = @{
                                 NSStrikethroughStyleAttributeName: [NSNumber numberWithInt:NSUnderlineStyleSingle]
                                 };
    UIImageView *favIcon;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:CellIdentifier];
        cell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"table-products-bg.png"]];
        cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:14];
    }
    favIcon = [[UIImageView alloc] initWithFrame:CGRectMake(271, 12, 16.5, 14.5)];
    favIcon.tag = 12;
    [cell.contentView addSubview:favIcon];

    MIngredientFromRecipeInMenu* ingredient = nil;
    if(indexPath.section == 0) {
        ingredient = [self->notBought objectAtIndex:indexPath.row];
        if(ingredient != nil)
        {            
            favIcon.image = [UIImage imageNamed:@"products-checkbox.png"];
            cell.textLabel.text = ingredient.Ingredient.Ingredient.Name;
        }
    } else  {
        ingredient = [self->bought objectAtIndex:indexPath.row];
        if(ingredient != nil)
        {
            favIcon.image = [UIImage imageNamed:@"products-checkbox-checked.png"];
            NSAttributedString* attrText = [[NSAttributedString alloc] initWithString:ingredient.Ingredient.Ingredient.Name attributes:strikeThrough];
            cell.textLabel.attributedText = attrText;
        }
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  39;
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
-(void) addNavigationButtons
{
    UIBarButtonItem* buttonBack = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain                                                                            target:self action:@selector(backButtonClicked)];
    UINavigationItem* currentItem = [self.navigationBar.items objectAtIndex:0];
    currentItem.leftBarButtonItem = buttonBack;
}
- (void)backButtonClicked {
    [self.navigationController popViewControllerAnimated:YES];
}
// table view header modificaton
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,tableView.frame.size.width,30)];
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, headerView.frame.size.width-120.0, headerView.frame.size.height)];
    [headerLabel setBackgroundColor:[UIColor clearColor]];
    headerLabel.font = [UIFont fontWithName:@"Dakota" size:18];
    [headerLabel setTextColor:[UIColor colorWithRed:69.0/255.0f green:69.0/255.0f blue:69.0/255.0f alpha:0.58]];
    if(section == 0) {
        headerLabel.text = @"Products to Buy";
    } else {
        headerLabel.text = @"Already Bought";
    }
    [headerView addSubview:headerLabel];
    
    return headerView;
}
-(float)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {    
    return  46.0;
}
@end
