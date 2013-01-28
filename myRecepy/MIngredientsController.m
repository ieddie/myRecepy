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
    MRecipeWithIngredients* recipe;
    NSInteger counter;
    __weak IBOutlet UITableView *ingredienttable;
}
@end

@implementation MIngredientsController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        recipe = [[MRecipeWithIngredients alloc] init];
        counter = 0;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnAddIngredient:(id)sender {
    MIngredientWithAmount* ingredient = [[MIngredientWithAmount alloc] initWithIngredient:nil
                                                                                   Amount:1.0
                                                                              Measurement:[[MMeasurement alloc] initWithId:1 Name:@"Something"]];
    [recipe addIngredient:ingredient];
    [ingredienttable reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [recipe getNumberOfIngridients];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                       reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.text = [[[recipe getIngredientAtIndex:indexPath.row] Ingredient] IngredientName];
    return cell;
}


@end
