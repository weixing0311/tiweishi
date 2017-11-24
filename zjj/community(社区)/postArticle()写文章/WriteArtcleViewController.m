//
//  WriteArtcleViewController.m
//  zjj
//
//  Created by iOSdeveloper on 2017/10/24.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "WriteArtcleViewController.h"
#import "TZImagePickerController.h"
#import "UIView+Layout.h"
#import "TZTestCell.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import "LxGridViewFlowLayout.h"
#import "TZImageManager.h"
#import "TZVideoPlayerController.h"
#import "TZPhotoPreviewController.h"
#import "TZGifPhotoPreviewController.h"
#import "TZLocationManager.h"

@interface WriteArtcleViewController ()<TZImagePickerControllerDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UIAlertViewDelegate,UINavigationControllerDelegate,UITextViewDelegate>
{
    NSMutableArray *_selectedPhotos;
    NSMutableArray *_selectedAssets;
    BOOL _isSelectOriginalPhoto;
    
    CGFloat _itemWH;
    CGFloat _margin;
    
}
@property (nonatomic, strong) UIImagePickerController *imagePickerVc;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (strong, nonatomic) LxGridViewFlowLayout *layout;
@property (strong, nonatomic) CLLocation *location;
@property (nonatomic,assign) BOOL isHaveVideo;
@property (nonatomic,strong) UITextView * textView;
@property (nonatomic,copy) NSString * videoUrlStr;
@property (nonatomic,assign) BOOL isShooting;//判断是不是拍摄的视频
@property (nonatomic,copy)   NSURL * shootingVideoUrl;
@property (nonatomic,strong)UILabel * textViewCountLb;
@end

