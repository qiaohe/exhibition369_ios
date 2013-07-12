//
//  ApplyViewController.m
//  Exhibition369
//
//  Created by M J on 13-6-19.
//  Copyright (c) 2013年 MobilyDaily. All rights reserved.
//

#import "ApplyViewController.h"
#import "MainViewController.h"
#import "Constant.h"


@interface ApplyViewController ()

@end

@implementation ApplyViewController

@synthesize delegate;
@synthesize mainViewDelegate;
@synthesize nameTextField;
@synthesize phoneNumTexField;
@synthesize emailTextField;
@synthesize OldFrame;
@synthesize KeyboardFrame;
@synthesize currentTextField;
@synthesize ExhibitorType;
@synthesize ChoseType;
@synthesize activity;
@synthesize PresentationView;
@synthesize nameError;
@synthesize phoneNumError;
@synthesize emailError;
@synthesize noChooseType;
@synthesize applySuccess;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"申请报名";
    }
    return self;
}

- (void)dealloc
{
    [self.delegate         release];
    [self.mainViewDelegate release];
    [self.nameTextField    release];
    [self.phoneNumTexField release];
    [self.emailTextField   release];
    [self.currentTextField release];
    [self.ExhibitorType    release];
    [self.ChoseType        release];
    [self.activity         release];
    [self.PresentationView release];
    [self.nameError        release];
    [self.phoneNumError    release];
    [self.emailError       release];
    [self.noChooseType     release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    #ifdef __IPHONE_5_0
        float version = [[[UIDevice currentDevice] systemVersion] floatValue];
        if (version >= 5.0) {
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidChangeFrameNotification object:nil];
        }
    #endif
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
    
    self.activity.hidesWhenStopped = YES;
    [self.activity stopAnimating];

    [self initData];
    // Do any additional setup after loading the view from its nib.
}

- (void)keyboardDidShow:(NSNotification*)notification
{
    NSDictionary *userInfo = [notification userInfo];
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    
    if ([self.nameTextField isFirstResponder]) {
        self.currentTextField = self.nameTextField;
    }if ([self.phoneNumTexField isFirstResponder]) {
        self.currentTextField = self.phoneNumTexField;
    }if ([self.emailTextField isFirstResponder]) {
        self.currentTextField = self.emailTextField;
    }
    float YPath = [self YPathForTextFeild:self.currentTextField KeyBoardRect:keyboardRect];
    if (YPath < 0) {
        //self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y + YPath, self.view.frame.size.width, self.view.frame.size.height);
    }
    //NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    //NSTimeInterval animationDuration = [animationDurationValue floatValue];
    //NSLog(@"duration = %f",animationDuration);
}

- (float)YPathForTextFeild:(UITextField*)_textField KeyBoardRect:(CGRect)keyboardRect
{
    float textFieldHeight = _textField.frame.origin.y + _textField.frame.size.height + 40;
    float keyboardHeight  = 460 - keyboardRect.size.height;
    return keyboardHeight - textFieldHeight;
}

- (void)keyboardDidHide:(NSNotification*)notification
{
    //self.view.frame = OldFrame;
}

- (IBAction)SetExhibitorType:(UIButton*)sender
{
    [self setTypeWithTag:sender.tag];
}

- (void)setTypeWithTag:(NSInteger)_tag
{
    switch (_tag) {
        case 301:{
            self.ChoseType = @"E";
            UIImageView *view1 = (UIImageView*)[self.view viewWithTag:201];
            UIImageView *view2 = (UIImageView*)[self.view viewWithTag:203];
            view1.highlighted = YES;
            view2.highlighted = NO;
            break;
        }case 302:{
            self.ChoseType = @"A";
            UIImageView *view1 = (UIImageView*)[self.view viewWithTag:201];
            UIImageView *view2 = (UIImageView*)[self.view viewWithTag:203];
            view2.highlighted = YES;
            view1.highlighted = NO;
            break;
        }
        default:
            break;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.OldFrame = self.view.frame;
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self ClearKeyBoard];
}
- (void)ClearKeyBoard{
    if ([self.nameTextField canResignFirstResponder]) {
        [self.nameTextField resignFirstResponder];
    }if ([self.phoneNumTexField canResignFirstResponder]) {
        [self.phoneNumTexField resignFirstResponder];
    }if ([self.emailTextField canResignFirstResponder]) {
        [self.emailTextField resignFirstResponder];
    }
}


