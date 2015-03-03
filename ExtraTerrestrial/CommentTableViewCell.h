//
//  CommentTableViewCell.h
//  ExtraTerrestrial
//
//  Created by Christian Poplawski on 28/02/15.
//  Copyright (c) 2015 chrispop. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *authorLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UITextView *bodyTextView;
@property (weak, nonatomic) IBOutlet UIWebView *bodyWebView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textViewLeftPadding;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *authorLabelLeftPadding;



@end
