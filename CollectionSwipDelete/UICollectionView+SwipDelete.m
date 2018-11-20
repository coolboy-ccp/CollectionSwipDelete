//
//  UICollectionView+SwipDelete.m
//  CollectionSwipDelete
//
//  Created by 储诚鹏 on 2018/11/20.
//  Copyright © 2018 储诚鹏. All rights reserved.
//

#import "UICollectionView+SwipDelete.h"
#import <objc/runtime.h>

const void *editingCellKey = &editingCellKey;
const void *touchedCellKey = &touchedCellKey;

@implementation UICollectionView (SwipDelete)

- (void)setEditingCell:(UICollectionViewCell *)editingCell {
    objc_setAssociatedObject(self, editingCellKey, editingCell, OBJC_ASSOCIATION_RETAIN);
}

- (UICollectionViewCell *)editingCell {
    return objc_getAssociatedObject(self, editingCellKey);
}

- (void)setTouchedCell:(UICollectionViewCell *)touchedCell {
    objc_setAssociatedObject(self, touchedCellKey, touchedCell, OBJC_ASSOCIATION_RETAIN);
}

- (UICollectionViewCell *)touchedCell {
    return objc_getAssociatedObject(self, touchedCellKey);
}

@end
