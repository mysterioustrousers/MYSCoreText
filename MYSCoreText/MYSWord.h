//
//  MYSWord.h
//  MYSCoreText
//
//  Created by Adam Kirk on 8/17/13.
//  Copyright (c) 2013 Mysterious Trousers. All rights reserved.
//


@interface MYSWord : NSObject


///-----------------------------
/// Text
///-----------------------------

/**
 *	The attributed string contents of this word.
 */
@property (nonatomic, strong, readonly) NSAttributedString *attributedString;

/**
 *	The range of the original attributed string that spawned this word.
 */
@property (nonatomic, assign, readonly) NSRange range;

/**
 *	The index in the original that string spawned this word of the first character in the word.
 *
 *	@return	The index in the original string that spawned this word of the first character in the word.
 */
- (NSUInteger)indexOfFirstCharacter;

/**
 *	The index in the original string that spawned this word of the last character in the word.
 *
 *	@return	The index in the original string that spawned this word of the last character in the word.
 */
- (NSUInteger)indexOfLastCharacter;



@end
