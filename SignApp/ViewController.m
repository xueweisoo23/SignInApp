//
//  ViewController.m
//  SignApp
//
//  Created by Genius on 2017/9/26.
//  Copyright © 2017年 Xue. All rights reserved.
//

#import "ViewController.h"
#import "SignInandOutViewController.h"

@interface ViewController ()

@property (nonatomic,strong) SignInandOutViewController *mainViewController; // 签到页面

@end

@implementation ViewController

- (SignInandOutViewController *)mainViewController {
    if (!_mainViewController) {
        _mainViewController = [[SignInandOutViewController alloc] init];
    }
    return _mainViewController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 点击登录按钮
- (IBAction)loginBtnTapped:(id)sender {
    if (self.mainViewController) {
        [self.navigationController pushViewController:self.mainViewController animated:YES];
    }
}

@end
