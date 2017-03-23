//
//  GoodsDetailViewController.m
//  YTGoodsDetailDemo
//
//  Created by TonyAng on 2017/3/23.
//  Copyright © 2017年 TonyAng. All rights reserved.
//

#import "GoodsDetailViewController.h"
#define Font(f)  [UIFont systemFontOfSize:f]
static NSString *cellID = @"cell";
@interface GoodsDetailViewController ()<UITableViewDelegate,UITableViewDataSource,UIWebViewDelegate,UIScrollViewDelegate>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)UIButton *tableViewBackButton;

@property(nonatomic,strong)UIView *headview;
@property(nonatomic,strong)UIImageView *headImageView;
@property(nonatomic,strong)UIWebView *webView;
@property(nonatomic,strong)UILabel *headLab;

@end

@implementation GoodsDetailViewController{
    CGFloat _maxContentOffSet_Y;
}

-(void)dealloc
{
    [_webView.scrollView removeObserver:self forKeyPath:@"contentOffset"];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if ([self.title isEqualToString:@"商品详情"]) {
        UIImage *shadowImage = self.navigationController.navigationBar.shadowImage;
        self.navigationController.navigationBar.shadowImage = shadowImage;
        [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
        [self.navigationController.navigationBar setShadowImage:nil];
        self.navigationController.navigationBar.translucent = NO;
        self.navigationController.navigationBarHidden = NO;
        self.title = @"商品详情";
    }else{
        self.navigationController.navigationBarHidden = YES;
        //透明
        [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                      forBarMetrics:UIBarMetricsDefault];
        self.navigationController.navigationBar.shadowImage = [UIImage new];
        self.navigationController.navigationBar.translucent = YES;
        self.title = @"";
    }
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    UIImage *shadowImage = self.navigationController.navigationBar.shadowImage;
    self.navigationController.navigationBar.shadowImage = shadowImage;
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor =[UIColor whiteColor];
    _maxContentOffSet_Y  = 80;
    [self.view addSubview:self.tableView];
    // second view
    [self.view addSubview:self.webView];
    self.webView.hidden = YES;
    UILabel *hv = self.headLab;
    // headLab
    [self.webView addSubview:hv];
    [self.headLab bringSubviewToFront:self.view];
    
    // 开始监听_webView.scrollView的偏移量
    [_webView.scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    [self createBackButton];
    [self createTableViewBackButton];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if(object == _webView.scrollView && [keyPath isEqualToString:@"contentOffset"])
    {
        //        NSLog(@"----old:%@----new:%@",change[@"old"],change[@"new"]);
        [self headLabAnimation:[change[@"new"] CGPointValue].y];
    }else
    {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
    
}

- (void)headLabAnimation:(CGFloat)offsetY
{
    _headLab.alpha = -offsetY/60;
    _headLab.center = CGPointMake(Device_Width/2, -offsetY/2.f);
    // 图标翻转，表示已超过临界值，松手就会返回上页
    if(-offsetY>_maxContentOffSet_Y){
        _headLab.textColor = [UIColor grayColor];
        _headLab.text = @"释放返回顶部";
    }else{
        _headLab.textColor = [UIColor grayColor];
        _headLab.text = @"上拉返回顶部";
    }
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    CGFloat offsetY = scrollView.contentOffset.y;
    if([scrollView isKindOfClass:[UITableView class]]) // tableView界面上的滚动
    {
        if (offsetY <0) {
            return;
        }
        // 能触发翻页的理想值:tableView整体的高度减去屏幕本省的高度
        CGFloat valueNum = _tableView.contentSize.height - Device_Height - 64;
        if ((offsetY - valueNum) > _maxContentOffSet_Y)
        {
            [self goToDetailAnimation]; // 进入图文详情的动画
        }
    }else // webView页面上的滚动
    {
        NSLog(@"-----webView-------");
        if(offsetY<0 && -offsetY>_maxContentOffSet_Y)
        {
            [self backToFirstPageAnimation]; // 返回基本详情界面的动画
            [self.tableView setContentOffset:CGPointMake(0, -20) animated:YES];
        }
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 25;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.textLabel.text = @"扯扯扯";
    return cell;
}

#pragma mark -
#pragma mark -------->进入详情的动画
- (void)goToDetailAnimation
{
    //不透明
    UIImage *shadowImage = self.navigationController.navigationBar.shadowImage;
    self.navigationController.navigationBar.shadowImage = shadowImage;
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBarHidden = NO;
    self.tableViewBackButton.hidden = YES;
    self.title = @"商品详情";
    self.webView.hidden = NO;
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionLayoutSubviews animations:^{
        _webView.frame = CGRectMake(0, 0, Device_Width, Device_Height - 64);
        _tableView.frame = CGRectMake(0, -Device_Height, Device_Width, Device_Height);
    } completion:^(BOOL finished) {
        
    }];
}

#pragma mark -
#pragma mark -------->返回第一个界面的动画
- (void)backToFirstPageAnimation
{
    //透明
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    self.title = @"";
    self.navigationController.navigationBarHidden = YES;
    self.tableViewBackButton.hidden = NO;
    self.webView.hidden = YES;
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionLayoutSubviews animations:^{
        _tableView.frame = CGRectMake(0, -20, Device_Width, Device_Height + 20);
        _webView.frame = CGRectMake(0, -Device_Height, Device_Width, Device_Height);
    } completion:^(BOOL finished) {
        
    }];
}

#pragma mark -
#pragma mark -------->headLab
- (UILabel *)headLab
{
    if(!_headLab){
        _headLab = [[UILabel alloc] init];
        _headLab.text = @"上拉返回顶部";
        _headLab.textAlignment = NSTextAlignmentCenter;
        _headLab.font = Font(13);
    }
    _headLab.frame = CGRectMake(0, 64, Device_Width, 40.f);
    _headLab.alpha = 0.f;
    _headLab.textColor = [UIColor grayColor];
    return _headLab;
}

#pragma mark -
#pragma mark -------->tableView
- (UITableView *)tableView
{
    if(!_tableView){
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, -20, Device_Width, Device_Height + 20) style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.rowHeight = 40.f;
        UILabel *tabFootLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, Device_Width, 60)];
        tabFootLab.text = @"上拉查看更多详情";
        tabFootLab.font = Font(13);
        tabFootLab.textAlignment = NSTextAlignmentCenter;
        tabFootLab.backgroundColor = [UIColor whiteColor];
        _tableView.tableFooterView = tabFootLab;
        
        _headview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Device_Width, 200)];
        _headview.backgroundColor = [UIColor purpleColor];
        
        UIImageView *tempImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 200)];
        tempImageView.image = [UIImage imageNamed:@"headimage"];
        [_headview addSubview:tempImageView];
        
        _tableView.tableHeaderView = _headview;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellID];
    }
    return _tableView;
}

