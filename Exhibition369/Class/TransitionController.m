//
//  TransitionController.m
//
//  Created by XJones on 11/25/11.
//

#import "TransitionController.h"
#import "Model.h"

@implementation TransitionController

@synthesize containerView = _containerView,
            viewController = _viewController;

- (id)initWithViewController:(UIViewController *)viewController
{
    if (self = [super init]) {
        _viewController = [viewController retain];
    }
    return self;
}

- (void)viewDidLoad {
    self.wantsFullScreenLayout = YES;
    
    [[Model sharedModel] initWithPlist];
    UIView *view = [[[UIView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame] autorelease];
    self.view = view;
    
    _containerView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
    [self.view addSubview:_containerView];
    
    [_containerView addSubview:self.viewController.view];
}

- (void)dealloc {
    [_containerView release];
    [super dealloc];
}

- (void)viewDidUnload {
    _containerView = nil;
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return [self.viewController shouldAutorotateToInterfaceOrientation:interfaceOrientation];
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [self.viewController willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [self.viewController didRotateFromInterfaceOrientation:fromInterfaceOrientation];
}

- (void)transitionToViewController:(UIViewController *)aViewController
                     withOptions:(ViewTrasitionEffect)options
{
    UIViewAnimationOptions newopt;
    NSTimeInterval time = 0.65f;
    
    if(options == ViewTrasitionEffectMoveLeft){
        aViewController.view.frame = CGRectMake(320, 0, 320, 460);
        [self.containerView addSubview:aViewController.view];
        time = 0.3f;
        newopt = UIViewAnimationOptionCurveLinear;
    } else if(options == ViewTrasitionEffectMoveRight){
        aViewController.view.frame = CGRectMake(-320, 0, 320, 460);
        [self.containerView addSubview:aViewController.view];
        time = 0.3f;
        newopt = UIViewAnimationOptionCurveLinear;
    }else {
        newopt = UIViewAnimationOptionTransitionNone;
        aViewController.view.frame = self.containerView.bounds;
    }
    
    [UIView transitionWithView:self.containerView
                      duration:time
                       options:newopt
                    animations:^{
                        if(options == ViewTrasitionEffectMoveLeft){
                            //aViewController.view.frame = CGAffineTransformScale
                            self.viewController.view.frame = CGRectMake(-320, 0, 320, 460);
                            aViewController.view.frame = CGRectMake(0, 0, 320, 460);
                        } else if(options == ViewTrasitionEffectMoveRight){
                            self.viewController.view.frame = CGRectMake(320, 0, 320, 460);
                            aViewController.view.frame = CGRectMake(0, 0, 320, 460);
                        }else {
                            [self.viewController.view removeFromSuperview];
                            [self.containerView addSubview:aViewController.view];
                        }
                        
                    }
                    completion:^(BOOL finished){
                        if(options == ViewTrasitionEffectMoveLeft || options == ViewTrasitionEffectMoveRight){
                            [self.viewController.view removeFromSuperview];
                        }
                        self.viewController = [aViewController retain];
                    }];
}


- (void)displayTip:(NSString *)tip modal:(BOOL)modal
{
    if (!tipViewController)
    {
        tipViewController = [[TipViewController alloc] init];
        tipViewController.view.center = self.view.center;
    }
    
    [self.view addSubview:tipViewController.view];
    tipViewController.textLabel.text = tip;
    tipViewController.view.alpha = 0;
    
    if (modal)
    {
        //overlayViewController.view.hidden = NO;
    }
    
    [UIView animateWithDuration:0.5
					 animations:^ {
						 tipViewController.view.alpha = 1;
                         //if (modal) overlayViewController.mask.alpha = ModalOpacity;
					 }
					 completion:^(BOOL finished) {
                         [self performSelector:@selector(hideTip:)
                                    withObject:[NSNumber numberWithBool:modal]
                                    afterDelay:1];
					 }];
}

- (void)hideTip:(NSNumber *)modal
{
    [UIView animateWithDuration:1
                     animations:^ {
                         tipViewController.view.alpha = 0;
                     }
                     completion:^(BOOL finished) {
                     }];
}

@end
