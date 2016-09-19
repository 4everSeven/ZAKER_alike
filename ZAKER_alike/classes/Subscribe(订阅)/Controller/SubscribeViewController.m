//
//  SubscribeViewController.m
//  ZAKER_alike
//
//  Created by 王思齐 on 16/8/30.
//  Copyright © 2016年 wangsiqi. All rights reserved.
//

#define margin 1
#define cellW (SQSW ) / 3
#define cellH cellW

#import "SubscribeViewController.h"
#import "MineTableViewController.h"
#import "HeaderScrollView.h"
#import "WebUtils.h"
#import <SDCycleScrollView.h>
#import "HeaderRotationItem.h"
#import "CollectionCellItem.h"
#import "CollectionViewCell.h"
#import "SubArticleListViewController.h"
#import "SearchViewController.h"
#import "EditingView.h"
#import <SVPullToRefresh.h>
@interface SubscribeViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,SDCycleScrollViewDelegate>
//各个板块的collection
@property(nonatomic,strong)UICollectionView *collection;
//作为视图最下面的滚动视图，负责全局的滚动
@property(nonatomic,strong)UIScrollView *mainScroll;
//循环播放视图
@property(nonatomic,strong)HeaderScrollView *headerScrollView;
//装载各频道数组
@property(nonatomic,strong)NSMutableArray *channelsArray;

