//
//  MRecipesForMenuController.h
//  myRecipeList
//
//  Created by Eduard Kantsevich on 3/12/13.
//  Copyright (c) 2013 Med. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MMenu.h"
#import "MMenus.h"
#import "MRecipeDetailsController.h"
#import "MRecipeListController.h"
#import "MEnumerations.h"
#import <QuartzCore/QuartzCore.h>

@interface MRecipesForMenuController : UIViewController <UITableViewDelegate, UITableViewDataSource, MNavigationParent>

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil;
- (void) ChildIsUnloading;


@property (weak, nonatomic) IBOutlet UILabel *lblDescription;

@property (weak, nonatomic) IBOutlet UINavigationBar* navigationBar;
@property (weak, nonatomic) IBOutlet UINavigationBar* navigationBarMenu;

@property (weak, nonatomic) IBOutlet UITableView *recipesTableView;
@property (weak, nonatomic) IBOutlet UITableView *menusTableView;


@property (weak, nonatomic) IBOutlet UIView *topLayer;

@end
