#import "RNNBasePresenter.h"
#import "UIViewController+RNNOptions.h"
#import "RNNTabBarItemCreator.h"
#import "RNNReactComponentRegistry.h"
#import "UIViewController+LayoutProtocol.h"
#import "DotIndicatorOptions.h"
#import "RCTConvert+Modal.h"
#import "BottomTabPresenterCreator.h"

@interface RNNBasePresenter ()
@property(nonatomic, strong) BottomTabPresenter* bottomTabPresenter;
@end
@implementation RNNBasePresenter

- (instancetype)initWithDefaultOptions:(RNNNavigationOptions *)defaultOptions {
    self = [super init];
    _defaultOptions = defaultOptions;
    _bottomTabPresenter = [BottomTabPresenterCreator createWithDefaultOptions:self.defaultOptions];
    return self;
}

- (instancetype)initWithComponentRegistry:(RNNReactComponentRegistry *)componentRegistry defaultOptions:(RNNNavigationOptions *)defaultOptions {
    self = [self initWithDefaultOptions:defaultOptions];
    _componentRegistry = componentRegistry;
    return self;
}

- (void)bindViewController:(UIViewController *)boundViewController {
    self.boundComponentId = boundViewController.layoutInfo.componentId;
    _boundViewController = boundViewController;
    _bottomTabPresenter.boundViewController = boundViewController;
}

- (void)setDefaultOptions:(RNNNavigationOptions *)defaultOptions {
    _defaultOptions = defaultOptions;
}

- (void)componentDidAppear {
    
}

- (void)componentDidDisappear {
    
}

- (void)applyOptionsOnInit:(RNNNavigationOptions *)initialOptions {
    UIViewController* viewController = self.boundViewController;
    RNNNavigationOptions *withDefault = [initialOptions withDefault:[self defaultOptions]];
    [viewController setModalPresentationStyle:[RCTConvert UIModalPresentationStyle:[withDefault.modalPresentationStyle getWithDefaultValue:@"default"]]];
    [viewController setModalTransitionStyle:[RCTConvert UIModalTransitionStyle:[withDefault.modalTransitionStyle getWithDefaultValue:@"coverVertical"]]];
    
    if (@available(iOS 13.0, *)) {
        viewController.modalInPresentation = ![withDefault.modal.swipeToDismiss getWithDefaultValue:YES];
    }
	
	UIApplication.sharedApplication.delegate.window.backgroundColor = [withDefault.window.backgroundColor getWithDefaultValue:nil];
}

- (void)applyOptionsOnViewDidLayoutSubviews:(RNNNavigationOptions *)options {

}

- (void)applyOptionsOnWillMoveToParentViewController:(RNNNavigationOptions *)options {
    [_bottomTabPresenter applyOptionsOnWillMoveToParentViewController:options];
}

- (void)applyOptions:(RNNNavigationOptions *)options {
    [_bottomTabPresenter applyOptions:options];
}

- (void)mergeOptions:(RNNNavigationOptions *)options resolvedOptions:(RNNNavigationOptions *)resolvedOptions {
    UIViewController* viewController = self.boundViewController;
    RNNNavigationOptions* withDefault = (RNNNavigationOptions *) [[resolvedOptions withDefault:_defaultOptions] overrideOptions:options];
    
    [_bottomTabPresenter mergeOptions:options resolvedOptions:resolvedOptions];
	
	if (options.window.backgroundColor.hasValue) {
		UIApplication.sharedApplication.delegate.window.backgroundColor = withDefault.window.backgroundColor.get;
	}
}

- (void)renderComponents:(RNNNavigationOptions *)options perform:(RNNReactViewReadyCompletionBlock)readyBlock {
    if (readyBlock) {
        readyBlock();
        readyBlock = nil;
    }
}

- (void)viewDidLayoutSubviews {

}

- (void)applyDotIndicator:(UIViewController *)child {
    [_bottomTabPresenter applyDotIndicator:child];
}

- (UIStatusBarStyle)getStatusBarStyle:(RNNNavigationOptions *)resolvedOptions {
    RNNNavigationOptions *withDefault = [resolvedOptions withDefault:[self defaultOptions]];
    NSString* statusBarStyle = [withDefault.statusBar.style getWithDefaultValue:@"default"];
    if ([statusBarStyle isEqualToString:@"light"]) {
        return UIStatusBarStyleLightContent;
    } else if (@available(iOS 13.0, *)) {
        if ([statusBarStyle isEqualToString:@"dark"]) {
            return UIStatusBarStyleDarkContent;
        } else {
            return UIStatusBarStyleDefault;
        }
    } else {
        return UIStatusBarStyleDefault;
    }
}

- (UIInterfaceOrientationMask)getOrientation:(RNNNavigationOptions *)options {
    return [options withDefault:[self defaultOptions]].layout.supportedOrientations;
}

- (BOOL)isStatusBarVisibility:(UINavigationController *)stack resolvedOptions:(RNNNavigationOptions *)resolvedOptions {
    RNNNavigationOptions *withDefault = [resolvedOptions withDefault:[self defaultOptions]];
    if (withDefault.statusBar.visible.hasValue) {
        return ![withDefault.statusBar.visible get];
    } else if ([withDefault.statusBar.hideWithTopBar getWithDefaultValue:NO]) {
        return stack.isNavigationBarHidden;
    }
    return NO;
}


@end
