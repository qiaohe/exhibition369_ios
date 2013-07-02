//
//  LoadingMoreTableFooterView.h
//  Exhibition369
//
//  Created by Jack Wang on 6/29/13.
//  Copyright (c) 2013 MobilyDaily. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

typedef enum{
	LoadingMorePullingUp = 0,
	LoadingMoreNormal,
	LoadingMoreLoading,
} LoadingMoreState;

@protocol LoadingMoreTableFooterDelegate;
@interface LoadingMoreTableFooterView : UIView{
    /*UILabel *_loadingMoreLabel;
    UIActivityIndicatorView *_loadingIndicator;*/
    
    LoadingMoreState _state;
    
	UILabel *_lastUpdatedLabel;
	UILabel *_statusLabel;
	CALayer *_arrowImage;
	UIActivityIndicatorView *_activityView;
}

@property(nonatomic,assign) id <LoadingMoreTableFooterDelegate> delegate;
@property(nonatomic) BOOL haveMoreData;
@property(nonatomic) BOOL isLoading;

- (id)initWithFrame:(CGRect)frame arrowImageName:(NSString *)arrow textColor:(UIColor *)textColor;
- (void)loadingMoreTableScrollViewDidScroll:(UIScrollView *)scrollView;
- (void)loadingMoreTableScrollViewDidEndDragging:(UIScrollView *)scrollView;
- (void)loadingMoreTableDataSourceDidFinishedLoading:(UIScrollView *)scrollView;
- (void)setState:(LoadingMoreState)aState;

@end

@protocol LoadingMoreTableFooterDelegate<NSObject>
- (void)didTriggerLoadingMore:(LoadingMoreTableFooterView*)view;
@end