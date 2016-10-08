//
//  Created by Marat Alekperov (aka Timur Harleev) (m.alekperov@gmail.com) on 18.11.12.
//  Copyright (c) 2012 Me and Myself. All rights reserved.
//


#import "THChatInput.h"


@implementation THChatInput


- (void) composeView {
   
   CGSize size = self.frame.size;
   
   // Input
	_inputBackgroundView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 238, size.height)];
	_inputBackgroundView.autoresizingMask = UIViewAutoresizingNone;
   _inputBackgroundView.contentMode = UIViewContentModeScaleToFill;
	//_inputBackgroundView.userInteractionEnabled = YES;
   //_inputBackgroundView.alpha = .5;
   _inputBackgroundView.backgroundColor = [UIColor clearColor];
   //_inputBackgroundView.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:.5];
	[self addSubview:_inputBackgroundView];
   [_inputBackgroundView release];
   
	// Text field
	_textView = [[UITextView alloc] initWithFrame:CGRectMake(5.0f, 0, 238, 0)];
   _textView.backgroundColor = [UIColor clearColor];
   //_textView.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:.3];
	_textView.delegate = self;
   _textView.contentInset = UIEdgeInsetsMake(-4, -2, -4, 0);
   _textView.showsVerticalScrollIndicator = NO;
   _textView.showsHorizontalScrollIndicator = NO;
	_textView.font = [UIFont fontWithName:@"HelveticaNeue" size:14.0];
	[self addSubview:_textView];
   [_textView release];
   
   [self adjustTextInputHeightForText:@"" animated:NO];
   
   _lblPlaceholder = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, 14, 160, 20)];
   _lblPlaceholder.font = [UIFont fontWithName:@"HelveticaNeue" size:14.0];
   _lblPlaceholder.text = @"Type here...";
   _lblPlaceholder.textColor = [UIColor lightGrayColor];
   _lblPlaceholder.backgroundColor = [UIColor clearColor];
	[self addSubview:_lblPlaceholder];
   [_lblPlaceholder release];
   
   [self sendSubviewToBack:_inputBackgroundView];
}


- (void) awakeFromNib {
   
   _inputHeight = 38.0f;
   _inputHeightWithShadow = 44.0f;
   _autoResizeOnKeyboardVisibilityChanged = YES;

   [self composeView];
}

- (void) adjustTextInputHeightForText:(NSString*)text animated:(BOOL)animated {
   
   int h1 = [text sizeWithFont:_textView.font].height;
   int h2 = [text sizeWithFont:_textView.font constrainedToSize:CGSizeMake(_textView.frame.size.width - 20, 170.0f) lineBreakMode:UILineBreakModeWordWrap].height;
   
   [UIView animateWithDuration:(animated ? .1f : 0) animations:^
    {
       int h = h2 == h1 ? _inputHeightWithShadow : h2 + 24;
       int delta = h - self.frame.size.height;
       CGRect r2 = CGRectMake(10, self.frame.origin.y -delta, self.frame.size.width, h);
       self.frame = r2; //CGRectMake(0, self.frame.origin.y - delta, self.superview.frame.size.width, h);
       _inputBackgroundView.frame = CGRectMake(0, 0, self.frame.size.width, h);
       
       CGRect r = _textView.frame;
       r.origin.y = 12;
       r.size.height = h - 18;
       _textView.frame = r;
        
    } completion:^(BOOL finished)
    {
       //
    }];
}

- (id) initWithFrame:(CGRect)frame {
   
   self = [super initWithFrame:frame];
   
   if (self)
   {
      _inputHeight = 38.0f;
      _inputHeightWithShadow = 44.0f;
      _autoResizeOnKeyboardVisibilityChanged = YES;
      
      [self composeView];
   }
   return self;
}

- (void) fitText {
   
   [self adjustTextInputHeightForText:_textView.text animated:YES];
}

- (void) setText:(NSString*)text {
   
   _textView.text = text;
   _lblPlaceholder.hidden = text.length > 0;
   [self fitText];
}


#pragma mark UITextFieldDelegate Delegate

- (void) textViewDidBeginEditing:(UITextView*)textView {
   
   if (_autoResizeOnKeyboardVisibilityChanged)
   {
       
       [UIView animateWithDuration:.25f animations:^{
           CGRect r = self.frame;
           r.origin.y -= 216;
           [self setFrame:r];
           
       }];

      
      [self fitText];
   }
   if ([_delegate respondsToSelector:@selector(textViewDidBeginEditing:)])
      [_delegate performSelector:@selector(textViewDidBeginEditing:) withObject:textView];
}

- (void) textViewDidEndEditing:(UITextView*)textView {
   
   if (_autoResizeOnKeyboardVisibilityChanged)
   {
       [UIView animateWithDuration:.25f animations:^{
           CGRect r = self.frame;
           r.origin.y += 216;
           [self setFrame:r];
       }];
      
      [self fitText];
   }
   _lblPlaceholder.hidden = _textView.text.length > 0;
   
   if ([_delegate respondsToSelector:@selector(textViewDidEndEditing:)])
     [_delegate performSelector:@selector(textViewDidEndEditing:) withObject:textView];
}

- (BOOL) textView:(UITextView*)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString*)text {
   
   if ([text isEqualToString:@"\n"])
   {
      if ([_delegate respondsToSelector:@selector(returnButtonPressed:)])
         [_delegate performSelector:@selector(returnButtonPressed:) withObject:_textView afterDelay:.1];
      return NO;
   }
   else if (text.length > 0)
   {
      [self adjustTextInputHeightForText:[NSString stringWithFormat:@"%@%@", _textView.text, text] animated:YES];
   }
   return YES;
}

- (void) textViewDidChange:(UITextView*)textView {
   
    _lblPlaceholder.hidden = _textView.text.length > 0;
   
   [self fitText];
   
   if ([_delegate respondsToSelector:@selector(textViewDidChange:)])
      [_delegate performSelector:@selector(textViewDidChange:) withObject:textView];
}


@end
