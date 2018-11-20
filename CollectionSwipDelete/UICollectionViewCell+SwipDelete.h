//
//  UICollectionViewCell+SwipDelete.h
//  CollectionSwipDelete
//
//  Created by 储诚鹏 on 2018/11/15.
//  Copyright © 2018 储诚鹏. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef BOOL (^SwipDeleteCallback) (UICollectionViewCell *cell);

@interface UICollectionViewCell (SwipDelete)

@property (nonatomic, assign) BOOL editable;
@property (nonatomic, copy) SwipDeleteCallback editBlock;


@end
