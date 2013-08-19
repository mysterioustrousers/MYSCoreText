//
//  MYSParagraph.h
//  MYSCoreText
//
//  Created by Adam Kirk on 8/17/13.
//  Copyright (c) 2013 Mysterious Trousers. All rights reserved.
//


@interface MYSParagraph : NSObject


///-----------------------------
/// Text
///-----------------------------

/**
 *	The attributed string contents of this paragraph.
 */
@property (nonatomic, strong, readonly) NSAttributedString *attributedString;

/**
 *	The range of the original attributed string that spawned this paragraph.
 */
@property (nonatomic, assign, readonly) NSRange range;


/**
 *	The index in the original that string spawned this paragraph of the first character in the paragraph.
 *
 *	@return	The index in the original string that spawned this paragraph of the first character in the paragraph.
 */
- (NSUInteger)indexOfFirstCharacter;

/**
 *	The index in the original string that spawned this paragraph of the last character in the paragraph.
 *
 *	@return	The index in the original string that spawned this paragraph of the last character in the paragraph.
 */
- (NSUInteger)indexOfLastCharacter;


@end
