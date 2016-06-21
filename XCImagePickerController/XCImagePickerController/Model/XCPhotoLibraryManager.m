//
//  XCPhotoLibraryManager.m
//  XCPhotoSelectController
//
//  Created by 小蔡 on 16/6/16.
//  Copyright © 2016年 小蔡. All rights reserved.
//

#import "XCPhotoLibraryManager.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>

@interface XCPhotoLibraryManager ()

@property (nonatomic, strong) ALAssetsLibrary * assetLibrary;

@end


@implementation XCPhotoLibraryManager

+ (instancetype)shareManager
{
    static XCPhotoLibraryManager * manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
        manager.assetLibrary = [[ALAssetsLibrary alloc] init];
    });
    return manager;
}

/// Return YES if Authorized 返回YES如果得到了授权
- (BOOL)authorizationStatusAuthorized
{
    if (iOS8Later) {
        if ([PHPhotoLibrary authorizationStatus] == PHAuthorizationStatusAuthorized) return YES;
    } else {
        if ([ALAssetsLibrary authorizationStatus] == ALAuthorizationStatusAuthorized) return YES;
    }
    return NO;
}

#pragma mark - 获得相册/相册数组
- (void)getCameraRollAlbumCompletion:(void (^)(XCAlbumModel *))completion{
    __block XCAlbumModel *model;
    if (iOS8Later) {
        PHFetchOptions *option = [[PHFetchOptions alloc] init];
        option.predicate = [NSPredicate predicateWithFormat:@"mediaType == %ld", PHAssetMediaTypeImage];
        option.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
        
        PHFetchResult *smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary options:nil];
        for (PHAssetCollection *collection in smartAlbums) {
            if ([collection.localizedTitle isEqualToString:@"Camera Roll"]) {
                PHFetchResult *fetchResult = [PHAsset fetchAssetsInAssetCollection:collection options:option];
                model = [XCAlbumModel modelWithResult:fetchResult name:collection.localizedTitle];
                XCBlock_Safe(completion, model);
                break;
            }
        }
    } else {
        [self.assetLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
            if ([group numberOfAssets] < 1) return;
            NSString *name = [group valueForProperty:ALAssetsGroupPropertyName];
            if ([name isEqualToString:@"Camera Roll"] || [name isEqualToString:@"相机胶卷"]) {
                model = [XCAlbumModel modelWithResult:group name:name];
                XCBlock_Safe(completion, model);
                *stop = YES;
            }
        } failureBlock:nil];
    }
}

- (void)getAllAlbumsCompletion:(void (^)(NSArray<XCAlbumModel *> *))completion{
    NSMutableArray *albumArr = [NSMutableArray array];
    if (iOS8Later) {
        PHFetchOptions *option = [[PHFetchOptions alloc] init];
        option.predicate = [NSPredicate predicateWithFormat:@"mediaType == %ld", PHAssetMediaTypeImage];
        option.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
        
        PHAssetCollectionSubtype smartAlbumSubtype = PHAssetCollectionSubtypeSmartAlbumUserLibrary | PHAssetCollectionSubtypeSmartAlbumRecentlyAdded | PHAssetCollectionSubtypeSmartAlbumVideos;
        // For iOS 9, We need to show ScreenShots Album && SelfPortraits Album
        if (iOS9Later) {
            smartAlbumSubtype = PHAssetCollectionSubtypeSmartAlbumUserLibrary | PHAssetCollectionSubtypeSmartAlbumRecentlyAdded | PHAssetCollectionSubtypeSmartAlbumScreenshots | PHAssetCollectionSubtypeSmartAlbumSelfPortraits | PHAssetCollectionSubtypeSmartAlbumVideos;
        }
       PHFetchResult *smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:smartAlbumSubtype options:nil];
        for (PHAssetCollection *collection in smartAlbums) {
            PHFetchResult *fetchResult = [PHAsset fetchAssetsInAssetCollection:collection options:option];
            if (fetchResult.count < 1) continue;
            if ([collection.localizedTitle containsString:@"Deleted"]) continue;
            if ([collection.localizedTitle isEqualToString:@"Camera Roll"]) {
                [albumArr insertObject:[XCAlbumModel modelWithResult:fetchResult name:collection.localizedTitle] atIndex:0];
            } else {
                [albumArr addObject:[XCAlbumModel modelWithResult:fetchResult name:collection.localizedTitle]];
            }
        }
        
        PHFetchResult *albums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular | PHAssetCollectionSubtypeAlbumSyncedAlbum options:nil];
        for (PHAssetCollection *collection in albums) {
            PHFetchResult *fetchResult = [PHAsset fetchAssetsInAssetCollection:collection options:option];
            if (fetchResult.count < 1) continue;
            if ([collection.localizedTitle isEqualToString:@"My Photo Stream"]) {
                [albumArr insertObject:[XCAlbumModel modelWithResult:fetchResult name:collection.localizedTitle] atIndex:1];
            } else {
                [albumArr addObject:[XCAlbumModel modelWithResult:fetchResult name:collection.localizedTitle]];
            }
        }
        XCBlock_Safe(completion, albumArr);

    } else {
        [self.assetLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
            if (group == nil) {
                XCBlock_Safe(completion, albumArr);
            }
            if ([group numberOfAssets] < 1) return;
            NSString *name = [group valueForProperty:ALAssetsGroupPropertyName];
            if ([name isEqualToString:@"Camera Roll"] || [name isEqualToString:@"相机胶卷"]) {
                [albumArr insertObject:[XCAlbumModel modelWithResult:group name:name] atIndex:0];
            } else if ([name isEqualToString:@"My Photo Stream"] || [name isEqualToString:@"我的照片流"]) {
                [albumArr insertObject:[XCAlbumModel modelWithResult:group name:name] atIndex:1];
            } else {
                [albumArr addObject:[XCAlbumModel modelWithResult:group name:name]];
            }
        } failureBlock:nil];
    }
}

