//
//  XCAlbumModel.h
//  XCPhotoSelectController
//
//  Created by 小蔡 on 16/6/16.
//  Copyright © 2016年 小蔡. All rights reserved.
//

#import "XCBaseModel.h"

@interface XCAlbumModel : XCBaseModel

@property (nonatomic, strong) UIImage * albumPhoto; //相册首张图片

@property (nonatomic, strong) NSString *name;        ///< The album name
@property (nonatomic, assign) NSInteger count;       ///< Count of photos the album contain

+ (instancetype)modelWithResult:(id)result name:(NSString *)name;

@end
