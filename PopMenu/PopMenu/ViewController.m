//
//  ViewController.m
//  PopMenu
//
//  Created by YXT on 16/8/6.
//  Copyright © 2016年 YXT. All rights reserved.
//

#import "ViewController.h"
#import "PopMenu.h"

@interface ViewController ()<PopMenuDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITextField *textField = [[UITextField alloc]initWithFrame:(CGRectMake(200, 200, 200, 30))];
    textField.borderStyle = UITextBorderStyleRoundedRect;
    textField.backgroundColor = [UIColor redColor];
    [self.view addSubview:textField];
}

- (IBAction)PopMenuBtnAction:(id)sender {
    
    NSArray *showArray = @[@"1",@"2",@"3",@"4",@"5",@"6"];
    
    PopMenu *menu = [PopMenu popMenuShowWithArray:showArray];
    
    
    menu.popMenuDelegate = self;
}

- (void)popMenu:(PopMenu *)menu didSelectItem:(id)item{
    
    NSString *str = [NSString stringWithFormat:@"%@",item];
    
    UIAlertController *alertvc = [UIAlertController alertControllerWithTitle:@"提示" message:str preferredStyle:UIAlertControllerStyleAlert];
    
    [self presentViewController:alertvc animated:YES completion:nil];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [alertvc dismissViewControllerAnimated:YES completion:nil];
    });
}
@end
