//
//  XCPhotoPickerController.m
//  XCPhotoSelectController
//
//  Created by 小蔡 on 16/6/16.
//  Copyright © 2016年 小蔡. All rights reserved.
//

#import "XCImagePickerController.h"
#import "XCAlbumViewController.h"
#import "XCPhohoViewController.h"

@interface XCImagePickerController ()

@end

@implementation XCImagePickerController

- (instancetype)initWithMaxPhotosCount:(NSInteger)maxPhotosCount isAllAlbums:(BOOL)isAllAlbums delegate:(id<XCImagePickerControllerDelegate>)delegate
{
    XCAlbumViewController * albumVC = [[XCAlbumViewController alloc] init];
    albumVC.isAllAlbums = isAllAlbums;
    self = [super initWithRootViewController:albumVC];
    if (self) {
        self.maxPhotosCount = maxPhotosCount > 0 ? maxPhotosCount : 9; // Default is 9 / 默认最大可选9张图片
        self.pickerDelegate = delegate;
        
        if (![[XCPhotoLibraryManager shareManager] authorizationStatusAuthorized]) {
            UILabel *tipLable = [[UILabel alloc] init];
            tipLable.frame = CGRectMake(10, 0, SCREEN_WIDTH - 20, SCREEN_HEIGHT - 100);
            tipLable.textAlignment = NSTextAlignmentCenter;
            tipLable.numberOfLines = 0;
            tipLable.font = [UIFont boldSystemFontOfSize:16];
            tipLable.textColor = [UIColor lightGrayColor];
            NSString *appName = [[NSBundle mainBundle].infoDictionary valueForKey:@"CFBundleDisplayName"];
            if (!appName) appName = [[NSBundle mainBundle].infoDictionary valueForKey:@"CFBundleName"];
            tipLable.text = [NSString stringWithFormat:@"请在%@的\"设置-隐私-照片\"选项中，\r允许%@访问你的手机相册。",[UIDevice currentDevice].model,appName];
            [self.view addSubview:tipLable];
        } else {
            WS(weakSelf);
            XCPhohoViewController * pickerVC = [[XCPhohoViewController alloc] init];
            [[XCPhotoLibraryManager shareManager] getCameraRollAlbumCompletion:^(XCAlbumModel * model) {
                pickerVC.albumModel = model;
                [weakSelf pushViewController:pickerVC animated:YES];
            }];
        }
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self preferredStatusBarStyle];
    [self prefersStatusBarHidden];
    [self preferredStatusBarUpdateAnimation];
    
    self.navigationBar.barStyle = UIBarStyleBlack;
    self.navigationBar.tintColor = [UIColor whiteColor];
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
