//
//  LoadingMoreTableFooterView.m
//  Exhibition369
//
//  Created by Jack Wang on 6/29/13.
//  Copyright (c) 2013 MobilyDaily. All rights reserved.
//

#import "LoadingMoreTableFooterView.h"

#define TEXT_COLOR	 [UIColor colorWithRed:87.0/255.0 green:108.0/255.0 blue:137.0/255.0 alpha:1.0]
#define FLIP_ANIMATION_DURATION 0.18f

@implementation LoadingMoreTableFooterView
@synthesize delegate = _delegate;
@synthesize haveMoreData = _haveMoreData;
@synthesize isLoading = _isLoading;

- (id)initWithFrame:(CGRect)frame
{
    _isLoading = NO;
    _haveMoreData = YES;
    //return [self initWithFrame:frame textColor:TEXT_COLOR];
    return [self initWithFrame:frame arrowImageName:@"blueArrow.png" textColor:TEXT_COLOR];
}

- (id)initWithFrame:(CGRect)frame arrowImageName:(NSString *)arrow textColor:(UIColor *)textColor  {
    if((self = [super initWithFrame:frame])){
/*- (id)initWithFrame:(CGRect)frame textColor:(UIColor *)textColor  {
        if((self = [super initWithFrame:frame])) {
		
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        
		UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, frame.size.height - 30.0f, self.frame.size.width, 20.0f)];
		label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		label.font = [UIFont systemFontOfSize:12.0f];
		label.textColor = textColor;
		label.shadowColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
		label.shadowOffset = CGSizeMake(0.0f, 1.0f);
		label.backgroundColor = [UIColor clearColor];
		label.textAlignment = NSTextAlignmentCenter;
        label.text = @"加载更多展会";
		[self addSubview:label];
		_loadingMoreLabel=label;
		[label release];
        
        
        UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(-50.0f, frame.size.height - 30.0f, self.frame.size.width, 20.0f)];
        [self addSubview:indicator];
        [indicator setColor:textColor];
        _loadingIndicator = indicator;
        [indicator release];
		
    }
	
    return self;*/
    
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.backgroundColor = [UIColor colorWithRed:226.0/255.0 green:231.0/255.0 blue:237.0/255.0 alpha:1.0];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, frame.size.height - 30.0f, self.frame.size.width, 20.0f)];
        label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        label.font = [UIFont systemFontOfSize:12.0f];
        label.textColor = textColor;
        label.shadowColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
        label.shadowOffset = CGSizeMake(0.0f, 1.0f);
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:label];
        _lastUpdatedLabel=label;
        [label release];
        
        label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, frame.size.height - 48.0f, self.frame.size.width, 20.0f)];
        label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        label.font = [UIFont boldSystemFontOfSize:13.0f];
        label.textColor = textColor;
        label.shadowColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
        label.shadowOffset = CGSizeMake(0.0f, 1.0f);
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:label];
        _statusLabel=label;
        [label release];
        
        CALayer *layer = [CALayer layer];
        layer.frame = CGRectMake(25.0f, frame.size.height - 65.0f, 30.0f, 55.0f);
        layer.contentsGravity = kCAGravityResizeAspect;
        layer.contents = (id)[UIImage imageNamed:arrow].CGImage;
        
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 40000
        if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
            layer.contentsScale = [[UIScreen mainScreen] scale];
        }
#endif
        
        [[self layer] addSublayer:layer];
        _arrowImage.transform = CATransform3DMakeRotation((M_PI / 180.0) * 180.0f, 0.0f, 0.0f, 1.0f);
        _arrowImage=layer;
        
        UIActivityIndicatorView *view = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        view.frame = CGRectMake(25.0f, frame.size.height - 38.0f, 20.0f, 20.0f);
        
        [self addSubview:view];
        _activityView = view;
        [view release];
        
        
        [self setState:LoadingMoreNormal];
        
    }

    return self;
	
}


