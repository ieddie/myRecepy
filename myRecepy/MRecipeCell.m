//
//  MRecipeCell.m
//  myRecipeList
//
//  Created by Sergey Yashchuk on 4/20/13.
//  Copyright (c) 2013 Med. All rights reserved.
//

#import "MRecipeCell.h"

@implementation MRecipeCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"grey.png"]];
        
        self.mainLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 7.0, 220.0, 10)];
        self.mainLabel.tag = 10;
        self.mainLabel.backgroundColor = [UIColor clearColor];
        self.mainLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:14];
        self.mainLabel.textColor = [UIColor blackColor];
        self.mainLabel.text = @"dafs asdf asdf asfd";
        self.mainLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleHeight;
        
        self.secondLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 29.0, 220.0, 10)];
        self.secondLabel.tag = 11;
        self.secondLabel.backgroundColor = [UIColor clearColor];
        self.secondLabel.font = [UIFont systemFontOfSize:12.0];
        self.secondLabel.textColor = [UIColor colorWithRed:136.0/255.0f green:136.0/255.0f blue:136.0/255.0f alpha:1.0];
        self.secondLabel.text = @"dafs asdf asdf asfd";
        self.secondLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleHeight;
        
        self.favIconBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        // Need to setup action for fav Icon
        //[favIconBtn addTarget:self action: forControlEvents:UIControlEventTouchDown];
        self.favIconBtn.frame = CGRectMake(288.0, 18.5, 17.5, 17.5);
        
        [self.contentView addSubview:self.mainLabel];
        [self.contentView addSubview:self.secondLabel];
        [self.contentView addSubview:self.favIconBtn];

    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
