/**
 ---------------------------------------------------------------------
 * 文件名：    PopMenu.h
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

#import <UIKit/UIKit.h>

@protocol PopMenuDelegate;

@interface PopMenu : UIView

@property (nonatomic, assign) id<PopMenuDelegate>popMenuDelegate;

+ (instancetype)popMenuShowWithArray:(NSArray *)showArray; //显示弹出菜单
+ (void)popMenuDismiss;//隐藏弹出菜单

@end

@protocol PopMenuDelegate <NSObject>

@required
- (void)popMenu:(PopMenu *)menu didSelectItem:(id)item;

@end