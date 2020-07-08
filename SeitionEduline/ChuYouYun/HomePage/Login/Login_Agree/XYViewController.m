//
//  XYViewController.m
//  dafengche
//
//  Created by IOS on 17/2/21.
//  Copyright © 2017年 ZhiYiForMac. All rights reserved.
//

#import "XYViewController.h"
#import "rootViewController.h"
#import "AppDelegate.h"
#import "SYG.h"
#import "BigWindCar.h"
#import "UIImageView+WebCache.h"
#import "TKProgressHUD+Add.h"
#import "MyHttpRequest.h"
#import "ZhiyiHTTPRequest.h"
#import "YKTWebView.h"


@interface XYViewController ()

@property (strong ,nonatomic)UIScrollView *scrollView;
@property (strong ,nonatomic)YKTWebView     *webView;
@property (strong ,nonatomic)NSString      *H5Str;

@end

@implementation XYViewController

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
    _titleImage.backgroundColor = BasidColor;
    _titleLabel.text = @"注册协议";
    [self interFace];
    [self addWebView];
    [self netWorkBasicSingle];
}

#pragma mark --- 添加网络试图
- (void)addWebView {
    
    _webView = [[YKTWebView alloc] initWithFrame:CGRectMake(0, MACRO_UI_UPHEIGHT, MainScreenWidth, MainScreenHeight - MACRO_UI_UPHEIGHT)];
    _webView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_webView];
    
    
    [_webView setUserInteractionEnabled:YES];//是否支持交互
    [_webView setOpaque:YES];//opaque是不透明的意思
    [_webView loadHTMLString:_H5Str baseURL:nil];
}

#pragma mark --- 事件监听
- (void)backPressed {
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark --- 网络请求

//获取单页面
- (void)netWorkBasicSingle {
    
    NSString *endUrlStr = YunKeTang_Basic_Basic_single;
    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
    
    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];
    [mutabDict setValue:@"reg" forKey:@"key"];
    
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:allUrlStr]];
    [request setHTTPMethod:NetWay];
    NSString *encryptStr = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetEncryptStr:mutabDict];
    [request setValue:encryptStr forHTTPHeaderField:HeaderKey];
    
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSString *receiveStr = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        _H5Str = receiveStr;
        [self addWebView];
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
    }];
    [op start];
}

- (void)interFace {
    
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)addNav {
    
    UIView *SYGView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 64)];
    SYGView.backgroundColor = BasidColor;
    [self.view addSubview:SYGView];
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(5, 20, 40, 40)];
    [backButton setImage:[UIImage imageNamed:@"ic_back"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backPressed) forControlEvents:UIControlEventTouchUpInside];
    [SYGView addSubview:backButton];
    
    //添加中间的文字
    UILabel *titleText = [[UILabel  alloc] initWithFrame:CGRectMake(50, 25,MainScreenWidth - 100, 30)];
    titleText.text = @"注册协议";
    [titleText setTextColor:[UIColor whiteColor]];
    titleText.textAlignment = NSTextAlignmentCenter;
    titleText.font = [UIFont systemFontOfSize:20];
    [SYGView addSubview:titleText];
    
    //添加横线
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 63, MainScreenWidth, 1)];
    button.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [SYGView addSubview:button];
    
}

