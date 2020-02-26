#import "BottomTabsAppearancePresenter.h"

@implementation BottomTabsAppearancePresenter

- (void)bindViewController:(UITabBarController *)boundViewController {
    [super bindViewController:boundViewController];
    boundViewController.tabBar.standardAppearance = [UITabBarAppearance new];
}

- (void)applyOptionsOnInit:(RNNNavigationOptions *)options {
    [super applyOptionsOnInit:options];
    UITabBarController *bottomTabs = self.tabBarController;
    bottomTabs.tabBar.standardAppearance = [UITabBarAppearance new];
}

- (void)setTabBarBackgroundColor:(UIColor *)backgroundColor {
    UITabBarController *bottomTabs = self.tabBarController;
    for (UIViewController* childViewController in bottomTabs.childViewControllers) {
        childViewController.tabBarItem.standardAppearance.backgroundColor = backgroundColor;
    }
}

@end
