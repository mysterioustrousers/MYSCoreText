//
//  MYSFramesetterTests.m
//  MYSCoreText
//
//  Created by Adam Kirk on 8/6/13.
//  Copyright (c) 2013 Mysterious Trousers. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "MYSCoreText.h"


@interface MYSFramesetterTests : XCTestCase
@property (nonatomic, strong) MYSFramesetter *framesetter;
@end


@implementation MYSFramesetterTests

- (void)setUp
{
    [super setUp];
    NSString *string = (@"A long string of text to test on this with some really long strings of text"
                        @"that wrap and also some hard \nline breaks that will generate lines for us "
                        @"in a frame");
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:string];
    _framesetter = [[MYSFramesetter alloc] initWithAttributedString:attributedString];
}


- (void)testCreateFramesetter
{
    XCTAssertNotNil(_framesetter);
    XCTAssertNotNil(_framesetter.attributedString);
}

- (void)testGetTypesetter
{
    XCTAssertNotNil(_framesetter.typesetter);
}

- (void)testFrameWithRangePath
{
    CGPathRef path  = CGPathCreateWithRect(CGRectMake(0, 0, 30, 30), NULL);
    NSRange range   = NSMakeRange(0, [_framesetter.attributedString length]);
    MYSFrame *frame = [_framesetter frameWithRange:range path:path];
    XCTAssertNotNil(frame);
}

- (void)testFrameWithRect
{
    CGRect rect         = CGRectMake(0, 0, 40, 40);
    MYSFrame *frame     = [_framesetter frameWithRect:rect];
    XCTAssertNotNil(frame);
}

- (void)testSuggestedSizeConstrainedToWidth
{
    CGFloat width   = 50;
    CGSize size     = [_framesetter suggestedSizeConstrainedToWidth:width];
    XCTAssertTrue(floorf(size.width) == 52);
    XCTAssertTrue(size.height == 315);
}

- (void)testSuggestedSizeConstrainedToSize
{
    CGSize size = CGSizeMake(50, 5000);
    CGSize suggestedWidth = [_framesetter suggestedSizeConstrainedToSize:size];
    XCTAssertTrue(floorf(suggestedWidth.width) == 52);
    XCTAssertTrue(suggestedWidth.height == 315);
}

- (void)testSuggestedSizeOfRangeConstrainedToSize
{
    CGSize size             = CGSizeMake(50, 5000);
    NSRange range           = NSMakeRange(0, 30);
    CGSize suggestedWidth   = [_framesetter suggestedSizeOfRange:range
                                               constrainedToSize:size];
    XCTAssertTrue(floorf(suggestedWidth.width) == 46);
    XCTAssertTrue(suggestedWidth.height == 60);
}

- (void)testRangeThatFitsInFrameOfSize
{
    CGSize size         = CGSizeMake(50, 50);
    NSRange fitRange    = [_framesetter rangeThatFitsInFrameOfSize:size];
    XCTAssertTrue(fitRange.location == 0);
    XCTAssertTrue(fitRange.length == 25);
}


@end
