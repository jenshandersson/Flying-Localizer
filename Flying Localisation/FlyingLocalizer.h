//
//  FlyingLocalizer.h
//  Flying Localisation
//
//  Created by Jens Andersson on 6/26/13.
//  Copyright (c) 2013 Jens Andersson. All rights reserved.
//

#import <Foundation/Foundation.h>

#define JALocalizedString(key, default) \
[FlyingLocalizer localizedStringForKey:(key) defaultString:default]

@interface FlyingLocalizer : NSObject

@property (nonatomic) NSURL *url;

- (void)updateFromServer;

+ (void)flyWithUrl:(NSString *)url;
+ (NSString *)localizedStringForKey:(NSString *)key defaultString:(NSString *)defaultString;

@end