- (IBAction)PressPhoneButton:(id)sender
{
    NSString *phoneNum = _PHONE_NUM_;// 电话号码
    NSURL *phoneURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",phoneNum]];
    
    UIWebView *phoneCallWebView = nil;
    
    if (!phoneCallWebView ) {
        phoneCallWebView = [[UIWebView alloc] init];
        phoneCallWebView.delegate = self;
    }
    
    [phoneCallWebView loadRequest:[NSURLRequest requestWithURL:phoneURL]];
    [self.view addSubview:phoneCallWebView];
    [phoneCallWebView release];
}


- (IBAction)PressCancleButton:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:^{
        if (self.applySuccess) {
            if (self.delegate) {
                [self.delegate ApplyViewApplySuccess];
            }else if (self.mainViewDelegate){
                [self.mainViewDelegate applySuccess];
            }
        }
    }];
}

- (IBAction)PressOkButton:(id)sender
{
    [self CheckUserInfoIsCorrect];
}

- (void) CheckUserInfoIsCorrect
{
    if ([self TheUserInfoIsEmpty:self.nameTextField]) {
        [self presentationShow:NameIsEmpty];
    }else if(![self isValidatePhoneNum:self.phoneNumTexField.text]){
        [self presentationShow:PhoneNumIsNotValidate];
    }else if(![self isValidateEmail:self.emailTextField.text]){
        [self presentationShow:EmailIsNotValidate];
    }else if(!self.ChoseType || [self.ChoseType isEqualToString:@""]){
        [self presentationShow:NotChoseType];
    }else{
        NSString *urlString = [ServerURL stringByAppendingString:@"/rest/applies/put"];
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       [Model sharedModel].selectExhibition.exKey, @"exKey",
                                       [Model sharedModel].systemConfig.token,     @"token",
                                       self.nameTextField.text,                    @"name",
                                       self.phoneNumTexField.text,                 @"mobile",
                                       self.emailTextField.text,                   @"email",
                                       self.ChoseType,                             @"type",
                                       nil];
        NSArray *paramArray = [params allKeys];
        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:urlString]];
        request.delegate = self;
        for (NSString *key in paramArray) {
            [request setPostValue:[params objectForKey:key] forKey:key];
        }
        self.activity.hidden = NO;
        [self.activity startAnimating];
        [request startAsynchronous];
    }
}

-(BOOL)isValidatePhoneNum:(NSString *)PhoneNum
{
    
    NSString *phoneNumRegex = @"(\\+\\d+)?1[3458]\\d{9}$";
    
    NSPredicate *phoneNumTest = [NSPredicate predicateWithFormat:@"SELF MATCHES%@",phoneNumRegex];
    
    return [phoneNumTest evaluateWithObject:PhoneNum];
}

-(BOOL)isValidateEmail:(NSString *)email
{
    
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES%@",emailRegex];
    
    return [emailTest evaluateWithObject:email];
}

