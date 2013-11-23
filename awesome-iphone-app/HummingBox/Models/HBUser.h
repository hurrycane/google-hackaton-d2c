//
//  HBUser.h
//  HummingBox
//
//  Created by Stefan Filip on 23/11/13.
//  Copyright (c) 2013 Hack Attack. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HBUser : NSObject

@property (nonatomic, strong) NSString *googlePlusID;
@property (nonatomic, strong) NSString *fullName;

- (NSURL *)googlePlusAvatarInSize:(unsigned int)size;
- (id)initWithAttributes:(NSDictionary *)attributes;

@end
