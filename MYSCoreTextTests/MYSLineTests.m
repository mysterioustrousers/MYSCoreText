//
//  MYSLineTests.m
//  MYSCoreText
//
//  Created by Adam Kirk on 8/9/13.
//  Copyright (c) 2013 Mysterious Trousers. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "MYSCoreText.h"


@interface MYSLineTests : XCTestCase
@property (nonatomic, strong) MYSLine *line;
@end


@implementation MYSLineTests

- (void)setUp
{
    [super setUp];
    NSString *string = (@"A long string of text to test on this with some really long strings of text"
                        @"that wrap and also some hard \nline breaks that will generate lines for us "
                        @"in a frame");
    NSAttributedString *attributedString    = [[NSAttributedString alloc] initWithString:string];
    MYSFramesetter *framesetter             = [[MYSFramesetter alloc] initWithAttributedString:attributedString];
    MYSFrame *frame                         = [framesetter frameWithRect:CGRectMake(10, 0, 100, 100)];
    _line                                   = frame.lines[0];
}




#pragma mark - Creating Lines

- (void)testInitWithAttributedString
{
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:@"hello there"];
    MYSLine *line = [[MYSLine alloc] initWithAttributedString:attributedString];
    XCTAssertEqualObjects(line.attributedString, attributedString);
}

- (void)testNewTruncatedLineToWidthTruncationtype
{
    MYSLine *line = [_line newTruncatedLineToWidth:50 truncationType:kCTLineTruncationMiddle];
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:@"A long string of "];
    XCTAssertTrue([line.attributedString isEqualToAttributedString:attributedString]);
}

- (void)testNewJustifiedLineToWidth
{
    MYSLine *line = [_line newJustifiedLineToWidth:100];
    XCTAssertEqualWithAccuracy(line.trailingWhitespaceWidth, 0, 0.01);
}




#pragma mark - Text

- (void)testAttributedString
{
    NSAttributedString *attributedStirng = _line.attributedString;
    NSAttributedString *result = [[NSAttributedString alloc] initWithString:@"A long string of "];
    XCTAssertEqualObjects(attributedStirng, result);
}

- (void)testRuns
{
    NSArray *runs = _line.runs;
    XCTAssertTrue([runs count] == 1);
}

- (void)testGlyphCount
{
    NSUInteger glyphCount = _line.glyphCount;
    XCTAssertTrue(glyphCount == 17);
}

- (void)testRange
{
    NSRange range = _line.range;
    XCTAssertTrue(range.location == 0);
    XCTAssertTrue(range.length == 17);
}




#pragma mark - Typographical Bounds

- (void)testOrigin
{
    CGPoint lineOrigin = _line.origin;
    XCTAssertTrue(lineOrigin.x == 10);
    XCTAssertTrue(lineOrigin.y == 88);
}

- (void)testTrailingWhitespaceWidth
{
    CGFloat trailingWhitespaceWidth = _line.trailingWhitespaceWidth;
    XCTAssertEqualWithAccuracy(trailingWhitespaceWidth, 3.333, 0.01);
}

- (void)testAscent
{
    CGFloat ascent = _line.ascent;
    XCTAssertEqualWithAccuracy(ascent, 9.2402, 0.01);
}

- (void)testDescent
{
    CGFloat descent = _line.descent;
    XCTAssertEqualWithAccuracy(descent, 2.759, 0.01);
}

- (void)testLeading
{
    CGFloat leading = _line.leading;
    XCTAssertEqualWithAccuracy(leading, 0.0, 0.01);
}

- (void)testLineHeight
{
    CGFloat lineHeight = _line.lineHeight;
    XCTAssertEqualWithAccuracy(lineHeight, 12.0, 0.01);
}

- (void)testBoundsWithOptions
{
    CGRect bounds = [_line boundsWithOptions:kCTLineBoundsUseHangingPunctuation | kCTLineBoundsUseGlyphPathBounds];
    XCTAssertEqualWithAccuracy(bounds.origin.x, 0.175, 0.01);
    XCTAssertEqualWithAccuracy(bounds.origin.y, -2.654, 0.01);
    XCTAssertEqualWithAccuracy(bounds.size.width, 79.01, 0.01);
    XCTAssertEqualWithAccuracy(bounds.size.height, 11.384, 0.01);
}




#pragma mark - Character Positions

- (void)testOffsetOfCharacterAtIndex
{
    CGFloat offset = [_line offsetOfCharacterAtIndex:3];
    XCTAssertEqualWithAccuracy(offset, 13.347, 0.01);
}

- (void)testIndexOfCharacterAtPosition
{
    CGPoint p = CGPointMake(20, 0);
    NSUInteger index = [_line characterIndexAtPoint:p];
    XCTAssertTrue(index == 4);
}




#pragma mark - Drawing

- (void)testDrawInContext
{

}

@end
