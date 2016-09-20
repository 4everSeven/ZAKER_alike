//
//  AirticleViewController.m
//  ZAKER_alike
//
//  Created by 王思齐 on 16/9/7.
//  Copyright © 2016年 wangsiqi. All rights reserved.
//

#import "AirticleViewController.h"
#import "WebUtils.h"
#import "ArticleContentItem.h"
#import "ArticleTopView.h"
#import "FunArticleTopView.h"
#import <SVProgressHUD.h>
#import "CommentItem.h"
#import "commentCell.h"
#import "SignInViewController.h"
#import "UIColor+Hex.h"
#import <MWPhotoBrowser.h>
//#import "PhotoBroswerVC.h"
//#import "PhotoBroswerVC.h"

@interface AirticleViewController ()<UITableViewDelegate,UITableViewDataSource,UIWebViewDelegate,UIGestureRecognizerDelegate,MWPhotoBrowserDelegate>
@property(nonatomic,strong)UITableView *mainTableView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property(nonatomic,strong)UIWebView *webView;

@property(nonatomic,strong)ArticleContentItem *contentItem;
@property(nonatomic,strong)ArticleTopView *topView;
@property(nonatomic,strong)FunArticleTopView *funTopView;
@property(nonatomic,strong)NSMutableArray *imagePaths;

@property(nonatomic,strong)NSArray *commentsArray;

//按到评论按钮出现的视图
@property(nonatomic,strong)UIView *commentView;
@property(nonatomic,strong)UITextField *TF;

@property(nonatomic,strong)UIView *statusView;

@end

@implementation AirticleViewController

#pragma mark - 生命周期 lifeCircle
- (void)viewDidLoad {
    [super viewDidLoad];
     [SVProgressHUD show];
    [self loadData];
    
    [self setMainT];
    
    [self setupTableHeaderView];
    
    
    
    [self loadComments];

    
    
    //NSLog(@"fullUrl:%@",self.funItem.full_url);
  
    //添加手势，当双击时，返回之前的界面
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapToBack)];
        doubleTap.numberOfTouchesRequired = 1;
        doubleTap.numberOfTapsRequired = 2;
        doubleTap.delegate = self;
    for (UIView*subView in self.view.subviews) {
       [ subView addGestureRecognizer:doubleTap];
        subView.userInteractionEnabled = YES;
    }
    
    [self setupCommentView];
    
    //对键盘进行监听
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeKeyboard:) name:UIKeyboardWillChangeFrameNotification object:nil];

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 方法 methods
-(void)loadData{
    if (self.item) {
        [WebUtils requestWithUrl:self.item.full_url andCompletion:^(id obj) {
            self.contentItem = obj;
            
            
            [self loadWebView:self.contentItem];
            [self.webView reload];
            
            [SVProgressHUD dismiss];
        }];
    }
    
    if (self.funItem) {
        [WebUtils requestWithUrl:self.funItem.full_url andCompletion:^(id obj) {
            self.contentItem = obj;
            
            
            [self loadWebView:self.contentItem];
            [self.webView reload];
            
            [SVProgressHUD dismiss];
        }];
    }
    
}

-(void)setUpStatusView{
    UIView *statusView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SQSW, 20)];
    statusView.backgroundColor = [UIColor colorWithHexString:self.item.block_color];
    //statusView.backgroundColor = [UIColor redColor];
    //NSLog(@"bcolor:%@",self.item.block_color);
    [self.view addSubview:statusView];
    self.statusView = statusView;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView.contentOffset.y >= 100) {
        if (self.statusView == nil && self.item) {
            [self setUpStatusView];
        }
        self.statusView.alpha = 1;
    }else{
        self.statusView.alpha = 0;
    }
    //NSLog(@"y:%f",scrollView.contentOffset.y);
}

