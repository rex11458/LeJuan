//
//  PYSurveyViewController.m
//  hpj_refactor
//
//  Created by LiuRex on 16/1/30.
//  Copyright © 2016年 Shanghai Youyou Finance Information Technology Co.,Ltd. All rights reserved.
//

#import "PYSurveyViewController.h"
#import "PYTask.h"
#import "PYQuestionnaireButtonItem.h"
#import "PYJsCoreContext.h"
#import "PYQuestion.h"
#import "PYSurveyHandler.h"
#import "Base64.h"
#import "INTULocationManager.h"
#import "HPJAlertView.h"
#import "PYHomeViewController.h"
#import "PYQuestionnaireSection.h"
#import "PYMenu.h"
#import "PYQuestionItemListViewController.h"
#import "BaseNavigationViewController.h"
#import "PYQuestionItem.h"
#import "SJAvatarBrowser.h"
#import "LJQRViewController.h"

@interface PYSurveyViewController ()<UIWebViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,PYQuestionItemListViewControllerDelegate,QRCodeScanDelegate>
{
    PYMenu *_menu;
    
    PYJsCoreContext *_jsContext;
    
    PYQuestion *_imageQuestion;
    UIAlertView *_searchAlertView;
    
    /*!
     *  离店备注
     */
    NSString *_leaveRemark;
    
}
@property (strong, nonatomic) IBOutlet UIToolbar *toolbar;
@property (strong, nonatomic) IBOutlet UIWebView *webView;

@property (strong, nonatomic) IBOutlet PYQuestionnaireButtonItem *submitItem;

- (IBAction)submitAction:(id)sender;

- (IBAction)toolBarItemAction:(UIBarButtonItem *)sender;

@end

@implementation PYSurveyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *path = PYQuestionnaireSadboxPath(_task.resultId);
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL fileURLWithPath:path]];
    
    [_webView loadRequest:request];
    
    _submitItem.task = self.task;
}

#pragma mark - UIWebViewDelegate


- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
#warning -后面优化
    
    NSString* url = [[request URL] absoluteString];
    
    NSArray *urlComps = [url componentsSeparatedByString:@"//"];
    
    if ([[urlComps objectAtIndex:1] isEqualToString:@"Recharge"])
    {
        if ([urlComps count] == 3 && [urlComps objectAtIndex:2]) {
            NSArray *arrayPara = [[urlComps objectAtIndex:2] componentsSeparatedByString:@"&"];
            
            NSMutableDictionary *_dicParams = [NSMutableDictionary dictionaryWithCapacity:4];
            for (NSString *str in arrayPara) {
                NSArray *innerArray = [str componentsSeparatedByString:@"="];
                [_dicParams setObject:[innerArray objectAtIndex:1] forKey:[innerArray objectAtIndex:0]];
            }
            _imageQuestion = [PYQuestion mj_objectWithKeyValues:_dicParams];
            [self takePhoto];
        }
    }
    if ([[urlComps objectAtIndex:1] isEqualToString:@"ShowImage"]) {
        NSString *str = [urlComps objectAtIndex:2];
        NSArray *array = [str componentsSeparatedByString:@"="];
        if (array && [array count] == 2) {
            NSString *strName = array[1];
            NSString *strImgPath = [PYPictureSadboxPath stringByAppendingPathComponent:strName];
            UIImage *image1 = [UIImage imageWithContentsOfFile:strImgPath];
            UIImageView *imageView = [[UIImageView alloc] initWithImage:image1];
            [SJAvatarBrowser showImage:imageView];
        }
    }

    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [webView animationWithStyle:UIActivityIndicatorViewStyleGray];

}


- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [webView endAnimation];
    
    _submitItem.enabled = YES;
    
    NSString *title = [self.webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    
    self.navigationItem.title = title;
    
    _jsContext = [[PYJsCoreContext alloc] initWithWebView:_webView];

    [_jsContext fillBackQuestionnaireWithId:_task.resultId];
    
    
    /*!
     *  如果没有进店，提示是否进店
     *
     */
    if (!_task.isArrival) {
        [[[UIAlertView alloc] initWithTitle:@"提示" message:NSLocalizedString(@"isArrival", nil) cancelButtonItem:[RIButtonItem itemWithLabel:@"确定" action:^{

            self.task.isArrival = YES;

            _submitItem.task = self.task;
            //保存状态
            _task.arrivalTime = [NSDate localStringDescription];
            [[PYQuestionnaireManager sharedInstance] alertQuestionnaire:self.task relationLoginName:PYCurrentUserLoginName];
        
        }] otherButtonItems:[RIButtonItem itemWithLabel:@"取消"], nil] show];
    }else if (_task.isDeparture){
        self.task.isDeparture = NO;
        _submitItem.task = self.task;
        //保存状态
        [[PYQuestionnaireManager sharedInstance] alertQuestionnaire:self.task relationLoginName:PYCurrentUserLoginName];

    }
}

#pragma mark - ItemAction
- (IBAction)submitAction:(id)sender
{
    //离店、进店、提交
    
    if (!_task.isArrival) {
   
        _task.isArrival = YES;
        _task.arrivalTime = [NSDate localStringDescription];
   
    }else if (!_task.isDeparture) {
    
        /*验证问卷是否完成*/

        if (![_jsContext isCompeleted]) {
            return;
        }
        
        _task.isDeparture = YES;
        _task.departureTime = [NSDate localStringDescription];
        //获取离店坐标
        [self getDeartureCoordinate];
        //离店备注
        _leaveRemark = [_jsContext getLeaveRemark];
        /*保存问卷*/
        [self saveQuestionnaire];
        /*保存后返回*/
        [self backAction];
        [self.navigationController popViewControllerAnimated:YES];
        
    }else{
        //上传问卷，先保存
        [self saveQuestionnaire];
        //检查网络状态
        [self checkReachabilityStatus];
        return;
    }
    _submitItem.task = self.task;
    //保存状态
    [[PYQuestionnaireManager sharedInstance] alertQuestionnaire:self.task relationLoginName:PYCurrentUserLoginName];
}

#pragma mark -  获取离店坐标
- (void)getDeartureCoordinate
{
    __weak __typeof(self) weakSelf = self;
//    [SVProgressHUD showWithStatus:@"正在离店..." maskType:SVProgressHUDMaskTypeGradient];
  [[INTULocationManager sharedInstance] requestLocationWithDesiredAccuracy:INTULocationAccuracyCity
                                                            timeout:10
                                               delayUntilAuthorized:YES
                                                              block:
                          ^(CLLocation *currentLocation, INTULocationAccuracy achievedAccuracy, INTULocationStatus status) {
//                              [SVProgressHUD dismiss];
                              if (status == INTULocationStatusSuccess) {
                                  // achievedAccuracy is at least the desired accuracy (potentially better)
                                  weakSelf.task.addrx = [@(currentLocation.coordinate.latitude) stringValue];
                                  weakSelf.task.addry = [@(currentLocation.coordinate.longitude) stringValue];
                                  [[PYQuestionnaireManager sharedInstance] alertQuestionnaire:weakSelf.task relationLoginName:PYCurrentUserLoginName];

                                  PYLog(@"经度: %f", currentLocation.coordinate.latitude);
                                  PYLog(@"纬度: %f", currentLocation.coordinate.longitude);
                                  PYLog(@"横向精准: %f", currentLocation.horizontalAccuracy);
                              }
                              else if (status == INTULocationStatusTimedOut) {
                                  // You may wish to inspect achievedAccuracy here to see if it is acceptable, if you plan to use currentLocation
                                  NSLog(@"请求超时!当前位置: %@", currentLocation);
                              }
                              else {
                                  // An error occurred
                                  if (status == INTULocationStatusServicesNotDetermined) {
                                      NSLog(@"Error: User has not responded to the permissions alert.");
                                  } else if (status == INTULocationStatusServicesDenied) {
                                      NSLog(@"Error: 通用>改应用>打开定位(试用应用程序时间)");
                                  } else if (status == INTULocationStatusServicesRestricted) {
                                      NSLog(@"Error: User is restricted from using location services by a usage policy.");
                                  } else if (status == INTULocationStatusServicesDisabled) {
                                      NSLog(@"Error: 通用>打开定位");
                                  } else {
                                      NSLog(@"未知的错误");
                                  }
                              }
                              
                          }];
}

