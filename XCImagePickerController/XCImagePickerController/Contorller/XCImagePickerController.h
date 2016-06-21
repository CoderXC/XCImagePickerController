//
//  XCPhotoPickerController.h
//  XCPhotoSelectController
//
//  Created by 小蔡 on 16/6/16.
//  Copyright © 2016年 小蔡. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AllDefiine.h"

@class XCAssetModel;
@class XCImagePickerController;

@protocol XCImagePickerControllerDelegate <NSObject>

@optional
- (void)pickerControllerDidCancel:(XCImagePickerController *)picker;
- (void)pickerController:(XCImagePickerController *)picker didFinishPickingAssets:(NSArray <XCAssetModel *> *)assets;

@end

@interface XCImagePickerController : UINavigationController

//最多选择多少张
@property (nonatomic, assign) NSInteger maxPhotosCount;

@property (nonatomic, weak) id<XCImagePickerControllerDelegate> pickerDelegate;

//初始化方法
- (instancetype)initWithMaxPhotosCount:(NSInteger)maxPhotosCount isAllAlbums:(BOOL)isAllAlbums delegate:(id<XCImagePickerControllerDelegate>)delegate;

@end
