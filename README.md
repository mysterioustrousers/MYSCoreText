MYSCoreText
===========

An Objective-C wrapper around Apple's Core Text framework.

### Installation

1. Clone this repo [somewhere]
2. In your Podfile, add this line:
```
pod "MYSCoreText"
```

pod? => https://github.com/CocoaPods/CocoaPods/

### Example Usage

Create a framsetter:

    NSString *string = (@"A long string of text to test on this with some really long strings of text"
                        @"that wrap and also some hard \nline breaks that will generate lines for us "
                        @"in a frame");
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:string];
    _framesetter = [[MYSFramesetter alloc] initWithAttributedString:attributedString];

Create a frame of text with a path:

    CGPathRef path  = CGPathCreateWithRect(CGRectMake(0, 0, 30, 30), NULL);
    NSRange range   = NSMakeRange(0, [_framesetter.attributedString length]);
    MYSFrame *frame = [_framesetter frameWithRange:range path:path];

Then use all the cool methods to get all the info you'd ever want about the layout of the text:

    for (MYSLine *line in frame.lines) {
      for (MYSRun *run in line.runs) {
        for (MYSGlyph *glyph in run.glyphs) {
          glyph.boundingBox; // => The bounding box of each glyph in the text.
        }
      }
    }


### Docs

http://cocoadocs.org/docsets/MYSCoreText/0.0.1/
