//
//  NewsMainViewController.m
//  dafengche
//
//  Created by 赛新科技 on 2017/8/1.
//  Copyright © 2017年 ZhiYiForMac. All rights reserved.
//

#import "NewsMainViewController.h"
#import "SYG.h"
#import "rootViewController.h"
#import "AppDelegate.h"
#import "ZhiyiHTTPRequest.h"
#import "UIImageView+WebCache.h"
#import "MJRefresh.h"
#import "ZXDTViewController.h"
#import "TKProgressHUD+Add.h"
#import "MyHttpRequest.h"
#import "UIButton+WebCache.h"

#import "NewsViewController.h"


@interface NewsMainViewController ()<UIScrollViewDelegate>

@property (strong ,nonatomic)UIImageView  *imageView;

@property (strong, nonatomic) UIButton *pastBtn;// 记录上一个按钮 用于判断是左滑还是右滑

@property (strong, nonatomic) UIView *topCateView;
@property (strong, nonatomic) UIScrollView *topScrollView;
@property (strong, nonatomic) UIView *cateSelectLineView;

@property (strong, nonatomic) UIScrollView *mainScrollView;//容器

@property (strong, nonatomic) NSMutableArray *cateArray;


@end

@implementation NewsMainViewController

-(UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, MACRO_UI_UPHEIGHT, MainScreenWidth, MainScreenHeight - MACRO_UI_UPHEIGHT)];
        _imageView.image = Image(@"云课堂_空数据.png");
        [self.view addSubview:_imageView];
    }
    return _imageView;
}

-(void)viewWillAppear:(BOOL)animated
{
    AppDelegate *app = [AppDelegate delegate];
    rootViewController * nv = (rootViewController *)app.window.rootViewController;
    [nv isHiddenCustomTabBarByBoolean:YES];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

-(void)viewWillDisappear:(BOOL)animated
{
    AppDelegate *app = [AppDelegate delegate];
    rootViewController * nv = (rootViewController *)app.window.rootViewController;
    [nv isHiddenCustomTabBarByBoolean:NO];
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _cateArray = [NSMutableArray new];
    [self addNav];
    [self netWorkNewsGetCategory];
}

- (void)makeTopCateView {
    _topCateView = [[UIView alloc] initWithFrame:CGRectMake(0, MACRO_UI_UPHEIGHT, MainScreenWidth, 40)];
    _topCateView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_topCateView];
    
    _topScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 40)];
    _topScrollView.backgroundColor = [UIColor whiteColor];
    _topScrollView.showsVerticalScrollIndicator = NO;
    _topScrollView.showsHorizontalScrollIndicator = NO;
    [_topCateView addSubview:_topScrollView];
    
    _cateSelectLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 40 / 2.0 + 7 + 5, 20, 2)];
    _cateSelectLineView.backgroundColor = BasidColor;
    
    [self makeCateUI];
    
    [_topScrollView addSubview:_cateSelectLineView];
}

// MARK: - 构建分类视图
- (void)makeCateUI {
    [_topScrollView removeAllSubviews];
    CGFloat xx = 0.0;
    CGFloat ww = 0.0;
    for (int i = 0; i<_cateArray.count; i++) {
        
        ww = [[NSString stringWithFormat:@"%@",[_cateArray[i] objectForKey:@"title"]] sizeWithFont:SYSTEMFONT(16)].width + 28;
        
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(xx, 0, ww, 40)];
        [btn setTitleColor:BasidColor forState:UIControlStateSelected];
        [btn setTitleColor:[UIColor blackColor] forState:0];
        btn.titleLabel.font = SYSTEMFONT(16);
        btn.tag = 66 + i;
        [btn setTitle:[_cateArray[i] objectForKey:@"title"] forState:0];
        [btn addTarget:self action:@selector(cateButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        if (i == 0) {
            _cateSelectLineView.centerX = btn.centerX;
            btn.selected = YES;
            btn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:18];//SYSTEMFONT(18);
            _pastBtn = btn;
        }
        [_topScrollView addSubview:btn];
        xx = xx + ww;
        if (i == (_cateArray.count - 1)) {
            _topScrollView.contentSize = CGSizeMake(xx, 0);
        }
    }
}

- (void)addNav {
    
    //添加view
    UIView *SYGView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, NavigationBarHeight)];
    SYGView.backgroundColor = BasidColor;
    [self.view addSubview:SYGView];
    
    UILabel *titleLab = [[UILabel alloc]initWithFrame:CGRectMake(30, 30, MainScreenWidth - 60, 24)];
    titleLab.text = @"资讯";
    [SYGView addSubview:titleLab];
    titleLab.font = [UIFont systemFontOfSize:20];
    titleLab.textColor = [UIColor whiteColor];
    titleLab.textAlignment = NSTextAlignmentCenter;
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(5, 20, 40, 40)];
    [backButton setImage:[UIImage imageNamed:@"ic_back@2x"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backPressed) forControlEvents:UIControlEventTouchUpInside];
    [SYGView addSubview:backButton];
    
    //设置button上字体的偏移量
//    [backButton setTitleEdgeInsets:UIEdgeInsetsMake(0,-10.0 , 0.0, 0)];
    [SYGView addSubview:backButton];
    
    
    //添加线
    UILabel *lineLab = [[UILabel  alloc] initWithFrame:CGRectMake(0, 63,MainScreenWidth, 1)];
    lineLab.backgroundColor = [UIColor colorWithHexString:@"#dedede"];
    [SYGView addSubview:lineLab];
    
    if (iPhoneX) {
        backButton.frame = CGRectMake(15, 40, 40, 40);
        titleLab.frame = CGRectMake(50, 45, MainScreenWidth - 100, 30);
        lineLab.frame = CGRectMake(0, 87, MainScreenWidth, 1);
    }
}

