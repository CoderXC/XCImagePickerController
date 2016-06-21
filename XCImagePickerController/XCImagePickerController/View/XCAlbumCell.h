//
//  XCAlbumCell.h
//  XCPhotoSelectController
//
//  Created by 小蔡 on 16/6/16.
//  Copyright © 2016年 小蔡. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XCAlbumModel.h"

#define XCAlbumCell_height 78

@interface XCAlbumCell : UITableViewCell

@property (nonatomic, strong) XCAlbumModel * model;

@end
