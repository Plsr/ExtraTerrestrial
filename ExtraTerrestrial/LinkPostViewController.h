//
//  LinkPostViewController.h
//  ExtraTerrestrial
//
//  Created by Christian Poplawski on 19/02/15.
//  Copyright (c) 2015 chrispop. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LinkPostViewController : UIViewController

@property (strong, nonatomic) NSURL* contentURL;
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end
