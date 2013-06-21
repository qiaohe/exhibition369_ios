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

@protocol RequestDelegate <NSObject>

- (void) RequestWithURL:(NSString*)URL Params:(NSMutableDictionary*)dic Method:(RequestMethod)method;
- (void) AppliedExhibition;

@end

@interface ApplyView : UIView{
    
}

@property (nonatomic, retain) NSString    *title;
@property (nonatomic, assign) id <RequestDelegate> delegate;
@property (nonatomic, retain) UILabel     *userNameLabel;
@property (nonatomic, retain) UITextField *userNameTextField;
@property (nonatomic, retain) UILabel     *phoneNumLabel;
@property (nonatomic, retain) UITextField *phoneNumTextField;
@property (nonatomic, retain) UILabel     *emailAddressLabel;
@property (nonatomic, retain) UITextField *emailAddressLTextField;

- (id)initWithFrame:(CGRect)frame andDelegate:(id)_delegate;

@end
