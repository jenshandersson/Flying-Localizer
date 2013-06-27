//
//  FlyingLocalizer.m
//  Flying Localisation
//
//  Created by Jens Andersson on 6/26/13.
//  Copyright (c) 2013 Jens Andersson. All rights reserved.
//

#import "FlyingLocalizer.h"
#import <AFNetworking.h>

static FlyingLocalizer *_shared;

@implementation FlyingLocalizer

+ (void)flyWithUrl:(NSString *)url {
    _shared = [[FlyingLocalizer alloc] initWithUrl:url];
    [_shared updateFromServer];
}

+ (FlyingLocalizer *)shared {
    if (_shared == nil) {
        [NSException raise:@"InstanceNotExists"
                    format:@"Attempted to access instance before initializaion. Please call flyWithUrl: first."];
    }
    return _shared;
}

- (id)initWithUrl:(NSString *)url {
    self = [super init];
    
    if (self) {
        self.url = [NSURL URLWithString:url];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateFromServer) name:UIApplicationDidBecomeActiveNotification object:nil];
    }
    
    return self;
}

- (void)updateFromServer {
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:self.url];
    [urlRequest addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [AFJSONRequestOperation addAcceptableContentTypes:[NSSet setWithObject:@"text/plain"]];
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
