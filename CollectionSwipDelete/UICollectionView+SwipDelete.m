//
//  UICollectionView+SwipDelete.m
//  CollectionSwipDelete
//
//  Created by 储诚鹏 on 2018/11/20.
//  Copyright © 2018 储诚鹏. All rights reserved.
//

#import "UICollectionView+SwipDelete.h"
#import "UICollectionViewCell+SwipDelete.h"
#import <objc/runtime.h>

@interface NSObject (SwipDelete)
@end

@implementation NSObject (SwipDelete)
- (__kindof UICollectionViewCell *)swipDeleteCollectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [self swipDeleteCollectionView:collectionView cellForItemAtIndexPath:indexPath];
    [cell enableEdit];
    cell.editBlock = ^{
        if (collectionView.delCallback) {
            NSIndexPath *idp = [collectionView indexPathForCell:collectionView.editingCell];
            collectionView.delCallback(idp, collectionView);
        }
    };
    return cell;
}
@end

const void *editingCellKey = &editingCellKey;
const void *touchedCellKey = &touchedCellKey;
const void *delCallbackKey = &delCallbackKey;

void objc_exchange_method(Class cls, SEL originalSelector, SEL swizzledSelector)
{
    Method originalMethod = class_getInstanceMethod(cls, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(cls, swizzledSelector);
    
    BOOL didAddMethod = class_addMethod(cls, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
    if (didAddMethod) {
        class_replaceMethod(cls, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

@implementation UICollectionView (SwipDelete)

#pragma mark -- propertys setting -- start --


- (void)setDelCallback:(DeleteBlock)delCallback {
    objc_setAssociatedObject(self, delCallbackKey, delCallback, OBJC_ASSOCIATION_COPY);
}

- (DeleteBlock)delCallback {
    return objc_getAssociatedObject(self, delCallbackKey);
}

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

#pragma mark -- propertys setting -- end --

#pragma mark -- enable edit

- (void)enableEdit {
    id delegate = self.dataSource;
    assert(delegate);
    objc_exchange_method([delegate class], @selector(collectionView:cellForItemAtIndexPath:), @selector(swipDeleteCollectionView:cellForItemAtIndexPath:));
}


@end




