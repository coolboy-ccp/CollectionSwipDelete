//
//  ViewController.m
//  CollectionSwipDelete
//
//  Created by 储诚鹏 on 2018/11/15.
//  Copyright © 2018 储诚鹏. All rights reserved.
//

#import "ViewController.h"
#import "SwipDeleteCell.h"
#import "UICollectionView+SwipDelete.h"

@interface ViewController ()<UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, copy) NSMutableArray *datas;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.collectionView registerNib:[UINib nibWithNibName:@"SwipDeleteCell" bundle:nil] forCellWithReuseIdentifier:@"SwipDeleteCell"];
    _datas = [NSMutableArray array];
    for (int i = 0; i < 20; i ++) {
        [_datas addObject:[NSString stringWithFormat:@"SwipDeleteCell__%d",i]];
    }
    [self.collectionView enableEdit];
    [self del];
}

- (void)del {
    self.collectionView.delCallback = ^(NSIndexPath * _Nonnull indexPath, UICollectionView * _Nonnull collectionView) {
        [self.datas removeObjectAtIndex:indexPath.row];
        [self.collectionView deleteItemsAtIndexPaths:@[indexPath]];
    };
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _datas.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SwipDeleteCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SwipDeleteCell" forIndexPath:indexPath];
    cell.name = _datas[indexPath.row];
    NSLog(@"cell name: %@", cell.name);
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(self.view.bounds.size.width, 44);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 1;
}



@end
