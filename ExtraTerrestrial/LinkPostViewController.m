//
//  LinkPostViewController.m
//  ExtraTerrestrial
//
//  Created by Christian Poplawski on 19/02/15.
//  Copyright (c) 2015 chrispop. All rights reserved.
//

#import "LinkPostViewController.h"

@interface LinkPostViewController ()

@end

@implementation LinkPostViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.contentURL.description]];
    [self.webView loadRequest:request];
    // Do any additional setup after loading the view.
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLayoutSubviews {
    self.webView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