- (IBAction)toolBarItemAction:(UIBarButtonItem *)sender
{
    switch (sender.tag) {
        case 0:
        {
            //分类信息
            [self showPageListInfo];
        }
            break;
        case 1:
        {
            //问题搜索
            [self searchQuestion];
        }
            break;
        case 2:
        {
            //题盘
            [self questionList];
        }
            break;
        case 3:
        {
            //二维码扫描
            [self barcodeScan];
        }
            break;
        case 4:
        {
            [self saveQuestionnaire];
        }
            break;
        default:
            break;
    }
}

#pragma mark - backAciton
- (void)backAction
{
    //旧数据
    NSString *oldQuesitonsString = [[[PYQuestionnaireManager sharedInstance] selectQuestionsByQuestionnaireId:_task.resultId relationLoginName:PYCurrentUserLoginName] mj_JSONString];

    //新数据
    NSString *newQuesitonsString = [[NSObject mj_keyValuesArrayWithObjectArray:[PYQuestion mj_objectArrayWithKeyValuesArray:[_jsContext questionnaireResult]]] mj_JSONString];
    __block BOOL selected = NO;
    if (![[oldQuesitonsString MD5String] isEqualToString:[newQuesitonsString MD5String]])
    {
        [[[UIAlertView alloc] initWithTitle:@"提示" message:NSLocalizedString(@"dataAlerted", nil) cancelButtonItem:[RIButtonItem itemWithLabel:@"确定" action:^{
            [self saveQuestionnaire];
            selected = YES;
        }] otherButtonItems:[RIButtonItem itemWithLabel:@"取消"  action:^{
            
            selected = YES;
            
        }], nil] show];
    
        while (!selected) {
            [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
        }
    }
}




#pragma mark - 检查网络状态
- (void)checkReachabilityStatus
{
    switch (PYReachabilityStatus) {
            
        case NotReachable:
            [UIAlertView showWithMessage:NSLocalizedString(@"noNetwork", nil)];
            return;
        case ReachableViaWWAN:
        {
            [[[UIAlertView alloc] initWithTitle:@"提示" message:NSLocalizedString(@"WWANNetworkRemaind", nil) cancelButtonItem:[RIButtonItem itemWithLabel:@"确定" action:^{
                [self uploadQuestionnaire];
            }] otherButtonItems:[RIButtonItem itemWithLabel:@"取消"], nil] show];
        }
            break;
        default:
            [self uploadQuestionnaire];
            break;
    }
}

#pragma mark -  uploadQuestionnaire
- (void)uploadQuestionnaire
{
    if (![_jsContext isCompeleted]) {
        return;
    }
    
    NSArray *quesitons = [[PYQuestionnaireManager sharedInstance] selectQuestionsByQuestionnaireId:_task.resultId relationLoginName:PYCurrentUserLoginName];
    NSArray<PYQuestion *> *a_questions = [PYQuestion mj_objectArrayWithKeyValuesArray:quesitons];

    
    [PYSurveyHandler uploadQuestionnaire:_task questions:a_questions progress:^(NSProgress *progress, NSString *message) {
      
        [SVProgressHUD showProgress:progress.fractionCompleted status:message maskType:SVProgressHUDMaskTypeGradient];

    } success:^(id obj) {
        [SVProgressHUD dismiss];
        [self showAlertView];
        [[PYQuestionnaireManager sharedInstance] deleteQuestaionnaire:_task relationLoginName:PYCurrentUserLoginName];
        
    } failure:^(id error_msg) {
      
        [SVProgressHUD showErrorWithStatus:error_msg];

    }];
}

#pragma mark - 提交问卷后跳转
- (void)showAlertView
{
    
    HPJAlertItem *item1 = [[HPJAlertItem alloc] initWithTitle:@"已下载的任务" titleColor:UIColorFromRGB(0x001166) imageName:@"yxz_icon"];
    HPJAlertItem *item2 = [[HPJAlertItem alloc] initWithTitle:@"未下载的任务" titleColor:UIColorFromRGB(0xB02621) imageName:@"wxz_icon"];
    
    HPJAlertView *alertView = [[HPJAlertView alloc] initWithMessage:@"问卷已经提交成功" Items:@[item1,item2] cancelButtonTitle:@"返回首页" delegate:self];
    [alertView show];
    return;
}

#pragma mark -HPJAlertViewDelegate
- (void)alertView:(HPJAlertView *)alertView didSelectedIndex:(NSInteger)index
{

    [self.navigationController popToRootViewControllerAnimated:YES];
 
    if (index == 1) {
        [self.navigationController.viewControllers.firstObject performSegueWithIdentifier:@"unDownloadTaskSeugeId" sender:nil];

    }else if (index == 2){
        [self.navigationController.viewControllers.firstObject performSegueWithIdentifier:@"downloadTaskSeugeId" sender:nil];

    }
}

#pragma mark - 拍照
- (void)takePhoto
{
    if ([self isCameraAvailable] && [self doesCameraSupportTakingPhotos]) {
        
        UIImagePickerController* pickerView = [[UIImagePickerController alloc] init];
        pickerView.sourceType = UIImagePickerControllerSourceTypeCamera;
        pickerView.videoQuality = UIImagePickerControllerQualityTypeLow;
        pickerView.delegate = self;
        [self.navigationController presentViewController:pickerView animated:YES completion:nil];
        
    }
    else if([self isPhotoLibraryAvailable] && [self canUserPickPhotosFromPhotoLibrary])
    {
        UIImagePickerController *controller = [[UIImagePickerController alloc] init];
        [controller setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        NSString *requiredMediaType = (NSString *)kUTTypeImage;
        [controller setMediaTypes:@[requiredMediaType]];
        [controller setAllowsEditing:NO];
        [controller setDelegate:self];
        [self.navigationController presentViewController:controller animated:YES completion:nil];
    }
    else
    {
        [UIAlertView showWithMessage:NSLocalizedString(@"NOCameraAndPhoto", nil)];
    }
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:^{
        NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
        if ([mediaType isEqualToString:(NSString *)kUTTypeImage])
        {
            UIImage *sourceImage = [info objectForKey:UIImagePickerControllerOriginalImage];

            if (sourceImage == nil) return ;
            
            NSData *imageData = UIImageJPEGRepresentation([sourceImage resizableImageWithSize:CGSizeMake(sourceImage.size.width * 0.25, sourceImage.size.height * 0.25)], 0.6);
            
//            unix 时间戳
            NSString *imageName = [[NSDate date].description MD5String];
            
            NSString *imagePath = [PYPictureSadboxPath stringByAppendingPathComponent:[imageName stringByAppendingPathExtension:@"PNG"]];
            if (![FCFileManager existsItemAtPath:imagePath]) {
                [FCFileManager createFileAtPath:imagePath];
            }
            BOOL result = [imageData writeToFile: imagePath atomically:YES];
            
            if (result) {
                [_jsContext setQuestionImageWithId:_imageQuestion.questionId subId:_imageQuestion.subQuestionId answerId:_imageQuestion.answerId imagePath:imagePath];
            }else{
                [SVProgressHUD showErrorWithStatus:@"图片获取失败"];
            }
        }
    }];
}

- (BOOL) cameraSupportsMedia:(NSString *)paramMediaType sourceType:(UIImagePickerControllerSourceType)paramSourceType{
    if ([paramMediaType length] == 0) return NO;
    
    __block BOOL result = NO;

    NSArray *availableMediaTypes = [UIImagePickerController availableMediaTypesForSourceType:paramSourceType];
    [availableMediaTypes enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL*stop) {
        NSString *mediaType = (NSString *)obj;
        if ([mediaType isEqualToString:paramMediaType]){
            result = YES;
            *stop= YES;
        }
    }];
    return result;
}

