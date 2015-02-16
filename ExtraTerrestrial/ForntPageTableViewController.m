//
//  ForntPageTableViewController.m
//  ExtraTerrestrial
//
//  Created by Christian Poplawski on 10/02/15.
//  Copyright (c) 2015 chrispop. All rights reserved.
//

#import "ForntPageTableViewController.h"

@interface ForntPageTableViewController ()
{
    NSArray *childrenData;
    NSURL *frontpageURL;
    NSArray *tableContents;
    NSArray *test;

}


@end

@implementation ForntPageTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Initialize table data
    frontpageURL = [NSURL URLWithString:@"http://reddit.com/.json"];
    self.apiCall = [[RedditAPICall alloc] initWithURL:frontpageURL];

    childrenData = [self.apiCall.apiCallReturns valueForKey:@"children"];
    
    NSArray *keys = [[NSArray alloc] initWithObjects:@"title", @"subreddit", @"score", @"num_comments", @"thumbnail", @"domain", @"permalink", @"is_self", @"selftext", @"author", nil];
    tableContents = [self.apiCall contentOfChildrenForKeys:keys];
    //test = [tableContents objectForKey:@"thumbnail"];
    
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
    return [tableContents count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //NSLog(@"DEBUG");
    static NSString *frontPageTableIdentifier = @"frontPageTableCell";
    static NSString *frontPageViewTableIdentifier = @"frontPageTableViewCell";
    
    if([self hasImageAtIndexPath:indexPath]) {
        FrontPageTableViewImageCell *cell = [tableView dequeueReusableCellWithIdentifier:frontPageViewTableIdentifier];
        [self configureImageCell:cell atIndexPath:indexPath];
        return cell;
    } else {
        FrontPageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:frontPageTableIdentifier];
        [self configureBasicCell:cell atIndexPath:indexPath];
        return cell;
    }
    
}


- (void)configureBasicCell:(FrontPageTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    cell.titleLabel.text = [[tableContents objectAtIndex:indexPath.row] valueForKey:@"title"];
    cell.subredditLabel.text = [[tableContents objectAtIndex:indexPath.row] valueForKey:@"subreddit"];
    cell.destinationLabel.text = [[tableContents objectAtIndex:indexPath.row] valueForKey:@"domain"];
}


- (void)configureImageCell:(FrontPageTableViewImageCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    cell.titleLabel.text = [[tableContents objectAtIndex:indexPath.row] valueForKey:@"title"];
    cell.subredditLabel.text = [[tableContents objectAtIndex:indexPath.row] valueForKey:@"subreddit"];
    cell.destinationLabel.text = [[tableContents objectAtIndex:indexPath.row] valueForKey:@"domain"];
    cell.customImageView.image = [[tableContents objectAtIndex:indexPath.row] valueForKey:@"thumbnail"];
}

-(BOOL) hasImageAtIndexPath: (NSIndexPath *) indexPath {
    if ([[tableContents objectAtIndex:indexPath.row] objectForKey:@"thumbnail"]) {
        return YES;
    } else {
        return NO;
    }
}

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


// Adapted from http://www.raywenderlich.com/73602/dynamic-table-view-cell-height-auto-layout
 // TODO: Finish
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    static FrontPageTableViewCell *sizingCell = nil;
    
    //  GCD, see https://developer.apple.com/library/mac/documentation/Performance/Reference/GCD_libdispatch_Ref/index.html#//apple_ref/c/func/dispatch_once
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //  This part is only ran once
        sizingCell = [self.tableView dequeueReusableCellWithIdentifier:@"frontPageTableCell"];
    });
    [self configureBasicCell:sizingCell atIndexPath:indexPath];
    [sizingCell setNeedsLayout];
    [sizingCell setNeedsDisplay];
    CGSize size = [sizingCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    return size.height + 1.0f;
    
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    // TODO: use new dictionary?
    if([[segue identifier]isEqualToString:@"showPostDetail"]) {
        //NSLog(@"Segue recognized");
        SelfPostTableViewController *postDetailViewController = [segue destinationViewController];
        NSIndexPath *currentPath = [self.tableView indexPathForSelectedRow];
        postDetailViewController.postData = [tableContents objectAtIndex:currentPath.row];
//        NSString *postURLString = [[tableContents objectAtIndex:currentPath.row] objectForKey:@"permalink"];
//        postDetailViewController.postURLString = postURLString;
        
        //TODO: Use isSelf to check which view should be loaded
//        postDetailViewController.isSelf = [[[tableContents objectAtIndex:currentPath.row] objectForKey:@"is_self"] boolValue];
    }
}


@end
