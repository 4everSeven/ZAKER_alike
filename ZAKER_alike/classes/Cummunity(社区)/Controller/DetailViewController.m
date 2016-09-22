//
//  DetailViewController.m
//  ZAKER_alike
//
//  Created by 王思齐 on 16/9/20.
//  Copyright © 2016年 wangsiqi. All rights reserved.
//

#import "DetailViewController.h"
#import "commentCell.h"
#import <SVProgressHUD.h>
#import "DetailTableHeaderView.h"
@interface DetailViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)DetailTableHeaderView *tableHeaderView;
@property(nonatomic,strong)NSArray *imagePaths;
@property(nonatomic,strong)UITableView *mainTableView;
@property(nonatomic,strong)NSArray *commentsArray;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomHeight;

//按到评论按钮出现的视图
@property(nonatomic,strong)UIView *commentView;
@property(nonatomic,strong)UITextField *TF;
@property (weak, nonatomic) IBOutlet UIView *bottomView;

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [SVProgressHUD show];
    [self setTableView];
    [self loadComments];
    self.tableHeaderView = [[DetailTableHeaderView alloc]initWithFrame:CGRectMake(0, 0, SQSW, self.item.detailHeight)];
    
    self.tableHeaderView.item = self.item;
    self.mainTableView.tableHeaderView = self.tableHeaderView;
    //去除多余的cell
    self.mainTableView.tableFooterView = [UIView new];
   // [self.view addSubview:self.bottomView];
    [self.view bringSubviewToFront:self.bottomView];
    [self setupCommentView];
    
    if (self.commentsArray == nil) {
        self.mainTableView.separatorStyle = NO;
    }
    //对键盘进行监听
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeKeyboard:) name:UIKeyboardWillChangeFrameNotification object:nil];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 键盘通知方法 methodsForKeyBoard

-(void)changeKeyboard:(NSNotification*)notification{
    NSDictionary *dic = notification.userInfo;
    CGRect keyBoardframe = [dic[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    
    
    [UIView animateWithDuration:[dic[UIKeyboardAnimationDurationUserInfoKey] doubleValue] delay:0 options:[dic[UIKeyboardAnimationCurveUserInfoKey] longValue] animations:^{
        
        CGRect comframe = self.commentView.frame;
        comframe.origin.y = keyBoardframe.origin.y - 104;
        
        if (keyBoardframe.origin.y == SQSH) {
            comframe.origin.y = SQSH;
        }
        
        NSLog(@"orin.y:%f",comframe.origin.y);
        self.commentView.frame = comframe;
        

        //通过动画，修改约束
        [self.view layoutIfNeeded];
    } completion:nil];
}

#pragma mark - 方法 methods
-(void)setTableView{
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SQSW, SQSH ) style:UITableViewStylePlain];
    tableView.contentInset = UIEdgeInsetsMake(0, 0, 108, 0);
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    [tableView registerNib:[UINib nibWithNibName:@"commentCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    self.mainTableView = tableView;
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
    //self.commentView.backgroundColor = [UIColor redColor];
    self.commentView.userInteractionEnabled = YES;
}

- (IBAction)clickToComment:(id)sender {
    [self.TF becomeFirstResponder];
    //NSLog(@"ssss");
    if ([self.TF isFirstResponder]) {
        //NSLog(@"ssss");

    }
}

-(void)sendComment{
    [self.view endEditing:YES];
        BmobObject *bOBj = [BmobObject objectWithClassName:@"Comment"];
        [bOBj setObject:self.TF.text forKey:@"text"];
        
        //添加用户字段 用来区分到底是谁发的
        [bOBj setObject:[BmobUser currentUser] forKey:@"user"];
    
        //设置此条评论 评论的是哪一个消息
        [bOBj setObject:self.item.bObj forKey:@"tobObj"];
    
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

-(void)loadComments{
    BmobQuery *query = [BmobQuery queryWithClassName:@"Comment"];
    [query includeKey:@"user"];
    [query orderByDescending:@"updatedAt"];
    [query whereKey:@"tobObj" equalTo:self.item.bObj];
    [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        self.commentsArray = [CommentItem arrayWithBmobObjectArray:array];
        // NSLog(@"array:%@",self.commentsArray);
        [self.mainTableView reloadData];
        [SVProgressHUD dismiss];
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

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView.contentOffset.y < 0) {
        [self.TF resignFirstResponder];
    }
}


@end