- (void)addScrollView {
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, MACRO_UI_UPHEIGHT, MainScreenWidth, MainScreenHeight - MACRO_UI_UPHEIGHT)];
    _scrollView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_scrollView];
    
    //添加具体内容
    UILabel *content = [[UILabel alloc] initWithFrame:CGRectMake(SpaceBaside, SpaceBaside, MainScreenWidth - 2 * SpaceBaside, 200)];
    [_scrollView addSubview:content];
    content.font = Font(15);
    if (iPhone5o5Co5S) {
        content.font = Font(13);
    }
    
    
    CGRect frame;
    //文本赋值
    content.text = @"l	欢迎机构用户入驻云课堂！\n\n\n云课堂网站由云课堂（北京）教育科技有限公司负责运营，专注于创新型学习服务，致力于打造乐享互联的全方位学习服务平台，让教与学更便利、更实效、更高质。\n\n机构用户在入驻云课堂之前请您仔细阅读本注册协议，在您点击“同意”按钮后，本协议即构成对双方有约束力的法律文件。\n 一、定义\n机构用户是指合法成立并存续的具有法人主体资格的企业、非企业单位，或者个体教师工作室以团体名义入驻云课堂的非法人单位。\n机构用户，以下亦称机构。\n机构用户及其注册教师，以下统称用户。\n云课堂网站，以下简称云课堂。\n二、合作方式及入驻流程说明\n1、机构用户通过注册并经审核入驻云课堂后，将在云课堂上拥有专属的网上旗舰店，机构可在旗舰店展示其品牌logo、完善基本信息、相关简介、路线地图、课程模块、照片、教学音频、教学视频等内容；机构可将其自有教师及学生资源运营到云课堂并为自有教师资源加注机构推荐图标。机构通过给学生提供优秀师资、优质课程和良好的服务等各种方式，维护专属的网上旗舰店，创造更多的线上交易额。云课堂通过网络推广积极提升机构的业界知名度、为机构扩大生源。云课堂为机构网上旗舰店提供技术服务。\n2、机构入驻应对应下列流程（详见云课堂首页“机构平台入驻流程说明“）：\n注册流程 签约流程 资料提交 审核流程 进入机构平台\n三、双方权利义务及法律责任\n1、机构应对自身提交及上传云课堂的资料信息的真实性、合法性、有效性承担相应法律责任。\n2、机构需在征得教师本人同意的前提下将教师运营至云课堂平台，并负责审核注册教师相关资质的真实性与合法性。机构审核教师的资质文件包括但不限于身份证、教师证、学历证等。机构应为注册教师拍摄自我介绍视频和授课演示视频。\n3、机构应核准注册教师的教学水平达到同行业中等及中等以上的教学水准。\n4、机构应加强对注册教师的管理，敦促注册教师严格遵守云课堂“网站条款“的约定，合法使用云课堂的服务。机构及注册教师均不得利用云课堂平台发布虚假信息、侵权信息及其他违法信息，不得利用云课堂的服务从事违法活动。\n5、机构应敦促注册教师及时维护其个人主页的活跃度，并跟踪确认其提供的资料真实、准确、完整、合法有效，提供资料如有变动的，应及时更新其资料。如果用户提供的资料不合法、不真实、不准确、不详尽的，用户需承担因此引起的相应责任及后果，并且云课堂保留终止用户使用云课堂各项服务的权利；\n6、学员与机构教师约课成功后，上课地点按教师与学员的约定确定。上课过程中发生的教师及学员的人身、财产损害事件，由相关责任方承担法律责任。\n7、机构及注册教师有责任妥善保管自己的帐号及密码，云课堂也应采取适当的技术措施，共同维护机构和注册教师帐号的安全性。\n8、云课堂有权受理学员对机构注册教师投诉事件，机构应积极协助并妥善处理。\n9、云课堂有权保留并合理使用机构及其教师注册及上传的所有信息。\n10、云课堂谨慎使用用户的所有信息，非依法律规定及用户许可，不得向任何第三方透露用户信息。云课堂对相关信息采用专业加密存储与传输方式，保障用户个人信息的安全。\n11、用户上传云课堂的任何内容如涉嫌侵犯第三方合法权益的，云课堂有权采取删除、屏蔽或断开链接等技术措施，用户须独立承担因侵权所产生法律责任。\n四、入驻费用说明\n云课堂对入驻机构暂不收取任何费用。\n五、知识产权说明\n1、用户在云课堂发布书稿、课件等信息或作品的，用户应独立享有相关著作权。如受到第三方的投诉或举报，用户应独立承担相关法律责任。\n2、云课堂提供的网络服务中包含的任何文本、图片、图形、音频和/或视频资料均受版权、商标和/或其它财产所有权法律的保护, 未经相关权利人同意, 上述资料均不得在任何媒体直接或间接发布、播放、出于播放或发布目的而改写或再发行, 或者被用于其他任何商业目的。\n3、用户未经云课堂书面许可不得擅自使用、不得以任何形式和理由对云课堂文字及图形标识的任何部分进行使用、复制、修改、传播或与其他产品捆绑使用，不得以任何可能引起消费者混淆的方式或任何诋毁或诽谤云课堂的方式用于任何商品或服务上。\n4、机构按照本协议第三条第2项要求为注册教师拍摄的视频，相关著作权归云课堂所有，机构除上传云课堂之外，非经云课堂书面许可，不得用作任何其他用途。\n5、软件使用：用户需要下载云课堂提供的手机/pad软件并安装后方得以从客户端使用云课堂所提供的服务。云课堂在此授予用户免费的、不可转让的、非独占的全球性个人许可，允许用户使用由云课堂提供的、包含在服务中的软件。但是，用户不得复制、修改、发布、出售或出租云课堂的服务软件或所含软件的任何部分，也不得进行反向工程或试图提取该软件的源代码。\n六、免责条款\n基于包括但不限于下列云课堂不可控制的原因或并非云课堂的过错所造成的损失，机构及注册教师应自行承担或向有关责任方追偿：\n1、不可抗力事件导致的服务中断；\n2、由于受到计算机病毒、木马或其他恶意程序、黑客攻击的破坏等不可抗拒因素可能引起的信息丢失、泄漏等风险；\n3、用户的电脑软件、系统、硬件和通信线路出现故障或自身操作不当；\n4、由于网络信号不稳定等原因所引起的登录失败、资料同步不完整、页面打开速度慢等；\n5、用户发布的内容被他人转发、复制等传播可能带来的风险和责任；\n6、其他云课堂无法控制的原因；\n7、如因系统维护或升级而需要暂停网络服务，云课堂将事先在网站发布通知。\n七、法律适用与争议解决\n1、本协议的履行与解释均适用中华人民共和国法律。\n2、云课堂与用户之间应以友好协商方式解决协议履行过程中产生的争议与纠纷，协商无效时，应提交当地法院通过诉讼解决。\n八、本协议条款的修改权与可分性\n1、为更好地提供服务并符合相关监管政策，本公司有权在必要时单方修改或变更本服务协议之内容，并将通过本公司网站公布最新的服务协议，无需另行单独通知您。\n2、本协议条款中任何一条被视为无效或因任何理由不可执行，不影响任何其余条款的有效性和可执行性。\n九、通知方式\n云课堂将采用在网站上发布通知公告或其他有效方式与用户进行联系。用户同意用网站发布通知方式接收所有协议、通知、披露和其他信息。\n十、协议生效\n本协议从机构点击同意开始，即时生效。\nl	云课堂用户（老师）服务协议\n欢迎访问云课堂！云课堂网站及相应的手机客服端由云课堂（北京）教育科技有限公司负责运营，专注于创新型学习服务，致力于打造乐享互联的全方位学习服务平台，让教与学更便利、更实效、更高质。\n用户在访问和使用云课堂提供的服务前请您仔细阅读本注册协议，在您点击“提交注册”按钮后，本协议即构成对双方有约束力的法律文件。\n一、用户说明使用云课堂服务，该协议用户包括老师端，以下单独称为老师\n二、云课堂服务模式\n用户应了解并知悉，云课堂是为学生及家长提供优质教育机构、老师、资源的一家教育综合服务平台。学生与老师双方通过云课堂平台可以达成独立的教学服务。如在线下教学过程中导致用户遭受相关财产及人身损害的，用户应直接向另一方追责，云课堂免于承担因学生和老师之间服务协议履行所致任何纠纷的赔偿责任。同时，云课堂拥有完善的客户服务跟踪体系，力求帮助或促使老师或学生妥善解决纠纷。\n三、使用细节\n1、老师入驻及信息发布\n老师可自主入驻云课堂，云课堂将履行网络服务提供者的义务，在后台审核老师的身份及资质，包括但不限于老师的身份证、教师证、学历证书等，但是，云课堂无法就老师所有信息内容的准确性、完整性、真实性等做出实质保证。\n通过审核后，老师入驻即行生效，老师将在云课堂上拥有个人专属主页，老师可在主页上自行展示其履历、照片、博文、教学成果、授课资料、视频宣传、课程说明等内容。老师有责任对自身展示的所有信息的真实性、合法性、完整性及有效性承担法律责任。\n老师入驻流程可详见云课堂首页导航栏“老师入驻”。\n2、账户管理服务\n用户使用云课堂服务，有负责维护自己账户的保密性并限制第三方使用/访问其计算机或移动设备，用户对其账户和密码下发生的所有活动承担法律责任。\n3、订单及支付\n本条款所述“订单”，是指用户在云课堂平台上根据自身需求自行匹配达成的老师与学生之间的教学服务。学生在平台上搜索到合适的老师后，订单在下述条件同时满足时正式成立：\n1） 学生通过云课堂联系到能够提供服务的老师并商定授课时间、地点、方式等服务信息；\n2） 学生已通过云课堂或直接向老师支付订单费用；\n一般情况下（系统默认开启平台支付保障功能），课时费用通过云课堂平台支付给授课老师，即授课完毕后，由学生在云课堂网站或客户端进行授课确认，确认完毕系统将课时费用支付给授课老师。但是，当学生在支付订单中关闭了平台支付保障功能后，课酬将不通过平台而直接支付给授课老师，关闭平台支付保障功能的情况下，学生将不能通过平台取消订单或申请退款，取消订单或申请退款，学生需直接联系授课老师。？有关订单的修改、取消、退费等事项，请参见云课堂网站的具体规则介绍。\n4、授课及评价体系\n老师可合理选择线上或线下授课方式。\n老师全部完成与学生达成的教学服务后，在云课堂网站或客户端学生可对老师的教学服务做出相应的评价。学生应保证评价的真实性和客观性，对不真实不客观或侵犯老师合法权益的评价，云课堂平台有权依法删除。\n在云课堂平台学生可发表对老师的评论、意见和其他内容，以及向平台提出建议、意见或其他信息，但是该等内容不得违反中国现行法律法规及其他规范性文件的规定，不得含有非法、淫秽、威胁、侮辱、诽谤、侵犯隐私、侵犯知识产权的内容或以其他形式对第三方权利构成侵犯。\n云课堂在接到有关权利人的投诉与举报后将采取合理的删除或屏蔽等措施。基于用户的过错给云课堂造成损失时，用户须对云课堂承担赔偿责任。\n四、双方权利义务及法律责任\n1、云课堂享有对本协议约定服务的监督、提示、检查、纠正等权利。\n2、云课堂有权保留用户注册及使用时预留的所有信息。云课堂在线上线下针对云课堂服务进行宣传推广活动时，有权合理使用用户预留的信息。\n3、云课堂有权删除或屏蔽用户上传的非法及侵权信息。\n4、云课堂谨慎使用用户的所有信息，非依法律规定及用户许可，不得向任何第三方透露用户信息。\n5、云课堂不对任何其他第三方搜索引擎的合法信息抓取功能采取屏蔽措施。\n6、云课堂在首页底导为任何涉嫌侵权的权利人设置便捷的投诉与举报渠道，并依法采取合理救济措施。\n7、用户须为合法目的使用云课堂提供的平台服务，用户不得利用云课堂平台发布任何与教育服务无关的商业信息，包括但不限于销售信息、招聘信息、寻求合作信息等。\n8、用户对其发布的信息的真实性、合法性、有效性及完整性承担法律责任。用户不得在云课堂平台上发布任何虚假、违法信息及言论。用户上传云课堂的任何内容如涉嫌侵犯第三方合法权利的，用户须独立承担因此所产生法律责任。\n9、用户仅对在云课堂上享有的服务及内容享有使用权，未经云课堂或其他第三方权利人的书面许可，用户不得对包括视频、学习软件、学习资料、音频等在内的任何内容进行翻录、复制、售卖、发行等违反知识产权相关法律、法规的行为，由此所导致的一切民事、行政或刑事责任，由用户自行承担。\n10、学生与老师的约课订单一旦达成，老师应在线下或线上全面、适当履行授课义务并独立承担法律责任。\n11、老师须为真实授课目的使用云课堂服务，不得违反诚实信用原则，采用刷单、提高课单价等方式恶意提高在云课堂平台上的交易额。\n12、老师使用云课堂服务，不得故意引导学生线下交易，故意逃单规避线上支付。\n13、老师使用云课堂服务，应自行维护个人主页的活跃度及实时更新。老师不得故意为自己刷评价。\n14、用户违反本协议约定情节严重的，云课堂有权关闭用户账户。\n五、用户注意义务特别提示\n用户上传云课堂平台的信息不得含有以下内容：\n（一）反对宪法确定的基本原则的；\n（二）危害国家统一、主权和领土完整的；\n三）泄露国家秘密、危害国家安全或者损害国家荣誉和利益的；\n（四）煽动民族仇恨、民族歧视，破坏民族团结，或者侵害民族风俗、习惯的；\n（五）宣扬邪教、迷信的；\n（六）扰乱社会秩序，破坏社会稳定的；\n（七）诱导未成年人违法犯罪和渲染暴力、色情、赌博、恐怖活动的；\n（八）侮辱或者诽谤他人，侵害公民个人隐私等他人合法权益的；\n（九）危害社会公德，损害民族优秀文化传统的；\n（十）有关法律、行政法规和国家规定禁止的其他内容。\n六、未成年人特别注意事项\n如果用户不是具备完全民事权利能力和完全民事行为能力的自然人，请用户征得其监护人许可或由其监护人直接使用云课堂服务。后续线上线下上课、付款等事宜也需由监护人陪同或征得监护人许可完成。\n七、知识产权说明\n1、软件使用\n老师需自行下载云课堂提供的手机/pad软件并安装后，从客户端使用云课堂获得所提供的服务。云课堂在此授予用户免费的、不可转让的、非独占的全球性个人许可，允许用户使用由云课堂提供的、包含在服务中的软件。但是，用户不得复制、修改、发布、出售或出租云课堂的服务软件或所含软件的任何部分，也不得进行反向工程或试图提取该软件的源代码。\n2、版权\n云课堂在服务中自行提供的内容（包括但不限于网页、文字、图片、音频、视频、图表等）的知识产权归云课堂所有，非经云课堂书面许可，用户不得任意使用或创造相关衍生作品，不得以任何形式通过任何方式复制、展示、修改、转让、分发、重新发布、下载、张贴或传输云课堂网站的内容。\n用户在云课堂网站自行上传的所有内容（包括但不限于文字、图片、音频、视频等），用户应享有相关知识产权或经过第三方合法授权。\n3、企业标识及商标\n云课堂企业标识及商标均为云课堂所有的合法财产。云课堂提供的网络服务中包含的任何文本、图片、图形、音频和/或视频资料均受版权、商标和/或其它财产所有权法律的保护, 未经云课堂同意, 上述资料均不得在任何媒体直接或间接发布、播放、出于播放或发布目的而改写或再发行, 或者被用于其他任何商业目的。未经云课堂的书面许可，云课堂网站上的任何内容都不应被解释为以默许或其他方式授予许可或使用云课堂网站上出现的标识或商标的权利。\n八、免责条款\n如发生以下情况，云课堂不对用户的直接或间接损失承担法律责任：\n1、云课堂系信息服务平台，不保证该等信息的准确性、有效性、及时性或完整性。提供信息的真实性、合法性、有效性及完整性等由信息提供者承担相关法律责任；\n2、不可抗力事件导致的服务中断或云课堂无法控制的原因所导致的用户损失，云课堂不承担任何责任；\n3、用户使用云课堂网站（包括链接到第三方网站或自第三方网站链接）而可能产生的计算机病毒、黑客入侵、系统失灵或功能紊乱等导致的用户损失，云课堂不承担任何责任；\n4、由于用户将个人注册账号信息告知他人或与他人共享注册帐号，由此导致的任何风险或损失，由用户自行承担；\n5、用户的电脑软件、系统、硬件和通信线路出现故障或自身操作不当；\n6、由于网络信号不稳定等原因所引起的登录失败、资料同步不完整、页面打开速度慢等；\n7、用户发布的内容被他人转发、复制等传播可能带来的风险和责任；\n8、老师与学生之间或与任何第三人间的违约行为、侵权责任等，由有关当事人自行承担法律责任；\n9、其他云课堂无法控制的原因；\n10、如因系统维护或升级而需要暂停网络服务，云课堂将尽可能事先在云课堂网站进行通知。\n九、服务终止情形\n用户在使用云课堂服务的过程中，具有下列情形时，云课堂有权终止对该用户的服务：\n1、用户以非法目的使用云课堂服务；\n2、用户不以约课上课的真实交易为目的使用云课堂服务；\n3、用户存在多次被投诉等不良记录的；\n4、其他侵犯云课堂合法权益的行为。\n十、隐私声明\n云课堂承诺将按照本隐私声明收集、使用和披露用户信息，除本声明另有规定外，不会在未经用户许可的情况下向第三方或公众披露用户信息：\n1、用户信息的范围包括：用户注册的账户信息、用户上传的信息、云课堂自动接收的用户信息、云课堂通过合法方式收集的用户信息等。\n2、用户信息的收集、使用和披露：\n为了给用户提供更优质的服务，云课堂保留收集用户cookie信息等权利，云课堂不会向第三方披露任何可能用以识别用户个人身份的信息；\n只在如下情况下，云课堂会合法披露用户信息：\n（1）经用户事先同意，向第三方披露；\n（2）根据法律的有关规定，或者行政或司法机构的要求，向第三方或者行政、司法机构披露；\n（3）其它根据法律、法规或者政策应进行的披露。\n3、用户信息的保护：\n（1）用户的账户均有安全保护功能，请妥善保管账户及密码信息。云课堂将通过服务器数据备份，确认技术上以实现安全的对用户密码进行加密等措施确保用户信息不丢失，不被滥用和变造。尽管有前述安全措施，但同时也请用户注意在信息网络上不存在“绝对的安全措施”。\n（2）除非经过用户同意，云课堂不允许任何用户、第三方通过云课堂收集、出售或者传播用户信息。\n（3）云课堂含有到其他网站的链接，云课堂不对那些网站的隐私保护措施负责。当用户登陆那些网站时，请提高警惕，保护个人隐私。\n十一、法律适用与争议解决\n1、本协议的履行与解释均适用中华人民共和国法律。\n2、云课堂与用户之间应以友好协商方式解决协议履行过程中产生的争议与纠纷，协商无效时，应提交当地法院通过诉讼解决。\n十二、本协议条款的修改权与可分性\n1、为更好地提供服务并符合相关监管政策，本公司有权在必要时单方修改或变更本服务协议之内容，并将通过本公司网站公布最新的服务协议，无需另行单独通知您。\n2、本协议条款中任何一条被视为无效或因任何理由不可执行，不影响任何其余条款的有效性和可执行性。\n十三、通知\n云课堂将采用在网站上发布通知公告或其他有效方式与用户进行联系。用户同意用网站发布通知方式接收所有协议、通知、披露和其他信息。\n十四、协议生效\n1、本协议自用户注册云课堂之日起生效。\n2、云课堂在法律许可范围内对本协议拥有解释权。\nl	云课堂用户（学生）服务协议\n欢迎访问云课堂！云课堂网站及相应的手机应用软件由云课堂（北京）教育科技有限公司负责运营，专注于创新型学习服务，致力于打造乐享实用的全方位学习服务平台，让教与学更便利、更实效、更高质。\n请用户在访问和使用云课堂提供的服务前请您仔细阅读本注册协议，在您点击“提交注册”按钮后，本协议即构成对双方有约束力的法律文件。\n一、用户说明\n使用云课堂服务，该协议用户包括学生端，以下单独称为学生\n二、云课堂服务模式\n用户应了解并知悉，云课堂是为学生及家长提供优质教育机构、老师、资源的一家教育综合服务平台。学生与老师双方通过云课堂平台可以达成独立的教学服务。如在线下教学过程中导致用户遭受相关财产及人身损害的，用户应直接向另一方追责，云课堂免于承担因学生和老师之间服务协议履行所致任何纠纷的赔偿责任。同时，云课堂建立了完善的客户服务体系，力争帮助或促使老师或学生妥善解决纠纷。\n三、使用细节\n1、学生注册\n学生使用云课堂提供的服务，需要注册一个云课堂账户。账户名即为学生所提供的常用手机号码、邮箱？，学生设置密码并确认，通过云课堂下发的验证码进行账户验证后，该账户即完成初步注册。学生在个人中心设置个人相关信息，在账户中可以查询课程记录和资金情况等。\n2、账户管理\n用户使用云课堂服务，应负责维护自己账户的保密性并限制第三方使用/访问其计算机或移动设备，用户对其账户和密码下发生的所有活动承担法律责任。\n3、订单及支付\n本条款所述“订单”，是指用户在云课堂平台上根据自身需求自行匹配达成的老师与学生之间的教学服务。学生在平台上搜索到合适的老师后，订单在下述条件同时满足时正式成立：\n1） 学生通过云课堂联系到能够提供服务的老师并商定授课时间、地点、方式等服务信息；\n2） 学生已通过云课堂或直接向老师支付订单费用；\n一般情况下（系统默认开启平台支付保障功能），课时费用通过云课堂平台支付给授课老师，即授课完毕后，由学生在云课堂网站或客户端进行授课确认，确认完毕系统将课时费用支付给授课老师。但是，当学生在支付订单中关闭了平台支付保障功能后，课酬将不通过平台而直接支付给授课老师，关闭平台支付保障功能的情况下，学生将不能通过平台取消订单或申请退款，取消订单或申请退款，学生需直接联系授课老师。？有关订单的修改、取消、退费等事项，请参见云课堂网站的具体规则介绍。\n5、课后评价体系\n老师履行完毕与学生达成的教学服务后，学生可在云课堂网站或客户端上对老师的教学服务做出相应的评价。学生应保证评价的真实性和客观性，对不真实不客观或侵犯老师合法权益的评价，云课堂平台有权依法删除。\n学生可以在云课堂平台发表对老师的评论、意见和其他内容，以及向平台提出建议、意见或其他信息，但是该等内容不得违反中国现行法律法规及其他规范性文件的规定，不得含有非法、淫秽、威胁、侮辱、诽谤、侵犯隐私、侵犯知识产权的内容或以其他形式对第三方权利构成侵犯。\n云课堂在接到有关权利人的投诉与举报后将采取合理的删除或屏蔽等措施。基于用户的过错给云课堂造成损失时，用户须对云课堂承担赔偿责任。\n四、双方权利义务及法律责任\n1、云课堂享有对本协议约定服务的监督、提示、检查、纠正等权利。\n2、云课堂有权保留用户注册及使用时预留的所有信息。云课堂在线上线下针对云课堂服务进行宣传推广活动时，有权合理使用用户预留的信息。\n3、云课堂有权删除或屏蔽用户上传的非法及侵权信息。\n4、云课堂谨慎使用用户的所有信息，非依法律规定及用户许可，不得向任何第三方透露用户信息。\n5、云课堂不对任何其他第三方搜索引擎的合法信息抓取功能采取屏蔽措施。\n6、云课堂在首页底导为任何涉嫌侵权的权利人设置便捷的投诉与举报渠道，并依法采取合理救济措施。\n7、用户须为合法目的使用云课堂提供的平台服务，用户不得利用云课堂平台发布任何与教育服务无关的商业信息，包括但不限于销售信息、招聘信息、寻求合作信息等。\n8、用户对其发布的信息的真实性、合法性、有效性及完整性承担法律责任。用户不得在云课堂平台上发布任何虚假、违法信息及言论。用户上传云课堂的任何内容如涉嫌侵犯第三方合法权利的，用户须独立承担因此所产生法律责任。\n9、用户仅对在云课堂上享有的服务及内容享有使用权，未经云课堂或其他第三方权利人的书面许可，用户不得对包括视频、学习软件、学习资料、音频等在内的任何内容进行翻录、复制、售卖、发行等违反知识产权相关法律、法规的行为，由此所导致的一切民事、行政或刑事责任，由用户自行承担。\n10、学生与老师的约课订单一旦达成，老师应在线下或线上全面、适当履行授课义务并独立承担法律责任。\n11、用户违反本协议约定情节严重的，云课堂有权关闭用户账户。\n五、用户注意义务特别提示\n用户上传云课堂平台的信息不得含有以下内容：\n（一）反对宪法确定的基本原则的；\n（二）危害国家统一、主权和领土完整的；\n（三）泄露国家秘密、危害国家安全或者损害国家荣誉和利益的；\n（四）煽动民族仇恨、民族歧视，破坏民族团结，或者侵害民族风俗、习惯的；\n（五）宣扬邪教、迷信的；\n（六）扰乱社会秩序，破坏社会稳定的；\n（七）诱导未成年人违法犯罪和渲染暴力、色情、赌博、恐怖活动的；\n（八）侮辱或者诽谤他人，侵害公民个人隐私等他人合法权益的；\n（九）危害社会公德，损害民族优秀文化传统的；\n（十）有关法律、行政法规和国家规定禁止的其他内容。\n六、未成年人特别注意事项\n如果用户不是具备完全民事权利能力和完全民事行为能力的自然人，请用户征得其监护人许可或由其监护人直接使用云课堂服务。后续线上线下上课、付款等事宜也需由监护人陪同或征得监护人许可完成。\n七、知识产权说明\n1、软件使用\n学生需自行下载云课堂提供的手机/pad软件并安装后，从客户端使用云课堂获得所提供的服务。云课堂在此授予用户免费的、不可转让的、非独占的全球性个人许可，允许用户使用由云课堂提供的、包含在服务中的软件。但是，用户不得复制、修改、发布、出售或出租云课堂的服务软件或所含软件的任何部分，也不得进行反向工程或试图提取该软件的源代码。\n2、版权\n云课堂在服务中自行提供的内容（包括但不限于网页、文字、图片、音频、视频、图表等）的知识产权归云课堂所有，非经云课堂书面许可，用户不得任意使用或创造相关衍生作品，不得以任何形式通过任何方式复制、展示、修改、转让、分发、重新发布、下载、张贴或传输云课堂网站的内容。\n用户在云课堂网站自行上传的所有内容（包括但不限于文字、图片、音频、视频等），用户应享有相关知识产权或经过第三方合法授权。\n3、企业标识及商标\n云课堂企业标识及商标均为云课堂所有的合法财产。云课堂提供的网络服务中包含的任何文本、图片、图形、音频和/或视频资料均受版权、商标和/或其它财产所有权法律的保护, 未经云课堂同意, 上述资料均不得在任何媒体直接或间接发布、播放、出于播放或发布目的而改写或再发行, 或者被用于其他任何商业目的。未经云课堂的书面许可，云课堂网站上的任何内容都不应被解释为以默许或其他方式授予许可或使用云课堂网站上出现的标识或商标的权利。\n八、免责条款\n如发生以下情况，云课堂不对用户的直接或间接损失承担法律责任：\n1、云课堂系信息服务平台，不保证该等信息的准确性、有效性、及时性或完整性。提供信息的真实性、合法性、有效性及完整性等由信息提供者承担相关法律责任；\n2、不可抗力事件导致的服务中断或云课堂无法控制的原因所导致的用户损失，云课堂不承担任何责任；\n3、用户使用云课堂网站（包括链接到第三方网站或自第三方网站链接）而可能产生的计算机病毒、黑客入侵、系统失灵或功能紊乱等导致的用户损失，云课堂不承担任何责任；\n4、由于用户将个人注册账号信息告知他人或与他人共享注册帐号，由此导致的任何风险或损失，由用户自行承担；\n5、用户的电脑软件、系统、硬件和通信线路出现故障或自身操作不当；\n6、由于网络信号不稳定等原因所引起的登录失败、资料同步不完整、页面打开速度慢等；\n7、用户发布的内容被他人转发、复制等传播可能带来的风险和责任；\n8、老师与学生之间或与任何第三人间的违约行为、侵权责任等，由有关当事人自行承担法律责任；\n9、其他云课堂无法控制的原因；\n10、如因系统维护或升级而需要暂停网络服务，云课堂将尽可能事先在云课堂网站进行通知。\n九、服务终止情形\n用户在使用云课堂服务的过程中，具有下列情形时，云课堂有权终止对该用户的服务：\n1、用户以非法目的使用云课堂服务；\n2、用户不以约课上课的真实交易为目的使用云课堂服务；\n3、用户存在多次被投诉等不良记录的；\n4、其他侵犯云课堂合法权益的行为。\n十、隐私声明\n云课堂承诺将按照本隐私声明收集、使用和披露用户信息，除本声明另有规定外，不会在未经用户许可的情况下向第三方或公众披露用户信息：\n1、用户信息的范围包括：用户注册的账户信息、用户上传的信息、云课堂自动接收的用户信息、云课堂通过合法方式收集的用户信息等。\n2、用户信息的收集、使用和披露：\n为了给用户提供更优质的服务，云课堂保留收集用户cookie信息等权利，云课堂不会向第三方披露任何可能用以识别用户个人身份的信息；\n只在如下情况下，云课堂会合法披露用户信息：\n（1）经用户事先同意，向第三方披露；\n（2）根据法律的有关规定，或者行政或司法机构的要求，向第三方或者行政、司法机构披露；\n（3）其它根据法律、法规或者政策应进行的披露。\n3、用户信息的保护：\n（1）用户的账户均有安全保护功能，请妥善保管账户及密码信息。云课堂将通过服务器数据备份，确认技术上以实现安全的对用户密码进行加密等措施确保用户信息不丢失，不被滥用和变造。尽管有前述安全措施，但同时也请用户注意在信息网络上不存在“绝对的安全措施”。\n（2）除非经过用户同意，云课堂不允许任何用户、第三方通过云课堂收集、出售或者传播用户信息。\n（3）云课堂含有到其他网站的链接，云课堂不对那些网站的隐私保护措施负责。当用户登陆那些网站时，请提高警惕，保护个人隐私。\n十一、法律适用与争议解决\n1、本协议的履行与解释均适用中华人民共和国法律。\n2、云课堂与用户之间应以友好协商方式解决协议履行过程中产生的争议与纠纷，协商无效时，应提交当地法院通过诉讼解决。\n十二、本协议条款的修改权与可分性\n1、为更好地提供服务并符合相关监管政策，本公司有权在必要时单方修改或变更本服务协议之内容，并将通过本公司网站公布最新的服务协议，无需另行单独通知您。\n2、本协议条款中任何一条被视为无效或因任何理由不可执行，不影响任何其余条款的有效性和可执行性。\n十三、通知\n云课堂将通过在本网站上发布通知或其他方式与用户进行联系。用户同意用网站发布通知方式接收所有协议、通知、披露和其他信息。\n十四、协议生效\n1、本协议自用户注册云课堂之日起生效。\n2、云课堂在法律许可范围内对本协议拥有解释权。\n";
    //设置label的最大行数
    content.numberOfLines = 0;
    CGRect labelSize = [content.text boundingRectWithSize:CGSizeMake(MainScreenWidth - 20, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingTruncatesLastVisibleLine attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:15]} context:nil];
    
    if (iPhone5o5Co5S) {
        labelSize = [content.text boundingRectWithSize:CGSizeMake(MainScreenWidth - 20, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingTruncatesLastVisibleLine attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:13]} context:nil];
    }
    
    content.frame = CGRectMake(content.frame.origin.x, content.frame.origin.y, MainScreenWidth - 20, labelSize.size.height);
    frame.size.height = labelSize.size.height;
    
    _scrollView.contentSize = CGSizeMake(MainScreenWidth, labelSize.size.height + 10);

    
}


@end
