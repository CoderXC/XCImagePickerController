//
//  XCAlbumCell.m
//  XCPhotoSelectController
//
//  Created by 小蔡 on 16/6/16.
//  Copyright © 2016年 小蔡. All rights reserved.
//

#import "XCAlbumCell.h"
#import "Masonry.h"

@interface XCAlbumCell ()

@property (nonatomic, strong) UIImageView * albumPhotoView;
@property (nonatomic, strong) UILabel * albumNameLable;
@property (nonatomic, strong) UILabel * albumCountLable;
@property (nonatomic, strong) UIImageView * arrowView;

@end

@implementation XCAlbumCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initUI];
    }
    return self;
}

- (void)initUI
{
    self.albumPhotoView = [[UIImageView alloc] init];
    self.albumPhotoView.contentMode = UIViewContentModeScaleAspectFill;
    self.albumPhotoView.clipsToBounds = YES;
    [self addSubview:self.albumPhotoView];
    CGFloat margin = 14;
    CGFloat photoWidth = XCAlbumCell_height - margin;
    [self.albumPhotoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(margin / 2);
        make.top.equalTo(self.mas_top).offset(margin / 2);
        make.width.and.height.equalTo(@(photoWidth));
    }];
    
    self.arrowView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"TableViewArrow"]];
    [self addSubview:self.arrowView];
    [self.arrowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.and.height.equalTo(@(15));
        make.right.equalTo(self.mas_right).offset(-margin);
        make.centerY.equalTo(self.mas_centerY);
    }];

    self.albumNameLable = [[UILabel alloc] init];
//    self.albumNameLable.backgroundColor = [UIColor orangeColor];
    self.albumNameLable.font = [UIFont systemFontOfSize:16];
    [self addSubview:self.albumNameLable];
    [self.albumNameLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.albumPhotoView.mas_right).offset(margin);
        make.right.equalTo(self.arrowView.mas_left).offset(-margin);
        make.bottom.equalTo(self.mas_centerY).offset(-2);
    }];
    
    self.albumCountLable = [[UILabel alloc] init];
    self.albumCountLable.font = [UIFont systemFontOfSize:12];
    [self addSubview:self.albumCountLable];
    [self.albumCountLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.albumNameLable.mas_left);
        make.right.equalTo(self.albumNameLable.mas_right);
        make.top.equalTo(self.mas_centerY).offset(2);
    }];
}

- (void)setModel:(XCAlbumModel *)model
{
    _model = model;
    if (_model.photo) {
        self.albumPhotoView.image = _model.photo;
    } else {
        [[XCPhotoLibraryManager shareManager] getAlbumCoverWithAlbumModel:model completion:^(UIImage *postImage) {
            self.albumPhotoView.image = postImage;
            _model.photo = postImage;
        }];
    }
    self.albumNameLable.text = model.name;
    self.albumCountLable.text = [NSString stringWithFormat:@"%zd", model.count];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
