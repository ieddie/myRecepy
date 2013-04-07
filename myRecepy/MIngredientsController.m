//
//  MIngredientsController.m
//  myRecepy
//
//  Created by Eduard Kantsevich on 1/7/13.
//  Copyright (c) 2013 Med. All rights reserved.
//

#import "MIngredientsController.h"
#import "MRecipe.h"
#import "MIngredientWithAmount.h"
#import "MRecipeWithIngredients.h"

@interface MIngredientsController ()
{
    NSMutableArray* ingrSearchResult;
    NSArray* ingredients;
    NSInteger counter;
    
    __weak IBOutlet UITableView *ingredienttable;
}
@end

@implementation MIngredientsController

static NSString *CellIdentifier = @"Cell";

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil Parent:(id<MParentWithNewIngredient>)parent
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self->ingrSearchResult = [[NSMutableArray alloc] init];
        self->ingredients = [[MIngredients Instance] availableIngredients];
        [self setParent:parent];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

	//Add the search bar, set no autocorrection
    self.tableView.tableHeaderView = self.searchBar;
    self.searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
    
    searching = NO;
    letUserSelectRow = YES;
    
    // add standard "+" button
    UINavigationItem* currentItem = [self.navigationBar.items objectAtIndex:0];
    UIBarButtonItem* buttonPlus = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                                target:self
                                                                                action:@selector(AddNewIngredientClicked:)];
    currentItem.rightBarButtonItem = buttonPlus;
}

-(void) createThreeButtons
{
    // these numbers would not work for iPad, need to take idiom into effect
    UIToolbar *tools = [[UIToolbar alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 103.0f, 44.0f)];
    tools.clearsContextBeforeDrawing = NO;
    tools.clipsToBounds = NO;
    tools.tintColor = [UIColor colorWithWhite:0.305f alpha:0.0f]; // should be close to black
    tools.barStyle = -1; // clear background
    
    NSMutableArray *buttons = [[NSMutableArray alloc] initWithCapacity:3];
    
    UIBarButtonItem* buttonPlus = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                                target:self
                                                                                action:@selector(AddNewIngredientClicked:)];
    [buttons addObject:buttonPlus];
    
    // Create a spacer.
    UIBarButtonItem* spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                            target:nil
                                                                            action:nil];
    spacer.width = 12.0f;
    [buttons addObject:spacer];
    
    // create "Done" button
    UIBarButtonItem* buttonDone = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                     target:self
                                                                     action:@selector(doneSearchingClicked)];
    [buttons addObject:buttonDone];
    
    // Add buttons to toolbar and toolbar to nav bar.
    [tools setItems:buttons animated:NO];
    
    UIBarButtonItem *allButtonsInOne = [[UIBarButtonItem alloc] initWithCustomView:tools];
    UINavigationItem* currentItem = [self.navigationBar.items objectAtIndex:0];
    currentItem.rightBarButtonItem = allButtonsInOne;
}

-(void) refreshListOfIngredients
{
    self->ingredients = [[MIngredients Instance] availableIngredients];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)AddNewIngredientClicked:(id)sender {
    MIngredientController *addNewIngredientController = [[MIngredientController alloc] initWithNibName:@"MIngredientController" bundle:nil];
    addNewIngredientController.delegate = self;
    [self.navigationController pushViewController:addNewIngredientController animated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(searching) {
        return [self->ingrSearchResult count];
    } else {
        return [self->ingredients count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                       reuseIdentifier:CellIdentifier];
    }
    if(searching) {
        cell.textLabel.text = [[ingrSearchResult objectAtIndex:indexPath.row] Name];
    } else {
        cell.textLabel.text = [[ingredients objectAtIndex:indexPath.row] Name];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MMeasurement* measurement = [[MMeasurement alloc] initWithId:1];
    MIngredient* ingredientToAdd = [ingredients objectAtIndex:indexPath.row];
    MIngredientWithAmount* ingredientWithAmountToAdd = [[MIngredientWithAmount alloc] initWithIngredient:ingredientToAdd Amount:1.0f Measurement:measurement];
    
    [self.Parent AddNewIngredient:ingredientWithAmountToAdd];
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSIndexPath *)tableView :(UITableView *)theTableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(letUserSelectRow)
        return indexPath;
    else
        return nil;
}

- (void) searchBarTextDidBeginEditing:(UISearchBar *)theSearchBar {
    
    searching = YES;
    letUserSelectRow = NO;
    self.tableView.scrollEnabled = NO;
    
    // Add the done button.
    [self createThreeButtons];
}

- (void) searchBarSearchButtonClicked:(UISearchBar *)theSearchBar {
    
    [self searchTableView];
}

- (void) doneSearchingClicked
{
    self.searchBar.text = @"";
    [self.searchBar resignFirstResponder];
    
    letUserSelectRow = YES;
    searching = NO;
        
    self.tableView.scrollEnabled = YES;
    
    // go back to two buttons
    UIBarButtonItem* buttonPlus = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                                target:self
                                                                                action:@selector(AddNewIngredientClicked:)];
    UINavigationItem* currentItem = [self.navigationBar.items objectAtIndex:0];
    currentItem.rightBarButtonItem = buttonPlus;
    [self.tableView reloadData];
}

//RootViewController.m
- (void)searchBar:(UISearchBar *)theSearchBar textDidChange:(NSString *)searchText {
    
    //Remove all objects first.
    [ingrSearchResult removeAllObjects];
    
    if([searchText length] > 0) {
        searching = YES;
        letUserSelectRow = YES;
        self.tableView.scrollEnabled = YES;
        [self searchTableView];
    }
    else {
        searching = NO;
        letUserSelectRow = NO;
        self.tableView.scrollEnabled = NO;
    }
    
    [self.tableView reloadData];
}
- (IBAction)closeClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) searchTableView
{
    NSString *searchText = self.searchBar.text;
    
    for (MIngredient* ingredient in self->ingredients)
    {
        NSString* ingredientName = [ingredient Name];
        NSRange titleResultsRange = [ingredientName rangeOfString:searchText options:NSCaseInsensitiveSearch];
        
        if (titleResultsRange.length > 0)
            [self->ingrSearchResult addObject:ingredient];
    }
}

@end
