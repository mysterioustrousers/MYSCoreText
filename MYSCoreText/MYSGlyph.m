//
//  MYSGlyph.m
//  MYSCoreText
//
//  Created by Adam Kirk on 8/2/13.
//  Copyright (c) 2013 Mysterious Trousers. All rights reserved.
//

#import "MYSRun_Private.h"
#import "MYSLine_Private.h"
#import "MYSFrame_Private.h"
#import "MYSGlyph_Private.h"
#import "MYSPrivate.h"


@interface MYSGlyph ()
@property (nonatomic, assign) CGGlyph            glyphRef;
@property (nonatomic, assign) CTGlyphInfoRef     glyphInfoRef;
@property (nonatomic, assign) CTFontRef          fontRef;
@property (nonatomic, strong) NSAttributedString *attributedString;
@end


@implementation MYSGlyph




#pragma mark - Text

- (NSAttributedString *)attributedString
{
    NSRange range = NSMakeRange(self.index, 1);
    return [_attributedString attributedSubstringFromRange:range];
}

// attributes   - assigned by run

// index        - assigned by run




#pragma mark - Geometry

// position     - assigned by run

- (CGRect)boundingBox
{
    CGRect r        = CGRectMake(0, 0, _advance.width, _lineHeight);
    r.origin        = MYSConvertPointFromRect(r.origin, _run.line.boundingBox);
    r.origin        = MYSConvertPointFromRect(r.origin, _run.line.frame.boundingBox);
    r.origin.x      = _position.x;
    r.origin.y     -= _descent;
    r.size.height  += _descent;
    return r;
}

- (CGPathRef)newPathOfGlyph;
{
    return CTFontCreatePathForGlyph(_fontRef, _glyphRef, NULL);
}

// advance      - assigned by run

// ascent       - assigned by run

// descent      - assigned by run

// leading      - assigned by run

// lineHeight   - assigned by run

// textMatrix   - assigned by run





#pragma mark - Glyph Information

- (NSString *)name
{
    NSString *name = (__bridge NSString *)CTGlyphInfoGetGlyphName(_glyphInfoRef);
    return name;
}

- (NSUInteger)characterIdentifier
{
    return CTGlyphInfoGetCharacterIdentifier(_glyphInfoRef);
}

- (NSCharacterCollection)characterCollection
{
    return CTGlyphInfoGetCharacterCollection(_glyphInfoRef);
}

- (CTGlyphInfoRef)CTGlyphInfo
{
    return _glyphInfoRef;
}

- (CGGlyph)CGGlyph
{
    return _glyphRef;
}




#pragma mark - Private

- (id)initWithCGGlyph:(CGGlyph)glyph attributedString:(NSAttributedString *)attributedString
{
    self = [super init];
    if (self) {
        _glyphRef                       = glyph;
        _attributedString               = attributedString;

        CFDictionaryRef attributesRef   = (__bridge CFDictionaryRef)_attributes;
        if (attributesRef && CFDictionaryContainsKey(attributesRef, kCTFontAttributeName)) {
            CTFontDescriptorRef fontDescriptorRef = CTFontDescriptorCreateWithAttributes(attributesRef);
            _fontRef = CTFontCreateWithFontDescriptor(fontDescriptorRef, 0.0, NULL);
            MYSCFSafeRelease(fontDescriptorRef);
        }
        else {
            _fontRef = CTFontCreateUIFontForLanguage(kCTFontSmallSystemFontType, 0, NULL);
        }

        _glyphInfoRef               = CTGlyphInfoCreateWithGlyph(_glyphRef,
                                                                 _fontRef,
                                                                 (__bridge CFStringRef)[self.attributedString string]);
    }
    return self;
}

- (NSString *)description
{
    return [self.attributedString string];
}

@end