//设置评论视图
-(void)setupCommentView{
    UIView *commentView = [[UIView alloc]initWithFrame:CGRectMake(0, SQSH, SQSW, 40)];
    commentView.backgroundColor = [UIColor whiteColor];
    UITextField *textF = [[UITextField alloc]initWithFrame:CGRectMake(10, 5, SQSW - 100, 30)];
    textF.placeholder = @"发布评论（少于100字）";
    [commentView addSubview:textF];
    UIButton *sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [sendButton setTitle:@"发送" forState:UIControlStateNormal];
    [sendButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    sendButton.frame = CGRectMake(SQSW - 55, 5, 50, 30);
    [sendButton addTarget:self action:@selector(sendComment) forControlEvents:UIControlEventTouchUpInside];
    [commentView addSubview:sendButton];
    [self.view addSubview:commentView];
    self.TF = textF;
    self.commentView = commentView;
    self.commentView.userInteractionEnabled = YES;
}

#pragma mark - 键盘通知方法 methodsForKeyBoard

-(void)changeKeyboard:(NSNotification*)notification{
    NSDictionary *dic = notification.userInfo;
    CGRect keyBoardframe = [dic[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
   
    
    [UIView animateWithDuration:[dic[UIKeyboardAnimationDurationUserInfoKey] doubleValue] delay:0 options:[dic[UIKeyboardAnimationCurveUserInfoKey] longValue] animations:^{
        
         CGRect comframe = self.commentView.frame;
        comframe.origin.y = keyBoardframe.origin.y - 40;
        
        if (keyBoardframe.origin.y == SQSH) {
            comframe.origin.y = SQSH;
        }
        
        //NSLog(@"orin.y:%f",comframe.origin.y);
        self.commentView.frame = comframe;
        
//        self.commentView.constant = SQSH - keyBoardframe.origin.y ;
//        //self.bottom.constant = 250;
//        NSLog(@"ori.y:%f",keyBoardframe.origin.y);
//        NSLog(@"botton:%f",self.bottom.constant);
        //通过动画，修改约束
        [self.view layoutIfNeeded];
    } completion:nil];
}

//设置主要的显示界面
- (void)setupTableHeaderView
{
    
    
    if (self.item) {
        ArticleTopView *topView = [[ArticleTopView alloc]initWithFrame:CGRectMake(0, -120, SQSW, 120)];
        
        topView.item = self.item;
        
        UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, SQSW, 100)];
        webView.delegate = self;
        webView.scrollView.scrollEnabled = NO;
        webView.scrollView.showsVerticalScrollIndicator = NO;
        webView.scrollView.contentInset  = UIEdgeInsetsMake(120, 0, 0, 0);
        
        [webView.scrollView addSubview:topView];
        self.webView = webView;
        
        self.topView = topView;
    }
    
    if (self.funItem) {
        FunArticleTopView *topView = [[FunArticleTopView alloc]initWithFrame:CGRectMake(0, -150, SQSW, 150)];
        topView.item = self.funItem;
        
        UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, SQSW, 100)];
        webView.delegate = self;
        webView.scrollView.scrollEnabled = NO;
        webView.scrollView.showsVerticalScrollIndicator = NO;
        webView.scrollView.contentInset  = UIEdgeInsetsMake(150, 0, 0, 0);
        
        [webView.scrollView addSubview:topView];
        self.webView = webView;
        
        self.funTopView = topView;
    }
    
   // NSLog(@"medias:%@",self.contentItem.media);

}

-(void)tapToBack{
    if (self.funItem) {
        [self.navigationController setNavigationBarHidden:NO animated:YES];
    }
    [self.navigationController popViewControllerAnimated:YES];
}


- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

#pragma mark - UIWebView delegateMethods
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    
    //加载之后的webView高度
    CGFloat webViewHeight= [[webView stringByEvaluatingJavaScriptFromString: @"document.body.offsetHeight"]floatValue];
    
    //底部view
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, webViewHeight + 20, SQSW, 100)];
    
    [webView.scrollView addSubview:view];
    
    CGRect frame = webView.frame;
   // frame.size.height = webViewHeight + 120 + 20 + 100;
    frame.size.height = webViewHeight + 120 + 20 ;
    webView.frame = frame;
    
    self.mainTableView.tableHeaderView = webView;
    

    [self.mainTableView reloadData];
    
    
}

//设置网页的内容格式
- (void)loadWebView:(ArticleContentItem *)contentItem
{
    NSMutableString *html = [NSMutableString string];
    // 头部内容
    [html appendString:@"<html>"];
    [html appendString:@"<head>"];
    [html appendString:@"</head>"];
    
    // 具体内容
    [html appendString:@"<body>"];
    [html appendString:[self setupBody:contentItem]];
    [html appendString:@"</body>"];
    
    // 尾部内容
    [html appendString:@"</html>"];
    
    //NSLog(@"html:%@",html);
    // 显示网页
    [self.webView loadHTMLString:html baseURL:nil];
}

//初始化网页body内容
- (NSString *)setupBody:(ArticleContentItem *)contentItem
{
    NSMutableString *body = [NSMutableString stringWithFormat:@"%@",contentItem.content];
    self.imagePaths = [NSMutableArray array];
    [contentItem.media enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        NSMutableString *m_url = obj[@"m_url"];
        NSString *imgTargetString  = [NSString stringWithFormat:@"id=\"id_image_%zd\"", idx];
        NSString *imgReplaceString = [NSString stringWithFormat:@"id=\"id_image_%zd\"  src=\"%@\"", idx, m_url];
        
       // NSLog(@"string:%@",imgReplaceString);
        [self.imagePaths addObject:m_url];
        [body replaceOccurrencesOfString:imgTargetString withString:imgReplaceString options:NSCaseInsensitiveSearch range:NSMakeRange(0, body.length)];
    }];

    return body;
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *url = request.URL.absoluteString;
    NSRange range = [url rangeOfString:@"http://www.myzaker.com/?_zkcmd="];
    if (range.location != NSNotFound) {
        NSUInteger loc = range.location + range.length;
        NSString *src = [url substringFromIndex:loc];
        
        if ([src containsString:@"open_media"]) {
            NSRange indexRange = [src rangeOfString:@"&index="];
            NSInteger index = [[src substringFromIndex:(indexRange.location + indexRange.length)] integerValue];
            [self openMedia:index];
        }
        
        return NO;
    }
    return YES;
}

