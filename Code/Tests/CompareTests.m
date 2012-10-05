#import <SenTestingKit/SenTestingKit.h>
#import <OCHamcrestIOS/OCHamcrestIOS.h>

@interface CompareTests : SenTestCase

@end

@implementation CompareTests

- (void)testEqual {
    NSString *one = @"1";
    NSString *eins = [NSString stringWithFormat:@"%c", '1'];
    BOOL isEqualOperator = (one == eins);// ポインタ値は一致しない
    assertThatBool(isEqualOperator, equalToBool(NO));
    BOOL isEqualMethod = [one isEqualToString:eins];// 文字列的には一致する
    assertThatBool(isEqualMethod, equalToBool(YES));
}
@end
