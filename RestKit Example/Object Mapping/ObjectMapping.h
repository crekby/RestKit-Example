//
//  ObjectMapping.h
//  RestKit Example
//
//  Created by Aliaksandr Skulin on 1/20/16.
//  Copyright © 2016 Aliaksandr Skulin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ObjectMapping : NSObject

+ (void)mappArticles;
+ (void)mappDynamicObjects;
+ (void)mappObjectsWithObjectManager;
+ (void)serializeObjectToJSON;

@end
