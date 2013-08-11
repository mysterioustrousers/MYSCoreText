//
//  MYSRun.m
//  MYSCoreText
//
//  Created by Adam Kirk on 7/19/13.
//  Copyright (c) 2013 Mysterious Trousers. All rights reserved.
//

#import "MYSRun.h"
#import "MYSRun_Private.h"
#import "MYSPrivate.h"
#import "MYSGlyph.h"
#import "MYSGlyph_Private.h"


@interface MYSRun ()
@property (nonatomic, assign           ) CTRunRef           runRef;
@property (nonatomic, copy,   readwrite) NSAttributedString *attributedString;
@property (nonatomic, strong           ) NSDictionary       *typographicalBounds;
@end


@implementation MYSRun


#pragma mark - Working With Text

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
            NSMutableArray *glyphs  = [NSMutableArray new];
            NSUInteger glyphCount   = CTRunGetGlyphCount(_runRef);
            CGGlyph *glyphRefs      = malloc(sizeof(CGGlyph) * glyphCount);
            CTRunGetGlyphs(_runRef, CFRangeMake(0, glyphCount - 1), glyphRefs);

            NSUInteger charCount    = CTRunGetStringRange(_runRef).length;
            CFIndex *indices        = malloc(sizeof(CFIndex) * charCount);
            CTRunGetStringIndices(_runRef, CTRunGetStringRange(_runRef), indices);

            CGPoint *positions      = malloc(sizeof(CGPoint) * glyphCount);
            CTRunGetPositions(_runRef, CFRangeMake(0, glyphCount - 1), positions);

            CGSize *advances        = malloc(sizeof(CGSize) * glyphCount);
            CTRunGetAdvances(_runRef, CFRangeMake(0, glyphCount - 1), advances);

            for (CFIndex i = 0; i < glyphCount; i++) {
                CGGlyph glyphRef    = glyphRefs[i];
                MYSGlyph *glyph     = [[MYSGlyph alloc] initWithCGGlyph:glyphRef attributedString:_attributedString];
                glyph.attributes    = (__bridge NSDictionary *)CTRunGetAttributes(_runRef);
                glyph.index         = indices[i];
                glyph.position      = positions[i];
                glyph.advance       = advances[i];
                [glyphs addObject:glyph];
            }

            _glyphs = glyphs;
        }
        return _glyphs;
    }
}




#pragma mark - Typographic Geometry

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


@end
