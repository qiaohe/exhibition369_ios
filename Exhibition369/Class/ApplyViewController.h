//
//  ApplyViewController.h
//  Exhibition369
//
//  Created by M J on 13-6-19.
//  Copyright (c) 2013年 MobilyDaily. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ApplyView.h"
#import <Foundation/Foundation.h>

@class MainViewController;

typedef enum{
    NameIsEmpty,
    PhoneNumIsNotValidate,
    EmailIsNotValidate,
    NotChoseType,
}PresentationType;

@protocol ApplyRequestDelegate <NSObject>

- (void) ApplyRequestWithURL:(NSString*)URL Params:(NSMutableDictionary*)dic Method:(RequestMethod)method;
- (void) ApplyViewApplySuccess;

@end


@interface ApplyViewController : BaseUIViewController<UITextFieldDelegate,UIWebViewDelegate>

@property (nonatomic, assign) id <ApplyRequestDelegate>        delegate;
@property (nonatomic, retain) MainViewController               *mainViewDelegate;
@property (nonatomic, retain) IBOutlet UITextField             *nameTextField;
@property (nonatomic, retain) IBOutlet UITextField             *phoneNumTexField;
@property (nonatomic, retain) IBOutlet UITextField             *emailTextField;
@property (nonatomic, assign) CGRect                           OldFrame;
@property (nonatomic, assign) CGRect                           KeyboardFrame;
@property (nonatomic, retain) UITextField                      *currentTextField;
@property (nonatomic, retain) NSMutableArray                   *ExhibitorType;
@property (nonatomic, retain) NSString                         *ChoseType;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *activity;
@property (nonatomic, retain) UIView                           *PresentationView;
@property (nonatomic, retain) UILabel                          *nameError;
@property (nonatomic, retain) UILabel                          *phoneNumError;
@property (nonatomic, retain) UILabel                          *emailError;
@property (nonatomic, retain) UILabel                          *noChooseType;

- (IBAction)PressCancleButton:(id)sender;
- (IBAction)PressOkButton:(id)sender;
- (IBAction)PressPhoneButton:(id)sender;
- (IBAction)SetExhibitorType:(UIButton*)sender;

@end
