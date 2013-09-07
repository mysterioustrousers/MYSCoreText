//
//  MYSLine.m
//  MYSCoreText
//
//  Created by Adam Kirk on 7/19/13.
//  Copyright (c) 2013 Mysterious Trousers. All rights reserved.
//

#import "MYSPrivate.h"
#import "MYSFrame_Private.h"
#import "MYSLine_Private.h"
#import "MYSRun_Private.h"
#import "MYSWord_Private.h"
#import "MYSGlyph_Private.h"


@interface MYSLine ()
@property (nonatomic, assign           ) CTLineRef    lineRef;
@property (nonatomic, strong, readwrite) NSArray      *runs;
@property (nonatomic, strong, readwrite) NSArray      *words;
@property (nonatomic, strong           ) NSDictionary *typographicalBounds;
@end


@implementation MYSLine


#pragma mark - Creating Lines

- (id)initWithAttributedString:(NSAttributedString *)attributedString
{
    self = [self init];
    if (self) {
        _attributedString   = [attributedString copy];
        _lineRef            = CTLineCreateWithAttributedString((__bridge CFAttributedStringRef)attributedString);
    }
    return self;
}

- (MYSLine *)newTruncatedLineToWidth:(CGFloat)width truncationType:(CTLineTruncationType)truncationType
{
    NSString *tokenCharacter                = [NSString stringWithUTF8String:"\u2026"];
    NSAttributedString *tokenAttrString     = [[NSAttributedString alloc] initWithString:tokenCharacter];
    CTLineRef truncationToken               = CTLineCreateWithAttributedString((__bridge CFAttributedStringRef)tokenAttrString);
    CTLineRef lineRef                       = CTLineCreateTruncatedLine(_lineRef, width, truncationType, truncationToken);
    MYSLine *line                           = [[MYSLine alloc] initWithCTLine:lineRef attributedString:_attributedString];
    MYSCFSafeRelease(truncationToken);
    MYSCFSafeRelease(lineRef);
    return line;
}

- (MYSLine *)newJustifiedLineToWidth:(CGFloat)width
{
    CTLineRef lineRef = CTLineCreateJustifiedLine(_lineRef, 1.0, width);
    MYSLine *line = [[MYSLine alloc] initWithCTLine:lineRef attributedString:_attributedString];
    MYSCFSafeRelease(lineRef);
    return line;
}




#pragma mark - Text

- (NSAttributedString *)attributedString
{
    NSRange range = MYSNSRangeBridge(CTLineGetStringRange(_lineRef));
    return [_attributedString attributedSubstringFromRange:range];
}

- (NSUInteger)glyphCount
{
    return CTLineGetGlyphCount(_lineRef);
}

- (NSRange)range
{
    return MYSNSRangeBridge(CTLineGetStringRange(_lineRef));
}

- (NSUInteger)indexOfFirstCharacter
{
    return MYSNSRangeStartIndex(self.range);
}

- (NSUInteger)indexOfLastCharacter
{
    return NSMaxRange(self.range);
}




#pragma mark - Runs

- (NSArray *)runs
{
    @synchronized(self) {
        if (!_runs) {
            _runs                   = [NSMutableArray new];
            CFArrayRef runRefs      = CTLineGetGlyphRuns(_lineRef);
            for (CFIndex i = 0; i < CFArrayGetCount(runRefs); i++) {
                CTRunRef runRef     = CFArrayGetValueAtIndex(runRefs, i);
                MYSRun *run         = [[MYSRun alloc] initWithCTRun:runRef attributedString:_attributedString];
                run.line            = self;
                [(NSMutableArray *)_runs addObject:run];
            }
        }
        return _runs;
    }
}




#pragma mark - Words

- (NSArray *)words
{
    @synchronized(self) {
        if (!_words) {
            _words = [NSMutableArray new];
            [[_attributedString string] enumerateSubstringsInRange:self.range
                                                           options:(NSStringEnumerationByWords |
                                                                    NSStringEnumerationLocalized |
                                                                    NSStringEnumerationSubstringNotRequired)
                                                        usingBlock:^(NSString *substring,
                                                                     NSRange substringRange,
                                                                     NSRange enclosingRange,
                                                                     BOOL *stop)
             {
                 MYSWord *word = [[MYSWord alloc] initWithAttributedString:_attributedString range:substringRange];
                 [(NSMutableArray *)_words addObject:word];
             }];
        }
        return _words;
    }
}

- (MYSWord *)wordContainingIndex:(NSUInteger)index
{
    for (MYSWord *word in self.words) {
        if (MYSNSRangeContainsIndex(word.range, index)) {
            return word;
        }
    }

    MYSWord *closest = [self.words lastObject];
    for (MYSWord *word in self.words) {
        if (MYSIndexDistanceToRange(index, word.range) < MYSIndexDistanceToRange(index, closest.range)) {
            closest = word;
        }
    }

    return closest;
}





#pragma mark - Glyphs

- (NSArray *)glyphs
{
    NSMutableArray *glyphs = [NSMutableArray new];
    for (MYSRun *run in self.runs) {
        [glyphs addObjectsFromArray:run.glyphs];
    }
    return glyphs;
}

