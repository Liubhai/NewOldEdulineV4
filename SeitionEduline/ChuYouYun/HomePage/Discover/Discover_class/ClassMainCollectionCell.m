//
//  ClassMainCollectionCell.m
//  YunKeTang
//
//  Created by 刘邦海 on 2019/7/8.
//  Copyright © 2019 ZhiYiForMac. All rights reserved.
//

#import "ClassMainCollectionCell.h"

#define singleLeftSpace 20
#define topSpace 13
#define bottomSpace 7
#define singleRightSpace 3
#define faceImageHeight (MainScreenWidth/2.0 - singleRightSpace - singleLeftSpace) * 90 / 165.0

@implementation ClassMainCollectionCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self makeUI];
    }
    return self;
}

// MARK: - 创建子视图
- (void)makeUI {
    _faceImageView = [[UIImageView alloc] initWithFrame:CGRectMake(singleLeftSpace, topSpace, MainScreenWidth/2.0 - singleRightSpace - singleLeftSpace, faceImageHeight)];
    _faceImageView.image = Image(@"站位图");
    [self.contentView addSubview:_faceImageView];
    
    UIRectCorner rectCorner = UIRectCornerTopLeft | UIRectCornerTopRight;
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRoundedRect:_faceImageView.bounds byRoundingCorners:rectCorner cornerRadii:CGSizeMake(6, 6)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = _faceImageView.bounds;
    maskLayer.path = bezierPath.CGPath;
    _faceImageView.layer.mask = maskLayer;
    
    _themeLabel = [[UILabel alloc] initWithFrame:CGRectMake(singleLeftSpace + 5, _faceImageView.bottom + 10, _faceImageView.width - 10, 15)];
    _themeLabel.font = [UIFont systemFontOfSize:13];
    _themeLabel.textColor = RGBHex(0x434748);
    _themeLabel.text = @"MG动画设计实战班";
    [self.contentView addSubview:_themeLabel];
    
    _pricelabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth / 2.0 - singleLeftSpace - singleRightSpace - 4, 15)];
    _pricelabel.textColor = RGBHex(0xFF0036);
    _pricelabel.textAlignment = NSTextAlignmentRight;
    _pricelabel.font = [UIFont systemFontOfSize:13];
    _pricelabel.centerY = _themeLabel.centerY;
    _pricelabel.text = @"20育币";
    [self.contentView addSubview:_pricelabel];
    
    _scanIcon = [[UIImageView alloc] initWithFrame:CGRectMake(_themeLabel.left, 0, 15, 15)];
    _scanIcon.centerY = _themeLabel.bottom + 10 + 15 / 2.0;
    _scanIcon.image = Image(@"scan");
    [self.contentView addSubview:_scanIcon];
    
    _scanCountlabel = [[UILabel alloc] initWithFrame:CGRectMake(_scanIcon.right + 4, 0, MainScreenWidth / 4.0, 15)];
    _scanCountlabel.centerY = _scanIcon.centerY;
    _scanCountlabel.textColor = RGBHex(0xADACB4);
    _scanCountlabel.font = SYSTEMFONT(9);
    _scanCountlabel.text = @"(22人浏览)";
    [self.contentView addSubview:_scanCountlabel];
    
    _studyCountlabel = [[UILabel alloc] initWithFrame:CGRectMake(_faceImageView.right - 4 - 47, 0, 47, 15)];
    _studyCountlabel.centerY = _scanIcon.centerY;
    _studyCountlabel.textColor = RGBHex(0xADACB4);
    _studyCountlabel.font = SYSTEMFONT(9);
    _studyCountlabel.text = @"(1人在学习)";
    [self.contentView addSubview:_studyCountlabel];
    
    _studyIcon = [[UIImageView alloc] initWithFrame:CGRectMake(_studyCountlabel.left - 4 - 15, 0, 15, 15)];
    _studyIcon.centerY = _scanIcon.centerY;
    _studyIcon.image = Image(@"study_count");
    [self.contentView addSubview:_studyIcon];
    
    _activityType = [[UIButton alloc] initWithFrame:CGRectMake(_faceImageView.left + 5, _faceImageView.bottom - 20, 70, 15)];
    _activityType.layer.masksToBounds = YES;
    _activityType.layer.cornerRadius = 3.0;
    _activityType.hidden = YES;
    _activityType.titleLabel.font = SYSTEMFONT(11);
    [_activityType setTitleColor:[UIColor whiteColor] forState:0];
    [_activityType setBackgroundColor:RGBHex(0xE02620)];
    [self.contentView addSubview:_activityType];
}

