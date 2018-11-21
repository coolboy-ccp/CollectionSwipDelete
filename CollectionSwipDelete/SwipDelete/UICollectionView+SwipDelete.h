//
//  UICollectionView+SwipDelete.h
//  CollectionSwipDelete
//
//  Created by 储诚鹏 on 2018/11/20.
//  Copyright © 2018 储诚鹏. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^DeleteBlock) (NSIndexPath *indexPath, UICollectionView *collectionView);

@interface UICollectionView (SwipDelete)

@property (nonatomic, strong, nullable) UICollectionViewCell *editingCell;
@property (nonatomic, strong, nullable) UICollectionViewCell *touchedCell;
@property (nonatomic, copy) DeleteBlock delCallback;

- (void)enableEdit;

@end

NS_ASSUME_NONNULL_END
