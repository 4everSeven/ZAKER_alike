//
//  TRDetailViewController.m
//  ITSNS
//
//  Created by tarena on 16/8/29.
//  Copyright © 2016年 Ivan. All rights reserved.
//
#import "TRCommentCell.h"
#import "TRComment.h"
#import "TRDetailViewController.h"
#import "TRITObjectView.h"
#import "Utils.h"
#import "RecordButton.h"
@interface TRDetailViewController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;


@property (weak, nonatomic) IBOutlet UIView *commentBar;
@property (weak, nonatomic) IBOutlet YYTextView *commentTV;

@property (nonatomic, strong)UIScrollView *faceSV;
@property (nonatomic, strong)NSArray *faceArr;

//********多选图片相关
@property (nonatomic, strong)UIScrollView *selectedImageSV;
@property (weak, nonatomic) IBOutlet UILabel *imageCountLabel;


@property (nonatomic, strong)UIScrollView *pickerSV;
@property (nonatomic, strong)UIButton *addImageButton;
@property (nonatomic, strong)NSMutableArray *selectedImageViews;
//录音相关
@property (nonatomic, strong)UIView *voiceView;

@property (nonatomic, strong)UILabel *timeLabel;

@property (nonatomic, strong)NSData *voiceData;

@property (nonatomic, strong)NSArray *comments;
@end

@implementation TRDetailViewController
- (IBAction)sendAction:(id)sender {
    
    
    [self.view endEditing:YES];
    
    BmobObject *bOBj = [BmobObject objectWithClassName:@"Comment"];
    [bOBj setObject:self.commentTV.text forKey:@"text"];
 
    
    //添加用户字段 用来区分到底是谁发的
    [bOBj setObject:[BmobUser currentUser] forKey:@"user"];
    //设置此条评论 评论的是哪一个消息
    [bOBj setObject:self.itObj.bObj forKey:@"source"];
    
   
    

    
    
    [bOBj saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
        if (isSuccessful) {
            
            [self.itObj addCommentCount];
            
            //评论 每次增加1分
            [Utils addScore:1];
            NSLog(@"保存成功！");
              [self loadComments];
            
            //判断如果有图片
            if (self.selectedImageViews.count>0) {
                NSMutableArray *imageDatas = [NSMutableArray array];
                
                for (UIImageView *iv in self.selectedImageViews) {
                    
                    NSData *imageData = UIImageJPEGRepresentation(iv.image, .5);
                    [imageDatas addObject:@{@"filename":@"a.jpg",@"data":imageData}];
                    
                }
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
                
                [hud setMode:MBProgressHUDModeDeterminateHorizontalBar];
                hud.label.text = @"开始上传。。。";
                
                [BmobFile filesUploadBatchWithDataArray:imageDatas progressBlock:^(int index, float progress) {
                    hud.progress = progress;
                    hud.label.text = [NSString stringWithFormat:@"%d - %ld",index+1,self.selectedImageViews.count];
                    
                    
                } resultBlock:^(NSArray *array, BOOL isSuccessful, NSError *error) {
                   
                    NSLog(@"上传完成");
                    [hud hideAnimated:YES];
                    //准备数组装图片的地址
                    NSMutableArray *imagePaths = [NSMutableArray array];
                    
                    for (BmobFile *file in array) {
                        [imagePaths addObject:file.url];
                    }
                    
                    [bOBj setObject:imagePaths forKey:@"imagePaths"];
                    
                    
                    [bOBj updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                        if (isSuccessful) {
                            NSLog(@"保存成功！");
                            
                            [self loadComments];
                        }else{
                            NSLog(@"保存失败：%@",error);
                        }
                    }];
                    
                    
                    
                    
                }];
                
                
            }
            //如果有音频
            if(self.voiceData){
                
                //                MBProgressHUD *voiceHUD = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
                //                voiceHUD.mode = MBProgressHUDModeDeterminateHorizontalBar;
                
                BmobFile *voiceFile = [[BmobFile alloc]initWithFileName:@"a.amr" withFileData:self.voiceData];
                
                [voiceFile saveInBackground:^(BOOL isSuccessful, NSError *error) {
                    //                    [voiceHUD hideAnimated:YES];
                    
                    if (isSuccessful) {
                        //                        NSLog(@"音频上传成功！");
                        
                        
                        //把音频文件的路径和发布消息建立关系
                        
                        [bOBj setObject:voiceFile.url forKey:@"voicePath"];
                        
                        [bOBj updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                            if (isSuccessful) {
                                NSLog(@"上传音频成功");
                                [self loadComments];
                            }
                       
                            
                        }];

                    }
                    
                    
                } withProgressBlock:^(CGFloat progress) {
                    //                    voiceHUD.progress = progress;
                }];
                
            }
    
            
            
            
            
        }else{
            NSLog(@"保存失败：%@",error);
        }
    }];
    
    
    
    

}


