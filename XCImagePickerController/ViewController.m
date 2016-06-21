//
//  ViewController.m
//  XCPhotoSelectController
//
//  Created by 小蔡 on 16/6/16.
//  Copyright © 2016年 小蔡. All rights reserved.
//

#import "ViewController.h"
#import "XCImagePickerController.h"
#import "XCPhotoShowCell.h"

@interface ViewController ()<XCImagePickerControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) NSMutableArray * photos;

@property (nonatomic, strong) UICollectionView * collectionView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UIButton * tempBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [tempBtn setTitle:@"添加照片" forState:UIControlStateNormal];
    tempBtn.frame = CGRectMake(0, 30, SCREEN_WIDTH, 50);
    [self.view addSubview:tempBtn];
    [tempBtn addTarget:self action:@selector(tempBtnAction) forControlEvents:UIControlEventTouchUpInside];
    
    _photos = [[NSMutableArray alloc] init];
    
    [self.view addSubview:self.collectionView];
}

- (void)tempBtnAction
{
    XCImagePickerController * pickerContrller = [[XCImagePickerController alloc] initWithMaxPhotosCount:10 isAllAlbums:YES delegate:self];
    [self presentViewController:pickerContrller animated:YES completion:nil];
}

- (void)pickerControllerDidCancel:(XCImagePickerController *)picker
{
    NSLog(@"点击取消");
}

- (void)pickerController:(XCImagePickerController *)picker didFinishPickingAssets:(NSArray<XCAssetModel *> *)assets
{
    NSLog(@"%@", assets);
    if (assets.count > 0) {
        [_photos addObjectsFromArray:assets];
        [_collectionView reloadData];
    }
}

- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        CGFloat margin = 4;
        CGFloat itemWH = (SCREEN_WIDTH - 5 * margin) / 4;
        layout.itemSize = CGSizeMake(itemWH, itemWH);
        layout.minimumInteritemSpacing = margin;
        layout.minimumLineSpacing = margin;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(margin, 100, SCREEN_WIDTH - 2 * margin, SCREEN_HEIGHT - 100) collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.alwaysBounceVertical = YES;
        [_collectionView registerClass:[XCPhotoShowCell class] forCellWithReuseIdentifier:@"XCPhotoShowCell"];
    }
    return _collectionView;
}

#pragma mark --- UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _photos.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    XCPhotoCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"XCPhotoShowCell" forIndexPath:indexPath];
    cell.model = _photos[indexPath.row];
    return cell;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
