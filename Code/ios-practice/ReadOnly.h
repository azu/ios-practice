#import <Foundation/Foundation.h>

@interface ReadOnly : NSObject {
}

@property(nonatomic, strong, readonly) NSArray *array;

@end