-(UIView *)voiceView{
    
    if (!_voiceView) {
        _voiceView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 216)];
        
        RecordButton *btn = [[RecordButton alloc]initWithFrame:CGRectMake(0, 0, 150, 150)];
        btn.center = CGPointMake(LYSW/2, 216/2);
        
        [_voiceView addSubview:btn];
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(recordFinishAction:) name:@"RecordDidFinishNotification" object:nil];
        self.timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(btn.frame), LYSW, 15)];
        self.timeLabel.textColor = LYGreenColor;
        [_voiceView addSubview:self.timeLabel];
        self.timeLabel.textAlignment = NSTextAlignmentCenter;
    }
    
    return _voiceView;
}

- (void)recordFinishAction:(NSNotification *)notfi {
    float time = [notfi.object[@"time"]floatValue];
    self.timeLabel.text = [NSString stringWithFormat:@"%.2f秒",time];
    
    self.voiceData = notfi.object[@"data"];
    
}


-(UIScrollView *)faceSV{
    
    if (!_faceSV) {
        _faceSV = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 216)];
        //绑定表情
        [Utils faceMappingWithText:self.commentTV];
        //添加表情按钮
        NSString *path = [[NSBundle mainBundle]pathForResource:@"default" ofType:@"plist"];
        NSArray *faceArr = [NSArray arrayWithContentsOfFile:path];
        self.faceArr = faceArr;
        NSInteger page = faceArr.count%32==0?faceArr.count/32 : faceArr.count/32+1;
        
        [_faceSV setContentSize:CGSizeMake(page*self.view.bounds.size.width, 0)];
        //整页显示
        _faceSV.pagingEnabled = YES;
        
        float size = self.view.bounds.size.width/8;
        //        35   32    3
        for (int i=0; i<page; i++) {
            
            NSInteger count = 32;
            //如果是最后一页
            if (i==page-1) {
                count = faceArr.count%32;
            }
            for (int j=0; j<count; j++) {
                
                UIButton *faceBtn = [[UIButton alloc]initWithFrame:CGRectMake(j%8*size+i*self.view.bounds.size.width, j/8*size, size, size)];
                
                [_faceSV addSubview:faceBtn];
                
                //显示图片
                NSDictionary *faceDic = faceArr[j+32*i];
                NSString *imageName = faceDic[@"png"];
                [faceBtn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
                //让按钮记住自己是第几个
                faceBtn.tag = j+32*i;
                
                [faceBtn addTarget:self action:@selector(faceBtnAction:) forControlEvents:UIControlEventTouchUpInside];
            }
            
            
            
            
        }
        
        
        
        
    }
    return _faceSV;
}
-(void)faceBtnAction:(UIButton *)faceBtn{
    
    NSDictionary *faceDic = self.faceArr[faceBtn.tag];
    NSString *text = faceDic[@"chs"];
    
    [self.commentTV insertText:text];
    
    
    
}
-(UIScrollView *)selectedImageSV{
    if (!_selectedImageSV) {
        _selectedImageSV=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, LYSW, 216)];
        self.addImageButton=[[UIButton alloc]initWithFrame:CGRectMake(20, 30, 100, 140)];
        [self.addImageButton setImage:[UIImage imageNamed:@"1.png"] forState:UIControlStateNormal];
        [self.selectedImageSV addSubview:self.addImageButton];
        
        [self.addImageButton addTarget:self action:@selector(addImageAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _selectedImageSV;
}

-(void)addImageAction
{
    if (self.selectedImageViews.count<9) {
        UIImagePickerController *pick=[UIImagePickerController new];
        pick.delegate=self;
        [self presentViewController:pick animated:YES completion:nil];
    }
}

- (IBAction)clicked:(UIButton *)sender {
    
    switch (sender.tag) {
        case 0://图片
            self.commentTV.inputView = [self.commentTV.inputView isEqual:self.selectedImageSV]?nil : self.selectedImageSV;
            
            break;
        case 1://表情
            self.commentTV.inputView = [self.commentTV.inputView isEqual:self.faceSV]?nil : self.faceSV;
            
            
            break;
        case 2://录音
             self.commentTV.inputView = [self.commentTV.inputView isEqual:self.voiceView]?nil : self.voiceView;
            break;
    
    }
    [self.commentTV reloadInputViews];
}
- (IBAction)commentBtnAction:(id)sender {
    
    [self.commentTV becomeFirstResponder];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (self.selectedImageViews.count>0) {
        [self.commentTV becomeFirstResponder];
    }
    
    [self loadComments];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.selectedImageViews = [NSMutableArray array];
    self.title = @"详情";
    TRITObjectView *objView = [[TRITObjectView alloc]initWithFrame:CGRectMake(0, 0, LYSW, self.itObj.contentHeight)];
    //把数据传递进去 并显示
    objView.itObj = self.itObj;
    
    self.tableView.tableHeaderView = objView;
    
//    判断是否有录音
    if (self.itObj.voicePath) {
        
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemPlay target:self action:@selector(playAction)];
        
        
        
    }
    
    
    //监听软键盘
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardChangeAction:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    //注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"TRCommentCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"cell"];
    
    
    
}

