//
//  MIngredientController.m
//  myRecipeList
//
//  Created by Eduard Kantsevich on 3/3/13.
//  Copyright (c) 2013 Med. All rights reserved.
//

#import "MIngredientController.h"

@interface MIngredientController ()

@end

@implementation MIngredientController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
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
- (IBAction)addButtonClicked:(id)sender {
    if(self.IngredientName.text.length == 0) {
        return;
    }
    [[MIngredients Instance] addNewIngredient:self.IngredientName.text];
    MIngredientsController* parent = self.delegate;
    [parent refreshListOfIngredients];
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    [theTextField resignFirstResponder];
    
    [self addButtonClicked:self];
    return YES;
}

@end
