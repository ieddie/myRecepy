//
//  MIngredient.h
//  myRecepy
//
//  Created by Eduard Kantsevich on 1/11/13.
//  Copyright (c) 2013 Med. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MIngredient : NSObject

@property (strong, nonatomic) NSString* IngredientName;
@property (nonatomic) NSInteger Id;

- (id)initWithId:(NSInteger)ID Name:(NSString*)name;

@end
