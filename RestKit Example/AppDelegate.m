//
//  AppDelegate.m
//  RestKit Example
//
//  Created by Aliaksandr Skulin on 1/20/16.
//  Copyright © 2016 Aliaksandr Skulin. All rights reserved.
//

#import "AppDelegate.h"
#import "WebServerManager.h"

@interface AppDelegate ()

@property (nonatomic, strong) WebServerManager *webServerManager;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
//    configure local web server for fake JSON responces
//    if you will add your own methods use http://localhost:8080 as base URL
    self.webServerManager = [WebServerManager new];
    [self.webServerManager configureWebServer];
    
    return YES;
}

// Local web server configuration for JSON requests



@end
