//
//  ArticleEntity+CoreDataProperties.h
//  RestKit Example
//
//  Created by Aliaksandr Skulin on 1/20/16.
//  Copyright © 2016 Aliaksandr Skulin. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "ArticleEntity.h"
#import "AuthorEntity.h"

NS_ASSUME_NONNULL_BEGIN

@interface ArticleEntity (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *articleID;
@property (nullable, nonatomic, retain) NSString *title;
@property (nullable, nonatomic, retain) AuthorEntity *author;

@end

NS_ASSUME_NONNULL_END
