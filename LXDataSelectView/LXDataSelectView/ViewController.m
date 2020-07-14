//
//  ViewController.m
//  LXDataSelectView
//
//  Created by Gigaiot-Sasai on 2020/7/14.
//  Copyright © 2020 Gigaiot-Sasai. All rights reserved.
//

#import "ViewController.h"
#import "GIGDataSelectView.h"
#import <Masonry.h>

@interface ViewController ()
@property (nonatomic, weak) UILabel *Lab;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor orangeColor];
    
    //UILable
    UILabel *labOpType = [UILabel new];
    _Lab = labOpType;
    labOpType.text = @"Load ..";
    [labOpType sizeToFit];
    labOpType.lineBreakMode = NSLineBreakByTruncatingTail; //xxx...
    labOpType.textColor = [UIColor blackColor];
    labOpType.font = [UIFont systemFontOfSize:16];
    
    [self.view addSubview:labOpType];
    [labOpType mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.view).offset(0);
        make.size.mas_equalTo(CGSizeMake(200, 40));
    }];
    
    
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    NSLog(@"my:insert-%s",__func__);
    
    GIGDataSelectView *dataSelect = [[GIGDataSelectView alloc] initWithType:GIGDataSelectViewTypeText withData:@[@"testq1",@"test2",@"test3"]];
    dataSelect.strTitleText = @"select text";
    __weak typeof(self) weakSelf = self;
    [dataSelect setDidSelectItemBlock:^(id  _Nonnull selectItem, NSInteger index) {
        weakSelf.Lab.text = [NSString stringWithFormat:@"%@",selectItem];
    }];
    [dataSelect show];
}


@end
