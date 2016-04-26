//
//  HPQRViewController.h
//  Demo
//
//  Created by gurgle on 15/9/21.
//  Copyright © 2015年 handpay. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol QRCodeScanDelegate <NSObject>

- (void)qrCodeScanResult:(NSString *)result;

@end

@interface LJQRViewController : UIViewController

@property (nonatomic, assign) id<QRCodeScanDelegate> delegate;

@end



