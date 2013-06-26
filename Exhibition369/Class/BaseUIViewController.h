//
//  BaseUIViewController.h
//  Exhibition369
//
//  Created by Jack Wang on 6/18/13.
//  Copyright (c) 2013 MobilyDaily. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "ASINetworkQueue.h"
#import <QuartzCore/QuartzCore.h>

typedef enum{
    RequestGlobalInformation = 0,                   //获取全局信息
    RequestCreateOrAmend,                           //获取创建或修改展会信息
    RequestDelete,                                  //获取delete展会返回信息
    RequestExhibitionList,                          //获取展会列表
    RequestSignUp,                                  //获取已报名展会信息
    RequestNewsCreateOrAmend,                       //获取创建或修改展会新闻返回信息
    RequestNewsDelete,                              //获取删除新闻返回信息
    RequestNewsList,                                //获取新闻列表
    RequestNews,                                    //获取新闻content
    RequestApply,                                   //获取展会报名返回信息
    RequestApplyResult,                             //获取展会审批结果信息
    RequestApplyState,                              //获取展会审核状态
    RequestQRCode,                                  //获取二维码
    RequestSendMessage,                             //展会消息发送
    RequestPhoneMessageList,                        //获取手机消息列表
    RequestHasReadMessage,                          //消息已读回执
    RequestNewsIcon,                                //新闻图标
    RequestContent,                                 //新闻内容
}RequestType;

typedef NS_OPTIONS(NSUInteger, RequestMethod) {
    RequestMethodGET                       = 1 << 0,
    RequestMethodPOST                      = 1 << 1,
};

@interface BaseUIViewController : UIViewController<ASIHTTPRequestDelegate>{
    BOOL loadingData;
}
@property (nonatomic, retain) ASIHTTPRequest*theRequest;


- (void)sendRequestWith:(NSString *)url params:(NSMutableDictionary *)params method:(RequestMethod)method;
-(void)sendRequestWith:(NSString *)url params:(NSMutableDictionary *)params method:(RequestMethod)method request:(ASIHTTPRequest*)request;
- (void)requestFinished:(ASIHTTPRequest *)request;
- (void)requestFailed:(ASIHTTPRequest *)request;
- (void)showLoadingIndicator;
- (void)hideLoadingIndicator;
- (UIColor *)getColor:(NSString *)stringToConvert;

@end
