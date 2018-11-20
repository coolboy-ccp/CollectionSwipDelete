//
//  UICollectionViewCell+SwipDelete.m
//  CollectionSwipDelete
//
//  Created by 储诚鹏 on 2018/11/15.
//  Copyright © 2018 储诚鹏. All rights reserved.
//

#import "UICollectionViewCell+SwipDelete.h"
#import <objc/runtime.h>

const void *editableKey = &editableKey;
const void *editBlockKey = &editBlockKey;
const void *deleteBtnKey = &deleteBtnKey;
const void *originCenterXKey = &originCenterXKey;
const void *currentCenterXKey = &currentCenterXKey;

const CGFloat btnWidth = 80;
const CGFloat sureBtnWidth = 120;

@interface UICollectionViewCell()
@property (nonatomic, strong) UIButton *deleteBtn;
@property (nonatomic, assign) CGFloat originCenterX;
@property (nonatomic, assign) CGFloat currentCenterX;
@end

@implementation UICollectionViewCell (SwipDelete)

- (CGFloat)currentCenterX {
    id objc = objc_getAssociatedObject(self, currentCenterXKey);
    return [objc doubleValue];
}

- (void)setCurrentCenterX:(CGFloat)currentCenterX {
    objc_setAssociatedObject(self, currentCenterXKey, @(currentCenterX), OBJC_ASSOCIATION_ASSIGN);
}

- (CGFloat)originCenterX {
    id objc = objc_getAssociatedObject(self, originCenterXKey);
    return [objc floatValue];
}

- (void)setOriginCenterX:(CGFloat)originCenterX {
    objc_setAssociatedObject(self, originCenterXKey, @(originCenterX), OBJC_ASSOCIATION_ASSIGN);
}

- (BOOL)editable {
    id objc = objc_getAssociatedObject(self, editableKey);
    return [objc boolValue];
}

- (void)setEditable:(BOOL)editable {
    if (editable) {
        self.originCenterX = self.center.x;
        self.currentCenterX = self.center.x;
        [self addPanGesture];
        [self addDeletetButton];
    }
    objc_setAssociatedObject(self, editableKey, @(editable), OBJC_ASSOCIATION_ASSIGN);
}

- (SwipDeleteCallback)editBlock {
    return objc_getAssociatedObject(self, editBlockKey);
}

- (void)setEditBlock:(SwipDeleteCallback)editBlock {
    objc_setAssociatedObject(self, editBlockKey, editBlock, OBJC_ASSOCIATION_COPY);
}

- (void)addPanGesture {
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] init];
    [pan addTarget:self action:@selector(panAction:)];
    [self addGestureRecognizer:pan];
}

- (void)panAction:(UIPanGestureRecognizer *)pan {
    static CGFloat oX = 0;
    switch (pan.state) {
        case UIGestureRecognizerStateBegan:
        {
            CGPoint translation = [pan translationInView:self];
            oX = translation.x;
        }
            break;
        case UIGestureRecognizerStateChanged:
        {
            CGPoint translation = [pan translationInView:self];
            CGFloat moveX = translation.x - oX;
            CGPoint velocity = [pan velocityInView:self];
            if (moveX > 0 && velocity.x > self.deleteBtn.frame.size.width) {
                [self hideDelBtn];
                return;
            }
            NSLog(@"velocity-----%lf---%lf", velocity.x, translation.x);
            CGFloat distance = translation.x;
            CGFloat newCenterX = self.currentCenterX + distance;
            if (newCenterX > self.originCenterX) {
                newCenterX = self.originCenterX;
            }
            self.contentView.center = CGPointMake(newCenterX , self.contentView.center.y);
            
        }
            break;
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
        {
            [pan setTranslation:CGPointZero inView:self];
            CGFloat distance = self.originCenterX - self.contentView.center.x;
            BOOL toLeft = distance >= self.deleteBtn.frame.size.width / 2;
            if (toLeft) {
                [self showDelBtn];
            }
            else {
                [self hideDelBtn];
            }
            self.currentCenterX = self.contentView.center.x;
            
        }
            break;
            
        default:
            break;
    }
}

- (void)hideDelBtn {
    [UIView animateWithDuration:0.3 animations:^{
        self.contentView.center = CGPointMake(self.originCenterX, self.contentView.center.y);
    } completion:^(BOOL finished) {
        CGRect oRect = self.deleteBtn.frame;
        if (oRect.size.width == btnWidth) {
            return;
        }
        oRect.size.width = btnWidth;
        oRect.origin.x = self.bounds.size.width - btnWidth;
        self.deleteBtn.frame = oRect;
        [self.deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
    }];
}

- (void)showDelBtn {
    [UIView animateWithDuration:0.3 animations:^{
        self.contentView.center = CGPointMake(self.originCenterX - btnWidth, self.contentView.center.y);
    }];
}

- (void)sureEdit {
    [self.deleteBtn setTitle:@"确认删除" forState:UIControlStateNormal];
    [UIView animateWithDuration:0.3 animations:^{
        self.contentView.center = CGPointMake(self.originCenterX - sureBtnWidth, self.contentView.center.y);
        CGRect oRect = self.deleteBtn.frame;
        oRect.size.width = sureBtnWidth;
        oRect.origin.x = self.bounds.size.width - sureBtnWidth;
        self.deleteBtn.frame = oRect;
    }];
}

- (UIView *)deleteBtn {
    return objc_getAssociatedObject(self, deleteBtnKey);
}

- (void)setDeleteBtn:(UIButton *)deleteBtn {
    objc_setAssociatedObject(self, deleteBtnKey, deleteBtn, OBJC_ASSOCIATION_RETAIN);
}

- (void)addDeletetButton {
    self.contentView.backgroundColor = [UIColor whiteColor];
    UIView *bgView = [[UIView alloc] initWithFrame:self.bounds];
    bgView.backgroundColor = [UIColor redColor];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.titleLabel.textColor = [UIColor whiteColor];
    btn.titleLabel.font = [UIFont systemFontOfSize:16];
    [btn setTitle:@"删除" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(deleteAction:) forControlEvents:UIControlEventTouchUpInside];
    CGFloat width = self.bounds.size.width;
    CGFloat height = self.bounds.size.height;
    btn.frame = CGRectMake(width - 80, 0, btnWidth, height);
    self.deleteBtn = btn;
    [bgView addSubview:btn];
    [self addSubview:bgView];
    [self sendSubviewToBack:bgView];
}

- (void)deleteAction:(UIButton *)btn {
    [self sureEdit];
    if (self.editBlock) {
        BOOL sure = self.editBlock(self);
        if (sure) {
            
        }
    }
}

@end




