//
//  PYQuestionItemCollectionVIewCell.m
//  hpj_refactor
//
//  Created by LiuRex on 16/3/6.
//  Copyright © 2016年 Shanghai Youyou Finance Information Technology Co.,Ltd. All rights reserved.
//

#import "PYQuestionItemCollectionVIewCell.h"
#import "PYQuestionItem.h"
@implementation PYQuestionItemCollectionVIewCell

- (void)awakeFromNib
{
    self.layer.borderWidth = 0.25;
    self.layer.borderColor = [UIColor blackColor].CGColor;
}

- (void)setItem:(PYQuestionItem *)item indexPath:(NSIndexPath *)indexPath
{
    _numberLabel.text = item.qindex;
    
    if (item.completed)
    {
        _imageView.image = [UIImage imageNamed:@"duihao"];
    }else
    {
        _imageView.image = [UIImage imageNamed:@"wenhao"];
    }
    
    if(indexPath.row % 2 == 0) {
        self.contentView.backgroundColor = UIColorFromRGB(0xF0F5F8);
    } else {
        self.contentView.backgroundColor = UIColorFromRGB(0xE7EFF1);
    }
}

@end
