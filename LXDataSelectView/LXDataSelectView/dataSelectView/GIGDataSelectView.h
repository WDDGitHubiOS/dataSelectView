//
//  GIGDataSelectView.h
//  myTest
//
//  Created by Gigaiot-Sasai on 2019/11/15.
//  Copyright © 2019 Gigaiot-Sasai. All rights reserved.
//

//wallet2 常用-选择控件View
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class GIGDataSelectViewCell;
typedef NS_ENUM(NSInteger,GIGDataSelectViewType){
    GIGDataSelectViewTypeDefault = 0,   //普通模式 (含有titleView和图片和文本)
    GIGDataSelectViewTypeHightRow = 1,  //有titleView的高item
    GIGDataSelectViewTypeText = 2,       //仅显示选择文本(有提示关闭titleView)
};

@interface GIGDataSelectView : UIView

@property (nonatomic, strong) NSArray *arrDataSource;
@property (nonatomic, copy) NSString *strTitleText;
@property (nonatomic, copy) void(^didSelectItemBlock)(id selectItem,NSInteger index);

///  数据源格式 @[@{@"icon":@"",@"title":@"",@"iconUrl":@"",@"isSelect":@""}]
- (instancetype)initWithType:(GIGDataSelectViewType)type withData:(NSArray *)arrData;
- (void)show;
- (void)dismiss;
@end


@interface GIGDataSelectViewCell : UITableViewCell
//外部封装好的一个 dict
/*
   @[@{@"icon":@"",@"title":@"",@"iconUrl":@"",@"isSelect":@""}]
 
 */
@property (nonatomic, strong) id cellModel;

@property (nonatomic, strong) UILabel *cellLab;
@property (nonatomic, assign) BOOL isSelected;
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier type:(GIGDataSelectViewType)type;
@end
NS_ASSUME_NONNULL_END
