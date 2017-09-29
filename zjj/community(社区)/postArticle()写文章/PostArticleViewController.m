//
//  PostArticleViewController.m
//  zjj
//
//  Created by iOSdeveloper on 2017/9/22.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "PostArticleViewController.h"
#import "AddImageCell.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AssetsLibrary/AssetsLibrary.h>  // 必须导入

@interface PostArticleViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIView *imageView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *layout;


@property (nonatomic,strong)NSMutableArray * imagesArray;

@property (nonatomic,assign)BOOL isHaveMovie;
@property (nonatomic,  copy)NSString * movieFilePath;
@property (nonatomic, assign)CGSize moiveSize;
@property (nonatomic, copy)NSURL * movieUrl;
@property (nonatomic, assign)UIImage * videoImg;
@end

@implementation PostArticleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"";
    
    [self buildRightNaviBarItem];
    self.collectionView.delegate = self;
    self.collectionView.alwaysBounceVertical = YES;//实现代理
    self.collectionView.dataSource = self;                  //实现数据源方法
    self.collectionView.backgroundColor= HEXCOLOR(0xf8f8f8);
    self.collectionView.allowsMultipleSelection = YES;      //实现多选，默认是NO
    self.collectionView.frame = CGRectMake(0, 0, JFA_SCREEN_WIDTH, self.view.frame.size.height-self.tabBarController.tabBar.frame.size.height);

    [self.collectionView registerNib:[UINib nibWithNibName:@"AddImageCell"bundle:nil]forCellWithReuseIdentifier:@"AddImageCell"];
    _imagesArray  =[NSMutableArray array];

//    [_imagesArray addObject:getImage(@"demoimage_.jpg")];
//    [_imagesArray addObject:getImage(@"demoimage_.jpg")];
//    [_imagesArray addObject:getImage(@"demoimage_.jpg")];
//    [_imagesArray addObject:getImage(@"demoimage_.jpg")];
//    [_imagesArray addObject:getImage(@"demoimage_.jpg")];
//    [_imagesArray addObject:getImage(@"demoimage_.jpg")];
    [_imagesArray addObject:getImage(@"蓝牙秤_")];

    [self.imageView addSubview:self.collectionView];
    [self.collectionView reloadData];
}

-(void)didUpdateInfo
{
//    [self convertMovSourceURL:self.movieUrl];

    [self getVideoInfoWithSourcePath:nil];
    NSMutableDictionary * params =[NSMutableDictionary dictionary];
    [params safeSetObject:[UserModel shareInstance].userId forKey:@"userId"];
    [params safeSetObject:self.textView.text forKey:@"content"];
    
    
    if (_isHaveMovie==YES) {
        
//      long lsog =   [self fileSizeAtPath:self.movieUrl];
        
        NSData * data = [NSData dataWithContentsOfURL:self.movieUrl];
        NSData *videoImgData = UIImageJPEGRepresentation(self.videoImg, 0.001);
        
        self.currentTasks = [[BaseSservice sharedManager]
                             postMovie:@"app/community/article/saveArticle.do"
                             paramters:params
                             movieData:data videoImg:videoImgData movieName:nil
                             success:^(NSDictionary *dic) {
                                 
                                 [[UserModel shareInstance]showSuccessWithStatus:@"发表成功"];
                                 DLog(@"dic---%@",dic);
                                 [self.navigationController popViewControllerAnimated:YES];
                                 
                             }
                             failure:^(NSError *error) {
                                 
                                 DLog(@"error--%@",error);
                             }];

    }else{
        NSMutableArray * arr =[NSMutableArray arrayWithArray:_imagesArray];
        if (arr.count!=10) {
            [arr removeLastObject];
        }
        self.currentTasks = [[BaseSservice sharedManager]uploadImageWithPath:@"app/community/article/saveArticle.do" photos:arr params:params success:^(NSDictionary *dic) {
            DLog(@"dic---%@",dic);
            [[UserModel shareInstance]showSuccessWithStatus:@"发表成功"];
            DLog(@"dic---%@",dic);
            [self.navigationController popViewControllerAnimated:YES];

        } failure:^(NSError *error) {
            DLog(@"error--%@",error);

        }];
    }

}