- (MYSGlyph *)glyphAtCharacterIndex:(NSUInteger)index
{
    for (MYSGlyph *glyph in self.glyphs) {
        if (glyph.index == index) {
            return glyph;
        }
    }
    return nil;
}





#pragma mark - Geometry

// origin   - set by frame

- (CGFloat)trailingWhitespaceWidth
{
    return CTLineGetTrailingWhitespaceWidth(_lineRef);
}

- (CGFloat)ascent
{
    [self calculateTypographicalBounds];
    NSNumber *ascent = _typographicalBounds[MYSTypographicalBoundsAscentKey];
    return [ascent floatValue];
}

- (CGFloat)descent
{
    [self calculateTypographicalBounds];
    NSNumber *descent = _typographicalBounds[MYSTypographicalBoundsDescentKey];
    return [descent floatValue];
}

- (CGFloat)leading
{
    [self calculateTypographicalBounds];
    NSNumber *leading = _typographicalBounds[MYSTypographicalBoundsLeadingKey];
    return [leading floatValue];
}

- (CGFloat)lineHeight
{
    return self.ascent + self.descent + self.leading;
}

- (CGRect)boundingBox
{
    CGRect horizontalBounds     = CTLineGetBoundsWithOptions(_lineRef, kCTLineBoundsUseGlyphPathBounds);
    CGRect verticalBounds       = CTLineGetBoundsWithOptions(_lineRef, kCTLineBoundsUseOpticalBounds);



    CGRect bounds               = CGRectZero;
    bounds.size.width           = horizontalBounds.origin.x + horizontalBounds.size.width;
    bounds.size.height          = verticalBounds.size.height + 1;
    bounds.origin               = self.origin;
    bounds.origin.y            -= self.descent;
    return bounds;
}

- (CGRect)boundsWithOptions:(CTLineBoundsOptions)options
{
    return CTLineGetBoundsWithOptions(_lineRef, options);
}

- (CGFloat)offsetOfCharacterAtIndex:(NSInteger)index
{
    return CTLineGetOffsetForStringIndex(_lineRef, index, NULL);
}

- (NSUInteger)characterIndexAtPoint:(CGPoint)point
{
    point.y             = 0;
    point               = MYSPointDefinitelyInsideRect(point, self.boundingBox);
    NSUInteger index    = CTLineGetStringIndexForPosition(_lineRef, point);
    return index;
}











#pragma mark - Drawing

- (void)drawInContext:(CGContextRef)context
{
    CTLineDraw(_lineRef, context);
}




#pragma mark - Private

- (id)initWithCTLine:(CTLineRef)lineRef attributedString:(NSAttributedString *)attributedString
{
    self = [self init];
    if (self) {
        _lineRef            = MYSCFSafeRetain(lineRef);
        _attributedString   = attributedString;
    }
    return self;
}

- (void)calculateTypographicalBounds
{
    @synchronized(self) {
        if (!_typographicalBounds) {
            _typographicalBounds = [NSMutableDictionary new];
            CGFloat ascent;
            CGFloat descent;
            CGFloat leading;
            CTLineGetTypographicBounds(_lineRef, &ascent, &descent, &leading);
            _typographicalBounds = @{
                                     MYSTypographicalBoundsAscentKey    : @(ascent),
                                     MYSTypographicalBoundsDescentKey   : @(descent),
                                     MYSTypographicalBoundsLeadingKey   : @(leading)
                                     };
        }
    }
}

- (void)dealloc
{
    MYSCFSafeRelease(_lineRef);
}

- (NSString *)description
{
    NSMutableString *desc = [NSMutableString new];
    [desc appendString:[super description]];
    [desc appendString:@"\n"];
    [desc appendFormat:@"contents: %@", [[_attributedString string] substringWithRange:self.range]];
    [desc appendString:@"\n"];
    [desc appendFormat:@"range: %@", NSStringFromRange(self.range)];
    [desc appendString:@"\n"];
    [desc appendFormat:@"boundingBox: %@", NSStringFromRect(self.boundingBox)];
    [desc appendString:@"\n"];
    [desc appendFormat:@"line origin: %@", NSStringFromPoint(self.origin)];
    [desc appendString:@"\n"];
    [desc appendFormat:@"glyph count: %d", (int)self.glyphCount];
    [desc appendString:@"\n"];
    [desc appendFormat:@"trailing whitespace: %f", self.trailingWhitespaceWidth];
    [desc appendString:@"\n"];
    [desc appendFormat:@"ascent: %f", self.ascent];
    [desc appendString:@"\n"];
    [desc appendFormat:@"descent: %f", self.descent];
    [desc appendString:@"\n"];
    [desc appendFormat:@"leading: %f", self.leading];
    [desc appendString:@"\n"];
    [desc appendFormat:@"line height: %f", self.lineHeight];
    if (_frame) {
        [desc appendString:@"\n"];
        [desc appendFormat:@"line number: %d", (int)[_frame.lines indexOfObject:self]];
    }
    return desc;
}


@end
