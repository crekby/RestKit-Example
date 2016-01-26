//
//  ObjectMapping.m
//  RestKit Example
//
//  Created by Aliaksandr Skulin on 1/20/16.
//  Copyright © 2016 Aliaksandr Skulin. All rights reserved.
//

#import "ObjectMapping.h"
#import "AppDelegate.h"
#import <RestKit.h>
#import "ArticleObject.h"
#import "AuthorObject.h"
#import "BookObject.h"

@implementation ObjectMapping

// JSON:
//    [
//     {
//         "articleID": "123",
//         "title": "RestKit Object Mapping Example",
//         "author":
//         {
//             "authorID" : "234",8
//             "name": "Blake Watters",
//         }
//     }
//    ]

+ (void)mappArticles
{
    // Configure article mapping
    
    RKObjectMapping *articleMapping = [[RKObjectMapping alloc] initWithClass:[ArticleObject class]];
    
//    Option 1, add keys by one
//    [articleMapping addAttributeMappingFromKeyOfRepresentationToAttribute:@"articleID"];
    
//    Option 2, add keys from array, in this case keys and properties must have same name
//    [articleMapping addAttributeMappingsFromArray:@[@"articleID", @"title"]];
    
//   Option 3, add properties and connected keys from dictionary
    [articleMapping addAttributeMappingsFromDictionary:@{@"articleID" : @"articleID",
                                                         @"title"     : @"title"}];
    
    // If your mapping class has relationships with other classes you need to configure it here.
    
    // Mapping for relationship object
    RKObjectMapping *authorMapping = [[RKObjectMapping alloc] initWithClass:[AuthorObject class]];
    [authorMapping addAttributeMappingFromKeyOfRepresentationToAttribute:@"name"];
    
    // add relationship to article mapping
    RKRelationshipMapping *authorRelationshipMapping = [RKRelationshipMapping relationshipMappingFromKeyPath:@"author"
                                                                                                   toKeyPath:@"author"
                                                                                                 withMapping:authorMapping];
    [articleMapping addPropertyMapping:authorRelationshipMapping];
    
//    if you need custom date and time converting you should add configured date formatter to attribute mapping.
//    There already is few configured formater.
    
//    RKAttributeMapping *dateMapping = [RKAttributeMapping attributeMappingFromKeyPath:@"date" toKeyPath:@"date"];
//    NSDateFormatter *formatter = [NSDateFormatter new];
//    formatter.dateFormat = @"dd.MM.yyyy";
//    
//    Option 1, added it to specific mapping
//    dateMapping.valueTransformer = formatter;
//
//    Option 2, or add it globaly
//    [RKObjectMapping addDefaultDateFormatter:formatter];
//    [articleMapping addPropertyMapping:dateMapping];

//  Configure mapping descriptor
    
    RKResponseDescriptor *descriptor = [RKResponseDescriptor responseDescriptorWithMapping:articleMapping
                                                                                    method:RKRequestMethodAny // The HTTP method(s) for which the mapping is to be used
                                                                               pathPattern:nil
                                                                                   keyPath:nil  // specific keyPath if mapping objects isn't root objects
                                                                               statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)]; // range of HTTP codes, if request gets different  code operation will fail.
//  Configure URL request
    NSURL *url = [NSURL URLWithString:@"http://localhost:8080/article.json"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
//  Add token header for authorization
    [request setValue:@"LQbFp6O9niW1MlMr76CKqNHeJbAjzmyRwk2mbbq0" forHTTPHeaderField:@"Token"];
    
//  Configure mapping operation
    RKObjectRequestOperation *operation = [[RKObjectRequestOperation alloc] initWithRequest:request responseDescriptors:@[descriptor]];
    [operation setCompletionBlockWithSuccess:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        // handle result
        NSLog(@"%@", [mappingResult array]);
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        // handle failure
        NSLog(@"%@", error);
    }];
    
//  Launch operation
    [operation start];
}

// JSON
//    [
//     {
//         "type": "article",
//         "articleID": "123",
//         "title": "Intresting Article",
//         "author":
//         {
//             "authorID" : "234",
//             "name": "Article author",
//         }
//     },
//     {
//         "type": "book",
//         "title": "Intresting Book",
//         "author":
//         {
//             "authorID" : "345",
//             "name": "Book author",
//         }
//     }
//    ]

