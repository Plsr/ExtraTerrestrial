//
//  SelfPostTableViewController.m
//  ExtraTerrestrial
//
//  Created by Christian Poplawski on 13/02/15.
//  Copyright (c) 2015 chrispop. All rights reserved.
//

#import "SelfPostTableViewController.h"

@interface SelfPostTableViewController ()

@end

@implementation SelfPostTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"%@", self.postData);
    
    //NSURL *singlePostURL = [self urlFromPermalink:self.postURLString];
    //SinglePostAPICall *apiCall = [[SinglePostAPICall alloc] initWithURL:singlePostURL];
    //NSLog(@"%@", apiCall.apiCallReturns);
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *titleCellIdentifier = @"titleCell";
    TitleTableViewCell *titleCell = [tableView dequeueReusableCellWithIdentifier:titleCellIdentifier];
    titleCell.title.text = [self.postData objectForKey:@"title"];
    titleCell.author.text = [self.postData objectForKey:@"author"];
    titleCell.body.text = [self.postData objectForKey:@"selftext"];
    //titleCell.score.text = [self.postData objectForKey:@"score"];
    return titleCell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    static TitleTableViewCell *sizingCell = nil;
    
    //  GCD, see https://developer.apple.com/library/mac/documentation/Performance/Reference/GCD_libdispatch_Ref/index.html#//apple_ref/c/func/dispatch_once
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //  This part is only ran once
        sizingCell = [self.tableView dequeueReusableCellWithIdentifier:@"titleCell"];
    });
    sizingCell.title.text = [self.postData objectForKey:@"title"];
    sizingCell.author.text = [self.postData objectForKey:@"author"];
    sizingCell.body.text = [self.postData objectForKey:@"selftext"];
    [sizingCell setNeedsLayout];
    [sizingCell setNeedsDisplay];
    CGSize size = [sizingCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    return size.height + 1.0f;
    
}



-(NSURL *) urlFromPermalink: (NSString *) permalink {
    NSString *redditURL = @"http://reddit.com";
    NSString *json = @".json";
    NSString *construct = [[redditURL stringByAppendingString:permalink] stringByAppendingString:json];
    NSURL *validPermalinkURL = [NSURL URLWithString:construct];
    return validPermalinkURL;
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
