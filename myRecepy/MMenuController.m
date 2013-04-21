//
//  MRecipeListController.m
//  myRecipeList
//
//  Created by Eduard Kantsevich on 3/3/13.
//  Copyright (c) 2013 Med. All rights reserved.
//

#import "MMenuController.h"
#import "MIngredients.h"
#import "MMenus.h"

@implementation MMenuController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)DoneAddingClicked:(id)sender {
    [[MMenus Instance] addNewMenuWithName:self.nameTxtFld.text Desctiption:self.descriptionTxtFld.text];
    [self.parent ChildIsUnloading];
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)backBtnClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    [theTextField resignFirstResponder];
    return YES;
}

- (void)viewDidUnload {
    [self setNameTxtFld:nil];
    [self setDescriptionTxtFld:nil];
    [super viewDidUnload];
}
@end
