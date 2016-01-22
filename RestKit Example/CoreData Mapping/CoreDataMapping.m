//
//  CoreDataMapping.m
//  RestKit Example
//
//  Created by Aliaksandr Skulin on 1/20/16.
//  Copyright © 2016 Aliaksandr Skulin. All rights reserved.
//

#import "CoreDataMapping.h"
#import <RestKit/CoreData.h>
#import <RestKit/RestKit.h>
#import "ArticleEntity.h"
#import "AuthorEntity.h"

@implementation CoreDataMapping

// JSON:
//    [
//     {
//         "articleID": Count,
//         "title": "RestKit Object Mapping Example - Count",
//         "author":
//         {
//             "authorID" : "234",
//             "name": "Blake Watters",
//         }
//     }
//    ]

+ (void)mappArticlesToCoreData
{
    RKObjectManager* objectManager = [RKObjectManager managerWithBaseURL:[NSURL URLWithString:@"http://restkit.org"]];
    
//  initializing Core Data model and store
    NSURL *modelURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"Model" ofType:@"momd"]];

    NSManagedObjectModel *managedObjectModel = [[[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL] mutableCopy];
    RKManagedObjectStore *managedObjectStore = [[RKManagedObjectStore alloc] initWithManagedObjectModel:managedObjectModel];
    
    objectManager.managedObjectStore = managedObjectStore;
    [managedObjectStore createPersistentStoreCoordinator];
    
//  add Persistance store to coordinator
    NSError *error;
    [managedObjectStore addSQLitePersistentStoreAtPath:[RKApplicationDataDirectory() stringByAppendingString:@"/test.sqlite"]
                                fromSeedDatabaseAtPath:nil
                                     withConfiguration:nil
                                               options:@{NSInferMappingModelAutomaticallyOption: @YES, NSMigratePersistentStoresAutomaticallyOption: @YES}
                                                 error:&error];
    
//  Create contexts. Primary context is private queue and child for this context is main queue context
    [managedObjectStore createManagedObjectContexts];
    managedObjectStore.managedObjectCache = [[RKInMemoryManagedObjectCache alloc] initWithManagedObjectContext:managedObjectStore.persistentStoreManagedObjectContext];
    
//  Configure article mapping
    
    RKEntityMapping *articleMapping = [RKEntityMapping mappingForEntityForName:@"ArticleEntity" inManagedObjectStore:managedObjectStore];
    
//    Option 1, add keys by one
//    [articleMapping addAttributeMappingFromKeyOfRepresentationToAttribute:@"articleID"];
    
//    Option 2, add keys from array, in this case keys and properties must have same name
//    [articleMapping addAttributeMappingsFromArray:@[@"articleID", @"title"]];
    
//  Option 3, add properties and connected keys from dictionary
    [articleMapping addAttributeMappingsFromDictionary:@{@"articleID" : @"articleID",
                                                         @"title"     : @"title"}];
    
//  If your mapping class has relationships with other classes you need to configure it here.
    
//  Mapping for relationship object
    RKEntityMapping *authorMapping = [RKEntityMapping mappingForEntityForName:@"AuthorEntity" inManagedObjectStore:managedObjectStore];
    [authorMapping addAttributeMappingsFromArray:@[@"authorID", @"name"]];
    
//  add relationship to article mapping

    RKRelationshipMapping *relationship = [RKRelationshipMapping relationshipMappingFromKeyPath:@"author" toKeyPath:@"author" withMapping:authorMapping];
    [articleMapping addPropertyMapping:relationship];
    
//    If you need add relationship to not nested objects you need add next line:
//    [articleMapping addConnectionForRelationship:@"author" connectedBy:@{@"authorID" : @"authorID"}];
    
    articleMapping.identificationAttributes = @[ @"articleID" ];
    
//  Configure mapping descriptor
    
    RKResponseDescriptor *descriptor = [RKResponseDescriptor responseDescriptorWithMapping:articleMapping
                                                                                    method:RKRequestMethodAny // The HTTP method(s) for which the mapping is to be used
                                                                               pathPattern:nil
                                                                                   keyPath:nil  // specific keyPath if mapping objects isn't root objects
                                                                               statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)]; // range of HTTP codes, if request gets different  code operation will fail.
//  Configure URL request
    NSURL *url = [NSURL URLWithString:@"http://localhost:8080/manyArticles.json"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
//  Configure mapping operation
    RKManagedObjectRequestOperation *operation = [[RKManagedObjectRequestOperation alloc] initWithRequest:request responseDescriptors:@[descriptor]];
    
//  set operation context. every object will be added in this context created child contexts
    operation.managedObjectContext = managedObjectStore.persistentStoreManagedObjectContext;
    operation.managedObjectCache = managedObjectStore.managedObjectCache;
    
//  add operation completion blocks
    [operation setCompletionBlockWithSuccess:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        // handle result
        NSLog(@"%@", [mappingResult array]);
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        // handle failure
        NSLog(@"%@", error);
    }];

//  enqueue operation for execution
    [objectManager enqueueObjectRequestOperation:operation];
}

@end