@implementation WriteArtcleViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [self setTBWhiteColor];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"发表状态";
    self.isShooting = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    _selectedPhotos = [NSMutableArray array];
    _selectedAssets = [NSMutableArray array];
    [self configCollectionView];
    [self buildTextView];
    [self buildRightNaviBarItem];
    [self myTypeIsShareImage];
    // Do any additional setup after loading the view.
}
-(void)buildCountLabel
{
    self.textViewCountLb  = [[UILabel alloc]initWithFrame:CGRectMake(JFA_SCREEN_WIDTH-170, 285, 150, 15)];
    self.textViewCountLb.backgroundColor = [UIColor clearColor];
    self.textViewCountLb.text = @"可输入121字";
    self.textViewCountLb.textColor = HEXCOLOR(0x666666);
    self.textViewCountLb.textAlignment = NSTextAlignmentRight;
    [self.view addSubview:self.textViewCountLb];
}
-(void)myTypeIsShareImage
{
    if (self.firstImage) {
        [_selectedPhotos addObject:self.firstImage];
        _textView.text = self.textStr;
        [self.collectionView reloadData];
    }
}
///创建右上button
-(void)buildRightNaviBarItem
{
    UIBarButtonItem * rightItem = [[UIBarButtonItem alloc]initWithTitle:@"发布" style:UIBarButtonItemStylePlain target:self action:@selector(didUpdateInfo)];
    
    self.navigationItem.rightBarButtonItem = rightItem;
    
}
#pragma mark ---网络请求
-(void)didUpdateInfo
{
    NSString *strUrl = [self.textView.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    if (strUrl.length<1&&!self.videoUrlStr&&_selectedPhotos.count<1) {
        [[UserModel shareInstance]showInfoWithStatus:@"文章不能为空"];
    }
    if (self.textView.text.length>100) {
        [[UserModel shareInstance]showInfoWithStatus:@"文章最长100字"];
        return;
    }
    NSMutableDictionary * params =[NSMutableDictionary dictionary];
    [params safeSetObject:[UserModel shareInstance].userId forKey:@"userId"];
    [params safeSetObject:self.textView.text forKey:@"content"];
    
    
    if (self.isHaveVideo==YES) {
        NSData * data;
        if (_isShooting==YES) {
            data = [NSData dataWithContentsOfURL:_shootingVideoUrl];
        }else{
            data = [NSData dataWithContentsOfFile:_videoUrlStr];
        }
        NSData *videoImgData = UIImageJPEGRepresentation(_selectedPhotos[0], 1);
        self.currentTasks = [[BaseSservice sharedManager]
                             postMovie:@"app/community/article/saveArticle.do"
                             paramters:params
                             movieData:data videoImg:videoImgData movieName:nil
                             success:^(NSDictionary *dic) {
                                 
                                 [[UserModel shareInstance]showSuccessWithStatus:@"发表成功"];
                                 DLog(@"dic---%@",dic);
                                 
                                 
                                 [[NSNotificationCenter defaultCenter]postNotificationName:@"SENDARTICLESUCCESS" object:nil];
                                 [self.navigationController popViewControllerAnimated:YES];
                                 
                             }
                             failure:^(NSError *error) {
                                 
                                 DLog(@"error--%@",error);
                             }];
        
    }else{
        self.currentTasks = [[BaseSservice sharedManager]uploadImageWithPath:@"app/community/article/saveArticle.do" photos:_selectedPhotos params:params success:^(NSDictionary *dic) {
            DLog(@"dic---%@",dic);
            [[UserModel shareInstance]showSuccessWithStatus:@"发表成功"];
            DLog(@"dic---%@",dic);
            [[NSNotificationCenter defaultCenter]postNotificationName:@"SENDARTICLESUCCESS" object:nil];
            [self getIntegral];
            [self.navigationController popViewControllerAnimated:YES];
            
        } failure:^(NSError *error) {
            DLog(@"error--%@",error);
            
        }];
    }
}
///完成获取积分任务--- 分享主页 分享健康报告
-(void)getIntegral
{
    if (self.shareType&&self.shareType.length>0) {
        NSMutableDictionary * params = [NSMutableDictionary dictionary];
        [params setObject:_shareType forKey:@"taskId"];
        [params safeSetObject:[UserModel shareInstance].userId forKey:@"userId"];
        
        self.currentTasks = [[BaseSservice sharedManager]post1:@"app/integral/growthsystem/gainPoints.do" HiddenProgress:NO paramters:params success:^(NSDictionary *dic) {
        } failure:^(NSError *error) {
            
        }];
    }
}

///buildTextView
-(void)buildTextView
{
    UIView * textBgView =[[UIView alloc]initWithFrame:CGRectMake(0, 80, JFA_SCREEN_WIDTH, 200)];
    textBgView.backgroundColor = HEXCOLOR(0xffffff);
    
    
    [self.view addSubview:textBgView];
    
    _textView = [[UITextView alloc]initWithFrame:CGRectMake(10, 10, JFA_SCREEN_WIDTH-20, 180) ];
    _textView.textColor = [UIColor blackColor];
    _textView.font  =[UIFont systemFontOfSize:15];
    _textView.delegate = self;
    _textView.returnKeyType = UIReturnKeyDone;
    [textBgView addSubview:_textView];
    
    _textView.layer.borderWidth= 1;
    _textView.layer.borderColor = HEXCOLOR(0xeeeeee).CGColor;
    _textView.layer.cornerRadius = 5;
    _textView.layer.masksToBounds =YES;
    
}

///build imagePickerVc
- (UIImagePickerController *)imagePickerVc {
    if (_imagePickerVc == nil) {
        _imagePickerVc = [[UIImagePickerController alloc] init];
        _imagePickerVc.delegate = self;
        // set appearance / 改变相册选择页的导航栏外观
        _imagePickerVc.navigationBar.barTintColor = self.navigationController.navigationBar.barTintColor;
        _imagePickerVc.navigationBar.tintColor = self.navigationController.navigationBar.tintColor;
        UIBarButtonItem *tzBarItem, *BarItem;
        if (iOS9Later) {
            tzBarItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[TZImagePickerController class]]];
            BarItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[UIImagePickerController class]]];
        } else {
            tzBarItem = [UIBarButtonItem appearanceWhenContainedIn:[TZImagePickerController class], nil];
            BarItem = [UIBarButtonItem appearanceWhenContainedIn:[UIImagePickerController class], nil];
        }
        NSDictionary *titleTextAttributes = [tzBarItem titleTextAttributesForState:UIControlStateNormal];
        [BarItem setTitleTextAttributes:titleTextAttributes forState:UIControlStateNormal];
        
    }
    return _imagePickerVc;
}
- (void)configCollectionView {
    // 如不需要长按排序效果，将LxGridViewFlowLayout类改成UICollectionViewFlowLayout即可
    _layout = [[LxGridViewFlowLayout alloc] init];
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(20, 300, JFA_SCREEN_WIDTH-40, 300) collectionViewLayout:_layout];
    _collectionView.alwaysBounceVertical = YES;
    _collectionView.backgroundColor = [UIColor whiteColor];
    
    _collectionView.contentInset = UIEdgeInsetsMake(4, 4, 4, 4);
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [self.view addSubview:_collectionView];
    [self.collectionView registerNib:[UINib nibWithNibName:@"TZTestCell"bundle:nil]forCellWithReuseIdentifier:@"TZTestCell"];

}
#pragma mark UICollectionView

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _selectedPhotos.count + 1;
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (_selectedPhotos.count>0) {
        if (self.isHaveVideo==YES) {
            UIImage * image = [_selectedPhotos objectAtIndex:0];
            
            return CGSizeMake(280/image.size.height*image.size.width, 280);
        }
        return CGSizeMake((JFA_SCREEN_WIDTH-20)/4-15, (JFA_SCREEN_WIDTH-20)/4-15);

    }else{
        return CGSizeMake((JFA_SCREEN_WIDTH-20)/4-10, (JFA_SCREEN_WIDTH-20)/4-10);
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TZTestCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TZTestCell" forIndexPath:indexPath];
    cell.videoImageView.hidden = YES;
    if (indexPath.row == _selectedPhotos.count) {
        cell.imageView.image = [UIImage imageNamed:@"cameraO_"];
        cell.deleteBtn.hidden = YES;

        if (self.isHaveVideo==YES||_selectedPhotos.count==9) {
            cell.imageView.hidden = YES;
        }else{
            cell.imageView.hidden =NO;
        }
    } else {
        cell.imageView.image = _selectedPhotos[indexPath.row];
        if (_selectedAssets.count>0&&_selectedPhotos.count==_selectedAssets.count) {
            cell.asset = _selectedAssets[indexPath.row];
        }
        cell.deleteBtn.hidden = NO;
    }
    cell.deleteBtn.tag = indexPath.row;
    [cell.deleteBtn addTarget:self action:@selector(deleteBtnClik:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == _selectedPhotos.count) {
        if (self.isHaveVideo==YES||_selectedPhotos.count==9) {
            return;
        }
        [self pushTZImagePickerController];
    } else { // preview photos or video / 预览照片或者视频
        if (_selectedPhotos.count==_selectedAssets.count) {
            id asset = _selectedAssets[indexPath.row];
            BOOL isVideo = NO;
            if ([asset isKindOfClass:[PHAsset class]]) {
                PHAsset *phAsset = asset;
                isVideo = phAsset.mediaType == PHAssetMediaTypeVideo;
            } else if ([asset isKindOfClass:[ALAsset class]]) {
                ALAsset *alAsset = asset;
                isVideo = [[alAsset valueForProperty:ALAssetPropertyType] isEqualToString:ALAssetTypeVideo];
            }
            else if (isVideo) { // perview video / 预览视频
                TZVideoPlayerController *vc = [[TZVideoPlayerController alloc] init];
                TZAssetModel *model = [TZAssetModel modelWithAsset:asset type:TZAssetModelMediaTypeVideo timeLength:@""];
                vc.model = model;
                [self presentViewController:vc animated:YES completion:nil];
            } else { // preview photos / 预览照片
                TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithSelectedAssets:_selectedAssets selectedPhotos:_selectedPhotos index:indexPath.row];
                imagePickerVc.maxImagesCount = 9;
                imagePickerVc.allowPickingGif =NO;
                imagePickerVc.isSelectOriginalPhoto = _isSelectOriginalPhoto;
                [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
                    _selectedPhotos = [NSMutableArray arrayWithArray:photos];
                    _selectedAssets = [NSMutableArray arrayWithArray:assets];
                    _isSelectOriginalPhoto = isSelectOriginalPhoto;
                    [_collectionView reloadData];
                    _collectionView.contentSize = CGSizeMake(0, ((_selectedPhotos.count + 2) / 3 ) * (_margin + _itemWH));
                }];
                [self presentViewController:imagePickerVc animated:YES completion:nil];
            }
        }
    }
}


