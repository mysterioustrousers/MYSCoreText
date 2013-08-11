//
//  MYSFrameSetter.h
//  MYSCoreText
//
//  Created by Adam Kirk on 7/19/13.
//  Copyright (c) 2013 Mysterious Trousers. All rights reserved.
//

@class MYSFrame;
@class MYSTypesetter;


@interface MYSFramesetter : NSObject

/**
 *	The attributed string to be laid out and drawn. When 
 *  this changes, all derived objects become invalid.
 */
@property (nonatomic, copy) NSAttributedString *attributedString;

/**
 *	The typsetter used to help layout the text into lines. You can modify the typesetter to
 *  change how the text is laid out into a frame.
 */
@property (nonatomic, strong, readonly) MYSTypesetter *typesetter;



///---------------------------------------
/// @name Creating A Framesetter
///---------------------------------------

/**
 *	Create a new framesetter with an attributed string.
 *
 *	@param	attributedString	
 *              The attributed string.
 *
 *	@return	A newly created framesetter.
 */
- (id)initWithAttributedString:(NSAttributedString *)attributedString;



///---------------------------------------
/// @name Creating Frames
///---------------------------------------

/**
 *	A frame that lays out the range of text inside the path.
 *
 *	@param	range	
 *              The range of text in `attributedString` to lay out into lines.
 *	@param	path	
 *              The path to fill with text.
 *
 *	@return	A frame with lines of text laid out into lines that fit inside `path`.
 */
- (MYSFrame *)frameWithRange:(NSRange)range path:(CGPathRef)path;

/**
 *	A frame with the text from `attributedString` laid out inside `rect`.
 *
 *	@param	rect	
 *              The rect to lay the text out in.
 *
 *	@return	A new frame with text layed out in `rect`.
 */
- (MYSFrame *)frameWithRect:(CGRect)rect;



///---------------------------------------
/// @name Getting Suggested Frame Sizes
///---------------------------------------

/**
 *    Returns the suggested frame size for the text constrained to `width`.
 *
 *    @param    width    
 *                  The width you'd like to constain the size to. Decreasing the width will increase the height
 *                 and the inverse.
 *
 *    @return   The suggested size of a frame that would fit all the text in `attributedString`.
 */
- (CGSize)suggestedSizeConstrainedToWidth:(CGFloat)width;

/**
 *    Returns the suggested frame size for the text constrained to `size`.
 *
 *    @param    size    
 *                  The size you'd like to constain the size to.
 *
 *    @return   The suggested size of a frame that would fit all the text in `attributedString`.
 */
- (CGSize)suggestedSizeConstrainedToSize:(CGSize)size;

/**
 *    Returns the suggested frame size for the text constrained to `size`.
 *
 *    @param    range   
 *                  The range of `attributedString` to use to calcuate the suggestion.
 *    @param    size    
 *                  The size the suggestion should use as the maximum possible suggested size.
 *
 *    @return The smallest size the text would fit in.
 */
- (CGSize)suggestedSizeOfRange:(NSRange)range constrainedToSize:(CGSize)size;



///---------------------------------------
/// @name Range Calculations
///---------------------------------------

/**
 *    The range that actually fits in a frame of `size`.
 *
 *    @param    size    
 *                  The size the text should try to fit in.
 *
 *    @return   The range of `attributedString` that will actually fit in a frame of size `size`.
 */
- (NSRange)rangeThatFitsInFrameOfSize:(CGSize)size;



@end