- (void)presentationShow:(PresentationType)type
{
    if (type == NameIsEmpty) {
        if (!self.nameError) {
            nameError = [[UILabel alloc]initWithFrame:CGRectMake(50, self.nameTextField.frame.origin.y + self.nameTextField.frame.size.height, 220, 20)];
            nameError.tag = 401;
            nameError.textColor = [UIColor redColor];
            nameError.backgroundColor = [UIColor clearColor];
            nameError.font = [UIFont fontWithName:@"HelveticaNeue" size:11];
            nameError.textAlignment = NSTextAlignmentCenter;
            nameError.text          = @"*请检查你的姓名是否为空*";
            [self.view addSubview:nameError];
        }
        self.nameError.hidden = NO;
    }else if(type == PhoneNumIsNotValidate){
        if (!self.phoneNumError) {
            phoneNumError = [[UILabel alloc]initWithFrame:CGRectMake(50, self.phoneNumTexField.frame.origin.y + self.phoneNumTexField.frame.size.height, 220, 20)];
            phoneNumError.tag = 402;
            phoneNumError.textColor = [UIColor redColor];
            phoneNumError.backgroundColor = [UIColor clearColor];
            phoneNumError.font = [UIFont fontWithName:@"HelveticaNeue" size:11];
            phoneNumError.textAlignment = NSTextAlignmentCenter;
            phoneNumError.text          = @"*电话号码格式不正确*";
            [self.view addSubview:phoneNumError];
        }
        self.phoneNumError.hidden = NO;
    }else if(type == EmailIsNotValidate){
        if (!self.emailError) {
            emailError = [[UILabel alloc]initWithFrame:CGRectMake(50, self.emailTextField.frame.origin.y + self.emailTextField.frame.size.height, 220, 20)];
            emailError.tag = 403;
            emailError.textColor = [UIColor redColor];
            emailError.backgroundColor = [UIColor clearColor];
            emailError.font = [UIFont fontWithName:@"HelveticaNeue" size:11];
            emailError.textAlignment = NSTextAlignmentCenter;
            emailError.text          = @"*Email格式不正确*";
            [self.view addSubview:emailError];
        }
        self.emailError.hidden = NO;
    }else{
        if (!self.noChooseType) {
            UIButton *btn = (UIButton*)[self.view viewWithTag:301];
            noChooseType = [[UILabel alloc]initWithFrame:CGRectMake(50, btn.frame.origin.y + btn.frame.size.height, 220, 20)];
            noChooseType.tag = 404;
            noChooseType.textColor = [UIColor redColor];
            noChooseType.backgroundColor = [UIColor clearColor];
            noChooseType.font = [UIFont fontWithName:@"HelveticaNeue" size:11];
            noChooseType.textAlignment = NSTextAlignmentCenter;
            noChooseType.text          = @"*请选择参展身份*";
            [self.view addSubview:noChooseType];
        }
        self.noChooseType.hidden = NO;
    }
}

- (void)done:(ASIHTTPRequest *)request
{
    NSLog(@"finished");
    
    NSString *requestResult = [request responseStatusMessage];
    NSRange range = [requestResult rangeOfString:@"404 Not Found"];
    if (range.location == NSNotFound) {
        NSInteger responseResult = request.responseStatusCode;
        self.applySuccess = YES;
        switch (responseResult) {
            case 200:{
                [Model sharedModel].selectExhibition.applied = EXHIBITION_APPLIED_Y;
                [Model sharedModel].selectExhibition.status = EXHIBITION_STATUS_P;
                [[Model sharedModel].appliedExhibitionList addObject:[Model sharedModel].selectExhibition];
                [[PlistProxy sharedPlistProxy] updateAppliedExhibitions];
                if (self.delegate) {
                    [self dismissViewControllerAnimated:YES completion:^{
                        [self.delegate ApplyViewApplySuccess];
                    }];
                }else if(self.mainViewDelegate){
                    [self dismissViewControllerAnimated:YES completion:^{
                        [self.mainViewDelegate applySuccess];
                    }];
                }
                break;
            }case 400:{
                self.applySuccess = NO;
                [[Model sharedModel] displayTip:@"参数错误" modal:NO];
                break;
            }case 500:{
                self.applySuccess = NO;
                [[Model sharedModel] displayTip:@"服务器内部错误" modal:NO];
                break;
            }
            default:
                break;
        }
    }else {
        self.applySuccess = NO;
        [[Model sharedModel] displayTip:@"报名失败" modal:NO];
    }
    [self.activity stopAnimating];
}

- (void)showApplyErrorWithMessage:(NSString*)message
{
    
}

- (void)error:(ASIHTTPRequest *)request
{
    NSLog(@"Failed");
    self.applySuccess = NO;
    [[Model sharedModel] displayTip:@"报名失败" modal:NO];
    [self.activity stopAnimating];
}

- (void)ApplySuccess
{
    
}

- (BOOL)TheUserInfoIsEmpty:(UITextField*)_textField
{
    if (!_textField.text || [_textField.text isEqualToString:@""]) {
        return YES;
    }else
        return NO;
}

- (void)initData
{
    self.nameTextField.keyboardType = UIKeyboardTypeNamePhonePad;
    self.phoneNumTexField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    self.emailTextField.keyboardType = UIKeyboardTypeEmailAddress;
    self.ExhibitorType = [[NSMutableArray alloc]init];
    for (int i = 201; i<205; i++) {
        UIView *view = [self.view viewWithTag:i];
        [self.ExhibitorType addObject:view];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    self.nameError.hidden     = YES;
    self.phoneNumError.hidden = YES;
    self.emailError.hidden    = YES;
    self.noChooseType.hidden  = YES;
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
