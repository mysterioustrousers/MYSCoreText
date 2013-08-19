//
//  MYSPrivateTests.m
//  TwUI
//
//  Created by Adam Kirk on 8/14/13.
//
//

#import <XCTest/XCTest.h>
#import "MYSPrivate.h"


@interface MYSPrivateTests : XCTestCase
@end


@implementation MYSPrivateTests

- (void)testRangeBridgeCF2NS
{
    CFRange range   = CFRangeMake(100, 200);
    NSRange r       = MYSNSRangeBridge(range);
    XCTAssertTrue(r.location == range.location);
    XCTAssertTrue(r.length == range.length);
}

- (void)testRangeBridgeNS2CF
{
    NSRange range   = NSMakeRange(100, 200);
    CFRange r       = MYSCFRangeBridge(range);
    XCTAssertTrue(r.location == range.location);
    XCTAssertTrue(r.length == range.length);
}

- (void)testConvertPointFromRect
{
    CGPoint p   = CGPointMake(100, 100);
    CGRect r    = CGRectMake(10, 10, 200, 200);
    CGPoint p2  = MYSConvertPointFromRect(p, r);
    XCTAssertTrue(CGPointEqualToPoint(p2, CGPointMake(110, 110)));
}

- (void)testRangeContainsIndex
{
    NSRange r = NSMakeRange(100, 300);
    XCTAssertFalse(MYSNSRangeContainsIndex(r, 99));
    XCTAssertTrue(MYSNSRangeContainsIndex(r, 100));
    XCTAssertTrue(MYSNSRangeContainsIndex(r, 101));
    XCTAssertTrue(MYSNSRangeContainsIndex(r, 399));
    XCTAssertFalse(MYSNSRangeContainsIndex(r, 400));
}

- (void)testRangeStartIndex
{
    NSRange r = NSMakeRange(100, 300);
    XCTAssertTrue(MYSNSRangeStartIndex(r) == 100);
}

- (void)testRangeEndIndex
{
    NSRange r = NSMakeRange(100, 300);
    XCTAssertTrue(MYSNSRangeEndIndex(r) == 399);
}


@end
