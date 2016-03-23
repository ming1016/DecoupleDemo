//
//  DecoupleDemo
//
//  Created by DaiMing on 16/3/4.
//  Copyright © 2016年 Starming. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMTableViewModel.h"

@interface SMTableView : UIView

//view model
@property (nonatomic, strong) SMTableViewModel *viewModel;

- (instancetype)initWithViewModel:(SMTableViewModel *)viewModel;
- (void)updateWithViewModel:(SMTableViewModel *)viewModel;

@end
