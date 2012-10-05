//
//  Created by azu on 12/10/05.
//


#import <Foundation/Foundation.h>


@interface ReadOnly : NSObject {
}

@property(nonatomic, strong, readonly) NSArray *array;

@end