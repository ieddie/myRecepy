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

@interface MRecipesForMenuController : UIViewController <UITableViewDelegate, UITableViewDataSource, MNavigationParent>

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil MenuId:(NSInteger)MenuId;
- (void) ChildIsUnloading;


@property (weak, nonatomic) IBOutlet UILabel *lblDescription;

@property (weak, nonatomic) IBOutlet UINavigationBar* navigationBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
