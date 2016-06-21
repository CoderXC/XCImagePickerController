//
//  XCPhotoLibraryManager.h
//  XCPhotoSelectController
//
//  Created by 小蔡 on 16/6/16.
//  Copyright © 2016年 小蔡. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XCAlbumModel.h"
#import "XCAssetModel.h"

@interface XCPhotoLibraryManager : NSObject

+ (instancetype)shareManager;

/// Return YES if Authorized 返回YES如果得到了授权
- (BOOL)authorizationStatusAuthorized;

///Get Album 获得相册/相册数组
//获取相机胶卷相册
- (void)getCameraRollAlbumCompletion:(void (^)(XCAlbumModel *))completion;
//获取所有相册
- (void)getAllAlbumsCompletion:(void (^)(NSArray<XCAlbumModel *> *))completion;

/// Get Asset 获得Asset数组
- (void)getAssetsFromFetchResult:(id)result completion:(void (^)(NSArray<XCAssetModel *> *))completion;

/// Get photo 获得照片
//获取相册的最后一张图片(封面)
- (void)getAlbumCoverWithAlbumModel:(XCAlbumModel *)model completion:(void (^)(UIImage *postImage))completion;
//获取照片
- (void)getPhotoWithAsset:(id)asset completion:(void (^)(UIImage *photo,NSDictionary *info))completion;
//获取图片根据尺寸（px）
- (void)getPhotoWithAsset:(id)asset photoWidth:(CGFloat)photoWidth completion:(void (^)(UIImage *photo,NSDictionary *info))completion;


@end
