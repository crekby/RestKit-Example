//
//  ViewController.m
//  RestKit Example
//
//  Created by Aliaksandr Skulin on 1/20/16.
//  Copyright © 2016 Aliaksandr Skulin. All rights reserved.
//

#import "ViewController.h"
#import "Object Mapping/ObjectMapping.h"
#import "CoreData Mapping/CoreDataMapping.h"

@interface ViewController ()

@end

@implementation ViewController

- (IBAction)mappArticles:(id)sender {
    [ObjectMapping mappArticles];
}

- (IBAction)mappDynamicObjects:(id)sender {
    [ObjectMapping mappDynamicObjects];
}

- (IBAction)mappObjectsWithObjectManager:(id)sender {
    [ObjectMapping mappObjectsWithObjectManager];
}

- (IBAction)serializeObjectToJson:(id)sender {
    [ObjectMapping serializeObjectToJSON];
}

- (IBAction)MappObjectsToCoreData:(id)sender {
    [CoreDataMapping mappArticlesToCoreData];
}

@end
