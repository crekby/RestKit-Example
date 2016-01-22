//
//  AppDelegate.m
//  RestKit Example
//
//  Created by Aliaksandr Skulin on 1/20/16.
//  Copyright © 2016 Aliaksandr Skulin. All rights reserved.
//

#import "AppDelegate.h"
#import "GCDWebServer.h"
#import "GCDWebServerDataResponse.h"

@interface AppDelegate ()

@property (nonatomic, strong) GCDWebServer *webServer;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [self configureWebServer];
    
    return YES;
}

// Local web server configuration for JSON requests

- (void)configureWebServer
{
    // Create server
    self.webServer = [[GCDWebServer alloc] init];
    // Add a handler to respond to GET requests on any URL
    typeof(self) __weak weakSelf = self;
    [self.webServer addDefaultHandlerForMethod:@"GET"
                              requestClass:[GCDWebServerRequest class]
                              processBlock:^GCDWebServerResponse *(GCDWebServerRequest* request) {
                                  NSString *path = request.path;
                                  typeof(weakSelf) strongSelf = weakSelf;
                                  if ([path isEqualToString:@"/article.json"]) {
                                      return [GCDWebServerDataResponse responseWithJSONObject:
                                                                                                @{
                                                                                                    @"articleID": @"123",
                                                                                                    @"title": @"RestKit Object Mapping Example",
                                                                                                    @"author":
                                                                                                    @{
                                                                                                        @"authorID" : @"234",
                                                                                                        @"name": @"Blake Watters",
                                                                                                    }
                                                                                                }];
                                  }
                                  if ([path isEqualToString:@"/dynamicMapping.json"]) {
                                      return [GCDWebServerDataResponse responseWithJSONObject:
                                                                                              @[
                                                                                                @{
                                                                                                    @"type": @"article",
                                                                                                    @"articleID": @"123",
                                                                                                    @"title": @"Intresting Article",
                                                                                                    @"author":
                                                                                                            @{
                                                                                                                @"authorID" : @"234",
                                                                                                                @"name": @"Article author",
                                                                                                            }
                                                                                                },
                                                                                                @{
                                                                                                    @"type": @"book",
                                                                                                    @"title": @"Intresting Book",
                                                                                                    @"author":
                                                                                                            @{
                                                                                                                @"authorID" : @"345",
                                                                                                                @"name": @"Book author"
                                                                                                            }
                                                                                                }
                                                                                              ]];
                                  }
                                  if ([path isEqualToString:@"/manyArticles.json"]) {
                                      return [GCDWebServerDataResponse responseWithJSONObject:[strongSelf articlesWithCount:100]];
                                  }
                                  
                                  return [GCDWebServerDataResponse responseWithHTML:@"<html><body><p>You send a wrong request</p></body></html>"];
                                  
                              }];
    
    [self.webServer startWithPort:8080 bonjourName:nil];
}

- (NSArray *)articlesWithCount:(NSUInteger)count
{
    NSMutableArray *array = [NSMutableArray new];
    for (int i = 0; i < count; i++) {
        [array addObject:@{
                           @"type": @"article",
                           @"articleID": [NSString stringWithFormat:@"%d",i],
                           @"title": [NSString stringWithFormat:@"Intresting Article - %d", i],
                           @"author":
                               @{
                                   @"authorID" : @"234",
                                   @"name": @"Article author",
                                   }
                           }];
    }
    return array;
}

@end
