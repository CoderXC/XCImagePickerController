//
//  XCPhotoShowCell.m
//  XCImagePickerController
//
//  Created by 小蔡 on 16/6/20.
//  Copyright © 2016年 小蔡. All rights reserved.
//

#import "XCPhotoShowCell.h"

@implementation XCPhotoShowCell

- (void)setModel:(XCAssetModel *)model
{
    model.isSelected = NO;
    [super setModel:model];
}

@end
