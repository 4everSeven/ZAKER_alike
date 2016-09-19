//
//  SendingViewController.m
//  ZAKER_alike
//
//  Created by 王思齐 on 16/9/17.
//  Copyright © 2016年 wangsiqi. All rights reserved.
//

#import "SendingViewController.h"
#import <SVProgressHUD.h>
@interface SendingViewController ()<UITextViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottom;


//用来装多选图片
@property (nonatomic, strong)UIScrollView *sv;
@property(nonatomic)int count;
@property(nonatomic)NSMutableArray *images;
//用来记录删除的图片在数组中是第几个
@property(nonatomic)int tag;
@property(nonatomic)UIScrollView *svForMain;
@property(nonatomic)UIButton *addbutton;

@end

@implementation SendingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.textView.text = @"说点什么...";
    self.textView.delegate = self;
    self.images = [NSMutableArray array];
     [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeKeyboard:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    self.title = @"新建消息";
    UIBarButtonItem *rightBT = [[UIBarButtonItem alloc]initWithTitle:@"发送" style:UIBarButtonItemStylePlain target:self action:@selector(sendMessage)];
    self.navigationItem.rightBarButtonItem = rightBT;
    
    UIBarButtonItem *leftBt = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"arrowLeft-gray-32"] style:UIBarButtonItemStylePlain target:self action:@selector(goBackToLast)];
    self.navigationItem.leftBarButtonItem = leftBt;
}

//取消对键盘通知的监听
-(void)viewWillDisappear:(BOOL)animated{
    for (UIView *view in self.view.subviews) {
        [view resignFirstResponder];
    }
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

#pragma mark - 键盘通知方法 methodsForKeyBoard

-(void)changeKeyboard:(NSNotification*)notification{
    NSDictionary *dic = notification.userInfo;
    CGRect keyBoardframe = [dic[UIKeyboardFrameEndUserInfoKey] CGRectValue];
  
    [UIView animateWithDuration:[dic[UIKeyboardAnimationDurationUserInfoKey] doubleValue] delay:0 options:[dic[UIKeyboardAnimationCurveUserInfoKey] longValue] animations:^{
       
        self.bottom.constant = SQSH - keyBoardframe.origin.y ;
        //self.bottom.constant = 250;
        //NSLog(@"ori.y:%f",keyBoardframe.origin.y);
         // NSLog(@"botton:%f",self.bottom.constant);
        //通过动画，修改约束
        [self.view layoutIfNeeded];
    } completion:nil];
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    if ([textView.text isEqualToString:@"说点什么..."]) {
        textView.text = @"";
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    if (textView.text.length<1) {
        textView.text = @"说点什么";
    }
}

-(void)goBackToLast{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//点击图片按钮
- (IBAction)clickToPic:(id)sender {
    UIImagePickerController *vc = [UIImagePickerController new];
    vc.delegate = self;
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    UIView *v = [[UIView alloc]initWithFrame:CGRectMake(self.count * (80 + 20), 0, 80, 80)];
    UIImageView *iv = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 80, 80)];
    [v addSubview:iv];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(60, 0, 20, 20);
    //[button setBackgroundColor:[UIColor blackColor]];
    [button setImage:[UIImage imageNamed:@"delete (1)"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(deleteImage:) forControlEvents:UIControlEventTouchUpInside];
    self.count++;
    iv.image = image;
    [self.images addObject:v];
    [v addSubview:button];
    [self.sv addSubview:v];
    //[self.sv addSubview:button];
    self.sv.contentSize = CGSizeMake(v.frame.origin.x + v.frame.size.width, 80);
    //如果选择的图片到了九张，直接跳转回原来的界面
    if (self.images.count == 8) {
        [self goBackToVC];
    }
    
}

-(void)deleteImage:(UIButton *)sender{
    //NSLog(@"Images:%ld",self.images.count);
    [sender.superview removeFromSuperview];
    for(int i = 0;i<self.images.count;i++){
        UIView *v = self.images[i];
        if (v == sender.superview) {
            self.tag = i;
        }
    }
    //用来装被删除的图片后面的图片的视图数组
    NSMutableArray *deletedImages = [NSMutableArray array];
    for (int i = self.tag + 1; i<self.images.count; i++) {
        UIView *v = self.images[i];
        [deletedImages addObject:v];
    }
    for (UIView *v in deletedImages) {
        [UIView animateWithDuration:1 animations:^{
            v.frame = CGRectMake(v.frame.origin.x - 80 - 20, v.frame.origin.y, v.frame.size.width, v.frame.size.height);
            //            if (self.svForMain) {
            //                v.frame = CGRectMake(v.frame.origin.x - 100, v.frame.origin.y, v.frame.size.width, v.frame.size.height);
            //            }
        }];
    }
    [UIView animateWithDuration:1 animations:^{
        self.addbutton.frame = CGRectMake(self.addbutton.frame.origin.x - 80 - 20, self.addbutton.frame.origin.y, self.addbutton.frame.size.width, self.addbutton.frame.size.height);
    }];
    [self.images removeObject:sender.superview];
    UIView *v = [self.images lastObject];
    NSLog(@"self.images:%ld",self.images.count);
    self.sv.contentSize = CGSizeMake(v.frame.origin.x + v.frame.size.width, 80);
    self.svForMain.contentSize = CGSizeMake(self.addbutton.frame.origin.x + self.addbutton.frame.size.width, 216);
    self.count--;
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    
    //判断出第二个页面时才添加
    if (navigationController.viewControllers.count == 2) {
        UIView *v = [[UIView alloc]initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height-100, [UIScreen mainScreen].bounds.size.width, 100)];
        v.backgroundColor = [UIColor whiteColor];
        //添加完成按钮
        UIButton *saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
        saveButton.frame = CGRectMake([UIScreen mainScreen].bounds.size.width -40, 0, 38, 18);
        [saveButton setTitle:@"完成" forState:UIControlStateNormal];
        [saveButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [v addSubview:saveButton];
        [saveButton addTarget:self action:@selector(goBackToVC) forControlEvents:UIControlEventTouchUpInside];
        [viewController.view addSubview:v];
        UIScrollView *sv = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 20, 375, 80)];
        //sv.backgroundColor = [UIColor greenColor];
        [v addSubview:sv];
        self.sv = sv;
        //设置滚动时有无弹簧效果
        self.sv.bounces = NO;
        //设置有无横向滚动条
        self.sv.showsHorizontalScrollIndicator = NO;
        
        //让选择图片页面显示图片的控件高度-100；
        NSLog(@"%@",viewController.view.subviews);
        UIView *view = [viewController.view.subviews firstObject];
        CGRect frame = view.frame;
        frame.size.height -=100;
        view.frame = frame;
        
        
    }
    if (navigationController.viewControllers.count == 1){
        self.count = 0;
    }
}

