//
//  DecoupleDemo
//
//  Created by DaiMing on 16/3/4.
//  Copyright © 2016年 Starming. All rights reserved.
//

#import "TestTableCellView.h"
#import "Masonry.h"

@interface TestTableCellView()

@property (nonatomic, strong) UILabel *cellLabel;

@end

@implementation TestTableCellView

- (instancetype)init {
    if (self = [super init]) {
        [self buildForInit];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self buildForInit];
    }
    return self;
}

- (void)buildForInit {
//    self.backgroundColor = [UIColor redColor];
    [self addSubview:self.cellLabel];
//    [self.cellLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self).offset(3);
//        make.left.equalTo(self).offset(20);
//    }];
}

#pragma mark - Interface
- (void)buildTitle:(NSString *)titleString {
//    NSLog(@"self%@ super%@",self,self.superview);
    self.cellLabel.text = titleString;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [UIView setAnimationsEnabled:NO];
    self.cellLabel.frame = CGRectMake(20, 20, 300, 30);
    [UIView setAnimationsEnabled:YES];
}

#pragma mark - Getter
- (UILabel *)cellLabel {
    if (!_cellLabel) {
        _cellLabel = [[UILabel alloc] init];
        _cellLabel.textColor = [UIColor lightGrayColor];
    }
    return _cellLabel;
}


@end