-(BOOL)isHaveVideo
{
    if (_selectedAssets.count>0) {
        PHAsset *phAsset = _selectedAssets[0];
        if (phAsset.mediaType == PHAssetMediaTypeVideo) {
            return YES;
        }
        else
         {
            return NO;
        }
    }else{
        if (self.shootingVideoUrl)
        {
            return YES;
        }else
        {
            return NO;
        }
    }
}
#pragma mark - LxGridViewDataSource

/// 以下三个方法为长按排序相关代码
//- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath {
//    return indexPath.item < _selectedPhotos.count;
//}

//- (BOOL)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)sourceIndexPath canMoveToIndexPath:(NSIndexPath *)destinationIndexPath {
//    return (sourceIndexPath.item < _selectedPhotos.count && destinationIndexPath.item < _selectedPhotos.count);
//}
//
//- (void)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)sourceIndexPath didMoveToIndexPath:(NSIndexPath *)destinationIndexPath {
//    UIImage *image = _selectedPhotos[sourceIndexPath.item];
//    [_selectedPhotos removeObjectAtIndex:sourceIndexPath.item];
//    [_selectedPhotos insertObject:image atIndex:destinationIndexPath.item];
//
//    id asset = _selectedAssets[sourceIndexPath.item];
//    [_selectedAssets removeObjectAtIndex:sourceIndexPath.item];
//    [_selectedAssets insertObject:asset atIndex:destinationIndexPath.item];
//
//    [_collectionView reloadData];
//}

