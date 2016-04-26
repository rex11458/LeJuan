//
//  PYImproveTitleView.h
//  hpj_refactor
//
//  Created by LiuRex on 16/1/30.
//  Copyright © 2016年 Shanghai Youyou Finance Information Technology Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PYImproveTitleView : UIView
{
@private
    UIButton *_titleButton;
    
    id        _target;
    SEL       _aciton;
}
@property (nonatomic,strong) UIActivityIndicatorView *indicatorView;
@property (nonatomic,copy) NSString *title;

- (instancetype)initWithFrame:(CGRect)frame target:(id)target aciton:(SEL)aciton;

- (void)startAnimating;
- (void)stopAnimating;

@end
