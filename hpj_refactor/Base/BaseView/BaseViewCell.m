//
//  BaseViewCell.m
//  hpj_refactor
//
//  Created by LiuRex on 16/1/31.
//  Copyright © 2016年 Shanghai Youyou Finance Information Technology Co.,Ltd. All rights reserved.
//

#import "BaseViewCell.h"

@interface BaseViewCell ()
{
    UIImageView *_selectedImageView;
}
@end

@implementation BaseViewCell

- (void)awakeFromNib
{
    [self addSelectedView];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self addSelectedView];
    }
    return self;
}

- (void)addSelectedView
{
//    
    _selectedImageView = [[UIImageView alloc] initWithImage: [UIImage imageWithColor:UU_WHITH_BUTTON_SELECTED_COLOR]];
    
    self.selectedBackgroundView = _selectedImageView;
    
}

- (void)layoutSubviews
{
    _selectedImageView.frame = self.bounds;
}



@end
