//
//  AuthorEntity+CoreDataProperties.h
//  RestKit Example
//
//  Created by Aliaksandr Skulin on 1/20/16.
//  Copyright © 2016 Aliaksandr Skulin. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "AuthorEntity.h"

NS_ASSUME_NONNULL_BEGIN

@interface AuthorEntity (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSString *authorID;
@property (nullable, nonatomic, retain) NSSet<ArticleEntity *> *articles;

@end

@interface AuthorEntity (CoreDataGeneratedAccessors)

- (void)addArticlesObject:(ArticleEntity *)value;
- (void)removeArticlesObject:(ArticleEntity *)value;
- (void)addArticles:(NSSet<ArticleEntity *> *)values;
- (void)removeArticles:(NSSet<ArticleEntity *> *)values;

@end

NS_ASSUME_NONNULL_END
