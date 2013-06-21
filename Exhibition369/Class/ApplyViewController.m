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

@synthesize exhibitionImage;
@synthesize exhibitionTitle;
@synthesize statusArray;
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
    self.exhibitionImage  = nil;
    self.exhibitionTitle  = nil;
    self.statusArray      = nil;
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
    [self SetApplyStatus:@"start"];
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

- (void)SetApplyStatus:(NSString*)Status
{
    if ([Status isEqualToString:@"N"]) {
        for (UIImageView *e in self.statusArray) {
            e.highlighted = NO;
        }
    }else if ([Status isEqualToString:@"P"]) {
        for (int i = 0; i<5; i++) {
            UIImageView *e = [self.statusArray objectAtIndex:i];
            if (i < 3) {
                e.highlighted = YES;
            }
        }
    }else if ([Status isEqualToString:@"A"]) {
        for (UIImageView *e in self.statusArray) {
            e.highlighted = YES;
        }
    }else if ([Status isEqualToString:@"D"]) {
        for (UIImageView *e in self.statusArray) {
            e.highlighted = YES;
        }
    }else {
        for (int i = 0; i<5; i++) {
            UIImageView *e = [self.statusArray objectAtIndex:i];
            if (i == 0) {
                e.highlighted = YES;
            }
        }
    }
}

- (IBAction)PressCancleButton:(id)sender
{
    [self.delegate ApplyViewPressCancleButton];
}

- (IBAction)PressOkButton:(id)sender
{
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
    }
}

- (BOOL)TheUserInfoIsEmpty:(UITextField*)_textField
{
    if (!self.nameTextField.text || [self.nameTextField.text isEqualToString:@""]) {
        return YES;
    }return NO;
}

- (void)initData
{
    [self.exhibitionImage setImage:[Model sharedModel].selectExhibition.icon];
    [self.exhibitionTitle setText:[Model sharedModel].selectExhibition.name];
    self.statusArray = [NSArray arrayWithObjects:[self.view viewWithTag:101],[self.view viewWithTag:102],[self.view viewWithTag:103],[self.view viewWithTag:104],[self.view viewWithTag:105], nil];
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
