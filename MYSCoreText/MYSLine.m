//
//  MYSLine.m
//  MYSCoreText
//
//  Created by Adam Kirk on 7/19/13.
//  Copyright (c) 2013 Mysterious Trousers. All rights reserved.
//

#import "MYSLine.h"
#import "MYSLine_Private.h"
#import "MYSRun.h"
#import "MYSRun_Private.h"
#import "MYSPrivate.h"


@interface MYSLine ()
@property (nonatomic, assign           ) CTLineRef    lineRef;
@property (nonatomic, strong, readwrite) NSArray      *runs;
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
    return line;
}

- (MYSLine *)newJustifiedLineToWidth:(CGFloat)width
{
    CTLineRef lineRef = CTLineCreateJustifiedLine(_lineRef, 1.0, width);
    MYSLine *line = [[MYSLine alloc] initWithCTLine:lineRef attributedString:_attributedString];
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




#pragma mark - Runs

- (NSArray *)runs
{
    @synchronized(self) {
        if (!_runs) {
            NSMutableArray *runs    = [NSMutableArray new];
            CFArrayRef runRefs      = CTLineGetGlyphRuns(_lineRef);

            for (CFIndex i = 0; i < CFArrayGetCount(runRefs); i++) {
                CTRunRef runRef     = CFArrayGetValueAtIndex(runRefs, i);
                MYSRun *run         = [[MYSRun alloc] initWithCTRun:runRef attributedString:_attributedString];
                [runs addObject:run];
            }

            _runs = runs;
        }
        return _runs;
    }
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





#pragma mark - Typographical Bounds

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

- (CGRect)boundsWithOptions:(CTLineBoundsOptions)options
{
    return CTLineGetBoundsWithOptions(_lineRef, options);
}




#pragma mark - Character Positions

- (CGFloat)offsetOfCharacterAtIndex:(NSInteger)index
{
    return CTLineGetOffsetForStringIndex(_lineRef, index, NULL);
}

- (NSUInteger)indexOfCharacterAtPosition:(CGPoint)point
{
    return CTLineGetStringIndexForPosition(_lineRef, point);
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


@end
