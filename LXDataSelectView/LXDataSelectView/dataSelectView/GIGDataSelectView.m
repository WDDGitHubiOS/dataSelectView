//
//  GIGDataSelectView.m
//  myTest
//
//  Created by Gigaiot-Sasai on 2019/11/15.
//  Copyright © 2019 Gigaiot-Sasai. All rights reserved.
//

#import "GIGDataSelectView.h"
#import <Masonry.h>
#import "UIView+LFMEFrame.h"

#define TitleViewH 45
#define DefaultTypeRowH 50
#define HightTypeRowH 60
#define SelectImemCount 3  //默认显示3行数据

#define KSelfH self.frame.size.height
#define KSelfW self.frame.size.width

// 刘海头机型（iPhone X XR XS XSP）
#define IS_IPHONE_X \
({BOOL isPhoneX = NO;\
if (@available(iOS 11.0, *)) {\
isPhoneX = [[UIApplication sharedApplication] delegate].window.safeAreaInsets.bottom > 0.0;\
}\
(isPhoneX);})

#define kSafeAreaBottom      (IS_IPHONE_X ? 34 :  0) // 底部安全栏高度
#define kSafeAreaTop         (IS_IPHONE_X ? 44 : 20) // 状态栏高度
#define kSafeAreaNavigationH (IS_IPHONE_X ? 88 : 64) // 导航栏高度
#define ksafeAreaTabBarH     (IS_IPHONE_X ? 83 : 49) // tabbar高度


@interface GIGDataSelectView ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, assign) GIGDataSelectViewType currentType;
@property (nonatomic, strong) UIView *contentViews;
//listView
@property (nonatomic, strong) UITableView *tableView;
//titleView
@property (nonatomic, strong) UIView *titleView;
//titleViewLab
@property (nonatomic, strong) UILabel *labTitle;
@end

@implementation GIGDataSelectView

- (instancetype)initWithType:(GIGDataSelectViewType)type withData:(NSArray *)arrData{
    if (self = [super initWithFrame:[UIScreen mainScreen].bounds]) {
        _currentType = type;
        _arrDataSource = arrData;
        [self setupBaseUI];
    }
    return self;
}

- (void)setupBaseUI{
    //
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    self.alpha = 0.0f;
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = [UIColor clearColor];
    [btn addTarget:self action:@selector(tapAction) forControlEvents:UIControlEventTouchUpInside];
    btn.frame = self.bounds;
    [self addSubview:btn];
    
    
    //viewFrame
    CGRect contentFrame = CGRectMake(0, KSelfH, KSelfW, 240);
    self.contentViews = [[UIView alloc] initWithFrame:contentFrame];
    self.contentViews.backgroundColor = [UIColor whiteColor];
    self.contentViews.alpha = 1.0f;
    [self addSubview:self.contentViews];
    
    //显示计算
    //tableview距离顶部的距离
    CGFloat tableViewMarginTop = TitleViewH;
    CGFloat tableViewH = 0;
    
    if (_currentType == GIGDataSelectViewTypeHightRow){ //含有图片的 高Row
        tableViewH = self.arrDataSource.count > SelectImemCount ? SelectImemCount * HightTypeRowH : self.arrDataSource.count * HightTypeRowH;
    }else{// 默认和 仅文本
        tableViewH = self.arrDataSource.count > SelectImemCount ? SelectImemCount * DefaultTypeRowH : self.arrDataSource.count * DefaultTypeRowH;
    }
    self.contentViews.height = TitleViewH + tableViewH + kSafeAreaBottom;
    [self.contentViews addSubview:self.titleView];
    
    //圆角
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.contentViews.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(15, 15)];
    CAShapeLayer *shapeLayer = [[CAShapeLayer alloc] init];
    shapeLayer.path = path.CGPath;
    shapeLayer.frame = self.contentViews.bounds;
    self.contentViews.layer.mask = shapeLayer;
    
   
    
    [self.contentViews addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(- kSafeAreaBottom);
        make.top.mas_equalTo(tableViewMarginTop);
    }];
}

- (void)tapAction{
    [self dismiss];
}


//关闭条
- (UIView *)titleView{
    if (!_titleView) {
        _titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.width, 45)];
        
        //UILabel
        UILabel *labTitle = [UILabel new];
        _labTitle = labTitle;
        labTitle.text = self.strTitleText;
        labTitle.textColor = [UIColor blackColor];
        labTitle.font = [UIFont systemFontOfSize:18];
        [labTitle sizeToFit];
        [_titleView addSubview:labTitle];
        [labTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.bottom.mas_equalTo(-7);
        }];
        
        //btnClose
        UIButton *btnClose = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnClose setImage:[UIImage imageNamed:@"导航栏关闭"] forState:UIControlStateNormal];
        [btnClose setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
        [btnClose addTarget:self action:@selector(tapAction) forControlEvents:UIControlEventTouchUpInside];
        [_titleView addSubview:btnClose];
        [btnClose mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-15);
            make.bottom.mas_equalTo(-7);
            make.size.mas_equalTo(CGSizeMake(15, 15));
        }];
        
    }
    return _titleView;
}

