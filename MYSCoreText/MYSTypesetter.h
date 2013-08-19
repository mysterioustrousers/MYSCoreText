//
//  MYSTypesetter.h
//  MYSCoreText
//
//  Created by Adam Kirk on 8/1/13.
//  Copyright (c) 2013 Mysterious Trousers. All rights reserved.
//


@class MYSFramesetter;
@class MYSLine;


@interface MYSTypesetter : NSObject


/**
 *	The framesetter that created this typsetter, if there is one.
 */
@property (nonatomic, assign, readonly) MYSFramesetter *framesetter;

/**
 *  The attributed string used to create the typesetter.
 */
@property (nonatomic, copy, readonly) NSAttributedString *attributedString;



///----------------------------
/// Creating Typesetters
///----------------------------

/**
 *  Creates a typesetter with the attributed string.
 *
 *  @param  attributedString
 *              The attributed string to typeset. This parameter must be filled in with a valid
 *              CFAttributedString object.
 *
 *  @return The resultant typesetter can be used to create lines, perform line breaking, and do other
 *              contextual analysis based on the characters in the string.
 */
- (id)initWithAttributedString:(NSAttributedString *)attributedString;




///----------------------------
/// Creating Lines
///----------------------------

/**
 *    Creates an immutable line from the typesetter.
 *
 *    @param    range    
 *                  The string range on which the line is based. If the length portion of range is set to 0, 
 *                  then the typesetter continues to add glyphs to the line until it runs out of characters 
 *                  in the string. The location and length of the range must be within the bounds of the 
 *                  string, or the call will fail.
 *
 *    @return   An MYSLine object.
 */
- (MYSLine *)lineWithRange:(NSRange)range;

/**
 *    Creates an immutable line from the typesetter at a specified line offset.
 *
 *    @param    range    
 *                  The string range on which the line is based. If the length portion of range is set to 0, 
 *                  then the typesetter continues to add glyphs to the line until it runs out of characters 
 *                  in the string. The location and length of the range must be within the bounds of the 
 *                  string, or the call will fail.
 *    @param    offset
 *                  The line position offset.
 *
 *    @return   An MYSLine object.
 */
- (MYSLine *)lineWithRange:(NSRange)range offset:(CGFloat)offset;




///----------------------------
/// Breaking Lines
///----------------------------

/**
 *    Suggests a contextual line breakpoint based on the width provided.
 *
 *    @param    startIndex  
 *                  The starting point for the line-break calculations. The break
 *                  calculations include the character starting at startIndex.
 *    @param    width       
 *                  The requested line-break width.
 *
 *    @return   A count of the characters from startIndex that would cause the line break. The value returned can be
 *              used to construct a character range for `lineWithRange:`
 */
- (NSInteger)suggestedLineBreakIndexWithStartIndex:(NSInteger)startIndex width:(CGFloat)width;

/**
 *    Suggests a contextual line breakpoint based on the width provided and the specified offset.
 *    NOTE: The core text function this relies on appears to be broken. Changing offset does nothing to the result.
 *
 *    @param    startIndex
 *                  The starting point for the line-break calculations. The break
 *                  calculations include the character starting at startIndex.
 *    @param    width
 *                  The requested line-break width.
 *    @param    offset
 *                  The line position offset.
 *
 *    @return   A count of the characters from startIndex that would cause the line break. The value returned can be
 *              used to construct a character range for `lineWithRange:offset:`
 */
- (NSInteger)suggestedLineBreakIndexWithStartIndex:(NSInteger)startIndex width:(CGFloat)width offset:(CGFloat)offset;

/**
 *    Suggests a cluster line breakpoint based on the width provided.
 *
 *    @param    startIndex  
 *                  The starting point for the typographic cluster-break calculations. The break
 *                  calculations include the character starting at startIndex.
 *    @param    width       
 *                  The requested typographic cluster-break width.
 *
 *    @return   A count of the characters from startIndex that would cause the cluster break. The value
 *              returned can be used to construct a character range for `lineWithRange:`.
 */
- (NSInteger)suggestedClusterBreakIndexWithStartIndex:(NSInteger)startIndex width:(CGFloat)width;

/**
 *    Suggests a cluster line breakpoint based on the specified width and line offset.
 *
 *    @param    startIndex    
 *                  The starting point for the typographic cluster-break calculations. The break calculations
 *                  include the character starting at startIndex.
 *    @param    width    
 *                  The requested typographic cluster-break width.
 *    @param    offset    
 *                  The line offset position.
 *
 *    @return   A count of the characters from startIndex that would cause the cluster break. The value returned
 *              can be used to construct a character range for `lineWithRange:offset:`.
 */
- (NSInteger)suggestedClusterBreakIndexWithStartIndex:(NSInteger)startIndex width:(CGFloat)width offset:(CGFloat)offset;


@end
