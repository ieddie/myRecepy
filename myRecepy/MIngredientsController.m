//
//  MIngredientsController.m
//  myRecepy
//
//  Created by Eduard Kantsevich on 1/7/13.
//  Copyright (c) 2013 Med. All rights reserved.
//

#import "MIngredientsController.h"
#import "MRecipe.h"

@interface MIngredientsController ()
{
    MRecepy* recepy;
    NSInteger counter;
    __weak IBOutlet UITableView *ingredienttable;
}
@end

@implementation MIngredientsController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        recepy = [[MRecepy alloc] initWithName:@"SomeRecepyName"];
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
    NSString* addIngridientWithText = [NSString stringWithFormat:@"%d", ++counter];
    [recepy addIngredient:addIngridientWithText];
    [ingredienttable reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [recepy getNumberOfIngridients];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                       reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.text = [recepy getIngredientAtIndex:indexPath.row];
    return cell;
}


@end