- (void)pushTZImagePickerController {
    
    UIAlertController * al = [UIAlertController alertControllerWithTitle:@"添加照片/视频" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    if (_selectedPhotos.count==0) {
        [al addAction:[UIAlertAction actionWithTitle:@"拍摄视频" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            
            NSString *mediaType = AVMediaTypeVideo;
            //        pickerCon.mediaTypes = @[(NSString *)];//设定相机为视频
            
            AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
            
            if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied){
                [[UserModel shareInstance]showInfoWithStatus:@"相机权限受限"];
                
                NSLog(@"相机权限受限");
                return;
            }
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeAudio completionHandler:^(BOOL granted) {
                NSLog(@"%@",granted ? @"麦克风准许":@"麦克风不准许");
            }];
            
            AVAuthorizationStatus authStatus1 = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
            if (authStatus1 ==AVAuthorizationStatusNotDetermined||
                authStatus1 ==AVAuthorizationStatusRestricted||
                authStatus1==AVAuthorizationStatusDenied) {
                [[UserModel shareInstance]showInfoWithStatus:@"麦克风未授权"];
                return;
            }
            
            
            UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];//初始化
            picker.delegate = self;
            picker.allowsEditing = NO;//设置可编辑
            picker.sourceType = sourceType;
            
            picker.mediaTypes = @[(NSString *)kUTTypeMovie,(NSString *)kUTTypeVideo];//设定相机为视频
            //        picker.cameraDevice = UIImagePickerControllerCameraDeviceRear;//设置相机后摄像头
            picker.videoMaximumDuration = 10;//最长拍摄时间
            picker.videoQuality = UIImagePickerControllerQualityTypeIFrame1280x720;//拍摄质量
            
            [self presentViewController:picker animated:YES completion:nil];
        }]];

    }

    
    [al addAction:[UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self enterPhotoAlbum];

    }]];
    [al addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    
    [self presentViewController:al animated:YES completion:nil];
}
-(void)enterPhotoAlbum
{
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:9-_selectedPhotos.count columnNumber:4 delegate:self pushPhotoPickerVc:YES];
    // imagePickerVc.navigationBar.translucent = NO;
    
