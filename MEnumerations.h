//
//  MEnumerations.h
//  myRecipeList
// version from temp2 branch
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

