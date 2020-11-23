//
//  BaseViewController.m
//  HZYToolBox
//
//  Created by hong  on 2018/6/26.
//  Copyright © 2018年 HZY. All rights reserved.
//

#import "BaseViewController.h"
@interface BaseViewController ()

@end

@implementation BaseViewController
- (instancetype)init
{
    self = [super init];
    if (self) {
         self.modalPresentationStyle = UIModalPresentationFullScreen;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:false];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = StyleColor;
    [self configNaviBar];
}

- (void)configNaviBar{
    [self.navigationController.navigationBar setTitleTextAttributes: @{NSFontAttributeName:FONT_SIZE(17),NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.automaticallyAdjustsScrollViewInsets = false;
    self.navigationController.navigationBar.barTintColor = StyleColor;
    [self.navigationController.navigationBar setShadowImage:[UIImage imageNamed:@"lucency"]];
    self.navigationController.navigationBar.translucent = false;
//    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(backAction) image:[UIImage imageNamed:@"back"]];
}


- (void)hiddenLeftBtn{
    self.navigationItem.leftBarButtonItem = nil;
}

- (BOOL)shouldAutorotate{
    return true;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
@end