#pragma mark - 五类个性化设置，这些参数都可以不传，此时会走默认设置
    imagePickerVc.isSelectOriginalPhoto = _isSelectOriginalPhoto;
    if (_selectedPhotos.count>0)
    {
        imagePickerVc.allowPickingVideo =NO;
    }
    else
    {
        imagePickerVc.allowPickingVideo =YES;
    }
    // 1.设置目前已经选中的图片数组
    imagePickerVc.selectedAssets = _selectedAssets; // 目前已经选中的图片数组
    imagePickerVc.allowTakePicture = YES; // 在内部显示拍照按钮
    
    
    
    imagePickerVc.showSelectBtn = NO;
    // 设置竖屏下的裁剪尺寸
    NSInteger left = 30;
    NSInteger widthHeight = self.view.tz_width - 2 * left;
    NSInteger top = (self.view.tz_height - widthHeight) / 2;
    imagePickerVc.cropRect = CGRectMake(left, top, widthHeight, widthHeight);
    
    imagePickerVc.isStatusBarDefault = NO;
#pragma mark - 到这里为止
    
    // You can get the photos by block, the same as by delegate.
    // 你可以通过block或者代理，来得到用户选择的照片.
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        
    }];
    
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}
#pragma mark - UIImagePickerController

- (void)takePhoto {
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if ((authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied) && iOS7Later) {
        // 无相机权限 做一个友好的提示
        if (iOS8Later) {
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"无法使用相机" message:@"请在iPhone的""设置-隐私-相机""中允许访问相机" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"设置", nil];
            [alert show];
        } else {
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"无法使用相机" message:@"请在iPhone的""设置-隐私-相机""中允许访问相机" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
        }
    } else if (authStatus == AVAuthorizationStatusNotDetermined) {
        // fix issue 466, 防止用户首次拍照拒绝授权时相机页黑屏
        if (iOS7Later) {
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                if (granted) {
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        [self takePhoto];
                    });
                }
            }];
        } else {
            [self takePhoto];
        }
        // 拍照之前还需要检查相册权限
    } else if ([TZImageManager authorizationStatus] == 2) { // 已被拒绝，没有相册权限，将无法保存拍的照片
        if (iOS8Later) {
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"无法访问相册" message:@"请在iPhone的""设置-隐私-相册""中允许访问相册" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"设置", nil];
            [alert show];
        } else {
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"无法访问相册" message:@"请在iPhone的""设置-隐私-相册""中允许访问相册" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
        }
    } else if ([TZImageManager authorizationStatus] == 0) { // 未请求过相册权限
        [[TZImageManager manager] requestAuthorizationWithCompletion:^{
            [self takePhoto];
        }];
    } else {
        [self pushImagePickerController];
    }
}

// 调用相机
- (void)pushImagePickerController {
    // 提前定位
    __weak typeof(self) weakSelf = self;
    [[TZLocationManager manager] startLocationWithSuccessBlock:^(CLLocation *location, CLLocation *oldLocation) {
        weakSelf.location = location;
    } failureBlock:^(NSError *error) {
        weakSelf.location = nil;
    }];
    
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
        self.imagePickerVc.sourceType = sourceType;
        if(iOS8Later) {
            _imagePickerVc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        }
        [self presentViewController:_imagePickerVc animated:YES completion:nil];
    } else {
        NSLog(@"模拟器中无法打开照相机,请在真机中使用");
    }
}

