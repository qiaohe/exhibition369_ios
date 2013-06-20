//
//  ApplyView.h
//  369HUI
//
//  Created by M J on 13-6-19.
//  Copyright (c) 2013年 M J. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AccessDeviceIden.h"
#import "ApplyStateView.h"
#import "ApplyResultView.h"
#import "Model.h"

@interface ApplyView : UIView{
    UILabel     *userNameLabel;
    UITextField *userNameTextField;
    UILabel     *phoneNumLabel;
    UITextField *phoneNumTextField;
    UILabel     *emailAddressLabel;
    UITextField *emailAddressLTextField;
}

@property (nonatomic, retain) UILabel     *userNameLabel;
@property (nonatomic, retain) UITextField *userNameTextField;
@property (nonatomic, retain) UILabel     *phoneNumLabel;
@property (nonatomic, retain) UITextField *phoneNumTextField;
@property (nonatomic, retain) UILabel     *emailAddressLabel;
@property (nonatomic, retain) UITextField *emailAddressLTextField;

- (id)initWithFrame:(CGRect)frame andDelegate:(id)_delegate;

@end
