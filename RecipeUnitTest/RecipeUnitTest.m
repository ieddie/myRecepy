//
//  RecipeUnitTest.m
//  RecipeUnitTest
//
//  Created by Eduard Kantsevich on 1/27/13.
//  Copyright (c) 2013 Med. All rights reserved.
//

#import "RecipeUnitTest.h"

@implementation RecipeUnitTest

- (void)setUp
{
    [super setUp];
}

- (void)tearDown
{
    [super tearDown];
}

- (void)testAddMesurement {
    NSString* measurementToAdd =@"chashka";
    [[MMeasurements Instance] addNewMeasurement:measurementToAdd];
    NSArray* curMeasurements = [[MMeasurements Instance] availableMeasurements];
    NSInteger length = [curMeasurements count];
    BOOL found = false;
    for (NSInteger i =0; i < length; ++i) {
        MMeasurement* measurement = [curMeasurements objectAtIndex:i];
        if ([[measurement Name] isEqualToString:measurementToAdd]) {
            found = TRUE;
        }
    }
    STAssertTrue(found, @"Added measurement wasn't found");
}

- (void)testGetMesurement {
    NSString* measurementToAdd =@"chashka";
    [[MMeasurements Instance] addNewMeasurement:measurementToAdd];
    NSArray* curMeasurements = [[MMeasurements Instance] availableMeasurements];
    NSInteger length = [curMeasurements count];
    BOOL found = false;
    for (NSInteger i =0; i < length; ++i) {
        MMeasurement* measurement = [curMeasurements objectAtIndex:i];
        if ([[measurement Name] isEqualToString:measurementToAdd]) {
            found = TRUE;
        }
    }
    STAssertTrue(found, @"Added measurement wasn't found");
}

- (void)testGetIngredients {
    NSString* measurementToAdd =@"chashka";
    [[MMeasurements Instance] addNewMeasurement:measurementToAdd];
    NSArray* curMeasurements = [[MMeasurements Instance] availableMeasurements];
    NSInteger length = [curMeasurements count];
    BOOL found = false;
    for (NSInteger i =0; i < length; ++i) {
        MMeasurement* measurement = [curMeasurements objectAtIndex:i];
        if ([[measurement Name] isEqualToString:measurementToAdd]) {
            found = TRUE;
        }
    }
    STAssertTrue(found, @"Added measurement wasn't found");
}

@end
