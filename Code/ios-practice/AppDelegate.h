//
//  AppDelegate.h
//  ios-practice
//
//  Created by azu on 10/05/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property(nonatomic, strong) UIStoryboard *storyboard;
@property(nonatomic, strong) UINavigationController * navigationController;
@end