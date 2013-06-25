//
//  ApplyViewController.m
//  Exhibition369
//
//  Created by M J on 13-6-19.
//  Copyright (c) 2013年 MobilyDaily. All rights reserved.
//

#import "ApplyViewController.h"

@interface ApplyViewController ()

@end

@implementation ApplyViewController

@synthesize nameTextField;
@synthesize phoneNumTexField;
@synthesize emailTextField;
@synthesize OldFrame;
@synthesize KeyboardFrame;
@synthesize currentTextField;

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
    self.nameTextField    = nil;
    self.phoneNumTexField = nil;
    self.emailTextField   = nil;
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
    

    [self initData];
    // Do any additional setup after loading the view from its nib.
}

- (void)keyboardDidShow:(NSNotification*)notification
{
    NSDictionary *userInfo = [notification userInfo];
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    NSLog(@"keyboard Height = %f",keyboardRect.size.height);
    
    if ([self.nameTextField isFirstResponder]) {
        NSLog(@"name");
        self.currentTextField = self.nameTextField;
    }if ([self.phoneNumTexField isFirstResponder]) {
        NSLog(@"phone");
        self.currentTextField = self.phoneNumTexField;
    }if ([self.emailTextField isFirstResponder]) {
        NSLog(@"email");
        self.currentTextField = self.emailTextField;
    }
    float YPath = [self YPathForTextFeild:self.currentTextField KeyBoardRect:keyboardRect];
    NSLog(@"YPath = %f",YPath);
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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.OldFrame = self.view.frame;
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"touchBegan");
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
        phoneCallWebView = [[UIWebView alloc] initWithFrame:CGRectZero];
    }
    
    [phoneCallWebView loadRequest:[NSURLRequest requestWithURL:phoneURL]];
    [phoneCallWebView release];
}


- (IBAction)PressCancleButton:(id)sender
{
    //[self.delegate ApplyViewPressCancleButton];
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)PressOkButton:(id)sender
{
    /*
    NSLog(@"OK");
    if ([self TheUserInfoIsEmpty:self.nameTextField] || [self TheUserInfoIsEmpty:self.phoneNumTexField] || [self TheUserInfoIsEmpty:self.emailTextField]) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"信息不能为空，请检查你的信息" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
        [alertView release];
    }else{
        NSString *urlString = [ServerURL stringByAppendingFormat:@"/rest/applies/put"];
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:[Model sharedModel].selectExhibition.exKey, @"exKey",
                                       [Model sharedModel].systemConfig.token,     @"token",
                                       self.nameTextField.text,                @"name",
                                       self.phoneNumTexField.text,                @"mobile",
                                       self.emailTextField.text,           @"email",
                                       nil];
        
        NSLog(@"url = %@",urlString);
        [self.delegate ApplyRequestWithURL:urlString Params:params Method:RequestMethodPOST];
    }*/
    NSString *urlString = [ServerURL stringByAppendingString:@"/rest/applies/put"];
    NSLog(@"url = %@",urlString);
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:[Model sharedModel].selectExhibition.exKey, @"exKey",
                                                                                    [Model sharedModel].systemConfig.token,     @"token",
                                                                                    self.nameTextField.text,                    @"name",
                                                                                    self.phoneNumTexField.text,                 @"mobile",
                                                                                    self.emailTextField.text,                   @"email",
                                                                                    nil];
    NSArray *paramArray = [params allKeys];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:urlString]];
    request.delegate = self;
    request.postFormat = ASIURLEncodedPostFormat;
    for (NSString *key in paramArray) {
        [request setPostValue:[params objectForKey:key] forKey:key];
    }
    [request startAsynchronous];
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSLog(@"finished");
    
    NSLog(@"responseString = %@",[request responseStatusMessage]);
    NSString *requestResult = [request responseStatusMessage];
    NSRange range = [requestResult rangeOfString:@"404 Not Found"];
    if (range.location == NSNotFound) {
        
        NSInteger responseResult = request.responseStatusCode;
        switch (responseResult) {
            case 200:{
                 [Model sharedModel].selectExhibition.status = @"P";
                 [[Model sharedModel].appliedExhibitionList addObject:[Model sharedModel].selectExhibition];
                 [[PlistProxy sharedPlistProxy]updateAppliedExhibitions];
                break;
            }case 400:{
                UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"参数错误" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alertView show];
                [alertView release];
            }case 500:{
                UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"服务器内部错误" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
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

- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSLog(@"Failed");
}

- (BOOL)TheUserInfoIsEmpty:(UITextField*)_textField
{
    if (!self.nameTextField.text || [self.nameTextField.text isEqualToString:@""]) {
        return YES;
    }return NO;
}

- (void)initData
{
    
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