+ (void)mappDynamicObjects
{
    RKObjectMapping *articleMapping = [[RKObjectMapping alloc] initWithClass:[ArticleObject class]];
    [articleMapping addAttributeMappingsFromDictionary:@{@"articleID" : @"articleID",
                                                         @"title"     : @"title"}];
    RKObjectMapping *authorMapping = [[RKObjectMapping alloc] initWithClass:[AuthorObject class]];
    [authorMapping addAttributeMappingFromKeyOfRepresentationToAttribute:@"name"];
    RKRelationshipMapping *authorRelationshipMapping = [RKRelationshipMapping relationshipMappingFromKeyPath:@"author"
                                                                                                   toKeyPath:@"author"
                                                                                                 withMapping:authorMapping];
    [articleMapping addPropertyMapping:authorRelationshipMapping];
    
    RKObjectMapping *bookMapping = [[RKObjectMapping alloc] initWithClass:[BookObject class]];
    [bookMapping addAttributeMappingFromKeyOfRepresentationToAttribute:@"title"];
    [bookMapping addPropertyMapping:[authorRelationshipMapping copy]];
    
//  Configure Dynamic mapping
    RKDynamicMapping *dynamicMapping = [RKDynamicMapping new];
    
//  Return appropriate mapping for circumstances
    [dynamicMapping setObjectMappingForRepresentationBlock:^RKObjectMapping *(id representation) {
        if ([[representation valueForKey:@"type"] isEqualToString:@"book"]) {
            return bookMapping;
        } else {
            return articleMapping;
        }
    }];
    
    RKResponseDescriptor *descriptor = [RKResponseDescriptor responseDescriptorWithMapping:dynamicMapping
                                                                                    method:RKRequestMethodAny
                                                                               pathPattern:nil
                                                                                   keyPath:nil
                                                                               statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    
//  Configure URL request
    NSURL *url = [NSURL URLWithString:@"http://localhost:8080/dynamicMapping.json"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
//  Add token header for authorization
    [request setValue:@"LQbFp6O9niW1MlMr76CKqNHeJbAjzmyRwk2mbbq0" forHTTPHeaderField:@"Token"];
    
//  Configure mapping operation
    RKObjectRequestOperation *operation = [[RKObjectRequestOperation alloc] initWithRequest:request responseDescriptors:@[descriptor]];
    [operation setCompletionBlockWithSuccess:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        // handle result
        NSLog(@"%@", [mappingResult array]);
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        // handle failure
        NSLog(@"%@", error);
    }];
    
//  Launch operation
    [operation start];
}

// JSON:
//    [
//     {
//         "articleID": "123",
//         "title": "RestKit Object Mapping Example",
//         "author":
//         {
//             "authorID" : "234",
//             "name": "Blake Watters",
//         }
//     }
//    ]

+ (void)mappObjectsWithObjectManager
{
    RKObjectManager *manager = [RKObjectManager managerWithBaseURL:[NSURL URLWithString:@"http://localhost:8080"]];
    
//  Add token header for authorization
    [manager.HTTPClient setDefaultHeader:@"Token" value:@"LQbFp6O9niW1MlMr76CKqNHeJbAjzmyRwk2mbbq0"];
    
    RKObjectMapping *articleMapping = [[RKObjectMapping alloc] initWithClass:[ArticleObject class]];
    [articleMapping addAttributeMappingsFromDictionary:@{@"articleID" : @"articleID",
                                                         @"title"     : @"title"}];
    RKObjectMapping *authorMapping = [[RKObjectMapping alloc] initWithClass:[AuthorObject class]];
    [authorMapping addAttributeMappingFromKeyOfRepresentationToAttribute:@"name"];
    RKRelationshipMapping *authorRelationshipMapping = [RKRelationshipMapping relationshipMappingFromKeyPath:@"author"
                                                                                                   toKeyPath:@"author"
                                                                                                 withMapping:authorMapping];
    [articleMapping addPropertyMapping:authorRelationshipMapping];
    RKResponseDescriptor *descriptor = [RKResponseDescriptor responseDescriptorWithMapping:articleMapping
                                                                                    method:RKRequestMethodAny
                                                                               pathPattern:@"/article.json" // specific path for descriptor, same as path for getting objects
                                                                                   keyPath:nil
                                                                               statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    [manager addResponseDescriptor:descriptor];
    [manager getObjectsAtPath:@"/article.json" parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        NSLog(@"%@", [mappingResult array]);
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
    }];
}


//  Same way you can mapp local JSON dictionary to object.
//  Just change object and jsonDict places, and use normal mapping instead of inversed.

+ (void)serializeObjectToJSON
{
//  configure object for serialization
    ArticleObject *object = [ArticleObject new];
    object.title = @"Title";
    object.articleID = @"123";
    
    NSMutableDictionary *jsonDict = [NSMutableDictionary dictionary];
    
//  Configure mapping
    RKObjectMapping *articleMapping = [[RKObjectMapping alloc] initWithClass:[ArticleObject class]];
    [articleMapping addAttributeMappingsFromDictionary:@{@"articleID" : @"articleID",
                                                         @"title"     : @"title"}];
    
//  Configure serialization operation
    RKMappingOperation *operation = [[RKMappingOperation alloc] initWithSourceObject:object
                                                                   destinationObject:jsonDict
                                                                             mapping:[articleMapping inverseMapping]]; // invert mapping
//  start operation
    NSError *error = nil;
    [operation performMapping:&error];
    NSLog(@"%@", jsonDict);
}

@end
