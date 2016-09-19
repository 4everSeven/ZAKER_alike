//
//  SubArticleListViewController.m
//  ZAKER_alike
//
//  Created by 王思齐 on 16/9/5.
//  Copyright © 2016年 wangsiqi. All rights reserved.
//

#import "SubArticleListViewController.h"
#import <SVProgressHUD.h>
#import "WebUtils.h"
#import "SubArticleItem.h"

#import "subArtiListCell1.h"
#import "SubArtiListCell2.h"
#import "SubArtiListCell3.h"


@interface SubArticleListViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property(nonatomic,strong)UICollectionView *mainCollectionView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;

@property(nonatomic,strong)NSArray *subArticleItemsArray;
@property (nonatomic, strong) NSString *topImageURL;
@property(nonatomic,strong)NSMutableArray *pagesArray;
@property (weak, nonatomic) IBOutlet UILabel *latestTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastTimeLabel;
@property (weak, nonatomic) IBOutlet UISlider *pageSlideView;

@end

static NSString *subCell1 = @"cell1";
static NSString *subCell2 = @"cell2";
static NSString *subCell3 = @"cell3";

@implementation SubArticleListViewController

#pragma mark - 生命周期 lifeCircle


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
        //隐藏导航栏
        [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [SVProgressHUD show];
    
    //先隐藏下方的各种工具栏
    self.bottomView.hidden = YES;
    
    [self mainCollectionView];
    
     [self loadData];
    
    //设置slider的一些属性
    self.pageSlideView.minimumValue = 0;
    self.pageSlideView.value = 0;
    [self.pageSlideView setThumbImage:[UIImage imageNamed:@"rec"] forState:UIControlStateNormal];
    [self.pageSlideView setThumbImage:[UIImage imageNamed:@"rec"] forState:UIControlStateHighlighted];
    //添加点击事件，当点击并滑动时，页面跟着变换
    [self.pageSlideView addTarget:self action:@selector(changePage:) forControlEvents:UIControlEventTouchUpInside];
    
    //注册各种类型的cell
    [self.mainCollectionView registerNib:[UINib nibWithNibName:@"subArtiListCell1" bundle:nil] forCellWithReuseIdentifier:subCell1];
    [self.mainCollectionView registerNib:[UINib nibWithNibName:@"SubArtiListCell2" bundle:nil] forCellWithReuseIdentifier:subCell2];
    [self.mainCollectionView registerNib:[UINib nibWithNibName:@"SubArtiListCell3" bundle:nil] forCellWithReuseIdentifier:subCell3];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadData{
    //self.item.api_url
    [WebUtils requestSubArticleWithUrl:self.api_url andCompletion:^(NSArray *array, NSString *url) {
        self.subArticleItemsArray = array;
        self.topImageURL = url;
        
        NSMutableArray *page = [NSMutableArray arrayWithCapacity:6];
        NSMutableArray *pages = [NSMutableArray array];
        SubArticleItem *article = [[SubArticleItem alloc] init];
        for (int i = 0; i < self.subArticleItemsArray.count; ++i) {
            article = self.subArticleItemsArray[i];
            [page addObject:article];
            while (page.count == 6) {
                [pages addObject:page];
                page = [NSMutableArray arrayWithCapacity:6];
            }
        }
        self.pagesArray = pages;
        
        //设置下面滑动条的文字
        SubArticleItem *firstObj = self.subArticleItemsArray.firstObject;
        self.latestTimeLabel.text = [self dateString:firstObj.date];
        
        SubArticleItem *lastObj = self.subArticleItemsArray.lastObject;
        self.lastTimeLabel.text = [self dateString:lastObj.date];
        self.pageSlideView.maximumValue = self.pagesArray.count - 1;
        
        [self.mainCollectionView reloadData];
        
        self.bottomView.hidden = NO;
        [SVProgressHUD dismiss];
        
        self.pageSlideView.value = 0;
        
        [self.mainCollectionView setContentOffset:CGPointMake(0, 0) animated:YES];
    }];
    
   
}




//回到订阅界面
- (IBAction)goBackToTop:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

//按下按钮后，刷新
- (IBAction)refresh:(UIButton*)sender {
    [SVProgressHUD show];
    [self loadData];
}

//当点击并滑动时，页面跟着变换
-(void)changePage:(UISlider *)sender{
    NSInteger page = (NSInteger)sender.value;
//    if (page * self.mainCollectionView.frame.size.width > self.mainCollectionView.contentSize.width) {
//        [self.mainCollectionView setContentOffset:CGPointMake((page - 2) * self.mainCollectionView.frame.size.width, 0) animated:YES];
//    }else{
         [self.mainCollectionView setContentOffset:CGPointMake(page * self.mainCollectionView.frame.size.width, 0) animated:YES];
    //}
}

//把时间转换成几个小时前的方法
- (NSString *)dateString:(NSString *)dateStr
{
    //把字符串转为NSdate
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [dateFormatter dateFromString:dateStr];
    
    if (!date) {
        return @"";
    }
    int minites = [[NSDate date] timeIntervalSinceDate:date]/60;
    if (minites < 0) {
        return @"";
    }
    if (minites < 60) {//不到一小时
        return [NSString stringWithFormat:@"%d分钟前",minites];
    }
    else if(minites < 60 * 24)//不到一天
    {
        return [NSString stringWithFormat:@"%d小时前",minites / 60];
    }
    else if(minites < 60 * 24 * 3)//不大于三天
    {
        return [NSString stringWithFormat:@"%d天前",minites / 60 / 24];
    }
    
    return @"";
}

#pragma mark - UICollectionDataSource delegateMethods
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.pagesArray.count;
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    subArtiListCell1 *cell1 = [collectionView dequeueReusableCellWithReuseIdentifier:subCell1 forIndexPath:indexPath];
    cell1.articlesArray = self.pagesArray[indexPath.row];
    cell1.topImageURL = self.topImageURL;
    
    cell1.item = self.item;
    //cell1.block_color = self.block_color;
    
    SubArtiListCell2 *cell2 = [collectionView dequeueReusableCellWithReuseIdentifier:subCell2 forIndexPath:indexPath];
    cell2.articlesArray = self.pagesArray[indexPath.row];
    cell2.topImageURL = self.topImageURL;
    cell2.item = self.item;
    //cell2.block_color = self.block_color;
    
    SubArtiListCell3 *cell3 = [collectionView dequeueReusableCellWithReuseIdentifier:subCell3 forIndexPath:indexPath];
    cell3.articlesArray = self.pagesArray[indexPath.row];
    cell3.topImageURL = self.topImageURL;
    cell3.item = self.item;
    //cell3.block_color = self.block_color;
    
        if (indexPath.row % 3 == 0) {
            return cell1;
        } else if (indexPath.row % 3 == 1){
            return cell2;
        } else {
            return cell3;
        }
}

//拖动界面的同时下方sliderView也跟着动
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger pageNum = scrollView.contentOffset.x / scrollView.frame.size.width;
    [self.pageSlideView setValue:pageNum animated:YES];
}

#pragma mark - 懒加载 lazyLoad
- (UICollectionView *)mainCollectionView {
    //设置流水布局
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = self.contentView.frame.size;
    flowLayout.minimumLineSpacing = 0;
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    //设置滑动的方向
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
   // NSLog(@"contentViewheight:%f",self.contentView.frame.size.height);
	if(_mainCollectionView == nil) {
		_mainCollectionView = [[UICollectionView alloc] initWithFrame:self.contentView.bounds collectionViewLayout:flowLayout];
        _mainCollectionView.delegate = self;
        _mainCollectionView.dataSource = self;
        _mainCollectionView.pagingEnabled = YES;
        _mainCollectionView.backgroundColor = [UIColor whiteColor];
        _mainCollectionView.showsHorizontalScrollIndicator = NO;
        [self.view addSubview:_mainCollectionView];
	}
	return _mainCollectionView;
}

@end
