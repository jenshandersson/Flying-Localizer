//
//  FlyingLocalizer.m
//  Flying Localisation
//
//  Created by Jens Andersson on 6/26/13.
//  Copyright (c) 2013 Jens Andersson. All rights reserved.
//

#import "FlyingLocalizer.h"
#import <AFNetworking.h>
@implementation FlyingLocalizer

+ (FlyingLocalizer *)shared {
    static FlyingLocalizer *_shared;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shared = [[FlyingLocalizer alloc] init];
    });
    return _shared;
}

- (id)init {
    self = [super init];
    
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateFromServer) name:UIApplicationDidBecomeActiveNotification object:nil];
        [self updateFromServer];
    }
    
    return self;
}

- (void)updateFromServer {
    NSString *url = @"http://localhost/~jensa/response.json";
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    [urlRequest addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:urlRequest success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSDictionary *all = JSON;
        [all enumerateKeysAndObjectsUsingBlock:^(id key, id object, BOOL *stop) {
            [self persistStrings:object forLanguage:key];
        }];
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        ;
    }];
    [operation start];
}

- (void)persistStrings:(NSDictionary *)strings forLanguage:(NSString *)code {
    [NSKeyedArchiver archiveRootObject:strings toFile:[self pathForLanguage:code]];
}

- (NSDictionary *)languageDict {
    NSDictionary *d = [NSKeyedUnarchiver unarchiveObjectWithFile:[self pathForLanguage:[self languageCode]]];
    return d;
}

- (NSString *)pathForLanguage:(NSString *)code {
    NSString *docsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *filename = [docsPath stringByAppendingPathComponent:code];
    return filename;
}

- (NSString *)languageCode {
    NSUserDefaults* defs = [NSUserDefaults standardUserDefaults];
    NSArray* languages = [defs objectForKey:@"AppleLanguages"];
    NSString* preferredLang = [languages objectAtIndex:0];
    return preferredLang;
}

-(void) dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (NSString *)localizedStringForKey:(NSString *)key defaultString:(NSString *)defaultString {
    
    NSString *string = [[self languageDict] objectForKey:key];
    if (!string) {
        NSString *localString = NSLocalizedString(key, nil);
        if (![localString isEqual:key])
            string = localString;
    }
    
    return string ? : defaultString;
}

+ (NSString *)localizedStringForKey:(NSString *)key defaultString:(NSString *)defaultString {
    return [[self shared] localizedStringForKey:key defaultString:defaultString];
}

@end