@property (nonatomic, assign, getter=isEditing) BOOL editing;
@property(nonatomic,strong)EditingView *edtingView;
@property(nonatomic,strong)NSMutableArray *cellsArray;
@end
@implementation SubscribeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.editing = NO;
    
    //设置导航栏按钮
    UIBarButtonItem *leftBT = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"life_my_account"] style:UIBarButtonItemStylePlain target:self action:@selector(gotoMyself)];
    self.navigationItem.leftBarButtonItem = leftBT;
    
    UIBarButtonItem *searchBT = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"icon-search-o"] style:UIBarButtonItemStylePlain target:self action:@selector(gotoSearchVC)];
    self.navigationItem.rightBarButtonItem = searchBT;
    [self mainScroll];
   
    //头部的轮播视图
    [self headerScrollView];
    
    //从用户偏好设置中取出数据
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSData *data = [ud objectForKey:@"channelsArray"];
    self.channelsArray = [(NSArray*)[NSKeyedUnarchiver unarchiveObjectWithData:data] mutableCopy];
    //NSLog(@"chnnaera.count:%ld",self.channelsArray.count);
    if (self.channelsArray.count < 2) {
        //加载各频道数据
        [self loadData];
    }
    
    [self collection];
    
    [self.collection registerNib:[UINib nibWithNibName:@"CollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"cell"];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
     __block __weak __typeof(&*self)weakSelf = self;
    [self.mainScroll addPullToRefreshWithActionHandler:^{
        [weakSelf reloadTheWholeVC];
    }];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    if (self.navigationController.childViewControllers.count == 1) {
//        <#statements#>
//    }
//    //从用户偏好设置中取出数据
//    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
//    NSData *data = [ud objectForKey:@"channelsArray"];
//    self.channelsArray = [(NSArray*)[NSKeyedUnarchiver unarchiveObjectWithData:data] mutableCopy];
//    //NSLog(@"chnnaera.count:%ld",self.channelsArray.count);
//    [self.collection reloadData];
//    CGRect frame = _collection.frame;
//    NSInteger hang = (self.channelsArray.count - 1)/ 3 + 1;
//    //NSLog(@"hang:%ld",hang);
//    frame.size.height = cellH * hang  ;
//    _collection.frame = frame;
//    self.mainScroll.contentSize = CGSizeMake(SQSW, 200 + frame.size.height + 108 + hang  - 1 );
    self.navigationController.navigationBarHidden = NO;
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
//    if (self.channelsArray.count % 3 == 2) {
//        return self.channelsArray.count + 1;
//    }else if (self.channelsArray.count %3 == 1){
//        return self.channelsArray.count + 2;
//    }else{
//        return self.channelsArray.count;
//    }
    return self.channelsArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    
    //cell.editing = self.editing;
    cell.channelIndex = indexPath.row;
//    if (indexPath.row == self.channelsArray.count) {
//        cell.backgroundColor = [UIColor whiteColor];
//        //cell.item = self.channelsArray[indexPath.row];
//        if (cell.item == nil) {
//            for (UIView *view in cell.contentView.subviews) {
//                [view removeFromSuperview];
//            }
//        }
//        return cell;
//    }else if (indexPath.row == self.channelsArray.count + 1){
//        cell.backgroundColor = [UIColor whiteColor];
//        //cell.item = self.channelsArray[indexPath.row];
//        if (cell.item == nil) {
//            for (UIView *view in cell.contentView.subviews) {
//                [view removeFromSuperview];
//            }
//        }
//        return cell;
//    }else{
//        cell.item = self.channelsArray[indexPath.row];
////       if (cell.item == nil) {
////            for (UIView *view in cell.contentView.subviews) {
////                [view removeFromSuperview];
////            }
////        }
//        cell.backgroundColor = [UIColor whiteColor];
//        return cell;
//    }
    cell.backgroundColor = [UIColor whiteColor];
    cell.item = self.channelsArray[indexPath.row];
    return cell;
    

}

#pragma mark - UICollectionDelegate delegateMethods
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
       if (self.isEditing) {
        return;
    }else{
//        if (self.channelsArray.count % 3 != 0) {
//            if (self.channelsArray.count % 3 ==1) {
//                if (indexPath.row == self.channelsArray.count - 3) {
//                    SearchViewController *svc = [SearchViewController new];
//                    [self.navigationController pushViewController:svc animated:YES];
//                }
//            }
//            if (self.channelsArray.count % 3 == 2) {
//                if (indexPath.row == self.channelsArray.count - 2) {
//                    SearchViewController *svc = [SearchViewController new];
//                    [self.navigationController pushViewController:svc animated:YES];
//                }
//            }
//            if (indexPath.row != self.channelsArray.count && indexPath.row != self.channelsArray.count - 1) {
//                SubArticleListViewController *vc = [SubArticleListViewController new];
//                CollectionCellItem *item = self.channelsArray[indexPath.row];
//                //vc.item = self.channelsArray[indexPath.row];
//                vc.item = item;
//                vc.api_url = [item valueForKey:@"api_url"];
//                vc.block_color = [item valueForKey:@"block_color"];
//                [self.navigationController pushViewController:vc animated:YES];
//            }
//        }else{
//            if (indexPath.row != self.channelsArray.count - 1) {
//                SubArticleListViewController *vc = [SubArticleListViewController new];
//                vc.item = self.channelsArray[indexPath.row];
//                CollectionCellItem *item = self.channelsArray[indexPath.row];
//                //vc.api_url = item.api_url;
//                vc.api_url = [item valueForKey:@"api_url"];
//                [self.navigationController pushViewController:vc animated:YES];
//            }
//            if (indexPath.row == self.channelsArray.count - 1) {
//                 SearchViewController *svc = [SearchViewController new];
//                [self.navigationController pushViewController:svc animated:YES];
//            }
        if (indexPath.row == self.channelsArray.count - 1) {
            SearchViewController *svc = [SearchViewController new];
            [self.navigationController pushViewController:svc animated:YES];
        }else{
            SubArticleListViewController *vc = [SubArticleListViewController new];
                            CollectionCellItem *item = self.channelsArray[indexPath.row];
                            //vc.item = self.channelsArray[indexPath.row];
                            vc.item = item;
                            vc.api_url = [item valueForKey:@"api_url"];
                            vc.block_color = [item valueForKey:@"block_color"];
                            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    
}

#pragma mark - 方法 methods
//前往个人中心
-(void)gotoMyself{
    MineTableViewController *vc = [[UIStoryboard storyboardWithName:@"Mine" bundle:nil]instantiateViewControllerWithIdentifier:@"mine"];
    [self.navigationController pushViewController:vc animated:YES];
}

//前往搜索界面
-(void)gotoSearchVC{
    SearchViewController *vc = [SearchViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

//加载各频道数据的方法
- (void)loadData
{
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"rootBlocks" ofType:@"plist"];
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];

    self.channelsArray = [CollectionCellItem mj_objectArrayWithKeyValuesArray:data[@"blocksData"]];
    
    // 添加最后一个cell,专门用来添加类型的cell
    CollectionCellItem *item = [[CollectionCellItem alloc] init];
    item.title = @"添加内容";
    item.pic = @"addRootBlock_cell_add";
    item.need_userinfo = @"NO";
    item.block_color = @"#d3d7d4";
    
    [self.channelsArray addObject:item];
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    //[ud setValue:self.channelsArray forKey:@"channelsArray"];
    [ud setObject:[NSKeyedArchiver archivedDataWithRootObject:self.channelsArray] forKey:@"channelsArray"];
    [ud synchronize];
}

#pragma mark - 懒加载 lazyLoad
- (UICollectionView *)collection {
	if(_collection == nil) {
        //设置流水布局
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.itemSize = CGSizeMake(cellW , cellH);
        flowLayout.minimumLineSpacing = 0;
        flowLayout.minimumInteritemSpacing = 0;
        
		_collection = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 200, SQSW, SQSW - 108 -200) collectionViewLayout:flowLayout];
        [self.mainScroll addSubview:_collection];
        //_collection.backgroundColor = MainBgColor;
        _collection.backgroundColor = [UIColor whiteColor];
        _collection.delegate = self;
        _collection.dataSource = self;
        //使collection不能滚动
        _collection.scrollEnabled = NO;
        
        CGRect frame = _collection.frame;
        NSInteger hang = (self.channelsArray.count - 1)/ 3 + 1;
        //NSLog(@"hang:%ld",hang);
        frame.size.height = cellH * hang  ;
        _collection.frame = frame;
        
        self.mainScroll.contentSize = CGSizeMake(SQSW, 200 + frame.size.height + 108 + hang  - 1 );
        
        //此处给其增加长按手势，用此手势触发cell移动效果
        UILongPressGestureRecognizer *longGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handlelongGesture:)];
        [_collection addGestureRecognizer:longGesture];
	}
	return _collection;
}

