//
//  CummunityViewController.m
//  ZAKER_alike
//
//  Created by 王思齐 on 16/8/30.
//  Copyright © 2016年 wangsiqi. All rights reserved.
//

#import "CummunityViewController.h"
#import "MineTableViewController.h"
#import "TopicViewController.h"
#import "FriendCircleViewController.h"
#import "SelectedViewController.h"
#import "SendingViewController.h"
#import "SignInViewController.h"
@interface CummunityViewController ()<UIScrollViewDelegate>
//主要的滚动视图
@property(nonatomic,strong)UIScrollView *mainScrollView;
//头上可供选择的视图
@property(nonatomic,strong)UIView *selectView;
//在可供选择的额视图下面的一条线的背景
@property(nonatomic,strong)UIView *selectBottomView;
//下划线红色
@property(nonatomic,strong)UIView *underLineView;
//上一个被选择的button
@property(nonatomic,strong)UIButton *previousButton;
@end

@implementation CummunityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置导航栏按钮
    UIBarButtonItem *leftBT = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"life_my_account"] style:UIBarButtonItemStylePlain target:self action:@selector(gotoMyself)];
    self.navigationItem.leftBarButtonItem = leftBT;
    
    UIBarButtonItem *rightBT = [[UIBarButtonItem alloc]initWithTitle:@"发送消息" style:UIBarButtonItemStylePlain target:self action:@selector(gotoSend)];
    self.navigationItem.rightBarButtonItem = rightBT;
    [self mainScrollView];
    [self selectView];
    [self setChildViewControllers];
    
//    //添加登录成功的监听
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reset) name:@"登录成功" object:nil];
   // [self buttonClicked:self.selectView.subviews.lastObject];
    }


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//-(void)reset{
//    //设置导航栏按钮
//    UIBarButtonItem *leftBT = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"life_my_account"] style:UIBarButtonItemStylePlain target:self action:@selector(gotoMyself)];
//    self.navigationItem.leftBarButtonItem = leftBT;
//    
//    UIBarButtonItem *rightBT = [[UIBarButtonItem alloc]initWithTitle:@"发送消息" style:UIBarButtonItemStylePlain target:self action:@selector(gotoSend)];
//    self.navigationItem.rightBarButtonItem = rightBT;
//    [self mainScrollView];
//    [self selectView];
//    [self setChildViewControllers];
//    
//    NSLog(@"11111");
//}

#pragma mark - 方法 methods
//前往个人中心
-(void)gotoMyself{
    MineTableViewController *vc = [[UIStoryboard storyboardWithName:@"Mine" bundle:nil]instantiateViewControllerWithIdentifier:@"mine"];
    [self.navigationController pushViewController:vc animated:YES];
}

//前往发送消息
-(void)gotoSend{
    if (![BmobUser currentUser]) {
        UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"您还未登录" message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"登录" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {

            SignInViewController *vc = [SignInViewController new];
            [self.navigationController pushViewController:vc animated:YES];
            //[self presentViewController:vc animated:YES completion:nil];
        }];
        UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            nil;
        }];
        [ac addAction:action1];
        [ac addAction:action2];
        [self presentViewController:ac animated:YES completion:nil];
    }
    SendingViewController *vc = [SendingViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

//设置子控制器
-(void)setChildViewControllers{
    [self addChildViewController:[TopicViewController new]];
    [self addChildViewController:[SelectedViewController new]];
    [self addChildViewController:[FriendCircleViewController new]];
    
    //得到子控制器的数目
    NSInteger count = self.childViewControllers.count;
    
    for (NSInteger i = 0; i < count; i++) {
        UIView *view = self.childViewControllers[i].view;
        view.frame = CGRectMake(0 + SQSW * i, 0, SQSW, SQSH - 99);
        [self.mainScrollView addSubview:view];
    }
    self.mainScrollView.contentSize = CGSizeMake(SQSW * count, SQSH);
    self.mainScrollView.pagingEnabled = YES;
    self.mainScrollView.showsVerticalScrollIndicator = NO;
    self.mainScrollView.showsHorizontalScrollIndicator = NO;
    //取消弹簧效果
    self.mainScrollView.bounces = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self setChildViewForScroll:0];
}