- (void)setClassMainInfo:(NSDictionary *)dict cellIndex:(NSIndexPath *)index {
    [_faceImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[dict objectForKey:@"imageurl"]]] placeholderImage:Image(@"站位图")];
    _themeLabel.text = [NSString stringWithFormat:@"%@",[dict objectForKey:@"album_title"]];
    _pricelabel.text = [NSString stringWithFormat:@"%@育币",[dict objectForKey:@"price"]];
    CGFloat priceWidth = [_pricelabel.text sizeWithFont:_pricelabel.font].width + 4;
    _scanCountlabel.text = [NSString stringWithFormat:@"(%@人浏览)",[dict objectForKey:@"view_nums_mark"]];
    _studyCountlabel.text = [NSString stringWithFormat:@"(%@人在学习)",[dict objectForKey:@"order_count_mark"]];
    CGFloat studyWidth = [_studyCountlabel.text sizeWithFont:_studyCountlabel.font].width;
    if (index.row % 2 == 0) {
        _faceImageView.frame = CGRectMake(singleLeftSpace, topSpace, MainScreenWidth/2.0 - singleRightSpace - singleLeftSpace, faceImageHeight);
        _pricelabel.frame = CGRectMake(_faceImageView.right - priceWidth - 4, 0, priceWidth, 15);
        _pricelabel.centerY = _themeLabel.centerY;
        _themeLabel.frame = CGRectMake(singleLeftSpace + 5, _faceImageView.bottom + 10, _pricelabel.left - (singleLeftSpace + 5), 15);
        _scanIcon.frame = CGRectMake(_themeLabel.left, 0, 15, 15);
        _scanIcon.centerY = _themeLabel.bottom + 10 + 15 / 2.0;
        _scanCountlabel.frame = CGRectMake(_scanIcon.right + 4, 0, MainScreenWidth / 4.0, 15);
        _scanCountlabel.centerY = _scanIcon.centerY;
        _studyCountlabel.frame = CGRectMake(_faceImageView.right - 4 - studyWidth, 0, studyWidth, 15);
        _studyCountlabel.centerY = _scanIcon.centerY;
        _studyIcon.frame = CGRectMake(_studyCountlabel.left - 4 - 15, 0, 15, 15);
        _studyIcon.centerY = _scanIcon.centerY;
    } else {
        _faceImageView.frame = CGRectMake(0, topSpace, MainScreenWidth/2.0 - singleRightSpace - singleLeftSpace, faceImageHeight);
        _pricelabel.frame = CGRectMake(_faceImageView.right - 4 - priceWidth, 0, priceWidth, 15);
        _pricelabel.centerY = _themeLabel.centerY;
        _themeLabel.frame = CGRectMake(0 + 5, _faceImageView.bottom + 10, _pricelabel.left - 5, 15);
        _scanIcon.frame = CGRectMake(_themeLabel.left, 0, 15, 15);
        _scanIcon.centerY = _themeLabel.bottom + 10 + 15 / 2.0;
        _scanCountlabel.frame = CGRectMake(_scanIcon.right + 4, 0, MainScreenWidth / 4.0, 15);
        _scanCountlabel.centerY = _scanIcon.centerY;
        _studyCountlabel.frame = CGRectMake(_faceImageView.right - 4 - studyWidth, 0, studyWidth, 15);
        _studyCountlabel.centerY = _scanIcon.centerY;
        _studyIcon.frame = CGRectMake(_studyCountlabel.left - 4 - 15, 0, 15, 15);
        _studyIcon.centerY = _scanIcon.centerY;
    }
    
    if ([[dict objectForKey:@"has_event"] integerValue]) {
        _activityType.hidden = NO;
        NSString *eventType = [NSString stringWithFormat:@"%@",[[dict objectForKey:@"event_type_info"] objectForKey:@"type_code"]];
        // 1 限时打折 2 抢购(不限时不限量) 3 限量秒杀(不限时) 4 限时抢购(不限量) 5 秒杀(限时限量) 6 拼团
        NSString *eventTitle = @" ";
        NSString *eventIcon = @"discount";
        if ([eventType integerValue] == 1) {
            eventTitle = @"限时打折";
        } else if ([eventType integerValue] == 2) {
            eventTitle = @"抢购";
            eventIcon = @"fire";
        } else if ([eventType integerValue] == 3) {
            eventTitle = @"限量秒杀";
            eventIcon = @"seckill";
        } else if ([eventType integerValue] == 4) {
            eventTitle = @"限时抢购";
            eventIcon = @"fire";
        } else if ([eventType integerValue] == 5) {
            eventTitle = @"秒杀";
            eventIcon = @"seckill";
        } else if ([eventType integerValue] == 6) {
            eventTitle = @"拼团";
            eventIcon = @"seckill";
        } else if ([eventType integerValue] == 7) {
            eventTitle = @"砍价";
            eventIcon = @"seckill";
        } else {
            _activityType.hidden = YES;
        }
        CGFloat eventWidth = [eventTitle sizeWithFont:_activityType.titleLabel.font].width + 4;
        _activityType.frame = CGRectMake(_faceImageView.left + 5, _faceImageView.bottom - 20, eventWidth + 6 + 12 + 10, 15);
        [_activityType setImage:Image(eventIcon) forState:0];
        [_activityType setTitle:eventTitle forState:0];
        _activityType.imageEdgeInsets = UIEdgeInsetsMake(0, -6/2.0, 0, 6/2.0);
        _activityType.titleEdgeInsets = UIEdgeInsetsMake(0, 6/2.0, 0, -6/2.0);
    } else {
        _activityType.hidden = YES;
    }
}

@end
