//
//  XCPhohoPickerViewController.m
//  XCPhotoSelectController
//
//  Created by 小蔡 on 16/6/16.
//  Copyright © 2016年 小蔡. All rights reserved.
//

@interface XCCollectionFootView : UICollectionReusableView

@property (nonatomic, strong) UILabel * titleLable;

@end

@implementation XCCollectionFootView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.titleLable = [[UILabel alloc] initWithFrame:CGRectMake(0,0, self.frame.size.width,self.frame.size.height)];
        self.titleLable.font = [UIFont systemFontOfSize:16];
        self.titleLable.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.titleLable];
    }
    return self;
}

@end


#import "XCPhohoViewController.h"
#import "XCImagePickerController.h"
#import "XCPhotoCell.h"
#import "XCAlbumModel.h"

#define XCCollectionView_FooterHeight 50

@interface XCPhohoViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic, strong) NSMutableArray * photos;
@property (nonatomic, strong) NSMutableArray * selectPhotos;

@property (nonatomic, strong) UICollectionView * collectionView;
@property (nonatomic, strong) UILabel * footerLable;

@end

@implementation XCPhohoViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (_photos.count > 0) {
        [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:(_photos.count - 1) inSection:0] atScrollPosition:UICollectionViewScrollPositionBottom animated:NO];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];

    self.navigationItem.title = self.albumModel.name;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(finishPicking)];
    
    _photos = [[NSMutableArray alloc] init];
    _selectPhotos = [[NSMutableArray alloc] init];
    
    [self.view addSubview:self.collectionView];
    
    WS(weakSelf);
    [[XCPhotoLibraryManager shareManager] getAssetsFromFetchResult:self.albumModel.result completion:^(NSArray<XCAssetModel *> * photoArr) {
        [weakSelf.photos removeAllObjects];
        [weakSelf.photos addObjectsFromArray:photoArr];
        [weakSelf.collectionView reloadData];
    }];
}

- (void)finishPicking
{
    XCImagePickerController * pickerController = (XCImagePickerController *)self.navigationController;
    if ([pickerController.pickerDelegate respondsToSelector:@selector(pickerController:didFinishPickingAssets:)]) {
        [pickerController.pickerDelegate pickerController:pickerController didFinishPickingAssets:_selectPhotos];
    }
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        CGFloat margin = 2;
        CGFloat itemWH = (SCREEN_WIDTH - 3 * margin) / 4;
        layout.itemSize = CGSizeMake(itemWH, itemWH);
        layout.minimumInteritemSpacing = margin;
        layout.minimumLineSpacing = margin;
        [layout setFooterReferenceSize:CGSizeMake(SCREEN_WIDTH, XCCollectionView_FooterHeight)];
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64) collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.alwaysBounceVertical = YES;
        [_collectionView registerClass:[XCPhotoCell class] forCellWithReuseIdentifier:@"XCPhotoCell"];
        [_collectionView registerClass:[XCCollectionFootView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"XCCollectionFootView"];
    }
    return _collectionView;
}

- (UILabel *)footerLable
{
    if (!_footerLable) {
        _footerLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, XCCollectionView_FooterHeight)];
        _footerLable.font = [UIFont systemFontOfSize:16];
        _footerLable.textAlignment = NSTextAlignmentCenter;
    }
    _footerLable.text = [NSString stringWithFormat:@"共有%zd张", _photos.count];
    return _footerLable;
}

#pragma mark --- UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _photos.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    XCPhotoCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"XCPhotoCell" forIndexPath:indexPath];
    cell.model = _photos[indexPath.row];
    return cell;
}


-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableView =nil;
    if (kind ==UICollectionElementKindSectionFooter){
        XCCollectionFootView *footerV = (XCCollectionFootView *)[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"XCCollectionFootView"forIndexPath:indexPath];
        footerV.titleLable.text = [NSString stringWithFormat:@"%zd张照片", _photos.count];
        reusableView = footerV;
    }
    return reusableView;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    XCAssetModel * model = _photos[indexPath.row];
    XCPhotoCell * cell = (XCPhotoCell *)[collectionView cellForItemAtIndexPath:indexPath];
    XCImagePickerController * pickerController = (XCImagePickerController *)self.navigationController;
    
    if (model.isSelected) {
        [_selectPhotos removeObject:model];
        model.isSelected = !model.isSelected;
        cell.model = model;
    } else {
        if (_selectPhotos.count < pickerController.maxPhotosCount) {
            model.isSelected = !model.isSelected;
            cell.model = model;
            [_selectPhotos addObject:model];
        } else {
            [self showAlertWithTitle:[NSString stringWithFormat:@"你最多只能选择%zd张照片",pickerController.maxPhotosCount]];
        }
    }
    self.navigationItem.title = self.selectPhotos.count ? [NSString stringWithFormat:@"你已选择%zd张照片",self.selectPhotos.count] : self.albumModel.name;
}

- (void)showAlertWithTitle:(NSString *)title {
    if (iOS8Later) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"我知道了" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:alertController animated:YES completion:nil];
    } else {
        [[[UIAlertView alloc] initWithTitle:title message:nil delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil] show];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
