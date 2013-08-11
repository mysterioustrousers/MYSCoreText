//
//  MYSGlyph.h
//  MYSCoreText
//
//  Created by Adam Kirk on 8/2/13.
//  Copyright (c) 2013 Mysterious Trousers. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface MYSGlyph : NSObject

///---------------------------------
/// Working With Strings
///---------------------------------

/**
 *	A one glyph attributed string.
 */
@property (nonatomic, strong, readonly) NSAttributedString *attributedString;

/**
 *	The attributes of the glyph's attributed string. (font, font size, etc.)
 */
@property (nonatomic, strong, readonly) NSDictionary *attributes;

/**
 *	The index of this glyph in the run. This can be used to map the glyph back to the character in the backing store.
 */
@property (nonatomic, assign, readonly) NSUInteger index;




///--------------------------------
/// Glyph Geometry
///--------------------------------

/**
 *	The graphical position of this glyph.
 */
@property (nonatomic, assign, readonly) CGPoint position;

/**
 *	The smallest rectanble that encloses the glyph path.
 */
@property (nonatomic, assign, readonly) CGRect boundingBox;

/**
 *	The path of the glyph. You could use this to do very custom drawing of the glyph.
 */
@property (nonatomic, assign, readonly) CGPathRef path;

/**
 *	The distance in the writing direction of the beginning of rendering this glyph to the beginning of rendering
 *  the next glyph.
 */
@property (nonatomic, assign, readonly) CGSize  advance;





///--------------------------------
/// Getting Glyph Information
///--------------------------------

/**
 *	Returns an NSCharacterCollection value specifying the glyph–to–character identifier mapping of the receiver.
 */
@property (nonatomic, assign, readonly) NSCharacterCollection characterCollection;

/**
 *	Get the CTGlyphInfo reference that backs this glyph.
 */
- (CTGlyphInfoRef)CTGlyphInfo;

/**
 *	Get a CGGlyph type from this glyph.
 */
- (CGGlyph)CGGlyph;


@end
