//
//  XCBaseModel.h
//  XCPhotoSelectController
//
//  Created by 小蔡 on 16/6/16.
//  Copyright © 2016年 小蔡. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AllDefiine.h"
#import "XCPhotoLibraryManager.h"

@interface XCBaseModel : NSObject

@property (nonatomic, strong) UIImage * photo;
@property (nonatomic, strong) id result;             ///< PHFetchResult<PHAsset> or ALAssetsGroup<ALAsset>

@end