- (NSDictionary *)getVideoInfoWithSourcePath:(NSString *)path{
    AVURLAsset * asset = [AVURLAsset assetWithURL:self.movieUrl];
    CMTime   time = [asset duration];
    int seconds = ceil(time.value/time.timescale);
    
    NSInteger   fileSize = [[NSFileManager defaultManager] attributesOfItemAtPath:path error:nil].fileSize;
    DLog(@"视频大小-%@",@{@"size" : @(fileSize),
                 @"duration" : @(seconds)});
    return @{@"size" : @(fileSize),
             @"duration" : @(seconds)};
}



-(void)buildRightNaviBarItem
{
    UIBarButtonItem * rightItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"settings_"] style:UIBarButtonItemStylePlain target:self action:@selector(didUpdateInfo)];
    
    self.navigationItem.rightBarButtonItem = rightItem;
    
}


-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (self.imagesArray.count==10||self.isHaveMovie==YES) {
        return self.imagesArray.count-1;
    }
    return self.imagesArray.count;
}
////定义每个Section的四边间距

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    
    return UIEdgeInsetsMake(5, 5, 5, 5);//分别为上、左、下、右
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    AddImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"AddImageCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    NSMutableArray * infoArr = [NSMutableArray arrayWithArray:_imagesArray];

    if (_imagesArray.count==10||self.isHaveMovie ==YES) {
        [infoArr removeLastObject];
    }
    
    if (indexPath.row ==infoArr.count-1) {
        cell.backgroundColor = [UIColor redColor];
    }
    cell.headImageView.image = [infoArr objectAtIndex:indexPath.row];
    UILongPressGestureRecognizer* longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(onLongPress:)];
    [cell addGestureRecognizer:longPress];

    return cell;
}

//设置item大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (_isHaveMovie ==YES) {
        
        return CGSizeMake((JFA_SCREEN_WIDTH-20)/2, (JFA_SCREEN_WIDTH-20)/2/self.moiveSize.width*self.moiveSize.height);

    }else{
        return CGSizeMake((JFA_SCREEN_WIDTH-20)/4-20, (JFA_SCREEN_WIDTH-20)/4-20);

    }
}
//这个是两行cell之间的间距（上下行cell的间距）

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 5;
}
//两个cell之间的间距（同一行的cell的间距）

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 2;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    if (indexPath.row ==_imagesArray.count-1) {
        if (_isHaveMovie ==YES) {
            return;
        }
        if (_imagesArray.count==10) {
            return;
        }
        [self changeHeader:nil];
    }
}
- (void)onLongPress:(id)sender
{
    if (_imagesArray.count<3) {
        return;
    }
    UILongPressGestureRecognizer* longPress = (UILongPressGestureRecognizer*)sender;
    UIGestureRecognizerState state = longPress.state;
    
    CGPoint location = [longPress locationInView:_collectionView];
    NSIndexPath* indexPath = [_collectionView indexPathForItemAtPoint:location];
    static UIView* snapshot = nil;             ///< A snapshot of the row user is moving.
    static NSIndexPath* sourceIndexPath = nil; ///< Initial index path, where gesture begins.
    static NSIndexPath* originIndexPath = nil;
    switch (state) {
        case UIGestureRecognizerStateBegan: {
            if (indexPath) {
                sourceIndexPath = indexPath;
                UICollectionViewCell* cell = [_collectionView cellForItemAtIndexPath:indexPath];
                // Take a snapshot of the selected row using helper method.
                snapshot = [self takeSnapshotForView:cell];
                // Add the snapshot as subview, centered at cell's center...
                __block CGPoint center = cell.center;
                snapshot.center = center;
                snapshot.alpha = 0.0;
                [_collectionView addSubview:snapshot];
                [UIView animateWithDuration:0.25
                                 animations:^{
                                     // Offset for gesture location.
                                     center.y = location.y;
                                     snapshot.center = center;
                                     snapshot.transform = CGAffineTransformMakeScale(1.05, 1.05);
                                     snapshot.alpha = 0.98;
                                     cell.alpha = 0.0f;
                                 }
                                 completion:^(BOOL finished) {
                                     cell.hidden = YES;
                                 }];
            }
            break;
        }
            
        case UIGestureRecognizerStateChanged: {
            CGPoint center = snapshot.center;
            center.x = location.x;
            center.y = location.y;
            snapshot.center = center;
            // Is destination valid and is it different from source?
            if (indexPath && ![indexPath isEqual:sourceIndexPath]) {
                // ... move the rows.
                [_collectionView moveItemAtIndexPath:sourceIndexPath toIndexPath:indexPath];
                NSMutableArray * infoArr = [NSMutableArray arrayWithArray:_imagesArray];
                
                if (_imagesArray.count==10) {
                    [infoArr removeLastObject];
                }

                [infoArr exchangeObjectAtIndex:sourceIndexPath.row withObjectAtIndex:indexPath.row];
                // ... and update source so it is in sync with UI changes.
                if (originIndexPath == nil) {
                    originIndexPath = [sourceIndexPath copy];
                }
                sourceIndexPath = indexPath;
            }
            break;
        }
            
        default: {
            // Clean up.
            UICollectionViewCell* cell = [_collectionView cellForItemAtIndexPath:sourceIndexPath];
            [UIView animateWithDuration:0.25
                             animations:^{
                                 snapshot.center = cell.center;
                                 snapshot.transform = CGAffineTransformIdentity;
                                 snapshot.alpha = 0.0;
                                 cell.alpha = 1.0f;
                             }
                             completion:^(BOOL finished) {
                                 cell.hidden = NO;
                                 [snapshot removeFromSuperview];
                                 snapshot = nil;
                             }];
            sourceIndexPath = nil;
            originIndexPath = nil;
            break;
        }
    }
}

