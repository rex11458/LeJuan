//
//  PYNetworkUnavailableView.h
//  lianhebao
//
//  Created by lwp on 14-11-13.
//  Copyright (c) 2014年 Steven. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ReloadBlock)();

@interface PYNetworkUnavailableView : UIView

@property (nonatomic, copy) NSString *message; //

- (id)initWithFrame:(CGRect)frame message:(NSString *)message;

@property (nonatomic, copy) ReloadBlock reloadBlock;

@end
