//
//  XCPhotoLibraryController.m
//  XCPhotoSelectController
//
//  Created by 小蔡 on 16/6/16.
//  Copyright © 2016年 小蔡. All rights reserved.
//

#import "XCAlbumViewController.h"
#import "XCPhohoViewController.h"
#import "XCImagePickerController.h"
#import "XCAlbumCell.h"

@interface XCAlbumViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray * albums;
@property (nonatomic, strong) UITableView * tableView;

@end

@implementation XCAlbumViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"相册";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancel)];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    
    _albums = [[NSMutableArray alloc] init];
    
    WS(weakSelf);
    if (self.isAllAlbums) {
        [[XCPhotoLibraryManager shareManager] getAllAlbumsCompletion:^(NSArray<XCAlbumModel *> *models) {
            [weakSelf.albums removeAllObjects];
            [weakSelf.albums addObjectsFromArray:models];
            [weakSelf.tableView reloadData];
        }];
    } else {
        [[XCPhotoLibraryManager shareManager] getCameraRollAlbumCompletion:^(XCAlbumModel *model) {
            [weakSelf.albums removeAllObjects];
            [weakSelf.albums addObject:model];
            [weakSelf.tableView reloadData];
        }];
    }
}

- (void)cancel
{
    XCImagePickerController * pickerController = (XCImagePickerController *)self.navigationController;
    if ([pickerController.pickerDelegate respondsToSelector:@selector(pickerControllerDidCancel:)]) {
        [pickerController.pickerDelegate pickerControllerDidCancel:pickerController];
    }
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.rowHeight = XCAlbumCell_height;
        [_tableView registerClass:[XCAlbumCell class] forCellReuseIdentifier:@"XCAlbumCell"];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _albums.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XCAlbumCell * cell = [tableView dequeueReusableCellWithIdentifier:@"XCAlbumCell"];
    cell.model = _albums[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    XCPhohoViewController * photoVC = [[XCPhohoViewController alloc] init];
    photoVC.albumModel = _albums[indexPath.row];
    [self.navigationController pushViewController:photoVC animated:YES];
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
