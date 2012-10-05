#import "Property.h"

@interface Property ()

@property(nonatomic, strong, readwrite) NSArray *array;// readwriteを付ける
// 外から見えないようにするなら@interfaceのプロパティを消す
@end

@implementation Property {
// @implementにインスタンス変数が書けるようになったのはXcode 4.2から
@private
    NSArray *_array;// Xcode 4.4からここは省略してもいい
}

@synthesize array = _array;// XCode4.5からはここも省略できる

- (id)init {
    self = [super init];
    if (!self){
        return nil;
    }
    // 初期化
    _array = [NSArray arrayWithObjects:@"a",@"b", nil];

    return self;
}


@end