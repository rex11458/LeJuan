//
//  PYMenu.m
//  hpj_refactor
//
//  Created by LiuRex on 16/3/4.
//  Copyright © 2016年 Shanghai Youyou Finance Information Technology Co.,Ltd. All rights reserved.
//

#import "PYMenu.h"
#import <KxMenu/KxMenu.h>

@interface PYMenu ()
{
    void(^_selectedIndex)(NSInteger index);
    NSMutableArray *_menuItems;
}
@end

@implementation PYMenu

- (instancetype)initWithView:(UIView *)view rect:(CGRect)rect titles:(NSArray *)titles selectedIndex:(void(^)(NSInteger index))selectedIndex
{
    
    if (self = [super init]) {
        
        _menuItems = [NSMutableArray array];
        
        _view = view;
        _rect = rect;
        self.titles = titles;
        _selectedIndex = [selectedIndex copy];
    }
    
    return self;
}

- (void)setTitles:(NSArray *)titles
{
    _titles = [titles copy];

    for (NSInteger i = 0; i < _titles.count; i++) {
        NSString *title = [_titles objectAtIndex:i];
        KxMenuItem *kxMenuItem = [KxMenuItem menuItem:title
                                                image:nil
                                               target:self
                                               action:@selector(itemAction:)];
        
        [_menuItems addObject:kxMenuItem];
    }
}

- (void)itemAction:(KxMenuItem *)item
{
    NSString *title = item.title;
    NSInteger index = [_titles indexOfObject:title];
    
    if (_selectedIndex) {
        _selectedIndex(index);
    }
}

- (void)show
{
    [KxMenu showMenuInView:self.view
                  fromRect:_rect
                 menuItems:_menuItems];
}

@end