- (void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    
    
    if ([type isEqualToString:@"public.image"]) {
        TZImagePickerController *tzImagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:self];
        tzImagePickerVc.sortAscendingByModificationDate = YES;
        [tzImagePickerVc showProgressHUD];
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        
        // save photo and get asset / 保存图片，获取到asset
        [[TZImageManager manager] savePhotoWithImage:image location:self.location completion:^(NSError *error){
            if (error) {
                [tzImagePickerVc hideProgressHUD];
                NSLog(@"图片保存失败 %@",error);
            } else {
                [[TZImageManager manager] getCameraRollAlbum:NO allowPickingImage:YES completion:^(TZAlbumModel *model) {
                    [[TZImageManager manager] getAssetsFromFetchResult:model.result allowPickingVideo:NO allowPickingImage:YES completion:^(NSArray<TZAssetModel *> *models) {
                        [tzImagePickerVc hideProgressHUD];
                        TZAssetModel *assetModel = [models firstObject];
                        if (tzImagePickerVc.sortAscendingByModificationDate) {
                            assetModel = [models lastObject];
                        }
                        [self refreshCollectionViewWithAddedAsset:assetModel.asset image:image];
                    }];
                }];
            }
        }];
    }
    else if([type isEqualToString:@"public.movie"])
    {
        if (_selectedPhotos.count!=0) {
            return;
        }
        NSURL *videoURL = [info objectForKey:UIImagePickerControllerMediaURL];
        NSLog(@"found a video");
        
        
        UIImage * image =[self getThumbnailImage:videoURL];
        
        [_selectedPhotos insertObject:image atIndex:0];
        self.isHaveVideo = YES;
        self.shootingVideoUrl = videoURL;
        self.isShooting =YES;
        [self.collectionView reloadData];
    }
}

- (void)refreshCollectionViewWithAddedAsset:(id)asset image:(UIImage *)image {
    [_selectedAssets addObject:asset];
    [_selectedPhotos addObject:image];
    [_collectionView reloadData];
    
    if ([asset isKindOfClass:[PHAsset class]]) {
        PHAsset *phAsset = asset;
        NSLog(@"location:%@",phAsset.location);
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    if ([picker isKindOfClass:[UIImagePickerController class]]) {
        [picker dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) { // take photo / 去拍照
        [self takePhoto];
    } else if (buttonIndex == 1) {
        [self pushTZImagePickerController];
    }
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) { // 去设置界面，开启相机访问权限
        if (iOS8Later) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        }
    }
}
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto {
    
    _selectedPhotos = [NSMutableArray arrayWithArray:photos];
    _selectedAssets = [NSMutableArray arrayWithArray:assets];
    if (self.firstImage) {
        [_selectedPhotos addObject:self.firstImage];
    }
    _isSelectOriginalPhoto = isSelectOriginalPhoto;
    [_collectionView reloadData];
    // _collectionView.contentSize = CGSizeMake(0, ((_selectedPhotos.count + 2) / 3 ) * (_margin + _itemWH));
    
    // 1.打印图片名字
    [self printAssetsName:assets];
    // 2.图片位置信息
    if (iOS8Later) {
        for (PHAsset *phAsset in assets) {
            NSLog(@"location:%@",phAsset.location);
        }
    }
}
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingVideo:(UIImage *)coverImage sourceAssets:(id)asset {
    _selectedPhotos = [NSMutableArray arrayWithArray:@[coverImage]];
    _selectedAssets = [NSMutableArray arrayWithArray:@[asset]];
    // open this code to send video / 打开这段代码发送视频
     [[TZImageManager manager] getVideoOutputPathWithAsset:asset completion:^(NSString *outputPath) {
         
         self.videoUrlStr = outputPath;
     DLog(@"视频导出到本地完成,沙盒路径为:%@",outputPath);
//     Export completed, send video here, send by outputPath or NSData
//     导出完成，在这里写上传代码，通过路径或者通过NSData上传
    
     }];
    [_collectionView reloadData];
}
- (void)deleteBtnClik:(UIButton *)sender {
    
    if ([self isSameImageWithImage:[_selectedPhotos objectAtIndex:sender.tag]]==YES) {
        self.firstImage = nil;
        self.shareType = nil;
    }
    
    [_selectedPhotos removeObjectAtIndex:sender.tag];
    if (_selectedAssets.count>0&&_selectedAssets.count==_selectedPhotos.count) {
        [_selectedAssets removeObjectAtIndex:sender.tag];
    }
    
    if (_selectedPhotos.count<1) {
        _videoUrlStr = @"";
        _isShooting = NO;
    }
    [_collectionView performBatchUpdates:^{
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:sender.tag inSection:0];
        [_collectionView deleteItemsAtIndexPaths:@[indexPath]];
    } completion:^(BOOL finished) {
        [_collectionView reloadData];
    }];
}