- (UIView*)takeSnapshotForView:(UIView*)inputView
{
    UIView* snapshot = [inputView snapshotViewAfterScreenUpdates:YES];
    snapshot.layer.masksToBounds = NO;
    snapshot.layer.cornerRadius = 0.0;
    snapshot.layer.shadowOffset = CGSizeMake(-5.0, 0.0);
    snapshot.layer.shadowRadius = 5.0;
    snapshot.layer.shadowOpacity = 0.4;
    return snapshot;
}
- (IBAction)changeHeader:(id)sender {
    UIAlertController *al = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [al addAction:[UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        UIImagePickerController *pickerImage = [[UIImagePickerController alloc] init];
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
            pickerImage.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            pickerImage.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:pickerImage.sourceType];
            
        }
        pickerImage.delegate = self;
        pickerImage.allowsEditing = NO;
        [self presentViewController:pickerImage animated:YES completion:nil];
    }]];
    [al addAction:[UIAlertAction actionWithTitle:@"相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSString *mediaType = AVMediaTypeVideo;
        
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
        
        if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied){
            
            NSLog(@"相机权限受限");
            
            return;
            
        }
        
        UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];//初始化
        picker.delegate = self;
        picker.allowsEditing = YES;//设置可编辑
        picker.sourceType = sourceType;
        [self presentViewController:picker animated:YES completion:nil];
    }]];
    
    
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
        //        picker.videoMaximumDuration = 10;//最长拍摄时间
        picker.videoQuality = UIImagePickerControllerQualityTypeMedium;//拍摄质量
        
        
        
        [self presentViewController:picker animated:YES completion:nil];
    }]];

    [al addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:al animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    NSString *mediaType=[info objectForKey:UIImagePickerControllerMediaType];
    //判断资源类型
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]){
        //如果是图片
        UIImage *image =info[UIImagePickerControllerOriginalImage];
        [image scaledToSize:CGSizeMake(JFA_SCREEN_WIDTH, JFA_SCREEN_WIDTH/image.size.width*image.size.height)];
        
        [_imagesArray insertObject:image atIndex:_imagesArray.count-1];
        [self.collectionView reloadData];
    
    }
    else if([mediaType isEqualToString:(NSString *)kUTTypeMovie])
    {
        if (_imagesArray.count!=1) {
            return;
        }
            NSURL *videoURL = [info objectForKey:UIImagePickerControllerMediaURL];
            NSLog(@"found a video");

        
        UIImage * image =[self getThumbnailImage:videoURL];
        
        self.videoImg = image;
        [_imagesArray insertObject:image atIndex:0];
        self.movieUrl = videoURL;
        self.moiveSize = image.size;
        self.isHaveMovie = YES;
        [self.collectionView reloadData];
        }
    [self dismissViewControllerAnimated:YES completion:nil];
}//点击cancel 调用的方法


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize
{
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);
    
    // Tell the old image to draw in this new context, with the desired
    // new size
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // End the context
    UIGraphicsEndImageContext();
    
    // Return the new image.
    return newImage;
}
/**mov转mp4格式*/
-(void)convertMovSourceURL:(NSURL *)sourceUrl
{
    AVURLAsset *avAsset = [AVURLAsset URLAssetWithURL:sourceUrl options:nil];
    NSArray *compatiblePresets=[AVAssetExportSession exportPresetsCompatibleWithAsset:avAsset];
    //NSLog(@"%@",compatiblePresets);
    if ([compatiblePresets containsObject:AVAssetExportPresetHighestQuality]) {
        AVAssetExportSession *exportSession=[[AVAssetExportSession alloc] initWithAsset:avAsset presetName:AVAssetExportPresetHighestQuality];
        NSString *mp4Path=[[NSUserDefaults standardUserDefaults] objectForKey:@"kMP4FilePath"];
        NSString *resultPath=[NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES)[0] stringByAppendingFormat:@"picture_t10.mp4"];
        exportSession.outputURL=[NSURL fileURLWithPath:resultPath];
        exportSession.outputFileType = AVFileTypeMPEG4;
        exportSession.shouldOptimizeForNetworkUse = YES;
        [exportSession exportAsynchronouslyWithCompletionHandler:^(void){
            switch (exportSession.status) {
                case AVAssetExportSessionStatusCancelled:
                    NSLog(@"AVAssetExportSessionStatusCancelled");
                    break;
                case AVAssetExportSessionStatusUnknown:
                    NSLog(@"AVAssetExportSessionStatusUnknown");
                    break;
                case AVAssetExportSessionStatusWaiting:
                    NSLog(@"AVAssetExportSessionStatusWaiting");
                    break;
                case AVAssetExportSessionStatusExporting:
                    NSLog(@"AVAssetExportSessionStatusExporting");
                    break;
                case AVAssetExportSessionStatusCompleted:
                {
                    //NSLog(@"resultPath = %@",resultPath);
                    BOOL success=[[NSFileManager defaultManager]moveItemAtPath:resultPath toPath:[mp4Path stringByAppendingPathComponent:@"1.mp4"] error:nil];
                    if(success)
                    {
                        NSArray *files=[[NSFileManager defaultManager] contentsOfDirectoryAtPath:mp4Path error:nil];
                        NSLog(@"%@",files);
                        NSLog(@"success");
                    }
                    break;
                }
                case AVAssetExportSessionStatusFailed:
                    DLog (@"AVAssetExportSessionStatusFailed: %@", exportSession.error);

                    break;
            }
        }];
    }
}