//点击图片进行浏览
- (void)openMedia:(NSInteger )index{
    MWPhotoBrowser *photoBrowser = [[MWPhotoBrowser alloc]initWithDelegate:self];
    //设置当前要显示的图片
    [photoBrowser setCurrentPhotoIndex:index];
    [self.navigationController pushViewController:photoBrowser animated:YES];
}

#pragma mark - MWPhotoBrowser delegateMethods
//返回图片个数
-(NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser{
    return self.imagePaths.count;
}

//返回图片模型
- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index{
    NSMutableArray *photoArray = [NSMutableArray array];
    for (NSString *url in self.imagePaths) {
        MWPhoto *photo = [MWPhoto photoWithURL:[NSURL URLWithString:url]];
        [photoArray addObject:photo];
    }
    MWPhoto *photo = photoArray[index];
    return photo;
}

//返回之前的界面
- (IBAction)goBackToLastVC:(UIButton *)sender {
    if (self.funItem) {
        [self.navigationController setNavigationBarHidden:NO animated:NO];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

//点击按钮评论
- (IBAction)clickToComment:(id)sender {
    [self.TF becomeFirstResponder];
}

//点击跳到底部的评论列表
- (IBAction)showComments:(UIButton *)sender {
    NSIndexPath *scrollIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [[self mainTableView] scrollToRowAtIndexPath:scrollIndexPath
                            atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

-(void)sendComment{
    [self.view endEditing:YES];
    //如果没有登录，那么设置成不能进行评论
    if ([BmobUser currentUser] == nil) {
        UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"您还没有登录" message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"登录" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            SignInViewController *vc = [SignInViewController new];
            [self.navigationController pushViewController:vc animated:YES];
            [self.navigationController setNavigationBarHidden:NO animated:NO];
        }];
        UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            nil;
        }];
        [ac addAction:action1];
        [ac addAction:action2];
        [self presentViewController:ac animated:YES completion:nil];
    }else{
        BmobObject *bOBj = [BmobObject objectWithClassName:@"Comment"];
        [bOBj setObject:self.TF.text forKey:@"text"];
        
        //添加用户字段 用来区分到底是谁发的
        [bOBj setObject:[BmobUser currentUser] forKey:@"user"];
        
        if (self.item) {
            //设置此条评论 评论的是哪一个消息
            [bOBj setObject:self.item.title forKey:@"articleTitle"];
        }
        
        if (self.funItem) {
            //设置此条评论 评论的是哪一个消息
            [bOBj setObject:self.funItem.title forKey:@"articleTitle"];
        }
        
        [bOBj saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
            if (isSuccessful) {
                NSLog(@"保存成功！");
                [self loadComments];
                [self.TF resignFirstResponder];
            }else{
                NSLog(@"%@",error);
            }
        }];
    }
}

-(void)loadComments{
    
    BmobQuery *query = [BmobQuery queryWithClassName:@"Comment"];
    [query includeKey:@"user"];
    [query orderByDescending:@"updatedAt"];
    if (self.item) {
        [query whereKey:@"articleTitle" equalTo:self.item.title];
    }
    if (self.funItem) {
        [query whereKey:@"articleTitle" equalTo:self.funItem.title];
    }
    [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        //NSLog(@"成绩");
        
        self.commentsArray = [CommentItem arrayWithBmobObjectArray:array];
       // NSLog(@"array:%@",self.commentsArray);
        [self.mainTableView reloadData];
    }];
}

#pragma mark - UITableViewDataSource delegateMethods
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.commentsArray.count == 0) {
        return 1;
    }else{
          return self.commentsArray.count;
    }
  
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    commentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    if (self.commentsArray.count == 0) {
        cell.contentView.alpha = 0;
    }else{
        cell.contentView.alpha = 1;
        cell.item = self.commentsArray[indexPath.row];
    }
    return cell;
}

#pragma mark - UITableView delegateMethods
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.commentsArray.count == 0) {
        return 50;
    }
    CommentItem *item = self.commentsArray[indexPath.row];
    return item.commentHeight;
}


-(void)setMainT{
    UITableView *mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SQSW, self.view.frame.size.height - self.bottomView.frame.size.height) style:UITableViewStylePlain];
    mainTableView.delegate = self;
    mainTableView.dataSource = self;
    mainTableView.tableFooterView = [UIView new];
    // [mainTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [mainTableView registerNib:[UINib nibWithNibName:@"commentCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:mainTableView];
    self.mainTableView = mainTableView;
}

@end
