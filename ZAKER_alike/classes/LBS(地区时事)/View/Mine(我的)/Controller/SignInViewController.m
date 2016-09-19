//
//  signInViewController.m
//  MP
//
//  Created by 王思齐 on 16/8/23.
//  Copyright © 2016年 wangsiqi. All rights reserved.
//

#import "SignInViewController.h"


#import "SignUpViewController.h"

#import "AppDelegate.h"

@interface SignInViewController ()
@property (weak, nonatomic) IBOutlet UITextField *userNameTF;
@property (weak, nonatomic) IBOutlet UITextField *passWordTF;
@property (weak, nonatomic) IBOutlet UIImageView *headerIV;
@property (weak, nonatomic) IBOutlet UIButton *signInButton;

@end

@implementation SignInViewController

#pragma mark - 生命周期 lifeCircle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.signInButton.backgroundColor = MainRed;
    //不隐藏导航栏
    self.navigationController.navigationBarHidden = NO;
    self.title = @"登录";
    //如果之前登录过，获取之前登录过的账号和头像
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *username = [ud objectForKey:@"username"];
    NSString *headPath = [ud objectForKey:@"headPath"];
     //NSLog(@"head:%@",headPath);
       if (username) {
        self.userNameTF.text = username;
        [self.headerIV sd_setImageWithURL:[NSURL URLWithString:headPath]];
    }
    }

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - 方法 methods
- (IBAction)clickedToSignIn:(UIButton*)sender {
    [BmobUser loginWithUsernameInBackground:self.userNameTF.text password:self.passWordTF.text block:^(BmobUser *user, NSError *error) {
        if (user) {
            NSLog(@"登录成功");
            NSString *headPath = [user objectForKey:@"headPath"];
            //NSLog(@"head:%@",headPath);
            [self.headerIV sd_setImageWithURL:[NSURL URLWithString:headPath]];
            //设置用户偏好设置
            NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
             [ud setObject:self.userNameTF.text forKey:@"username"];
            [ud setObject:headPath forKey:@"headPath"];
            
            //发出登录成功的广播
            //[[NSNotificationCenter defaultCenter]postNotificationName:@"登录成功" object:nil];
            
            //[self dismissViewControllerAnimated:YES completion:nil];
            [self.navigationController popViewControllerAnimated:YES];
            
        }else{
            NSLog(@"登录失败");
            UIAlertController *ac = [UIAlertController alertControllerWithTitle:nil message:@"用户名或密码错误" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"忘记密码" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                nil;
            }];
            UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"注册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                SignUpViewController *vc = [[SignUpViewController alloc]initWithNibName:@"SignUpViewController" bundle:nil];
             [self.navigationController pushViewController:vc animated:YES];
                //[self presentViewController:vc animated:YES completion:nil];
            }];
            UIAlertAction *action3 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                nil;
            }];
            [ac addAction:action1];
            [ac addAction:action2];
            [ac addAction:action3];
            [self presentViewController:ac animated:YES completion:nil];
        }
    }];

}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
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
