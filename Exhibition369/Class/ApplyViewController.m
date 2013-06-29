//
//  ApplyViewController.m
//  Exhibition369
//
//  Created by M J on 13-6-19.
//  Copyright (c) 2013年 MobilyDaily. All rights reserved.
//

#import "ApplyViewController.h"
#import "MainViewController.h"

@interface ApplyViewController ()

@end

@implementation ApplyViewController

@synthesize delegate;
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
    self.applyDelegate    = nil;
    self.nameTextField    = nil;
    self.phoneNumTexField = nil;
    self.emailTextField   = nil;
    self.currentTextField = nil;
    self.ExhibitorType    = nil;
    self.ChoseType        = nil;
    self.activity         = nil;
    self.PresentationView = nil;
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
    switch (sender.tag) {
        case 301:{
            
            break;
        }case 302:{
            
            break;
        }
        default:
            break;
    }
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
    NSString *phoneNum = @"10086";// 电话号码
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
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)PressOkButton:(id)sender
{
    [self CheckUserInfoIsCorrect];
}

- (void) CheckUserInfoIsCorrect
{
    if ([self TheUserInfoIsEmpty:self.nameTextField]) {
        
    }else if([self TheUserInfoIsEmpty:self.phoneNumTexField] ){
        
    }else if([self TheUserInfoIsEmpty:self.emailTextField]){
        
    }else if(!self.ChoseType || [self.ChoseType isEqualToString:@""]){
        
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

- (void)CheckAPropertyIsCorrectWithType:(PresentationType)_type
{
    
}

- (void)presentationShow:(PresentationType)type
{
    if (type == NameIsEmpty) {
        UILabel *namePresentation = [[UILabel alloc]initWithFrame:CGRectMake(self.nameTextField.frame.origin.x, self.nameTextField.frame.origin.y + self.nameTextField.frame.size.height, self.nameTextField.frame.size.width, 20)];
        namePresentation.tag = 401;
        namePresentation.textAlignment = NSTextAlignmentCenter;
        namePresentation.text          = @"*请检查你的姓名是否为空*";
        [self.view addSubview:namePresentation];
    }else if(type == PhoneNumIsEmpty){
        UILabel *PhonePresentation = [[UILabel alloc]initWithFrame:CGRectMake(self.nameTextField.frame.origin.x, self.nameTextField.frame.origin.y + self.nameTextField.frame.size.height, self.nameTextField.frame.size.width, 20)];
        PhonePresentation.tag = 401;
        PhonePresentation.textAlignment = NSTextAlignmentCenter;
        PhonePresentation.text          = @"*请检查你的姓名是否为空*";
        [self.view addSubview:PhonePresentation];
    }else if(type == EmailIsEmpty){
        UILabel *emailPresentation = [[UILabel alloc]initWithFrame:CGRectMake(self.nameTextField.frame.origin.x, self.nameTextField.frame.origin.y + self.nameTextField.frame.size.height, self.nameTextField.frame.size.width, 20)];
        emailPresentation.tag = 401;
        emailPresentation.textAlignment = NSTextAlignmentCenter;
        emailPresentation.text          = @"*请检查你的姓名是否为空*";
        [self.view addSubview:emailPresentation];
    }else{
        
    }
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSLog(@"finished");
    
    NSString *requestResult = [request responseStatusMessage];
    NSRange range = [requestResult rangeOfString:@"404 Not Found"];
    if (range.location == NSNotFound) {
        
        NSInteger responseResult = request.responseStatusCode;
        switch (responseResult) {
            case 200:{
                [Model sharedModel].selectExhibition.status = @"P";
                [[Model sharedModel].appliedExhibitionList addObject:[Model sharedModel].selectExhibition];
                [[PlistProxy sharedPlistProxy]updateAppliedExhibitions];
                /*
                UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"提交成功" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                alertView.tag = 101;
                alertView.delegate = self;
                [alertView show];
                [alertView release];*/
                self.activity.hidden = YES;
                break;
            }case 400:{
                UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"参数错误" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                alertView.tag = 102;
                alertView.delegate = self;
                [alertView show];
                [alertView release];
            }case 500:{
                UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"服务器内部错误" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                alertView.tag = 103;
                alertView.delegate = self;
                [alertView show];
                [alertView release];
                break;
            }
            default:
                break;
        }
    }else {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"报名失败" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
        [alertView release];
    }
    
}

- (void)ApplySuccess
{
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSInteger tag = alertView.tag;
    switch (tag) {
        case 101:{
            if (self.delegate) {
                [self dismissViewControllerAnimated:YES completion:^{
                    [self.delegate ApplyViewApplySuccess];
                }];
            }else if(self.applyDelegate){
                [self dismissViewControllerAnimated:YES completion:^{
                    [self.applyDelegate ApplyViewApplySuccess];
                }];
            }else
                [self dismissViewControllerAnimated:YES completion:nil];
            break;
        }case 102:{
            
            break;
        }case 103:{
            
            break;
        }
        default:
            break;
    }
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSLog(@"Failed");
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
