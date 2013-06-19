//
//  BaseUIViewController.h
//  Exhibition369
//
//  Created by Jack Wang on 6/18/13.
//  Copyright (c) 2013 MobilyDaily. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"

typedef NS_OPTIONS(NSUInteger, RequestMethod) {
    RequestMethodGET                       = 1 << 0,
    RequestMethodPOST                      = 1 << 1,
};

@interface BaseUIViewController : UIViewController<ASIHTTPRequestDelegate>{
    BOOL loadingData;
}
@property (nonatomic, retain) ASIHTTPRequest*theRequest;


- (void)sendRequestWith:(NSString *)url params:(NSMutableDictionary *)params method:(RequestMethod)method;
- (void)requestFinished:(ASIHTTPRequest *)request;
- (void)requestFailed:(ASIHTTPRequest *)request;
- (void)showLoadingIndicator;
- (void)hideLoadingIndicator;
@end
