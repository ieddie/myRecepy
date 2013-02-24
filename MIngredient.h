//
//  MIngredient.h
//  myRecepy
//
//  Created by Eduard Kantsevich on 1/11/13.
//  Copyright (c) 2013 Med. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MIngredient : NSObject

@property (nonatomic) NSInteger Id;
@property (strong, nonatomic) NSString* Name;

- (id)initWithId:(NSInteger)ID Name:(NSString*)name;

@end