-(BOOL)isSameImageWithImage:(UIImage *)image
{
    NSData *data1 = UIImagePNGRepresentation(self.firstImage);
    NSData *data = UIImagePNGRepresentation(image);
    if ([data isEqual:data1]) {
        return YES;
    }else{
        return NO;
    }

}
#pragma mark - Private

/// 打印图片名字
- (void)printAssetsName:(NSArray *)assets {
    NSString *fileName;
    for (id asset in assets) {
        if ([asset isKindOfClass:[PHAsset class]]) {
            PHAsset *phAsset = (PHAsset *)asset;
            fileName = [phAsset valueForKey:@"filename"];
        } else if ([asset isKindOfClass:[ALAsset class]]) {
            ALAsset *alAsset = (ALAsset *)asset;
            fileName = alAsset.defaultRepresentation.filename;;
        }
        // NSLog(@"图片名字:%@",fileName);
    }
}
#pragma mark ---textView Delegate
//-(void)textViewDidChange:(UITextView *)textView
//{
//
//    BOOL flag=[NSString isContainsTwoEmoji:textView.text];
//
//    if (textView == self.textView) {
//
//        if (flag)
//        {
//            self.textView.text = [textView.text substringToIndex:textView.text.length -2];
//        }
//    }
//}
//- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
//    NSString *mediaType=[info objectForKey:UIImagePickerControllerMediaType];
//
//
//    [self dismissViewControllerAnimated:YES completion:nil];
//}

//获取视频缩略图
-(UIImage *)getThumbnailImage:(NSURL *)videoUrl {
    if (videoUrl) {
        AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:videoUrl options:nil];
        AVAssetImageGenerator *gen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
        // 设定缩略图的方向
        // 如果不设定，可能会在视频旋转90/180/270°时，获取到的缩略图是被旋转过的，而不是正向的
        gen.appliesPreferredTrackTransform = YES;
        // 设置图片的最大size(分辨率)
        gen.maximumSize = CGSizeMake(JFA_SCREEN_WIDTH, JFA_SCREEN_HEIGHT);
        CMTime time = CMTimeMakeWithSeconds(5.0, 600); //取第5秒，一秒钟600帧
        NSError *error = nil;
        CMTime actualTime;
        CGImageRef image = [gen copyCGImageAtTime:time actualTime:&actualTime error:&error];
        if (error) {
            UIImage *placeHoldImg = [UIImage imageNamed:@"posters_default_horizontal"];
            return placeHoldImg;
        }
        UIImage *thumb = [[UIImage alloc] initWithCGImage:image];
        CGImageRelease(image);
        return thumb;
    } else {
        UIImage *placeHoldImg = getImage(@"default");
        return placeHoldImg;
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
