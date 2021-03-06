/**
 ---------------------------------------------------------------------
 * 文件名：    PopMenu.m
 * 工程名：    PopMenu
 * 创建者：    Created by YXT on 16/8/6.
 * 所有者：    Copyright © 2016年 YXT. All rights reserved.
 *
 ---------------------------------------------------------------------
 * Date  : 16/8/6
 * Author: YXT
 * Notes :
 *
 ---------------------------------------------------------------------
 */

#import "PopMenu.h"

#define kWindow [UIApplication sharedApplication].keyWindow
#define kWindowWidth [UIApplication sharedApplication].keyWindow.bounds.size.width
#define kWindowHeight [UIApplication sharedApplication].keyWindow.bounds.size.height

#define kMenuWidth kWindowWidth / 3 * 2
#define kMenuHeight kWindowHeight / 5 * 3
/***********************   我是分割线   *************************/

@interface MaskView : UIView

@end

@implementation MaskView

- (instancetype)initWithFrame:(CGRect)frame{
    
    if ([super initWithFrame:frame]) {
        self.alpha = 0.5;
        self.backgroundColor = [UIColor blackColor];
    }
    
    return self;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    //移除视图
    
    for (UIView *view in kWindow.subviews) {
        
        if ([view isKindOfClass:[PopMenu class]] || [view isKindOfClass:[self class]]) {
            [view removeFromSuperview];
        }
    }
}

@end

/***********************   我是分割线   *************************/
@interface PopMenu ()<UITableViewDelegate,UITableViewDataSource>

/***  蒙版  ***/
@property (nonatomic, strong) MaskView *maskView;
/***  数据  ***/
@property (nonatomic, strong) UITableView *menuTableView;

@property (nonatomic, strong) NSArray *dataArray;

@end

@implementation PopMenu


- (instancetype)initWithFrame:(CGRect)frame{
    if ([super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        
    }
    
    return self;
}

- (void)setSelfCorner{
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerTopLeft|UIRectCornerTopRight | UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(10, 10)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}

+ (instancetype)popMenuShowWithArray:(NSArray *)showArray{
    
    PopMenu *menu = [[self alloc]initWithFrame:CGRectZero];
    menu.center = kWindow.center;

    menu.maskView = [[MaskView alloc]initWithFrame:kWindow.frame];
    [kWindow addSubview:menu.maskView];
    [kWindow addSubview:menu];
    
    [UIView animateWithDuration:0.3 animations:^{
       
        menu.frame = CGRectMake(0, 0, kMenuWidth, kMenuHeight);
        menu.center = kWindow.center;
        [menu setSelfCorner];
    } completion:^(BOOL finished) {
//        [menu setSelfCorner];
        [menu addSubview:menu.menuTableView];
        menu.dataArray = [NSArray arrayWithArray:showArray];
    }];
    return menu;
}

+ (void)popMenuDismiss{
    
    for (UIView *view in kWindow.subviews) {
        if ([view isKindOfClass:[self class]]) {
            PopMenu *menu = (PopMenu *)view;
            [menu.menuTableView removeFromSuperview];
            [UIView animateWithDuration:0.3 animations:^{
                menu.frame = CGRectZero;
                menu.center = kWindow.center;
            } completion:^(BOOL finished) {
                [menu.maskView removeFromSuperview];
                [menu removeFromSuperview];
            }];
        }
    }
}


#pragma mark - UITableView Delegate And DataSource

- (UITableView *)menuTableView{
    
    if (!_menuTableView) {
        _menuTableView = [[UITableView alloc]initWithFrame:self.bounds style:(UITableViewStylePlain)];
        _menuTableView.delegate = self;
        _menuTableView.dataSource = self;
        _menuTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    
    return _menuTableView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:(UITableViewCellStyleValue1) reuseIdentifier:@"cell"];
    }
    
    id str = [self.dataArray objectAtIndex:indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@",str];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [PopMenu popMenuDismiss];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        id item = [self.dataArray objectAtIndex:indexPath.row];
        
        if (self.popMenuDelegate || [self.popMenuDelegate respondsToSelector:@selector(popMenu:didSelectItem:)]) {
            [self.popMenuDelegate popMenu:self didSelectItem:item];
        }
    });
}


#pragma mark - 设置属性


- (void)setDataArray:(NSArray *)dataArray{
    _dataArray = dataArray; 
    [self.menuTableView reloadData];
}
@end
