//
//  BookObject.h
//  RestKit Example
//
//  Created by Aliaksandr Skulin on 1/20/16.
//  Copyright © 2016 Aliaksandr Skulin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AuthorObject.h"

@interface BookObject : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) AuthorObject *author;

@end
