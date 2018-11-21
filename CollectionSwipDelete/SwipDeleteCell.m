//
//  SwipDeleteCell.m
//  CollectionSwipDelete
//
//  Created by 储诚鹏 on 2018/11/20.
//  Copyright © 2018 储诚鹏. All rights reserved.
//

#import "SwipDeleteCell.h"

@implementation SwipDeleteCell
{
    __weak IBOutlet UILabel *nameLabel;
    
}

- (void)setName:(NSString *)name {
    nameLabel.text = name;
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

@end
