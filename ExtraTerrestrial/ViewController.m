//
//  ViewController.m
//  ExtraTerrestrial
//
//  Created by Christian Poplawski on 21/01/15.
//  Copyright (c) 2015 chrispop. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSURL *testURL = [[NSURL alloc] initWithString:@"http://reddit.com/.json"];
    self.redditDataConnection = [[RedditAPICall alloc] init];
    self.payload = [[NSArray alloc] init];
    //[self.redditDataConnection retrieveDataFromURL:testURL];
    //self.payload = [self.redditDataConnection returnDataForKeyChildren];
    
    //DEBUG
    NSLog(@"%@", [self.payload valueForKey:@"title"]);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
