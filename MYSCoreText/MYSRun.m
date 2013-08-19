//
//  MYSRun.m
//  MYSCoreText
//
//  Created by Adam Kirk on 7/19/13.
//  Copyright (c) 2013 Mysterious Trousers. All rights reserved.
//

#import "MYSRun_Private.h"
#import "MYSGlyph_Private.h"
#import "MYSPrivate.h"


@interface MYSRun ()
@property (nonatomic, assign           ) CTRunRef           runRef;
@property (nonatomic, copy,   readwrite) NSAttributedString *attributedString;
@property (nonatomic, strong           ) NSDictionary       *typographicalBounds;
@end


@implementation MYSRun


#pragma mark - Text

- (NSAttributedString *)attributedString
{
    NSRange range = MYSNSRangeBridge(CTRunGetStringRange(_runRef));
    return [_attributedString attributedSubstringFromRange:range];
}

- (NSDictionary *)attributes
{
    NSDictionary *attributes = (__bridge NSDictionary *)CTRunGetAttributes(_runRef);
    return attributes;
}

- (CTRunStatus)status
{
    return CTRunGetStatus(_runRef);
}

- (NSRange)range
{
    CFRange range = CTRunGetStringRange(_runRef);
    return MYSNSRangeBridge(range);
}




#pragma mark - Glyphs

- (NSUInteger)glyphCount
{
    return CTRunGetGlyphCount(_runRef);
}

- (NSArray *)glyphs
{
    @synchronized(self) {
        if (!_glyphs) {
            _glyphs  = [NSMutableArray new];
            NSUInteger glyphCount   = CTRunGetGlyphCount(_runRef);

            CGGlyph glyphRefs[glyphCount];
            CTRunGetGlyphs(_runRef, CFRangeMake(0, glyphCount), glyphRefs);

            CFIndex indices[glyphCount];
            CTRunGetStringIndices(_runRef, CFRangeMake(0, 0), indices);

            CGPoint positions[glyphCount];
            CTRunGetPositions(_runRef, CFRangeMake(0, glyphCount), positions);

            CGSize advances[glyphCount];
            CTRunGetAdvances(_runRef, CFRangeMake(0, glyphCount), advances);

            for (CFIndex i = 0; i < glyphCount; i++) {
                CGGlyph glyphRef    = glyphRefs[i];
                MYSGlyph *glyph     = [[MYSGlyph alloc] initWithCGGlyph:glyphRef attributedString:_attributedString];
                glyph.attributes    = (__bridge NSDictionary *)CTRunGetAttributes(_runRef);
                glyph.index         = indices[i];
                glyph.position      = positions[i];
                glyph.advance       = advances[i];
                glyph.ascent        = self.ascent;
                glyph.descent       = self.descent;
                glyph.leading       = self.leading;
                glyph.lineHeight    = self.lineHeight;
                glyph.textMatrix    = self.textMatrix;
                glyph.run           = self;
                [(NSMutableArray *)_glyphs addObject:glyph];
            }
        }
        return _glyphs;
    }
}




#pragma mark - Geometry

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

- (CGAffineTransform)textMatrix
{
    return CTRunGetTextMatrix(_runRef);
}

- (CGRect)boundsInContext:(CGContextRef)context
{
    return CTRunGetImageBounds(_runRef, context, CTRunGetStringRange(_runRef));
}




#pragma mark - Drawing

- (void)drawInContext:(CGContextRef)context
{
    CTRunDraw(_runRef, context, CTRunGetStringRange(_runRef));
}




#pragma mark - Private

- (id)initWithCTRun:(CTRunRef)runRef attributedString:(NSAttributedString *)attributedString
{
    self = [super init];
    if (self) {
        _runRef             = MYSCFSafeRetain(runRef);
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
            CTRunGetTypographicBounds(_runRef, CFRangeMake(0, CTRunGetGlyphCount(_runRef)), &ascent, &descent, &leading);
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
    MYSCFSafeRelease(_runRef);
}

- (NSString *)description
{
    return [[_attributedString string] substringWithRange:self.range];
}

@end
