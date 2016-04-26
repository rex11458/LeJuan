//
//  HPQRView.h
//  Demo
//
//  Created by gurgle on 15/9/22.
//  Copyright © 2015年 handpay. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LJQRViewCancelDelegate <NSObject>

- (void)cancelAction;

@end

@interface LJQRView : UIView

@property (nonatomic, assign) id<LJQRViewCancelDelegate> delegate;
@property (nonatomic, assign) CGSize transparentArea;

@end
