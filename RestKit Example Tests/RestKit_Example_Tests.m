//
//  RestKit_Example_Tests.m
//  RestKit Example Tests
//
//  Created by Aliaksandr Skulin on 1/21/16.
//  Copyright © 2016 Aliaksandr Skulin. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <RestKit/RestKit.h>
#import <RestKit/Testing.h>
#import "ArticleObject.h"

@interface RestKit_Example_Tests : XCTestCase

@end

@implementation RestKit_Example_Tests

- (void)setUp {
    [super setUp];
    // Configure RKTestFixture
    NSBundle *testTargetBundle = [NSBundle bundleForClass:[self class]];
    [RKTestFixture setFixtureBundle:testTargetBundle];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (RKObjectMapping *)articleMapping
{
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[ArticleObject class]];
    [mapping addAttributeMappingsFromDictionary:@{
                                                  @"title" : @"title",
                                                  @"articleID" : @"articleID"
                                                  }];
    RKObjectMapping *authorMapping = [[RKObjectMapping alloc] initWithClass:[AuthorObject class]];
    [authorMapping addAttributeMappingFromKeyOfRepresentationToAttribute:@"name"];
    RKRelationshipMapping *authorRelationshipMapping = [RKRelationshipMapping relationshipMappingFromKeyPath:@"author"
                                                                                                   toKeyPath:@"author"
                                                                                                 withMapping:authorMapping];
    [mapping addPropertyMapping:authorRelationshipMapping];
    return mapping;
}

- (void)testMappingOfTitle
{
    id parsedJSON = [RKTestFixture parsedObjectWithContentsOfFixture:@"article.json"];
    RKMappingTest *test = [RKMappingTest testForMapping:[self articleMapping] sourceObject:parsedJSON destinationObject:nil];
    [test addExpectation:[RKPropertyMappingTestExpectation expectationWithSourceKeyPath:@"title" destinationKeyPath:@"title"]];
    XCTAssertTrue([test evaluate], @"The title has not been set up!");
    // or
    XCTAssertNoThrow([test verify], @"The title has not been set up!");
}

- (void)testMappingOfTitleWithValue
{
    id parsedJSON = [RKTestFixture parsedObjectWithContentsOfFixture:@"article.json"];
    RKMappingTest *test = [RKMappingTest testForMapping:[self articleMapping] sourceObject:parsedJSON destinationObject:nil];
    
    [test addExpectation:[RKPropertyMappingTestExpectation expectationWithSourceKeyPath:@"title" destinationKeyPath:@"title" value:@"RestKit Object Mapping Example"]];
    XCTAssertTrue([test evaluate]);
}

- (void)testMappingOfTitleUsingBlock
{
    id parsedJSON = [RKTestFixture parsedObjectWithContentsOfFixture:@"article.json"];
    RKMappingTest *test = [RKMappingTest testForMapping:[self articleMapping] sourceObject:parsedJSON destinationObject:nil];
    
    // Use a block to create arbitrary expectations
    [test addExpectation:[RKPropertyMappingTestExpectation expectationWithSourceKeyPath:@"title" destinationKeyPath:@"title" evaluationBlock:^BOOL(RKPropertyMappingTestExpectation *expectation, RKPropertyMapping *mapping, id mappedValue, NSError **error) {
        NSString *title = (NSString *)mappedValue;
        return [title hasPrefix:@"RestKit"];
    }]];
    XCTAssertTrue([test evaluate]);
}

- (void)testMappingToExplicitObject
{
    ArticleObject *article = [ArticleObject new];
    id parsedJSON = [RKTestFixture parsedObjectWithContentsOfFixture:@"article.json"];
    RKMappingTest *test = [RKMappingTest testForMapping:[self articleMapping] sourceObject:parsedJSON destinationObject:article];
    
    // Check the value as well as the keyPaths
    [test addExpectation:[RKPropertyMappingTestExpectation expectationWithSourceKeyPath:@"title" destinationKeyPath:@"title" value:@"RestKit Object Mapping Example"]];
    XCTAssertTrue([test evaluate]);
    XCTAssert([article.title isEqualToString:@"RestKit Object Mapping Example"]);
}

@end
