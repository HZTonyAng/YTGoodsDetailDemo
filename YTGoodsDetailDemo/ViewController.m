//
//  ViewController.m
//  YTGoodsDetailDemo
//
//  Created by TonyAng on 2017/3/23.
//  Copyright © 2017年 TonyAng. All rights reserved.
//

#import "ViewController.h"
#import "GoodsDetailViewController.h"
#import "YQAnimatedTransition.h"

@interface ViewController () <UINavigationControllerDelegate>
@property (nonatomic, strong) UIButton *tempbutton;
@property (nonatomic, weak) UIImageView *selectImageView;
@property (nonatomic, strong) UIView *shadowView;

@end

@implementation ViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.navigationBarHidden = NO;
    self.shadowView.alpha = 0;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.title = @"YTGoodsDetailDemo";
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.delegate = self;
    self.view.backgroundColor = [UIColor whiteColor];
    self.tempbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.tempbutton.frame = CGRectMake(0, 300, 150, 80);
    [self.tempbutton setBackgroundImage:[UIImage imageNamed:@"headimage"] forState:UIControlStateNormal];
    self.tempbutton.backgroundColor = [UIColor grayColor];
    [self.tempbutton addTarget:self action:@selector(tempbuttonaction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.tempbutton];
    
    UILabel *tempLabel = [[UILabel alloc] initWithFrame:CGRectMake(Device_Width - 120, CGRectGetMaxY(self.tempbutton.frame) + 30, 100, 100)];
    tempLabel.backgroundColor = [UIColor cyanColor];
    [self.view addSubview:tempLabel];
    
    self.shadowView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Device_Width, Device_Height)];
    self.shadowView.backgroundColor = [UIColor whiteColor];
    self.shadowView.clipsToBounds = YES;
    self.shadowView.alpha = 0;
    [self.view addSubview:_shadowView];
    
    UIImageView *selectImageView = [UIImageView new];
    selectImageView.frame = CGRectNull;
    [self.view addSubview:selectImageView];
    self.selectImageView = selectImageView;
}

-(void)tempbuttonaction{
    NSLog(@"进入详情");
    self.navigationController.navigationBarHidden = YES;
    GoodsDetailViewController *goodsDetailViewC = [GoodsDetailViewController new];
    self.selectImageView.image = self.tempbutton.currentBackgroundImage;
    self.selectImageView.frame = self.tempbutton.frame;
    self.shadowView.alpha = 1;
    [UIView animateWithDuration:0.3 animations:^{
        self.selectImageView.frame = CGRectMake(0, 0, self.view.bounds.size.width, 200);
    } completion:^(BOOL finished) {
        [self.navigationController pushViewController:goodsDetailViewC animated:NO];
    }];
}

#pragma mark - UINavigationBarDelegate
- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC{
    
    if (operation == UINavigationControllerOperationPush) {
        YQAnimatedTransition *animatedTransition = [YQAnimatedTransition animatedTransitionWithType:YQAnimatedTransitionTypePush];
        return animatedTransition;
    }
    return nil;
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (viewController != self) {
        self.selectImageView.frame = CGRectNull;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