#pragma mark - Get Asset 获得照片数组
- (void)getAssetsFromFetchResult:(id)result completion:(void (^)(NSArray<XCAssetModel *> *))completion {
    NSMutableArray *photoArr = [NSMutableArray array];
    if ([result isKindOfClass:[PHFetchResult class]]) {
        for (PHAsset *asset in result) {
            [photoArr addObject:[XCAssetModel modelWithAsset:asset]];
        }
        XCBlock_Safe(completion, photoArr);
    } else if ([result isKindOfClass:[ALAssetsGroup class]]) {
        ALAssetsGroup *gruop = (ALAssetsGroup *)result;
        [gruop setAssetsFilter:[ALAssetsFilter allPhotos]];
        [gruop enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
            if (result == nil) {
                XCBlock_Safe(completion, photoArr);
            }
            [photoArr addObject:[XCAssetModel modelWithAsset:result]];
        }];
    }
}

#pragma mark - Get Photo 获得照片本身
- (void)getPhotoWithAsset:(id)asset completion:(void (^)(UIImage *, NSDictionary *))completion
{
    [self getPhotoWithAsset:asset photoWidth:SCREEN_WIDTH completion:completion];
}

- (void)getPhotoWithAsset:(id)asset photoWidth:(CGFloat)photoWidth completion:(void (^)(UIImage *, NSDictionary *))completion
{
    if ([asset isKindOfClass:[PHAsset class]]) {
        PHAsset *phAsset = (PHAsset *)asset;
        CGFloat aspectRatio = phAsset.pixelWidth / (CGFloat)phAsset.pixelHeight;
        CGFloat multiple = [UIScreen mainScreen].scale;
        CGFloat pixelWidth = photoWidth * multiple;
        CGFloat pixelHeight = pixelWidth / aspectRatio;
        [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:CGSizeMake(pixelWidth, pixelHeight) contentMode:PHImageContentModeAspectFit options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            BOOL downloadFinined = (![[info objectForKey:PHImageCancelledKey] boolValue] && ![info objectForKey:PHImageErrorKey] && ![[info objectForKey:PHImageResultIsDegradedKey] boolValue]);
            if (downloadFinined) {
                XCBlock_Safe(completion, result, info);
            }
        }];
    } else if ([asset isKindOfClass:[ALAsset class]]) {
        ALAsset *alAsset = (ALAsset *)asset;
        ALAssetRepresentation *assetRep = [alAsset defaultRepresentation];
        CGImageRef imageRef;
        if (photoWidth == [UIScreen mainScreen].bounds.size.width) {
            imageRef = [assetRep fullScreenImage];
        } else {
            imageRef = alAsset.thumbnail;
        }
        UIImage *image = [UIImage imageWithCGImage:imageRef scale:1.0 orientation:(UIImageOrientation)[assetRep orientation]];
        XCBlock_Safe(completion, image, nil);
    }
}

- (void)getAlbumCoverWithAlbumModel:(XCAlbumModel *)model completion:(void (^)(UIImage *postImage))completion
{
    if (iOS8Later) {
        [self getPhotoWithAsset:[model.result lastObject] photoWidth:SCREEN_WIDTH completion:^(UIImage *photo, NSDictionary *info) {
            XCBlock_Safe(completion, photo);
        }];
    } else {
        ALAssetsGroup *gruop = model.result;
        UIImage *postImage = [UIImage imageWithCGImage:gruop.posterImage];
        XCBlock_Safe(completion, postImage);
    }
}




@end