//设置下划线
-(void)setUnderLine{
    //获取第一个按钮
    UIButton *button = self.selectView.subviews.firstObject;
    
    CGFloat height = 2;
    CGFloat buttonHeight = button.frame.size.height;
    CGFloat buttonWidth = button.frame.size.width;
    UIView *underView = [[UIView alloc] init];
    underView.frame = CGRectMake(0, buttonHeight - height, buttonWidth, height);
    underView.backgroundColor = [button titleColorForState:UIControlStateSelected];
    
    [button addSubview:underView];
    self.underLineView = underView;
    
    // 加载第一次的时候第一个按钮默认为选中
    button.selected = YES;
    self.previousButton = button;
    
    [button.titleLabel sizeToFit];
    CGPoint size = underView.center;
    size.x = button.center.x;
    underView.center = size;
    
}


//上面的按钮被点击了之后触发的事件
-(void)buttonClicked:(UIButton*)sender{
    self.previousButton.selected = NO;
    sender.selected = YES;
    self.previousButton  = sender;
    
    NSInteger index = sender.tag - 10;
    
    //当按钮点击的时候,将underLine也跟随移动位置
    [UIView animateWithDuration:0.25 animations:^{
        CGPoint size = self.underLineView.center;
        size.x = sender.center.x;
        self.underLineView.center = size;
        
        CGFloat offsetX = index * self.mainScrollView.frame.size.width;
        self.mainScrollView.contentOffset = CGPointMake(offsetX, self.mainScrollView.contentOffset.y);
    } completion:^(BOOL finished) {
        [self setChildViewForScroll:index];
    }];

}

-(void)setChildViewForScroll:(NSInteger)index{
    UIViewController *vc = self.childViewControllers[index];
    
    if (vc.isViewLoaded) return;
    CGRect frame = vc.view.frame;
    frame.origin.x = index * self.mainScrollView.frame.size.width;
    frame.origin.y = 0;
    frame.size.width = self.mainScrollView.frame.size.width;
    frame.size.height = self.mainScrollView.frame.size.height;
    vc.view.frame = frame;
    [self.mainScrollView addSubview:vc.view];

}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //根据偏移量计算页码
    NSUInteger page = scrollView.contentOffset.x / scrollView.frame.size.width;
    
    UIButton *button = self.selectView.subviews[page];
    
    [self buttonClicked:button];
}

#pragma mark - 懒加载 lazyLoad
- (UIScrollView *)mainScrollView {
	if(_mainScrollView == nil) {
		_mainScrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
        [self.view addSubview:_mainScrollView];
        _mainScrollView.backgroundColor = [UIColor whiteColor];
        _mainScrollView.delegate = self;
	}
	return _mainScrollView;
}

- (UIView *)selectView {
	if(_selectView == nil) {
		_selectView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SQSW, 35)];
        _selectView.backgroundColor = [UIColor whiteColor];
        _selectView.alpha = 0.98;
        [self.view addSubview:_selectView];
        self.selectBottomView = [[UIView alloc] init];
        CGFloat height = _selectView.frame.size.height;
        
        _selectView.userInteractionEnabled = YES;
        //设置view上的按钮
        NSArray *buttonTitlesArray = @[@"话题",@"精选",@"好友圈"];
        for (int i = 0; i<3; i++) {
            
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setTitle:buttonTitlesArray[i] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
            button.titleLabel.font = [UIFont systemFontOfSize:14];
            CGFloat width = SQSW/3.0;
            button.frame = CGRectMake(i * width, 0, width, height);
            //设置button的tag值
            button.tag = 10 + i;
            [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
            [_selectView addSubview:button];
        }
        
        [self setUnderLine];
        
        self.selectBottomView.frame = CGRectMake(0, height - 0.5, SQSW, 1);
        self.selectBottomView.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1];
        [self.view addSubview:self.selectBottomView];
	}
	return _selectView;
}

@end
