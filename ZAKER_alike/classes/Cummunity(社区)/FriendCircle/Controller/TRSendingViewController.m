//
//  TRSendingViewController.m
//  ITSNS
//
//  Created by tarena on 16/8/24.
//  Copyright © 2016年 Ivan. All rights reserved.
//
#import "TRSelectLocationViewController.h"
#import "RecordButton.h"
#import "Utils.h"
#import "TRSendingViewController.h"
#import "YYTextView.h"
@interface TRSendingViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,YYTextViewDelegate>




@property (weak, nonatomic) IBOutlet UIButton *locationbtn;

@property (nonatomic, strong) IBOutlet UIView *buttonView;

@property (nonatomic, strong)YYTextView *titleTV;
@property (nonatomic, strong)YYTextView *detailTV;
//用来记录当前正在响应的textView
@property (nonatomic, strong)YYTextView *currentTV;

@property (nonatomic, strong)NSArray *faceArr;



@property (weak, nonatomic) IBOutlet UILabel *locationLabel;

@property (nonatomic, strong)UIScrollView *faceSV;


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
@end

@implementation TRSendingViewController
- (IBAction)locationAction:(id)sender {
    
    TRSelectLocationViewController *vc = [TRSelectLocationViewController new];
    
    [self.navigationController pushViewController:vc animated:YES];
    
    
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
    
    [self.currentTV insertText:text];
    
    
    
}


//    标题
-(YYTextView *)titleTV{
    if (!_titleTV) {
        YYTextView *titleTV=[[YYTextView alloc]initWithFrame:CGRectMake(LYMargin, 64, LYSW-2*LYMargin, 30)];
        titleTV.placeholderText=@"标题  (可选)";
       
        titleTV.delegate = self;
         [Utils faceMappingWithText:titleTV];
        titleTV.font=[UIFont systemFontOfSize:14];
        [self.view addSubview:titleTV];
        _titleTV = titleTV;
        
        //设置附属view
        [self.buttonView removeFromSuperview];
        titleTV.inputAccessoryView = self.buttonView;
    }
    return _titleTV;
}

-(YYTextView *)detailTV{
    if (!_detailTV) {
        YYTextView *detailTV=[[YYTextView alloc]initWithFrame:CGRectMake(LYMargin, 115, LYSW-2*LYMargin, 150)];
        detailTV.delegate = self;
        [self.view addSubview:detailTV];
        _detailTV=detailTV;
        [Utils faceMappingWithText:detailTV];
       detailTV.inputAccessoryView = self.buttonView;
    }
    return _detailTV;
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


-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.titleTV becomeFirstResponder];

    
    //显示选择的位置
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    
    self.locationLabel.text = [NSString stringWithFormat:@"%f,%f",[ud floatForKey:@"lon"],[ud floatForKey:@"lat"]];
}



- (IBAction)clicked:(UIButton *)sender {
    
    
    
    switch (sender.tag) {
        case 0://图片
            
            
            self.currentTV.inputView = [self.currentTV.inputView isEqual:self.selectedImageSV]?nil:self.selectedImageSV;
            
            [self.currentTV reloadInputViews];
            
            //如果一张都没选择过 则直接跳转到选择图片页面
            if (self.selectedImageViews.count==0) {
                
                UIImagePickerController *pick=[UIImagePickerController new];
                pick.delegate=self;
                [self presentViewController:pick animated:YES completion:nil];
                
                
            }
            
            
            break;
        case 1://表情
            
            self.currentTV.inputView = [self.currentTV.inputView isEqual:self.faceSV]?nil:self.faceSV;
            [self.currentTV reloadInputViews];
            
            
            break;
            
        case 2://录音
            self.currentTV.inputView = [self.currentTV.inputView isEqual:self.voiceView]?nil:self.voiceView;
            
            [self.currentTV reloadInputViews];
            
        default:
            break;
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
   
    self.selectedImageViews = [NSMutableArray array];
    [self initUI];
    
    self.detailTV.placeholderText = @"详情...";
}

-(void)initUI{
    //分割线
    UIView *line=[[UIView alloc]initWithFrame:CGRectMake(0, 97, 375, 1)];
    line.backgroundColor = LYGrayColor;
    [self.view addSubview:line];
    
    
    
    self.locationbtn.layer.cornerRadius = self.locationbtn.bounds.size.height/2;
    self.locationbtn.layer.masksToBounds = YES;
    
    switch (self.type.intValue) {
        case 0:
            self.title = @"新建消息";
            break;
            
        case 1:
            self.title = @"新建问题";
            break;
        case 2:
            self.title = @"新建项目";
            break;
    }
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(backAction)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"发布" style:UIBarButtonItemStyleDone target:self action:@selector(sendAction)];
    
    self.navigationController.navigationBar.tintColor = LYGreenColor;
    
  
   
}

-(void)backAction{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)sendAction{
    
    [self.view endEditing:YES];
    
    BmobObject *bOBj = [BmobObject objectWithClassName:@"ITObject"];
    [bOBj setObject:self.titleTV.text forKey:@"title"];
    [bOBj setObject:self.detailTV.text forKey:@"detail"];
    //取值 0 1 2  0朋友圈消息 1问题 2项目
    [bOBj setObject:self.type forKey:@"type"];
    //添加用户字段 用来区分到底是谁发的
    [bOBj setObject:[BmobUser currentUser] forKey:@"user"];
    
    //判断是否有位置
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    float lon = [ud floatForKey:@"lon"];
    float lat = [ud floatForKey:@"lat"];
    if (lon!=0&&lat!=0) {//有位置
        BmobGeoPoint *point = [[BmobGeoPoint alloc]initWithLongitude:lon WithLatitude:lat];
        [bOBj setObject:point forKey:@"location"];
    }
    
    
    
    
    [bOBj saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
        if (isSuccessful) {
            NSLog(@"保存成功！");
            //增加积分
            [Utils addScore:self.type.intValue+1];
            
            
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
                            
                            [self dismissViewControllerAnimated:YES completion:nil];
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
                            }
                             [self dismissViewControllerAnimated:YES completion:nil];
                            
                        }];
                        
                        
                       
                    }
                    
                    
                } withProgressBlock:^(CGFloat progress) {
//                    voiceHUD.progress = progress;
                }];
                
            }
            //没有音频和图片
            if (!self.voiceData && self.selectedImageViews.count==0) {
                [self dismissViewControllerAnimated:YES completion:nil];
            }
            

            
            
            
        }else{
            NSLog(@"保存失败：%@",error);
        }
    }];

    
    
    
    
    
    
  
    
}
#pragma mark YYTextViewDelegate
- (void)textViewDidBeginEditing:(YYTextView *)textView{
    //开始编辑的时候记录当前正在响应的textView 不然点击表情按钮的时候不知道往哪个textView里面添加图片
    self.currentTV = textView;
}

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
