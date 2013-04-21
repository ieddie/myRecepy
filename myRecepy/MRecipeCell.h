//
//  MRecipeCell.h
//  myRecipeList
//
//  Created by Sergey Yashchuk on 4/20/13.
//  Copyright (c) 2013 Med. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MRecipeCell : UITableViewCell

@property (strong, nonatomic) UILabel *mainLabel, *secondLabel;
@property (strong, nonatomic) UIButton *favIconBtn;

@end
