//
//  ios_practiceTests.m
//  ios-practiceTests
//
//  Created by azu on 10/05/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ios_practiceTests.h"
#import "ReadOnly.h"


#define HC_SHORTHAND

#import <OCHamcrestIOS/OCHamcrestIOS.h>

@implementation ios_practiceTests {
}


- (void)testReadOnlyInit {
    ReadOnly *readOnly = [[ReadOnly alloc] init];
    assertThat(readOnly.array, notNilValue());
}

@end