-(void)goBackToVC{
    [self dismissViewControllerAnimated:YES completion:nil];
    //self.textView.inputView = self.svForMain;
    NSLog(@"images：%@",self.images);
}

#pragma mark - 发送方法 methods
//点击发布按钮之后
-(void)sendMessage{
    //上传照片和文字
    [self.view endEditing:YES];
    [SVProgressHUD show];
    BmobObject *bOBj = [BmobObject objectWithClassName:@"ITObject"];
    [bOBj setObject:self.textView.text forKey:@"detail"];
    //添加用户字段 用来区分到底是谁发的
    [bOBj setObject:[BmobUser currentUser] forKey:@"user"];
    [bOBj saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
        if (isSuccessful) {
            NSLog(@"保存成功");
            //判断是否有图片
            if (self.images.count != 0) {
                NSMutableArray *imageDatas = [NSMutableArray array];
                for (UIView *view in self.images) {
                    for (UIView *subview in view.subviews) {
                        if ([subview isKindOfClass:[UIImageView class]]) {
                            UIImageView *imageView = (UIImageView*)subview;
                            NSData *imageData = UIImageJPEGRepresentation(imageView.image, .5);
                            [imageDatas addObject:@{@"filename":@"a.jpg",@"data":imageData}];
                        }
                    }
                }
                [BmobFile filesUploadBatchWithDataArray:imageDatas progressBlock:^(int index, float progress) {
                    nil;
                } resultBlock:^(NSArray *array, BOOL isSuccessful, NSError *error) {
                   // hud.label.text = @"上传完成";
                    NSLog(@"上传完成");
                    //[hud hideAnimated:YES];
                    //准备数组装图片的地址
                    NSMutableArray *imagePaths = [NSMutableArray array];
                    
                    for (BmobFile *file in array) {
                        [imagePaths addObject:file.url];
                    }
                    [bOBj setObject:imagePaths forKey:@"imagePaths"];
                    [bOBj updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                        if (isSuccessful) {
                            NSLog(@"保存成功！");
                            //[self dismissViewControllerAnimated:YES completion:nil];
                            [SVProgressHUD dismiss];
                            [self.navigationController popViewControllerAnimated:YES];
                        }else{
                            NSLog(@"保存失败：%@",error);
                        }
                    }];
                }];
            }
            //没有图片
            if (self.images.count==0) {
               // [self dismissViewControllerAnimated:YES completion:nil];
                [SVProgressHUD dismiss];
                 [self.navigationController popViewControllerAnimated:YES];
            }
        }else{
            NSLog(@"保存失败：%@",error);
        }
    }];
}



@end
