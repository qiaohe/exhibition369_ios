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

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        loadingData = NO;
    }
    return self;
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
        [request startAsynchronous];
        loadingData = YES;
        [self showLoadingIndicator];
    }else if (method == RequestMethodPOST){
        
        NSURL *nsurl = [NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        
        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:nsurl];
        [request setTimeOutSeconds:60];
        request.delegate = self;
        NSArray *keyArray = [params allKeys];
        for (int i = 0; i<[keyArray count]; i++) {
            [request setPostValue:[params objectForKey:[keyArray objectAtIndex:i]] forKey:[keyArray objectAtIndex:i]];
        }
        
        [request startAsynchronous];
        loadingData = YES;
        [self showLoadingIndicator];
    }
}

-(void)sendRequestWith:(NSString *)url params:(NSMutableDictionary *)params method:(RequestMethod)method requestUserInfo:(NSDictionary*)UserInfo
{
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
        request.userInfo = UserInfo;
        [request setTimeOutSeconds:60];
        request.delegate = self;
        [request startAsynchronous];
        loadingData = YES;
        [self showLoadingIndicator];
    }else if (method == RequestMethodPOST){
        
        NSURL *nsurl = [NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        
        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:nsurl];
        request.userInfo = UserInfo;
        [request setTimeOutSeconds:60];
        request.delegate = self;
        NSArray *keyArray = [params allKeys];
        for (int i = 0; i<[keyArray count]; i++) {
            [request setPostValue:[params objectForKey:[keyArray objectAtIndex:i]] forKey:[keyArray objectAtIndex:i]];
        }
        
        [request startAsynchronous];
        loadingData = YES;
        [self showLoadingIndicator];
    }
}

-(void) showLoadingIndicator{
    
    //TODO need implement this function in subview
}

-(void) hideLoadingIndicator{
    
    //TODO need implement this function in subview
}


#pragma mark - ASIHTTPRequestDelegate  default handler
- (void)requestFinished:(ASIHTTPRequest *)request
{
    loadingData = NO;
    [self hideLoadingIndicator];
    //NSString *responseString = [request responseString];
    
    //NSLog(@"Request Finished: %@", responseString);
    
    
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    loadingData = NO;
    [self hideLoadingIndicator];
    //NSLog(@"Request Failed: %@", request.error);
}


@end
