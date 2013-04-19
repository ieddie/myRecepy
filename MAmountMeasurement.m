//
//  MAmountMeasurement.m
//  myRecipeList
//
//  Created by Eduard Kantsevich on 3/5/13.
//  Copyright (c) 2013 Med. All rights reserved.
//

#import "MAmountMeasurement.h"

@interface MAmountMeasurement ()
{
    NSArray* measurements;
    NSInteger measurementId;
}

@end

@implementation MAmountMeasurement

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self->measurements = [[MMeasurements Instance] availableMeasurements];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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


@end
