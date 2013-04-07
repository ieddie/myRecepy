//
//  MIngredientsController.h
//  myRecepy
//
//  Created by Eduard Kantsevich on 1/7/13.
//  Copyright (c) 2013 Med. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MIngredients.h"
#import "MEnumerations.h"
#import "MRecipeDetailsController.h"
#import "MIngredientController.h"

@interface MIngredientsController : UIViewController <UITableViewDelegate, UITableViewDataSource>
{
    BOOL searching;
    BOOL letUserSelectRow;
}

@property (strong, nonatomic) id<MParentWithNewIngredient> Parent;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UINavigationBar *navigationBar;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil Parent:(id<MParentWithNewIngredient>)parent;

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
-(void) refreshListOfIngredients;

- (void) doneSearchingClicked;
- (void) searchTableView;

@end
