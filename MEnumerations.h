//
//  MEnumerations.h
//  myRecipeList
//
//  Created by Eduard Kantsevich on 1/22/13.
//  Copyright (c) 2013 Med. All rights reserved.
//

typedef enum {
    Success = 0,
    ContraintViolation = 1,
    GenericDBError = 2
} MResultCode;

@protocol MNavigationParent <NSObject>
@required
-(void) ChildIsUnloading;
@end

@protocol MParentWithNewIngredient
@required
-(void) AddNewIngredient:(id) newIngredient;
@end