- (BOOL)doesCameraSupportTakingPhotos {
    return [self cameraSupportsMedia:(NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypeCamera];
}

- (BOOL)canUserPickPhotosFromPhotoLibrary{
    return [self cameraSupportsMedia:( NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}

- (BOOL)isCameraAvailable {
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}

- (BOOL)isPhotoLibraryAvailable{
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary];
}

#pragma mark - 分类信息
- (void)showPageListInfo
{
   NSArray<PYQuestionnaireSection *> *sectionArray = [_jsContext questionnaireSectionList];
  
    NSMutableArray *titles = [NSMutableArray array];
    [sectionArray enumerateObjectsUsingBlock:^(PYQuestionnaireSection * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
       
        [titles addObject:obj.name];
    }];
    
    CGRect rect = CGRectMake(CGRectGetWidth(_toolbar.frame) / 5.0f * 0.25,  CGRectGetMidY(_toolbar.frame), CGRectGetWidth(_toolbar.frame) / 5.0f, CGRectGetWidth(_toolbar.frame) / 5.0f);
    _menu = [[PYMenu alloc] initWithView:self.view rect:rect titles:titles selectedIndex:^(NSInteger index) {
        
        PYQuestionnaireSection *section = [sectionArray objectAtIndex:index];
        [_jsContext showPage:section.id];
        
    }];
    [_menu show];
}


#pragma mark - 问卷题目搜索
- (void)searchQuestion
{
    /*需要加为全局变量，否则alertView会被释放，导致TextField.text取出为空*/
    _searchAlertView = [[UIAlertView alloc] initWithTitle:@"提示" message:NSLocalizedString(@"searchRemaind", nil) cancelButtonItem:[RIButtonItem itemWithLabel:@"搜索" action:^{
        UITextField *textField = [_searchAlertView textFieldAtIndex:0];
        if (textField.text.length > 0) {
            [_jsContext searchQuestionWithKey:textField.text];
        }
        
    }] otherButtonItems:[RIButtonItem itemWithLabel:@"取消"  action:^{
    }], nil];
    
    _searchAlertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    [_searchAlertView show];
}

#pragma mark - 题盘信息
- (void)questionList
{
  NSArray<PYQuestionItem *> *questionItems =  [_jsContext questionnairePanelList];
 
    if (questionItems.count == 0) {
        [SVProgressHUD showImage:nil status:NSLocalizedString(@"NoQuestionItem", nil)];
        return;
    }
    [self performSegueWithIdentifier:@"PYQuestionItemListModelSegueId" sender:questionItems];
}

#pragma mark - PYQuestionItemListViewControllerDelegate
- (void)questionItemListViewControllerSeletectedItem:(PYQuestionItem *)item
{
    [_jsContext scrollTopQuestionItemWithQustionId:item.qid];
}


#pragma mark - segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"PYQuestionItemListModelSegueId"]) {
        
        PYQuestionItemListViewController *vc = [[(UINavigationController *)segue.destinationViewController viewControllers] firstObject];
        vc.questionItems = sender;
        vc.delegate = self;
    }
}

