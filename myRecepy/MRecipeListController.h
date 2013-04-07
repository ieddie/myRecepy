//
//  MRecipeListController.h
//  myRecipeList
//
//  Created by Eduard Kantsevich on 3/3/13.
//  Copyright (c) 2013 Med. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MRecipes.h"
#import "MRecipeDetailsController.h"
#import "MMenus.h"
#import "MEnumerations.h"

@interface MRecipeListController : UIViewController <UITableViewDelegate, UITableViewDataSource, MNavigationParent>

@property (weak, nonatomic) IBOutlet UINavigationBar *navigationBar;
@property (weak, nonatomic) IBOutlet UITableView *RecipeListTableView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil Parent:(id<MNavigationParent>)Parent AddToMenu:(NSInteger) menuId;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil;

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

-(void) ChildIsUnloading;
@property(weak, nonatomic) id<MNavigationParent> parent;

@end
