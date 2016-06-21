//
//  XCAssetModel.m
//  XCPhotoSelectController
//
//  Created by 小蔡 on 16/6/16.
//  Copyright © 2016年 小蔡. All rights reserved.
//

#import "XCAssetModel.h"

@implementation XCAssetModel

+ (instancetype)modelWithAsset:(id)asset
{
    XCAssetModel *model = [[XCAssetModel alloc] init];
    model.result = asset;
    model.isSelected = NO;
    return model;
}
@end