#pragma mark -
#pragma mark -------->webView
- (UIWebView *)webView
{
    if(!_webView){
        _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, _tableView.contentSize.height, Device_Width, Device_Height - 64)];
        _webView.delegate = self;
        _webView.backgroundColor = [UIColor clearColor];
        _webView.scrollView.delegate = self;
        _webView.opaque = NO;
        [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.jianshu.com/users/4c1af25e268b/timeline"]]];
        [self initializeButtonWithFrame:CGRectMake(Device_Width - 65, Device_Height - 65 - 64,50, 50) title:@"TOP" action:@selector(scrollToTop:)];
        
    }
    return _webView;
}

/**
 *  初始化按钮
 *
 *  @param frame 尺寸
 *  @param title 标题
 *  @param aSEL  按钮的方法
 */
- (void)initializeButtonWithFrame:(CGRect)frame title:(NSString*)title action:(SEL)aSEL{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = [UIColor lightGrayColor];
    btn.frame = frame;
    [btn setTitle:title forState:0];
    [btn addTarget:self action:aSEL forControlEvents:UIControlEventTouchUpInside];
    btn.backgroundColor = [UIColor grayColor];
    [_webView addSubview:btn];
}

- (void)scrollToTop:(UIButton*)sender{
    NSLog(@"滚到顶部");
    if ([_webView subviews]) {
        UIScrollView* scrollView = [[_webView subviews] objectAtIndex:0];
        [scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    }
    [self backToFirstPageAnimation]; // 返回基本详情界面的动画
    [self.tableView setContentOffset:CGPointMake(0, -20) animated:YES];
}

#pragma mark -
#pragma mark -------->返回按钮
-(void)createBackButton{
    // 初始化一个返回按钮
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    // 为返回按钮设置图片样式
    [button setImage:[UIImage imageNamed:@"ic_back"] forState:UIControlStateNormal];
    // 设置返回按钮触发的事件
    [button addTarget:self action:@selector(BackAction) forControlEvents:UIControlEventTouchUpInside];
    
    // 返回按钮内容左靠
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    // 让返回按钮内容继续向左边偏移10
    button.contentEdgeInsets = UIEdgeInsetsMake(-1, 0, 0, 0);
    // 初始化一个BarButtonItem，并将其设置为返回的按钮的样式
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    // 将BarButtonItem添加到LeftBarButtonItem上
    self.navigationItem.leftBarButtonItem = backButton;
}

-(void)createTableViewBackButton{
    // 初始化一个返回按钮
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(7, 21, 40, 40)];
    // 为返回按钮设置图片样式
    [button setImage:[UIImage imageNamed:@"ic_back"] forState:UIControlStateNormal];
    // 设置返回按钮触发的事件
    [button addTarget:self action:@selector(BackAction) forControlEvents:UIControlEventTouchUpInside];
    
    // 返回按钮内容左靠
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    self.tableViewBackButton = button;
    [self.view addSubview:self.tableViewBackButton];
}

-(void)BackAction{
    [self.navigationController popViewControllerAnimated:YES];
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

@end