- (void) convertVideoWithModel:(NSURL*) url
{
    NSString * filePath = [NSString stringWithFormat:@"picture_t10.mp4"];
    //保存至沙盒路径
    NSString * pathDocuments = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString * videoPath = [NSString stringWithFormat:@"%@/Image", pathDocuments];
    NSString * sandBoxFilePath = [videoPath stringByAppendingPathComponent:filePath];
    
    //转码配置
//    NSURL *exportUrl = [NSURL fileURLWithPath:[documentsDirectory stringByAppendingPathComponent:@"export.m4a"]];

    AVURLAsset *asset = [AVURLAsset URLAssetWithURL:url options:nil];
    AVAssetExportSession *exportSession= [[AVAssetExportSession alloc] initWithAsset:asset presetName:AVAssetExportPresetMediumQuality];
    exportSession.shouldOptimizeForNetworkUse = YES;
    exportSession.outputURL = [NSURL fileURLWithPath:sandBoxFilePath];
    exportSession.outputFileType = AVFileTypeMPEG4;
    [exportSession exportAsynchronouslyWithCompletionHandler:^{
        int exportStatus = exportSession.status;
        DLog(@"%d",exportStatus);
        switch (exportStatus)
        {
            case AVAssetExportSessionStatusFailed:
            {
                // log error to text view
                NSError *exportError = exportSession.error;
                NSLog (@"AVAssetExportSessionStatusFailed: %@", exportError);
                break;
            }
            case AVAssetExportSessionStatusCompleted:
            {
                DLog(@"视频转码成功");

                
            }
        }
    }];
    
}
//获取视频缩略图
-(UIImage *)getThumbnailImage:(NSURL *)videoUrl {
    if (videoUrl) {
        AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:videoUrl options:nil];
        AVAssetImageGenerator *gen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
        // 设定缩略图的方向
        // 如果不设定，可能会在视频旋转90/180/270°时，获取到的缩略图是被旋转过的，而不是正向的
        gen.appliesPreferredTrackTransform = YES;
        // 设置图片的最大size(分辨率)
        gen.maximumSize = CGSizeMake(300, 169);
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
#pragma mark --计算视频大小
- (long long) fileSizeAtPath:(NSString*) filePath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
