//
//  PYQuestionItemCollectionVIewCell.h
//  hpj_refactor
//
//  Created by LiuRex on 16/3/6.
//  Copyright © 2016年 Shanghai Youyou Finance Information Technology Co.,Ltd. All rights reserved.
//

#import "BaseCollectionViewCell.h"
@class PYQuestionItem;
@interface PYQuestionItemCollectionVIewCell : BaseCollectionViewCell
@property (strong, nonatomic) IBOutlet UILabel *numberLabel;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;



- (void)setItem:(PYQuestionItem *)item indexPath:(NSIndexPath *)indexPath;

@end
