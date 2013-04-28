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
#import "MRecipeCell.h"

@interface MRecipesForMenuController ()
{
    NSArray* recipesForThisMenu;
    MMenu* currentMenu;
    NSIndexPath *oldIndexPath;
    
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
            oldIndexPath = [menus objectAtIndex:0];
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
    
    self.topLayer.layer.shadowOffset = CGSizeMake(0, 0);
    self.topLayer.layer.shadowRadius = 7;
    self.topLayer.layer.shadowOpacity = .4;
    self.topLayer.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.topLayer.bounds].CGPath;
    
    UIImage *navBackgroundImage = [UIImage imageNamed:@"nav-light-bg.png"];
    [_navigationBarMenu setBackgroundImage:navBackgroundImage forBarMetrics:UIBarMetricsDefault];
    
    self.navigationBarMenu.layer.masksToBounds = NO;
    self.navigationBarMenu.layer.shadowOffset = CGSizeMake(0, 0);
    self.navigationBarMenu.layer.shadowRadius = 3;
    self.navigationBarMenu.layer.shadowOpacity = .3;
    self.navigationBarMenu.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.navigationBarMenu.bounds].CGPath;
    
    oldIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.menusTableView selectRowAtIndexPath:oldIndexPath animated:YES  scrollPosition:UITableViewScrollPositionBottom];
    
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
        if ([self->recipesForThisMenu count] == 0) {
            UIColor *tableViewBackgroundImage = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg-empty-table-rec.png"]];
            [tableView setBackgroundColor:tableViewBackgroundImage];
        } else {
            UIColor *tableViewBackgroundImage = [UIColor colorWithPatternImage:[UIImage imageNamed:@"body-bg.png"]];
            [tableView setBackgroundColor:tableViewBackgroundImage];

        }
        return [self->recipesForThisMenu count];
    }
    else {
        return 0;
    }
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //cell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"grey.png"]];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MRecipeCell *recipeCell;
    UITableViewCell *menuCell;
    
    if (tableView.tag == 10) {
        recipeCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (recipeCell == nil) {
            recipeCell = [[MRecipeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
    } else if (tableView.tag == 11) {

        menuCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

        if (menuCell == nil) {
            menuCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            menuCell.contentView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"table-menus-bg.png"]];
            menuCell.textLabel.backgroundColor = [UIColor clearColor];
            menuCell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:14];
            
            UIView *bgColorView = [[UIView alloc] init];
            [bgColorView setBackgroundColor:[UIColor colorWithRed:58.0/255.0f green:62.0/255.0f blue:64.0/255.0f alpha:1]];
            [menuCell setSelectedBackgroundView:bgColorView];
            
            UIImageView *icoListing = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ico-listing.png"]];
            menuCell.imageView.image = icoListing.image;
        }
    }
    if(tableView.tag == 11) {
        menuCell.textLabel.text = [[self->menus objectAtIndex:indexPath.row] Name];
    } else if(tableView.tag == 10) {
        recipeCell.mainLabel.text = [[self->recipesForThisMenu objectAtIndex:indexPath.row] Name];
        recipeCell.secondLabel.text = [[self->recipesForThisMenu objectAtIndex:indexPath.row] Description];
        if([[self->recipesForThisMenu objectAtIndex:indexPath.row] IsFavorite] ) {
            //favIcon.image = [UIImage imageNamed:@"star_enabled_brushed.png"];
            recipeCell.favIconBtn.backgroundColor = [UIColor colorWithPatternImage: [UIImage imageNamed:@"star_enabled_brushed.png"]];
        } else {
            //favIcon.image = [UIImage imageNamed:@"star_disabled_brushed.png"];
            recipeCell.favIconBtn.backgroundColor = [UIColor colorWithPatternImage: [UIImage imageNamed:@"star_disabled_brushed.png"]];
        }
        //[recipeCell customAddSubview];
    }
    
    return tableView.tag == 11 ?  menuCell : recipeCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 10) {
        return  55;
    }
    return 40;
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
            currentItem.rightBarButtonItems = nil;
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
        
        UITableViewCell *oldCell= [tableView cellForRowAtIndexPath:oldIndexPath];
        UIImageView *icoListingDark = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ico-listing.png"]];
        oldCell.imageView.image = icoListingDark.image;
        
        if (oldIndexPath != indexPath) {
            UITableViewCell *newCell= [tableView cellForRowAtIndexPath:indexPath];
            UIImageView *icoListingLight = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ico-listing-light.png"]];
            newCell.imageView.image = icoListingLight.image;
            oldIndexPath = indexPath;
        }
        
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


    UIBarButtonItem *buttonShoppingBag = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"shopping_bag.png"]
                                                                         style:UIBarButtonSystemItemAdd
                                                                         target:self
                                                                         action:@selector(ShowShoppingBag)];
    
    [buttons addObject:buttonShoppingBag];
    
    UIBarButtonItem *buttonPlus = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"btn-add.png"]
                                                                   style:UIBarButtonSystemItemAdd
                                                                  target:self
                                                                  action:@selector(AddExistingRecipe)];
    UIImage *plusButtonBgImage = [[UIImage imageNamed:@"button-green-bg.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 6, 0, 6)];
    [buttonPlus setBackgroundImage:plusButtonBgImage forState:UIControlStateNormal barMetrics:UIBarButtonSystemItemCamera];
    
    [buttons addObject:buttonPlus];

    
    UIBarButtonItem *buttonMainMenu = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ico-main-menu.png"]
                                                                          style:UIBarButtonSystemItemAdd
                                                                         target:self
                                                                         action:@selector(FaceButtonClicked)];
    
    // Add buttons to toolbar and toolbar to nav bar.
    UINavigationItem* currentItem = [self.navigationBar.items objectAtIndex:0];
    currentItem.rightBarButtonItems = buttons;
    currentItem.leftBarButtonItem = buttonMainMenu;

    //add button to navigationBarMenu
    UIBarButtonItem *addMenuBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"btn-add-menu.png"]
                                                                   style:UIBarButtonSystemItemAdd
                                                                  target:self
                                                                  action:@selector(AddMenuClicked)];
    UIImage *addMenuBtnBg = [[UIImage imageNamed:@"button2-bg.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 6, 0, 6)];
    [addMenuBtn setBackgroundImage:addMenuBtnBg forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    
    
    UINavigationItem *currentMenuBarItem = [self.navigationBarMenu.items objectAtIndex:0];
    currentMenuBarItem.leftBarButtonItem = addMenuBtn;
}

- (IBAction)AddMenuClicked {
    MMenuController* addMenu = [[MMenuController alloc] initWithNibName:@"MMenuController" bundle:nil];
    addMenu.parent = self;
    [self.navigationController pushViewController:addMenu animated:YES];
}
- (void)FaceButtonClicked {
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