- (void)setState:(LoadingMoreState)aState{
	
	switch (aState) {
		case LoadingMorePullingUp:
			
			_statusLabel.text = NSLocalizedString(@"放手加载更多展会", @"放手加载更多展会");
			[CATransaction begin];
			[CATransaction setAnimationDuration:FLIP_ANIMATION_DURATION];
			_arrowImage.transform = CATransform3DIdentity;
			[CATransaction commit];
			
			break;
		case LoadingMoreNormal:
			
			if (_state == LoadingMorePullingUp) {
				[CATransaction begin];
				[CATransaction setAnimationDuration:FLIP_ANIMATION_DURATION];
				_arrowImage.transform = CATransform3DMakeRotation((M_PI / 180.0) * 180.0f, 0.0f, 0.0f, 1.0f);
				[CATransaction commit];
			}
			
			_statusLabel.text = NSLocalizedString(@"上拉加载更多展会", @"上拉加载更多展会");
			[_activityView stopAnimating];
			[CATransaction begin];
			[CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
			_arrowImage.hidden = NO;
			_arrowImage.transform = CATransform3DMakeRotation((M_PI / 180.0) * 180.0f, 0.0f, 0.0f, 1.0f);
			[CATransaction commit];
			
			//[self refreshLastUpdatedDate];
			
			break;
		case LoadingMoreLoading:
			
			_statusLabel.text = NSLocalizedString(@"加载中...", @"加载中...");
			[_activityView startAnimating];
			[CATransaction begin];
			[CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
			_arrowImage.hidden = YES;
			[CATransaction commit];
			
			break;
		default:
			break;
	}
	
	_state = aState;
}


- (void)loadingMoreTableScrollViewDidScroll:(UIScrollView *)scrollView{
    if (_state == LoadingMoreLoading) {
		
		CGFloat offset = MAX(scrollView.contentOffset.y * -1, 0);
		offset = MIN(offset, 60);
		scrollView.contentInset = UIEdgeInsetsMake(offset, 0.0f, 0.0f, 0.0f);
		
	} else if (scrollView.isDragging) {
		
        if (_haveMoreData && !_isLoading && _state == LoadingMorePullingUp) {
            if(([scrollView contentOffset].y + scrollView.frame.size.height <= [scrollView contentSize].height + 40 && scrollView.frame.size.height < [scrollView contentSize].height - 40) || (scrollView.frame.size.height >= [scrollView contentSize].height && [scrollView contentOffset].y <= 40))
                [self setState:LoadingMoreNormal];
		}
		else if (_haveMoreData && !_isLoading && _state == LoadingMoreNormal) {
            if(([scrollView contentOffset].y + scrollView.frame.size.height > [scrollView contentSize].height + 40 && scrollView.frame.size.height < [scrollView contentSize].height) || (scrollView.frame.size.height >= [scrollView contentSize].height && [scrollView contentOffset].y > 40))
                [self setState:LoadingMorePullingUp];
		}
	}
}

- (void)loadingMoreTableScrollViewDidEndDragging:(UIScrollView *)scrollView {
	
	if (_haveMoreData && !_isLoading) {
        
        if(([scrollView contentOffset].y + scrollView.frame.size.height > [scrollView contentSize].height + 40 && scrollView.frame.size.height < [scrollView contentSize].height) || (scrollView.frame.size.height >= [scrollView contentSize].height && [scrollView contentOffset].y > 40)){
            if ([_delegate respondsToSelector:@selector(didTriggerLoadingMore:)]) {
                [_delegate didTriggerLoadingMore:self];
            }
            
            [self setState:LoadingMoreLoading];
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:0.2];
            scrollView.contentInset = UIEdgeInsetsMake(60.0f, 0.0f, 0.0f, 0.0f);
            [UIView commitAnimations];
        }
	}
	
}

- (void)loadingMoreTableDataSourceDidFinishedLoading:(UIScrollView *)scrollView{
    _isLoading = NO;
    if(_state == LoadingMoreLoading){
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:.3];
        [scrollView setContentInset:UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f)];
        [UIView commitAnimations];
        
        [self setState:LoadingMoreNormal];
    }
}
@end