- (void)setStrTitleText:(NSString *)strTitleText{
    _strTitleText = strTitleText;
    _labTitle.text = strTitleText;
    if (_currentType == GIGDataSelectViewTypeHightRow) {
        
    }
}


#pragma mark - tableView
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
        _tableView.separatorColor = [UIColor grayColor];
        if (_currentType == GIGDataSelectViewTypeDefault) { //
            _tableView.separatorInset = UIEdgeInsetsMake(0, 50, 0, 0);
        }else if (_currentType == GIGDataSelectViewTypeHightRow){
            _tableView.separatorInset = UIEdgeInsetsMake(0, 75, 0, 0);
        }else{
            _tableView.separatorInset = UIEdgeInsetsMake(0, 15, 0, 0);
        }
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.scrollEnabled = YES;
        
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            
        }
    }
    return _tableView;
}

#pragma mark - tableViewFunc
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.arrDataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GIGDataSelectViewCell *cell =  [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(GIGDataSelectViewCell.class)];
    if (cell == nil) {
        cell = [[GIGDataSelectViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass(GIGDataSelectViewCell.class) type:_currentType];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    GIGDataSelectViewCell *selectCell =  (GIGDataSelectViewCell *)cell;
    selectCell.cellModel = self.arrDataSource[indexPath.row];
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    GIGDataSelectViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.cellLab.textColor = [UIColor blackColor];
    if (_didSelectItemBlock) {
        self.didSelectItemBlock(cell.cellModel,indexPath.row);
    }
    
    [self dismiss];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_currentType == GIGDataSelectViewTypeHightRow) {
        return HightTypeRowH;
    }else{
        return DefaultTypeRowH;
    }
}


#pragma mark - show/hide
- (void)show{
    
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    for (UIView *subviews in keyWindow.subviews) {
        if ([subviews isKindOfClass:GIGDataSelectView.class]) {
            return;
        }
    }
    
    [keyWindow addSubview:self];
    [UIView animateWithDuration:0.25 animations:^{
        self.contentViews.transform = CGAffineTransformMakeTranslation(0, -self.contentViews.height);
        self.alpha = 1.0;
    }];
}

- (void)dismiss{
    [UIView animateWithDuration:0.25 animations:^{
        self.contentViews.transform = CGAffineTransformIdentity;
        self.alpha = 0.0f;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
@end



#pragma mark - GIGDataSelectViewCell

@interface GIGDataSelectViewCell()
@property (nonatomic, strong) UIImageView *icon;
@property (nonatomic, strong) UIImageView *imgRightArrow;
@end

@implementation GIGDataSelectViewCell : UITableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier type:(GIGDataSelectViewType)type{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupCellWithType:type];
    }
    return self;
}

- (void)setupCellWithType:(GIGDataSelectViewType)type{
    //item icon
    UIImageView *icon = [UIImageView new];
    _icon = icon;
    icon.backgroundColor = [UIColor clearColor];
    icon.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:icon];
    [icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.left.mas_equalTo(16);
    }];
    
    //item text
    UILabel *labtext = [UILabel new];
    _cellLab = labtext;
    labtext.textColor = [UIColor blackColor];
    labtext.font = [UIFont systemFontOfSize:16];
    [labtext sizeToFit];
    [self addSubview:labtext];
    [labtext mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.mas_centerY);
        make.left.mas_equalTo(icon.mas_right).offset(15);
    }];
    
    if (type == GIGDataSelectViewTypeDefault) {
        [icon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(22, 22));
        }];
    }else if(type == GIGDataSelectViewTypeHightRow){
        [icon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(40, 40));
        }];
    }else if(type == GIGDataSelectViewTypeText){
        icon.hidden = YES;
        [labtext mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.mas_centerY);
            make.left.mas_equalTo(15);
        }];
    }
    
    //select icon
    UIImageView *imgRightArrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"wallet_lock_check_ic"]];
    _imgRightArrow = imgRightArrow;
    imgRightArrow.hidden = YES;
    imgRightArrow.backgroundColor = [UIColor clearColor];
    imgRightArrow.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:imgRightArrow];
    [imgRightArrow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.right.mas_equalTo(-15);
    }];
    
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setCellModel:(id)cellModel{
    if ([cellModel isKindOfClass:NSString.class]) {
        _cellModel = (NSString *)cellModel;
        _cellLab.text = cellModel;
    }
    
    
    if ([cellModel isKindOfClass:NSDictionary.class]) {
        _cellModel = (NSDictionary *)cellModel;

        _cellLab.text = cellModel[@"title"];
        //显示右侧的对号
        if ([[_cellModel allKeys] containsObject:@"isSelect"]) {
            BOOL isHiden = [cellModel[@"isSelect"] boolValue];
            _imgRightArrow.hidden = !isHiden;
        }else{
            _imgRightArrow.hidden = YES;
        }
    
        
        //如果包含iconUrl就设置网络图
        if ([[_cellModel allKeys] containsObject:@"iconUrl"]) {//包含iconUrl key 显示网络图
            //[_icon setImageWithURL:[NSURL URLWithString:cellModel[@"iconUrl"]] placeholder:nil];
        }else{//否则是本地图
            _icon.image = [UIImage imageNamed:cellModel[@"icon"]];
        }
    }
}
@end
