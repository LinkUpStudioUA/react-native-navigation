#import <UIKit/UIKit.h>
#import "RNNEventEmitter.h"
#import "RNNLayoutProtocol.h"

typedef void (^RNNReactViewReadyCompletionBlock)(void);

@interface UIViewController (LayoutProtocol) <RNNLayoutProtocol>

- (void)render;

- (UIViewController *)getCurrentChild;

- (UIViewController *)presentedComponentViewController;

- (UIViewController *)topMostViewController;

- (void)mergeOptions:(RNNNavigationOptions *)options;

- (void)mergeChildOptions:(RNNNavigationOptions *)options child:(UIViewController *)child;

- (UINavigationController *)stack;

- (RNNNavigationOptions *)resolveOptions;

- (RNNNavigationOptions *)resolveOptionsWithDefault;

- (void)setDefaultOptions:(RNNNavigationOptions *)defaultOptions;

- (void)overrideOptions:(RNNNavigationOptions *)options;

- (void)readyForPresentation;

- (void)componentDidAppear;

- (void)componentDidDisappear;

@property (nonatomic, retain) RNNBasePresenter* presenter;
@property (nonatomic, retain) RNNLayoutInfo* layoutInfo;
@property (nonatomic, strong) RNNNavigationOptions* options;
@property (nonatomic, strong) RNNNavigationOptions* defaultOptions;
@property (nonatomic, strong) RNNEventEmitter* eventEmitter;
@property (nonatomic) id<RNNComponentViewCreator> creator;
@property (nonatomic) RNNReactViewReadyCompletionBlock reactViewReadyCallback;
@property (nonatomic) BOOL waitForRender;

@end
