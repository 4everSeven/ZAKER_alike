//
//  CummunityDetailViewController.m
//  ZAKER_alike
//
//  Created by 王思齐 on 16/9/15.
//  Copyright © 2016年 wangsiqi. All rights reserved.
//

#import "CummunityDetailViewController.h"

@interface CummunityDetailViewController ()<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UILabel *authorLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIView *mainView;

@property(nonatomic,strong)UIWebView *webView;
@end

@implementation CummunityDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setTopView];
    [self webView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(void)setTopView{
    // 隐藏导航栏
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:self.item.icon]];
    self.authorLabel.text = self.item.name;
    self.timeLabel.text = [self dateString:self.item.date];
    
}

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


- (IBAction)goBackToPrevious:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
     [self.navigationController setNavigationBarHidden:NO animated:YES];
}

#pragma mark - UIWebViewDelegate delegateMethods
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{

    return YES;
    
}

#pragma mark - 懒加载 lazyLoad
- (UIWebView *)webView {
	if(_webView == nil) {
		_webView = [[UIWebView alloc] initWithFrame:self.mainView.bounds];
        _webView.delegate = self;
        _webView.backgroundColor = [UIColor whiteColor];
        //_webView.scrollView.contentInset = UIEdgeInsetsMake(0, 0, 35, 0);
        NSURL *url = [NSURL URLWithString:self.item.content_url];
        NSMutableURLRequest *requset = [NSMutableURLRequest requestWithURL:url];
        [_webView loadRequest:requset];
        [self.mainView addSubview:_webView];
	}
	return _webView;
}



@end
