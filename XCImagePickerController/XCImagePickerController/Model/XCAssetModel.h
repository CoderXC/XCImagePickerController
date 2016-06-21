//
//  XCAssetModel.h
//  XCPhotoSelectController
//
//  Created by 小蔡 on 16/6/16.
//  Copyright © 2016年 小蔡. All rights reserved.
//

#import "XCBaseModel.h"

@interface XCAssetModel : XCBaseModel

//照片选中状态 default = NO
@property (nonatomic, assign) BOOL isSelected;

/// 用一个PHAsset/ALAsset实例，初始化一个照片模型
+ (instancetype)modelWithAsset:(id)asset;

@end