- (void)handlelongGesture:(UILongPressGestureRecognizer *)longGesture {
    //判断手势状态
    switch (longGesture.state) {
        case UIGestureRecognizerStateBegan:{
            
            self.editing = YES;
            
            [[UIApplication sharedApplication].keyWindow addSubview:self.edtingView];
            [UIView animateWithDuration:0.3 animations:^{
                CGRect edframe = self.edtingView.frame;
                edframe.origin.y = SQSH - 100;
                self.edtingView.frame = edframe;
            }];
            
            [self.edtingView.editingButton addTarget:self action:@selector(exit:) forControlEvents:UIControlEventTouchUpInside];
            
            //[self.view addSubview:self.edtingView];
            
            //判断手势落点位置是否在路径上
            NSIndexPath *indexPath = [self.collection indexPathForItemAtPoint:[longGesture locationInView:self.collection]];
            if (indexPath == nil) {
                break;
            }
            
            self.cellsArray = [[self.collection visibleCells] mutableCopy];
            for (CollectionViewCell *cell in self.cellsArray) {
                cell.delButton.hidden = NO;
                [cell.delButton addTarget:self action:@selector(deleteItem:) forControlEvents:UIControlEventTouchUpInside];
                
                if ([[cell.item valueForKey:@"title"] isEqualToString:@"添加内容"]) {
                    cell.delButton.hidden = YES;
                    cell.alpha = 0.3;
                }
            }

            //在路径上则开始移动该路径上的cell
            [self.collection beginInteractiveMovementForItemAtIndexPath:indexPath];
        }
            break;
        case UIGestureRecognizerStateChanged:
            //移动过程当中随时更新cell位置
            [self.collection updateInteractiveMovementTargetPosition:[longGesture locationInView:self.collection]];
            //CGPoint position = [longGesture locationInView:self.collection];
            break;
        case UIGestureRecognizerStateEnded:
            //移动结束后关闭cell移动
            [self.collection endInteractiveMovement];
            break;
        default:
            [self.collection cancelInteractiveMovement];
            break;
    }
}

- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath{
    //返回YES允许其item移动
    if (self.channelsArray.count %3 != 0) {
        if (indexPath == nil || indexPath.row == self.channelsArray.count || indexPath.row == self.channelsArray.count - 1) {
            return NO;
        }else{
            return YES;
        }
    }else{
        if (indexPath == nil || indexPath.row == self.channelsArray.count - 1) {
            return NO;
        }else{
            return YES;
        }
    }
    
}

- (void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath*)destinationIndexPath {
    //取出源item数据
    id objc = [self.channelsArray objectAtIndex:sourceIndexPath.item];
    //从资源数组中移除该数据
    [self.channelsArray removeObject:objc];
    //将数据插入到资源数组中的目标位置上
    [self.channelsArray insertObject:objc atIndex:destinationIndexPath.item];
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    //[ud setValue:self.channelsArray forKey:@"channelsArray"];
    [ud setObject:[NSKeyedArchiver archivedDataWithRootObject:self.channelsArray] forKey:@"channelsArray"];
    [ud synchronize];
}

//点击按钮删除
-(void)deleteItem:(UIButton*)sender{
    [self.channelsArray removeObjectAtIndex:sender.tag];
    //[self.cellsArray ]
    [self.cellsArray removeObjectAtIndex:sender.tag];
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    //[ud setValue:self.channelsArray forKey:@"channelsArray"];
    [ud setObject:[NSKeyedArchiver archivedDataWithRootObject:self.channelsArray] forKey:@"channelsArray"];
    [ud synchronize];
    [self.collection reloadData];
    [self reloadFrame];
}

//退出编辑模式
-(void)exit:(UIButton *)sender{
    [sender.superview removeFromSuperview];
    self.cellsArray = [[self.collection visibleCells] mutableCopy];
    for (CollectionViewCell *cell in self.cellsArray) {
        cell.delButton.hidden = YES;
    }
    self.editing = NO;
}

-(void)reloadTheWholeVC{
    //从用户偏好设置中取出数据
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSData *data = [ud objectForKey:@"channelsArray"];
    self.channelsArray = [(NSArray*)[NSKeyedUnarchiver unarchiveObjectWithData:data] mutableCopy];
    //NSLog(@"chnnaera.count:%ld",self.channelsArray.count);
    if (self.channelsArray.count < 2) {
        //加载各频道数据
        [self loadData];
    }
    [self.collection reloadData];
    [self reloadFrame];
    [self.mainScroll.pullToRefreshView stopAnimating];
}

//界面的大小重新布局
-(void)reloadFrame{
    CGRect frame = self.collection.frame;
    NSInteger hang = (self.channelsArray.count - 1)/ 3 + 1;
    //NSLog(@"hang:%ld",hang);
    frame.size.height = cellH * hang  ;
    self.collection.frame = frame;
    self.mainScroll.contentSize = CGSizeMake(SQSW, 200 + frame.size.height + 108 + hang  - 1 );
}

- (UIScrollView *)mainScroll {
	if(_mainScroll == nil) {
		_mainScroll = [[UIScrollView alloc] initWithFrame:self.view.bounds];
        [self.view addSubview:_mainScroll];
        //_mainScroll.contentInset = UIEdgeInsetsMake(0, 0, 64, 0);
	}
	return _mainScroll;
}

- (HeaderScrollView *)headerScrollView {
	if(_headerScrollView == nil) {
		_headerScrollView = [[HeaderScrollView alloc] initWithFrame:CGRectMake(0, 0, SQSW, 200)];
        [self.mainScroll addSubview:_headerScrollView];
	}
        
	return _headerScrollView;
}

- (EditingView *)edtingView {
	if(_edtingView == nil) {
		_edtingView = [[[NSBundle mainBundle] loadNibNamed:@"EditingView" owner:nil options:nil]lastObject];
        CGRect frame = _edtingView.frame;
        frame.origin.y = SQSH;
        frame.size.width = SQSW;
        _edtingView.frame = frame;
        //[self.view addSubview:_edtingView];
	}
	return _edtingView;
}

@end
