//
//  WebServerManager.m
//  RestKit Example
//
//  Created by Aliaksandr Skulin on 1/26/16.
//  Copyright © 2016 Aliaksandr Skulin. All rights reserved.
//

#import "WebServerManager.h"
#import "GCDWebServer.h"
#import "GCDWebServerDataResponse.h"
#import "GCDWebServerErrorResponse.h"

@interface WebServerManager()

@property (nonatomic, strong) GCDWebServer *webServer;
@property (nonatomic, strong) NSString *currentOauthToken;

@end

@implementation WebServerManager

- (void)configureWebServer
{
    // Create server
    self.webServer = [[GCDWebServer alloc] init];
    
    // Hardcoded Token for checking authorization
    self.currentOauthToken = @"LQbFp6O9niW1MlMr76CKqNHeJbAjzmyRwk2mbbq0";
    
    // Add a handler to respond to GET requests on any URL
    typeof(self) __weak weakSelf = self;
    
    [self.webServer addDefaultHandlerForMethod:@"GET"
                                  requestClass:[GCDWebServerRequest class]
                                  processBlock:^GCDWebServerResponse *(GCDWebServerRequest* request) {
                                      typeof(weakSelf) strongSelf = weakSelf;
                                      
                                      NSString *token = [request.headers valueForKey:@"Token"];
                                      if (![strongSelf.currentOauthToken isEqualToString:token]) {
                                          return [GCDWebServerErrorResponse responseWithClientError:kGCDWebServerHTTPStatusCode_Unauthorized message:@"unauthorized"];
                                      }
                                      
                                      NSString *path = request.path;
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
                                      
                                      return [GCDWebServerErrorResponse responseWithClientError:kGCDWebServerHTTPStatusCode_NotFound message:@"Not Found"];
                                      
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
