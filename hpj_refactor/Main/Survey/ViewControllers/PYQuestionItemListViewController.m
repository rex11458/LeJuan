//
//  PYQuestionItemListViewController.m
//  hpj_refactor
//
//  Created by LiuRex on 16/3/6.
//  Copyright © 2016年 Shanghai Youyou Finance Information Technology Co.,Ltd. All rights reserved.
//

#import "PYQuestionItemListViewController.h"
#import "PYQuestionItemCollectionVIewCell.h"
@interface PYQuestionItemListViewController ()
- (IBAction)cancelAction:(id)sender;

@end

@implementation PYQuestionItemListViewController

static NSString * const reuseIdentifier = @"PYQuestionItemCollectionVIewCellId";

- (void)viewDidLoad {
    [super viewDidLoad];
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionViewLayout;
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    CGFloat width = CGRectGetWidth(self.view.bounds) / 3.0f;
    CGFloat height = width;
    layout.itemSize = CGSizeMake(width, height);
    
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

#pragma mark <UICollectionViewDataSource>
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.questionItems.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PYQuestionItemCollectionVIewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    [cell setItem:[self.questionItems objectAtIndex:indexPath.row] indexPath:indexPath];
    
    return cell;
}

#pragma mark <UICollectionViewDelegate>
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_delegate respondsToSelector:@selector(questionItemListViewControllerSeletectedItem:)]) {
        [_delegate questionItemListViewControllerSeletectedItem:[self.questionItems objectAtIndex:indexPath.row]];
    }
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)cancelAction:(id)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}
@end
