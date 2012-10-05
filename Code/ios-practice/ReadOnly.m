#import "ReadOnly.h"

@implementation ReadOnly {

@private
    NSArray *_array;
}

@synthesize array = _array;

- (id)init {
    self = [super init];
    if (!self){
        return nil;
    }
    // initで一回のみ初期化
    _array = [NSArray arrayWithObjects:@"readonly", @"first", @"init", nil];

    return self;
}

@end