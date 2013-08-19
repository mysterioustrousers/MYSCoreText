//
//  MYSGlyph.h
//  MYSCoreText
//
//  Created by Adam Kirk on 8/2/13.
//  Copyright (c) 2013 Mysterious Trousers. All rights reserved.
//


@interface MYSGlyph : NSObject



/**
 *	The run that spawned this glyph.
 */
@property (nonatomic, assign, readonly) MYSRun *run;




///---------------------------------
/// Text
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
/// Geometry
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
 *	The distance in the writing direction of the beginning of rendering this glyph to the beginning of rendering
 *  the next glyph.
 */
@property (nonatomic, assign, readonly) CGSize  advance;

/**
 *	The largest glyph ascent on the line.
 *  The ascent is the distance from the baseline to the top of the glyph.
 */
@property (nonatomic, assign, readonly) CGFloat ascent;

/**
 *	The largest glyph descent on the line.
 *  The descent of a glyph is the distance from the baseline to the lowest point on the glyph.
 */
@property (nonatomic, assign, readonly) CGFloat descent;

/**
 *	The leading of this line.
 *  The leading of a line is the space between the tops line's glyph's bounding box and the bottom line's glyph's bb.
 */
@property (nonatomic, assign, readonly) CGFloat leading;

/**
 *  The lineheight of this line.
 *  The lineheight is calculated by adding up the ascent, descent and leading of a line.
 */
@property (nonatomic, assign, readonly) CGFloat lineHeight;

/**
 *	Returns the text matrix needed to draw this run. To properly draw the glyphs in a run, the fields tx and ty
 *  of the CGAffineTransform returned by this function should be set to the current text position.
 */
@property (nonatomic, assign, readonly) CGAffineTransform textMatrix;

/**
 *	The path of the glyph. You could use this to do very custom drawing of the glyph.
 */
- (CGPathRef)newPathOfGlyph;





///--------------------------------
/// Glyph Information
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
