//
//  PYMenu.h
//  hpj_refactor
//
//  Created by LiuRex on 16/3/4.
//  Copyright © 2016年 Shanghai Youyou Finance Information Technology Co.,Ltd. All rights reserved.
//

#import <KxMenu/KxMenu.h>
/*!
 *  需作为成员变量使用，局部变量会被释放导致点击事件不相应
 */
@interface PYMenu : NSObject

@property (nonatomic, strong ,readonly) UIView *view;
@property (nonatomic, assign, readonly) CGRect rect;

@property (nonatomic, copy) NSArray *titles;

- (instancetype)initWithView:(UIView *)view rect:(CGRect)rect titles:(NSArray *)titles selectedIndex:(void(^)(NSInteger))selectedIndex;

- (void)show;

@end
