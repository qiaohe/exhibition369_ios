//
//  ApplyView.m
//  369HUI
//
//  Created by M J on 13-6-19.
//  Copyright (c) 2013年 M J. All rights reserved.
//

#import "ApplyView.h"

@implementation ApplyView

@synthesize title;
@synthesize delegate;
@synthesize userNameLabel;
@synthesize userNameTextField;
@synthesize phoneNumLabel;
@synthesize phoneNumTextField;
@synthesize emailAddressLabel;
@synthesize emailAddressLTextField;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.title = @"报名";
    }
    return self;
}

-(void)dealloc
{
    [self.title                  release];
    [self.delegate               release];
    [self.userNameLabel          release];
    [self.userNameTextField      release];
    [self.phoneNumLabel          release];
    [self.phoneNumTextField      release];
    [self.emailAddressLabel      release];
    [self.emailAddressLTextField release];
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame andDelegate:(id)_delegate
{
    self.title = @"报名";
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self updateDataWithDelegate:_delegate];
        self.delegate = _delegate;
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 6.0;
        self.layer.borderWidth = 1.0;
        self.layer.borderColor = [[UIColor whiteColor] CGColor];
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)updateDataWithDelegate:(id)_delegate
{
    NSString *ExhibitionApplyStatus = [Model sharedModel].selectExhibition.status;
    if ([ExhibitionApplyStatus isEqualToString:@"N"]) {
        userNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 20, 65, 30)];
        [userNameLabel setText:@"姓名"];
        userNameLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:userNameLabel];
        userNameTextField = [[UITextField alloc]initWithFrame:CGRectMake(userNameLabel.frame.origin.x + userNameLabel.frame.size.width + 10, userNameLabel.frame.origin.y, self.frame.size.width - 20 - userNameLabel.frame.size.width - 10, 30)];
        userNameTextField.delegate = _delegate;
        userNameTextField.placeholder = @"Enter text";
        userNameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        userNameTextField.borderStyle = UITextBorderStyleRoundedRect;
        [self addSubview:userNameTextField];
        
        phoneNumLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, userNameLabel.frame.origin.y + userNameLabel.frame.size.height + 20, 65, 30)];
        [phoneNumLabel setText:@"手机"];
        phoneNumLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:phoneNumLabel];
        phoneNumTextField = [[UITextField alloc]initWithFrame:CGRectMake(userNameLabel.frame.origin.x + userNameLabel.frame.size.width + 10, phoneNumLabel.frame.origin.y, self.frame.size.width - 20 - userNameLabel.frame.size.width - 10, 30)];
        phoneNumTextField.delegate = _delegate;
        phoneNumTextField.placeholder = @"Enter text";
        phoneNumTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        phoneNumTextField.borderStyle = UITextBorderStyleRoundedRect;
        [self addSubview:phoneNumTextField];
        
        emailAddressLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, phoneNumLabel.frame.origin.y + phoneNumLabel.frame.size.height + 20, 65, 30)];
        [emailAddressLabel setText:@"邮箱"];
        emailAddressLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:emailAddressLabel];
        emailAddressLTextField = [[UITextField alloc]initWithFrame:CGRectMake(userNameLabel.frame.origin.x + userNameLabel.frame.size.width + 10, emailAddressLabel.frame.origin.y, self.frame.size.width - 20 - userNameLabel.frame.size.width - 10, 30)];
        emailAddressLTextField.delegate = _delegate;
        emailAddressLTextField.placeholder = @"Enter text";
        emailAddressLTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        emailAddressLTextField.borderStyle = UITextBorderStyleRoundedRect;
        [self addSubview:emailAddressLTextField];
        
        UIButton *OKBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [OKBtn setTitle:@"提交" forState:UIControlStateNormal];
        OKBtn.frame = CGRectMake(50, emailAddressLabel.frame.origin.y + emailAddressLabel.frame.size.height + 50, 60, 40);
        [OKBtn addTarget:self action:@selector(PressOK:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:OKBtn];
        
        UIButton *CancelBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [CancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        CancelBtn.frame = CGRectMake(self.frame.size.width - 60 - 50, emailAddressLabel.frame.origin.y + emailAddressLabel.frame.size.height + 50, 60, 40);
        [CancelBtn addTarget:self action:@selector(PressCancle:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:CancelBtn];
    
    }else{
        [self.delegate AppliedExhibition];
    }
    
    
}

- (void)PressOK:(UIButton*)_btn
{
    NSString *urlString = [ServerURL stringByAppendingFormat:@"/rest/applies/put"];
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:[Model sharedModel].selectExhibition.exKey, @"exKey",
                                                                                    [Model sharedModel].systemConfig.token,     @"token",
                                                                                    self.userNameTextField.text,                @"name",
                                                                                    self.phoneNumTextField.text,                @"mobile",
                                                                                    self.emailAddressLTextField.text,           @"email",
                                                                                    nil];
    [self.delegate RequestWithURL:urlString Params:params Method:RequestMethodPOST];
}

- (void)PressCancle:(UIButton*)_btn
{
    NSLog(@"Cancle");
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