- (void)backPressed {
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark --- 添加控制器的滚动
- (void)addControllerSrcollView {
    
    _mainScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0,MACRO_UI_UPHEIGHT + 40, MainScreenWidth, MainScreenHeight - MACRO_UI_UPHEIGHT - 40)];
    _mainScrollView.contentSize = CGSizeMake(MainScreenWidth * _cateArray.count, 0);
    _mainScrollView.pagingEnabled = YES;
    _mainScrollView.showsHorizontalScrollIndicator = NO;
    _mainScrollView.showsVerticalScrollIndicator = NO;
    _mainScrollView.bounces = NO;
    _mainScrollView.delegate = self;
    [self.view addSubview:_mainScrollView];
    
    //添加控制器
    for (int i = 0 ; i < _cateArray.count ; i ++) {
        NewsViewController *newsVc= [[NewsViewController alloc] initWithIDString:_cateArray[i][@"zy_topic_category_id"] schoolId:[NSString stringWithFormat:@"%@",_cateArray[i][@"mhm_id"]]];
        newsVc.view.frame = CGRectMake(MainScreenWidth * i, 0, MainScreenWidth, MainScreenHeight - MACRO_UI_UPHEIGHT - 40 * HigtEachUnit);
        [_mainScrollView addSubview:newsVc.view];
        [self addChildViewController:newsVc];
    }
    
}

// MARK: - 滚动和点击事件最终逻辑
- (void)cateExchanged:(UIButton *)sender {
    
//    CGPoint btnPoint = [_topScrollView convertPoint:CGPointMake(sender.origin.x, sender.origin.y) toView:_topCateView];
    // 还需要继续优化成 首先分成 左滑 右滑
    if ((sender.right - _topScrollView.contentOffset.x) >= MainScreenWidth) {
        
        if (sender.tag > _pastBtn.tag) {
            // 右滑动
            if ((sender.tag - 66) < (_cateArray.count - 1)) {
                // 每次多移动一个按钮宽度
                UIButton *nextBtn = [_topScrollView viewWithTag:sender.tag + 1];
                [_topScrollView setContentOffset:CGPointMake((_topScrollView.contentOffset.x + ((sender.right - _topScrollView.contentOffset.x) - MainScreenWidth) + nextBtn.width), 0)];
            } else {
                [_topScrollView setContentOffset:CGPointMake(sender.right - MainScreenWidth, 0)];
            }
        } else if (sender.tag < _pastBtn.tag) {
            // 左滑动
            
        } else {
            
        }
    } else if ((sender.right - _topScrollView.contentOffset.x) < sender.width) {
        if ((sender.tag - 66) == 0) {
            // 每次多移动一个按钮宽度
            [_topScrollView setContentOffset:CGPointMake(0, 0)];
        } else if ((sender.tag - 66) > 0) {
            UIButton *btn = [_topScrollView viewWithTag:sender.tag - 1];
            [_topScrollView setContentOffset:CGPointMake(_topScrollView.contentOffset.x - btn.width - fabs(sender.right - _topScrollView.contentOffset.x), 0)];
        }
    }
    
    for (UIButton *object in _topScrollView.subviews) {
        if ([object isKindOfClass:[UIButton class]]) {
            if (object.tag == sender.tag) {
                object.selected = YES;
                object.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:18];
            } else {
                object.selected = NO;
                object.titleLabel.font = SYSTEMFONT(16);
            }
        }
    }
    if (_cateSelectLineView) {
        [UIView animateWithDuration:0.2 animations:^{
            
        } completion:^(BOOL finished) {
            self.cateSelectLineView.centerX = sender.centerX;
        }];
    }
}


// MARK: - 分类按钮点击事件
- (void)cateButtonClick:(UIButton *)sender {
    [self.mainScrollView setContentOffset:CGPointMake(MainScreenWidth * (sender.tag - 66), 0) animated:YES];
    [self cateExchanged:sender];
    _pastBtn = sender;
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger index = scrollView.contentOffset.x / MainScreenWidth;
    self.mainScrollView.contentOffset = CGPointMake(index * MainScreenWidth, 0);
    [self cateExchanged:[_topCateView viewWithTag:index + 66]];
    _pastBtn = [_topCateView viewWithTag:index + 66];
}

#pragma mark --- 网络请求
- (void)netWorkNewsGetCategory {
    
    NSString *endUrlStr = YunKeTang_News_news_getCategory;
    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
    
    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];
    [mutabDict setValue:@"20" forKey:@"count"];
    NSString *oath_token_Str = nil;
    if (UserOathToken) {
        oath_token_Str = [NSString stringWithFormat:@"%@:%@",UserOathToken,UserOathTokenSecret];
    }
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:allUrlStr]];
    [request setHTTPMethod:NetWay];
    NSString *encryptStr = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetEncryptStr:mutabDict];
    [request setValue:encryptStr forHTTPHeaderField:HeaderKey];
    [request setValue:oath_token_Str forHTTPHeaderField:OAUTH_TOKEN];
    
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSDictionary *dict = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr_Before:responseObject];
        if ([[dict stringValueForKey:@"code"] integerValue] == 1) {
            [_cateArray removeAllObjects];
            [_cateArray addObjectsFromArray:[YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr:responseObject]];
            if (_cateArray.count == 0) {
                self.imageView.hidden = NO;
            } else {
                [self makeTopCateView];
                [self addControllerSrcollView];
            }
        } else {
            [TKProgressHUD showError:[dict stringValueForKey:@"msg"] toView:self.view];
        }
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
    }];
    [op start];
}




@end
