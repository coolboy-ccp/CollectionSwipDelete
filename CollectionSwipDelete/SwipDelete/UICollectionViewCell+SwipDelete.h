//
//  UICollectionViewCell+SwipDelete.h
//  CollectionSwipDelete
//
//  Created by 储诚鹏 on 2018/11/15.
//  Copyright © 2018 储诚鹏. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^SwipDeleteCallback) (void);

@interface UICollectionViewCell (SwipDelete)

@property (nonatomic, copy) SwipDeleteCallback editBlock;

- (void)enableEdit;

@end
