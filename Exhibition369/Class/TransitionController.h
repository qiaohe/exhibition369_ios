//
//  TransitionController.h
//
//  Created by XJones on 11/25/11.
//

#import <UIKit/UIKit.h>
#import "TipViewController.h"
#import "BaseUIViewController.h"

typedef NS_OPTIONS(NSUInteger, ViewTrasitionEffect) {
    ViewTrasitionEffectNone                = 1 << 0,
    ViewTrasitionEffectFadeIn              = 1 << 1,
    ViewTrasitionEffectMoveLeft            = 1 << 2,
    ViewTrasitionEffectMoveRight           = 1 << 3,
    ViewTrasitionEffectFlip                = 1 << 4,
};


@interface TransitionController : BaseUIViewController {
    TipViewController *tipViewController;
}

@property (nonatomic, retain) IBOutlet UIView *                containerView;
@property (nonatomic, retain) IBOutlet UIViewController *      viewController;

- (id)initWithViewController:(UIViewController *)viewController;
- (void)transitionToViewController:(UIViewController *)aViewController
                       withOptions:(ViewTrasitionEffect)options;

- (void)displayTip:(NSString *)tip modal:(BOOL)modal;

@end
