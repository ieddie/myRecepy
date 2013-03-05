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
    NSArray* measurements;
    NSInteger counter;
    NSInteger measurementId;
    __weak IBOutlet UITableView *ingredienttable;
}
@end

@implementation MIngredientsController

static NSString *CellIdentifier = @"Cell";

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self->ingrSearchResult = [[NSMutableArray alloc] init];
        self->ingredients = [[MIngredients Instance] availableIngredients];
        self->measurements = [[MMeasurements Instance] availableMeasurements];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

	//Add the search bar
    self.tableView.tableHeaderView = self.searchBar;
    self.searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
    
    searching = NO;
    letUserSelectRow = YES;
}

-(void) refreshListOfIngredients
{
    self->ingredients = [[MIngredients Instance] availableIngredients];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)AddNewIngredientClicked:(id)sender {
    [self.tableView setEditing:FALSE animated:TRUE];
    /*
    MIngredientController *addNewIngredientController = [[MIngredientController alloc] initWithNibName:@"MIngredientController" bundle:nil];
    addNewIngredientController.delegate = self;
    [self.navigationController pushViewController:addNewIngredientController animated:YES];
     */
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
    /*
    MRecipeDetailsController* parent = self.delegate;
    parent.ingredientToAddId = [[ingredients objectAtIndex:indexPath.row] Id];
    [self.navigationController popViewControllerAnimated:YES];
     */
}

- (NSIndexPath *)tableView :(UITableView *)theTableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(letUserSelectRow)
        return indexPath;
    else
        return nil;
}

- (void)pickerView:(UIPickerView *)pV didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self->measurementId = [[self->measurements objectAtIndex:row] Id];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [self->measurements count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [[self->measurements objectAtIndex:row] Name];
}

- (void) searchBarTextDidBeginEditing:(UISearchBar *)theSearchBar {
    
    searching = YES;
    letUserSelectRow = NO;
    self.tableView.scrollEnabled = NO;
    
    //Add the done button.
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                                           target:self
                                                                                           action:@selector(doneSearchingClicked)];
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
    self.navigationItem.rightBarButtonItem = nil;
    self.tableView.scrollEnabled = YES;
    
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
