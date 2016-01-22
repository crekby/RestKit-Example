//
//  RestKit_Example_CoreData_Tests.m
//  RestKit Example
//
//  Created by Aliaksandr Skulin on 1/22/16.
//  Copyright © 2016 Aliaksandr Skulin. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <RestKit/CoreData/RKCoreData.h>
#import <RestKit/RestKit.h>
#import <RestKit/Testing.h>

@interface RestKit_Example_CoreData_Tests : XCTestCase

@property (nonatomic, strong) RKManagedObjectStore *managedObjectStore;

@end

@implementation RestKit_Example_CoreData_Tests

- (void)setUp {
    [super setUp];
    [RKTestFactory setUp];
    self.managedObjectStore = [RKTestFactory sharedObjectFromFactory:RKTestFactoryDefaultNamesManagedObjectStore];
}

- (void)tearDown {
    [RKTestFactory tearDown];
    self.managedObjectStore = nil;
    [super tearDown];
}

- (void)testManagedObjectIdentification
{
    RKEntityMapping *entityMapping = [RKEntityMapping mappingForEntityForName:@"ArticleEntity" inManagedObjectStore:self.managedObjectStore];
    entityMapping.identificationAttributes = @[ @"articleID" ];
    [entityMapping addAttributeMappingsFromDictionary:@{
                                                        @"articleID": @"articleID",
                                                        @"title"    : @"title"
                                                        }];
    NSDictionary *articleRepresentation = @{ @"articleID": @"1234", @"title": @"The Title" };
    RKMappingTest *mappingTest = [RKMappingTest testForMapping:entityMapping sourceObject:articleRepresentation destinationObject:nil];
    
    // Configure Core Data
    mappingTest.managedObjectContext = self.managedObjectStore.persistentStoreManagedObjectContext;
    
    // Create an object to match our criteria
    NSManagedObject *article = [NSEntityDescription insertNewObjectForEntityForName:@"ArticleEntity" inManagedObjectContext:self.managedObjectStore.persistentStoreManagedObjectContext];
    [article setValue:@"1234" forKey:@"articleID"];
    
    // Let the test perform the mapping
    [mappingTest performMapping];
    
    XCTAssertEqualObjects(article, mappingTest.destinationObject, @"Expected to match the Article, but did not");
}

@end
