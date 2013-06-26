#import "Flying_LocalisationAPIClient.h"
#import "AFJSONRequestOperation.h"

static NSString * const kFlying_LocalisationAPIBaseURLString = @"<# API Base URL #>";

@implementation Flying_LocalisationAPIClient

+ (Flying_LocalisationAPIClient *)sharedClient {
    static Flying_LocalisationAPIClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[self alloc] initWithBaseURL:[NSURL URLWithString:kFlying_LocalisationAPIBaseURLString]];
    });
    
    return _sharedClient;
}

- (id)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    if (!self) {
        return nil;
    }
    
    [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
    [self setDefaultHeader:@"Accept" value:@"application/json"];
    
    return self;
}

@end
