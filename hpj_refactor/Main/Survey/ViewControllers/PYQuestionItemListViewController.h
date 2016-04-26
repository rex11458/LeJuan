//
//  PYQuestionItemListViewController.h
//  hpj_refactor
//
//  Created by LiuRex on 16/3/6.
//  Copyright © 2016年 Shanghai Youyou Finance Information Technology Co.,Ltd. All rights reserved.
//

#import "BaseCollectionViewController.h"
@class PYQuestionItem;

@protocol PYQuestionItemListViewControllerDelegate ;
@interface PYQuestionItemListViewController : BaseCollectionViewController

@property (nonatomic, copy) NSArray<PYQuestionItem *> *questionItems;

@property (nonatomic, weak) id<PYQuestionItemListViewControllerDelegate> delegate;

@end


@protocol PYQuestionItemListViewControllerDelegate <NSObject>

@optional
- (void)questionItemListViewControllerSeletectedItem:(PYQuestionItem *)item;

@end