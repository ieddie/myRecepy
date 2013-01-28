//
//  MMeasurements.h
//  myRecipeList
//
//  Created by Eduard Kantsevich on 1/19/13.
//  Copyright (c) 2013 Med. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "sqlite3.h"
#import "MMeasurement.h"
#import "MEnumerations.h"

@interface MMeasurements : NSObject
+ (MMeasurements *)Instance;

@property (readonly, strong, nonatomic) NSArray* currentMeasurements;

- (MResultCode) addNewMeasurement:(NSString *) measurement;

@end
