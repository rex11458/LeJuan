//
//  HPQRViewController.m
//  Demo
//
//  Created by gurgle on 15/9/21.
//  Copyright © 2015年 handpay. All rights reserved.
//

#import "LJQRViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "LJQRView.h"


@interface LJQRViewController ()<AVCaptureMetadataOutputObjectsDelegate,LJQRViewCancelDelegate>
{
    BOOL _isReading;
    AVCaptureDevice *_captureDevice;
    AVCaptureSession *_captureSession;
    AVCaptureVideoPreviewLayer *_videoPreviewLayer;
}
@end

@implementation LJQRViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self startReading];
}

- (BOOL)startReading {
    _isReading = YES;
    
    NSError *error;
    _captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:_captureDevice error:&error];
    if (!input) {
        NSLog(@"%@", [error localizedDescription]);
        return NO;
    }
    _captureSession = [[AVCaptureSession alloc] init];
    // AVCaptureSession 可以设置 sessionPreset 属性，这个决定了视频输入每一帧图像质量的大小
    [_captureSession setSessionPreset:AVCaptureSessionPresetHigh];
    //AVCaptureSessionPreset640x480
    [_captureSession addInput:input];
    
    AVCaptureMetadataOutput *captureMetadataOutput = [[AVCaptureMetadataOutput alloc] init];
    [_captureSession addOutput:captureMetadataOutput];
    
//    dispatch_queue_t dispatchQueue;
//    dispatchQueue = dispatch_queue_create("myQueue", NULL);
    [captureMetadataOutput setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    [captureMetadataOutput setMetadataObjectTypes:[NSArray arrayWithObjects:
                                                   AVMetadataObjectTypeEAN13Code,
                                                   AVMetadataObjectTypeEAN8Code,
                                                   AVMetadataObjectTypeCode128Code,
                                                   AVMetadataObjectTypeQRCode, nil]];
    
    
    _videoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_captureSession];
    [_videoPreviewLayer setVideoGravity:AVLayerVideoGravityResize];
    // AVLayerVideoGravityResizeAspectFill
    [_videoPreviewLayer setFrame:self.view.frame];
    // CGRectMake(self.view.layer.frame.size.width/2-100/2, self.view.layer.frame.size.height/2-100/2, 100, 100)
    [self.view.layer addSublayer:_videoPreviewLayer];
    
    [_captureSession startRunning];
    
    
    CGRect screenRect = [UIScreen mainScreen].bounds;
    LJQRView *qrRectView = [[LJQRView alloc] initWithFrame:screenRect];
    qrRectView.delegate = self;
    qrRectView.transparentArea = CGSizeMake(200, 200);
    qrRectView.backgroundColor = [UIColor clearColor];
    qrRectView.center = CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height / 2);
    [self.view addSubview:qrRectView];
    
    UIButton *pop = [UIButton buttonWithType:UIButtonTypeCustom];
    pop.frame = CGRectMake(self.view.frame.size.width - 90, 22, 69, 32);
//    [pop setTitle:@"开关" forState:UIControlStateNormal];
    [pop setBackgroundImage:[UIImage imageNamed:@"camera_flash_off"] forState:UIControlStateNormal];
    [pop setBackgroundImage:[UIImage imageNamed:@"camera_flash_on"] forState:UIControlStateSelected];
    [pop addTarget:self action:@selector(onOrOffAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:pop];
    
    return YES;
}


-(void)stopReading {
    
    [_captureSession stopRunning];
    _captureSession = nil;
    [_videoPreviewLayer removeFromSuperlayer];
}

-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects
      fromConnection:(AVCaptureConnection *)connection
{
    if (!_isReading)
        return;
    
     NSString *stringValue = @"";
    
    if ([metadataObjects count] > 0) {
        _isReading = NO;
        [_captureSession stopRunning];
        
        AVMetadataMachineReadableCodeObject *metadataObj = [metadataObjects objectAtIndex:0];
        stringValue = metadataObj.stringValue;
    }
    
    if ([self respondsToSelector:@selector(dismissViewControllerAnimated:completion:)]) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else if ([self.navigationController respondsToSelector:@selector(popViewControllerAnimated:)]) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(qrCodeScanResult:)]) {
        [self.delegate qrCodeScanResult:stringValue];
    }
}


- (void)cancelAction {
    if ([self respondsToSelector:@selector(dismissViewControllerAnimated:completion:)]) {
        [self dismissViewControllerAnimated:YES completion:nil];
        return;
    }
    
    if ([self.navigationController respondsToSelector:@selector(popViewControllerAnimated:)]) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}


- (void)onOrOffAction:(UIButton *)button {
    
    button.selected = !button.selected;
    
    if (button.selected) {
        
        if([_captureDevice hasTorch])
        {
            if(_captureDevice.torchMode == AVCaptureTorchModeOff)
            {
                [_captureSession beginConfiguration];
                [_captureDevice lockForConfiguration:nil];
                [_captureDevice setTorchMode:AVCaptureTorchModeOn];
//                [_captureDevice setFlashMode:AVCaptureFlashModeOn];
                [_captureDevice unlockForConfiguration];
                [_captureSession commitConfiguration];
            }
        }
        
    } else  {
       
        [_captureSession beginConfiguration];
        [_captureDevice lockForConfiguration:nil];
        if(_captureDevice.torchMode == AVCaptureTorchModeOn)
        {
            [_captureDevice setTorchMode:AVCaptureTorchModeOff];
//            [_captureDevice setFlashMode:AVCaptureFlashModeOff];
        }
        [_captureDevice unlockForConfiguration];
        [_captureSession commitConfiguration];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