#pragma mark - 二维码扫描
- (void)barcodeScan
{
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] &&
       [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear])
    {
            LJQRViewController *qrViewController = [[LJQRViewController alloc] init];
            qrViewController.delegate = self;
            [self presentViewController:qrViewController animated:YES completion:nil];
    }
    else
    {
        [UIAlertView showWithMessage:NSLocalizedString(@"cameraUnavaliable", nil)];
    }
}

- (void)qrCodeScanResult:(NSString *)result
{
    if (result.length > 0)
    {
        [_jsContext searchQuestionWithKey:result];
    }
}

#pragma mark - 保存问卷
- (void)saveQuestionnaire
{
    /*!
     *  设置离店备注
     */
    self.task.leaveRemark = _leaveRemark;

    //保存进度
    self.task.progress = [_jsContext questionnaireCompletedRate];
    
    /*如果已离店，后问卷修改为未完成 则设置为未离店*/
    if (_task.isDeparture && _task.progress != 1){
        
        self.task.isDeparture = NO;
        _submitItem.task = self.task;
        //保存状态
        [[PYQuestionnaireManager sharedInstance] alertQuestionnaire:self.task relationLoginName:PYCurrentUserLoginName];
    }
    
    /*保存数据*/
    [[PYQuestionnaireManager sharedInstance] alertQuestionnaire:self.task relationLoginName:PYCurrentUserLoginName];
    
    
    [[PYQuestionnaireManager sharedInstance] saveQuestions:[_jsContext questionnaireResult] questionnaireId:self.task.resultId relationLoginName:PYCurrentUserLoginName];
}
@end
