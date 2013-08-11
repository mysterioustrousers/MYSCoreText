//
//  MYSLinesTests.m
//  MYSCoreText
//
//  Created by Adam Kirk on 8/10/13.
//  Copyright (c) 2013 Mysterious Trousers. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "MYSCoreText.h"


@interface MYSRunTests : XCTestCase
@property (nonatomic, strong) MYSRun *glyphRun;
@end


@implementation MYSRunTests

- (void)setUp
{
    [super setUp];
    NSString *string = (@"A long string of text to test on this with some really long strings of text"
                        @"that wrap and also some hard \nline breaks that will generate lines for us "
                        @"in a frame");
    NSAttributedString *attributedString    = [[NSAttributedString alloc] initWithString:string];
    MYSFramesetter *framesetter             = [[MYSFramesetter alloc] initWithAttributedString:attributedString];
    MYSFrame *frame                         = [framesetter frameWithRect:CGRectMake(10, 0, 100, 100)];
    MYSLine *line                           = frame.lines[0];
    _glyphRun                               = line.runs[0];
}

- (void)testAttributedString
{
    XCTAssertNotNil(_glyphRun.attributedString);
}

- (void)testGlyphCount
{
    NSUInteger glyphCount = _glyphRun.glyphCount;
    XCTAssertTrue(glyphCount == 17);
}

- (void)testGlyphs
{
    NSArray *glyphs = _glyphRun.glyphs;
    XCTAssertTrue([glyphs count] == 17);
}

- (void)testAttributes
{
    NSDictionary *attributes = _glyphRun.attributes;
    NSFont *font = [NSFont fontWithName:@"Helvetica" size:12];
    XCTAssertEqualObjects(attributes[NSFontAttributeName], font);
}

- (void)testStatus
{
    CTRunStatus status = _glyphRun.status;
    XCTAssertTrue(status == kCTRunStatusNoStatus);
}

- (void)testRange
{
    NSRange range = _glyphRun.range;
    XCTAssertTrue(range.location == 0);
    XCTAssertTrue(range.length == 17);
}

- (void)testAscent
{
    CGFloat ascent = _glyphRun.ascent;
    XCTAssertEqualWithAccuracy(ascent, 9.2402, 0.01);
}

- (void)testDescent
{
    CGFloat descent = _glyphRun.descent;
    XCTAssertEqualWithAccuracy(descent, 2.759, 0.01);
}

- (void)testLeading
{
    CGFloat leading = _glyphRun.leading;
    XCTAssertEqualWithAccuracy(leading, 0.0, 0.01);
}

- (void)testLineHeight
{
    CGFloat lineHeight = _glyphRun.lineHeight;
    XCTAssertEqualWithAccuracy(lineHeight, 12.0, 0.01);
}

- (void)testTextMatrix
{
    CGAffineTransform transform = _glyphRun.textMatrix;
    XCTAssertTrue(CGAffineTransformEqualToTransform(transform, CGAffineTransformIdentity));
}

- (void)testBoundsInContext
{

}

- (void)testDrawInContext
{

}

@end
