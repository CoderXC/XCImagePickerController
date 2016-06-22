//
//  XCPhotoCell.m
//  XCPhotoSelectController
//
//  Created by 小蔡 on 16/6/16.
//  Copyright © 2016年 小蔡. All rights reserved.
//

#import "XCPhotoCell.h"
#import "Masonry.h"

@interface XCPhotoCell ()

@property (nonatomic, strong) UIImageView * photoView;
@property (nonatomic, strong) UIView * selectMaskView;
@property (nonatomic, strong) UIImageView * selectView;

@end

@implementation XCPhotoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
    }
    return self;
}


- (void)initUI
{
    self.photoView = [[UIImageView alloc] initWithFrame:self.bounds];
    self.photoView.contentMode = UIViewContentModeScaleAspectFill;
    self.photoView.clipsToBounds = YES;
    [self addSubview:self.photoView];
    
    self.selectMaskView = [[UIView alloc] initWithFrame:self.bounds];
    self.selectMaskView.backgroundColor = [UIColor colorWithWhite:1 alpha:.4];
    [self addSubview:self.selectMaskView];

    self.selectView = [[UIImageView alloc] init];
    self.selectView.image = [UIImage imageNamed:@"AssetsPickerChecked"];
    [self.selectMaskView addSubview:self.selectView];
    CGFloat margin = 4;
    [self.selectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.selectMaskView.mas_right).offset(-margin);
        make.bottom.equalTo(self.selectMaskView.mas_bottom).offset(-margin);
        make.width.and.height.equalTo(@(30));
    }];
}

- (void)setModel:(XCAssetModel *)model
{
    _model = model;
    if (model.photo) {
        _photoView.image = model.photo;
    } else {
        [[XCPhotoLibraryManager shareManager] getPhotoWithAsset:model.result photoWidth:self.bounds.size.width completion:^(UIImage *photo, NSDictionary *info) {
            _photoView.image = photo;
            model.photo = photo;
        }];
    }
    self.selectMaskView.hidden = !model.isSelected;
}

@end
