//
//  BaseUIViewController.m
//  Exhibition369
//
//  Created by Jack Wang on 6/18/13.
//  Copyright (c) 2013 MobilyDaily. All rights reserved.
//

#import "BaseUIViewController.h"

@interface BaseUIViewController ()

@end

@implementation BaseUIViewController

@synthesize refreshHeaderView;
@synthesize reloading;
@synthesize loadingMoreFooterView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        loadingData = NO;
    }
    return self;
}

- (void)dealloc
{
    [self.theRequest            release];
    [self.refreshHeaderView     release];
    [self.loadingMoreFooterView release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)sendRequestWith:(NSString *)url params:(NSMutableDictionary *)params method:(RequestMethod)method{
    [self sendRequestWith:url params:params method:method userInfo:NULL];
}

-(void)sendRequestWith:(NSString *)url params:(NSMutableDictionary *)params method:(RequestMethod)method userInfo:(NSDictionary *)userInfo{
    if(method == RequestMethodGET){
        NSString *urlprams = @"";
        for (id keys in params) {
            urlprams = [urlprams stringByAppendingFormat:@"%@=%@&",keys,[params objectForKey:keys]];
        }
        
        if(![urlprams isEqualToString:@""]){
            url = [url stringByAppendingFormat:@"?%@",urlprams];
        }
        
        NSURL *nsurl = [NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        
        
        ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:nsurl];
        [request setTimeOutSeconds:60];
        request.delegate = self;
        if(userInfo != NULL)
            [request setUserInfo:userInfo];
        [request startAsynchronous];
        loadingData = YES;
        [self showLoadingIndicator];
    }else if (method == RequestMethodPOST){
        
        NSURL *nsurl = [NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        
        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:nsurl];
        [request setTimeOutSeconds:60];
        request.delegate = self;
        if(userInfo != NULL)
            [request setUserInfo:userInfo];
        NSArray *keyArray = [params allKeys];
        for (int i = 0; i<[keyArray count]; i++) {
            [request setPostValue:[params objectForKey:[keyArray objectAtIndex:i]] forKey:[keyArray objectAtIndex:i]];
        }
        
        [request startAsynchronous];
        loadingData = YES;
        [self showLoadingIndicator];
    }
}

-(void)sendRequestWith:(NSString *)url params:(NSMutableDictionary *)params method:(RequestMethod)method requestTag:(int)requestTag{
    
    if(method == RequestMethodGET){
        NSString *urlprams = @"";
        for (id keys in params) {
            urlprams = [urlprams stringByAppendingFormat:@"%@=%@&",keys,[params objectForKey:keys]];
        }
        
        if(![urlprams isEqualToString:@""]){
            url = [url stringByAppendingFormat:@"?%@",urlprams];
        }
        
        NSURL *nsurl = [NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        
        
        ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:nsurl];
        [request setTimeOutSeconds:60];
        request.delegate = self;
        request.tag = requestTag;
        [request startAsynchronous];
        loadingData = YES;
        [self showLoadingIndicator];
    }else if (method == RequestMethodPOST){
        
        NSURL *nsurl = [NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        
        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:nsurl];
        [request setTimeOutSeconds:60];
        request.delegate = self;
        request.tag = requestTag;
        NSArray *keyArray = [params allKeys];
        for (int i = 0; i<[keyArray count]; i++) {
            [request setPostValue:[params objectForKey:[keyArray objectAtIndex:i]] forKey:[keyArray objectAtIndex:i]];
        }
        
        [request startAsynchronous];
        loadingData = YES;
        [self showLoadingIndicator];
    }
    
}

-(void)sendRequestWith:(ASIHTTPRequest*)request
{
    request.delegate = self;
    [request startAsynchronous];
    loadingData = YES;
    [self showLoadingIndicator];
}

-(void) showLoadingIndicator{
    
    //TODO need implement this function in subview
}

-(void) hideLoadingIndicator{
    
    //TODO need implement this function in subview
}

- (UIColor *)getColor:(NSString *)stringToConvert
{
    NSString *cString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    // String should be 6 or 8 characters
    
    if ([cString length] < 6) return [UIColor blackColor];
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"]) cString = [cString substringFromIndex:1];
    if ([cString length] != 6) return [UIColor blackColor];
    
    // Separate into r, g, b substrings
    
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    // Scan values
    unsigned int r, g, b;
    
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}


#pragma mark - ASIHTTPRequestDelegate  default handler
- (void)requestFinished:(ASIHTTPRequest *)request
{
    loadingData = NO;
    [self hideLoadingIndicator];
    //NSString *responseString = [request responseString];
    
    //NSLog(@"Request Finished: %@", responseString);
    
    [self done:request];
    
    
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    loadingData = NO;
    [self hideLoadingIndicator];
    //NSLog(@"Request Failed: %@", request.error);
}

- (void)done:(ASIHTTPRequest *)request
{
    //handler by children
}

- (void)error:(ASIHTTPRequest *)request
{
    //handler by children
    [self error:request];
}


@end
