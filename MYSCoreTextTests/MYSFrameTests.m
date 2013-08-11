//
//  MYSFrameTests.m
//  MYSCoreText
//
//  Created by Adam Kirk on 8/9/13.
//  Copyright (c) 2013 Mysterious Trousers. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "MYSCoreText.h"


@interface MYSFrameTests : XCTestCase
@property (nonatomic, strong) MYSFrame *frame;
@property (nonatomic, assign) CGRect   rect;
@end


@implementation MYSFrameTests

- (void)setUp
{
    [super setUp];
    NSString *string = (@"A long string of text to test on this with some really long strings of text"
                        @"that wrap and also some hard \nline breaks that will generate lines for us "
                        @"in a frame");
    NSAttributedString *attributedString    = [[NSAttributedString alloc] initWithString:string];
    MYSFramesetter *framesetter             = [[MYSFramesetter alloc] initWithAttributedString:attributedString];
    _rect                                   = CGRectMake(0, 0, 200, 200);
    _frame = [framesetter frameWithRange:NSMakeRange(0, [string length]) path:CGPathCreateWithRect(_rect, NULL)];
}

- (void)testAttributedString
{
    XCTAssertNotNil(_frame.attributedString);
}

- (void)testLines
{
    NSArray *lines = _frame.lines;
    XCTAssertTrue([lines count] == 5);
}

- (void)testPath
{
    CGPathRef path = _frame.path;
    XCTAssertTrue(CGRectEqualToRect(CGPathGetBoundingBox(path), _rect));
}

- (void)testRange
{
    NSRange range = _frame.range;
    XCTAssertTrue(range.location == 0);
    XCTAssertTrue(range.length == [_frame.attributedString length]);
}

- (void)testVisibleRange
{
    NSRange visibleRange = _frame.visibleRange;
    XCTAssertTrue(visibleRange.location == 0);
    XCTAssertTrue(visibleRange.length == 159);
}

- (void)testDrawInContext
{
    
}

@end