-(void)loadComments{
    
    BmobQuery *query = [BmobQuery queryWithClassName:@"Comment"];
    [query includeKey:@"user"];
    [query orderByDescending:@"updatedAt"];
    [query whereKey:@"source" equalTo:self.itObj.bObj];
    [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        
        self.comments = [TRComment arrayWithBmobObjectArray:array];
        
        [self.tableView reloadData];
    }];
}
-(void)keyboardChangeAction:(NSNotification *)noti{
    
    NSLog(@"%@",noti.userInfo);
    CGRect keyboardF = [noti.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    //判断收软键盘
    if (keyboardF.origin.y==LYSH) {
        //还原
        self.commentBar.transform = CGAffineTransformIdentity;
    }else{//软键盘弹出
    
        self.commentBar.transform = CGAffineTransformMakeTranslation(0, -keyboardF.size.height-self.commentBar.height);
    }
    
    
    
    
    
}
-(void)playAction{
    
    
    [Utils playVoiceWithPath:self.itObj.voicePath];
    
    
    
}
#pragma mark UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.comments.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TRCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
 
    cell.comment = self.comments[indexPath.row];
   
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TRComment *comment = self.comments[indexPath.row];
 
    return 52 + [comment contentHeight];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
    
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
    
    [self.commentTV resignFirstResponder];
}
//
//表名称： Comment
//
//字段：
//text
//imagePaths
//voicePath
//source （被评论的ITObject对象）
//user (谁发送的)
#pragma mark 多选图片相关
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    
    
    UIImageView *iv=[[UIImageView alloc]initWithFrame:CGRectMake(self.selectedImageViews.count*80, 0, 80, 80)];
    
    iv.image=info[UIImagePickerControllerOriginalImage];
    
    [self.pickerSV addSubview:iv];
    
    
    iv.userInteractionEnabled=YES;
    [self.selectedImageViews addObject:iv];
    
    self.pickerSV.contentSize=CGSizeMake(self.selectedImageViews.count*80, 0);
    
    UIButton *delBtn =[[UIButton alloc]initWithFrame:CGRectMake(60, 0, 20, 20)];
    [delBtn addTarget:self action:@selector(deleteAction:) forControlEvents:UIControlEventTouchUpInside];
    [delBtn setTitle:@"X" forState:UIControlStateNormal];
    [delBtn setTitleColor:LYGreenColor forState:UIControlStateNormal];
    [iv addSubview:delBtn];
    
    //图片选择到9张得时候直接完成 返回
    if(self.selectedImageViews.count==9)
    {
        [self doneAction];
        
    }
    
    
    
    
    
}
-(void)deleteAction:(UIButton *)btn
{
    [self.selectedImageViews removeObject:btn.superview];
    [btn.superview removeFromSuperview];
    for(int i=0;i<self.selectedImageViews.count;i++)
    {
        UIImageView *iv=self.selectedImageViews[i];
        [UIView animateWithDuration:0.5 animations:^{
            iv.frame=CGRectMake(i*80, 0, 80, 80);
        }];
    }
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    
    
    //找到第二个页面 添加选择控件
    if(navigationController.viewControllers.count==2)
    {
        
        //得到页面中sv 把高度 -100
        UIView *cv = [viewController.view.subviews firstObject];
        CGRect frame = cv.frame;
        frame.size.height -= 100;
        cv.frame = frame;
        
        
        
        UIView *v=[[UIView alloc]initWithFrame:CGRectMake(0, 567, 375, 100)];
        v.backgroundColor = [UIColor whiteColor];
        [viewController.view addSubview:v];
        self.pickerSV=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 20, 375, 80)];
        self.pickerSV.backgroundColor=LYGrayColor;
        [v addSubview:self.pickerSV];
        UIButton *doneBtn=[[UIButton alloc]initWithFrame:CGRectMake(335, 0, 40, 20)];
        [doneBtn setTitle:@"完成" forState:UIControlStateNormal];
        doneBtn.backgroundColor=[UIColor grayColor];
        [v addSubview:doneBtn];
        [doneBtn addTarget:self action:@selector(doneAction) forControlEvents:UIControlEventTouchUpInside];
        
        //把之前选择的图片添加进去
        for(int i=0;i<self.selectedImageViews.count;i++)
        {
            UIImageView *iv=self.selectedImageViews[i];
            
            iv.frame=CGRectMake(i*80, 0, 80, 80);
            UIButton *delBtn = [[UIButton alloc]initWithFrame:CGRectMake(60, 0, 20, 20)];
            [delBtn addTarget:self action:@selector(deleteAction:) forControlEvents:UIControlEventTouchUpInside];
            [delBtn setTitle:@"X" forState:UIControlStateNormal];
            [delBtn setTitleColor:LYGreenColor forState:UIControlStateNormal];
            
            [iv addSubview:delBtn];
            [self.pickerSV addSubview:iv];
        }
    }
}
-(void)doneAction
{
    
    
    //遍历选择到的图片 把选择到的图片 添加到发送页面的SV里面
    for (int i=0; i<self.selectedImageViews.count; i++) {
        UIImageView *iv=self.selectedImageViews[i];
        iv.frame = CGRectMake(20+120*i, 30, 100, 140);
        //把图片里面的删除按钮 删掉
        UIButton *delBtn = [iv.subviews firstObject];
        [delBtn removeFromSuperview];
        
        [self.selectedImageSV addSubview:iv];
    }
    
    self.selectedImageSV.contentSize=CGSizeMake((self.selectedImageViews.count+1)*120, 0);
    
    self.addImageButton.center = CGPointMake(20+self.selectedImageViews.count*120+self.addImageButton.bounds.size.width/2, self.addImageButton.center.y);
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    [self updateImageCountLabel];
}

-(void)updateImageCountLabel{
    
    self.imageCountLabel.hidden = self.selectedImageViews.count==0?YES:NO;
    
    self.imageCountLabel.text = @(self.selectedImageViews.count).stringValue;
    
}


@end
