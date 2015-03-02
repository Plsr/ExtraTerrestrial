//
//  CommentTableViewCell.m
//  ExtraTerrestrial
//
//  Created by Christian Poplawski on 28/02/15.
//  Copyright (c) 2015 chrispop. All rights reserved.
//

#import "CommentTableViewCell.h"

@implementation CommentTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

// TODO: Move to cell class?
-(void)webViewDidFinishLoad:(UIWebView *)webView {
    /*CGRect frame = webView.frame;
    frame.size.height = 1;
    webView.frame = frame;
    CGSize fittingSize = [webView sizeThatFits:CGSizeZero];
    frame.size = fittingSize;
    webView.frame = frame;
    
    // TODO: Remove Debug
    NSLog(@"size: %f, %f", fittingSize.width, fittingSize.height);*/
    
    //self.webViewHeightConstraint.constant = webView.scrollView.contentSize.height;
  //  NSLog(@"THIS IS WHAT IM ACTUALLY INTERETED IN: %@", self.webViewHeightConstraint);
}


@end
