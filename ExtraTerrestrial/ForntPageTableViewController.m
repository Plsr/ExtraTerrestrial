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
    NSDictionary *childrenData;
    NSURL *frontpageURL;
}


@end

@implementation ForntPageTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Initialize table data
    frontpageURL = [NSURL URLWithString:@"http://reddit.com/.json"];
    self.apiCall = [[RedditAPICall alloc] initWithURL:frontpageURL];

    childrenData = [[self.apiCall.apiCallReturns valueForKey:@"children"] valueForKey:@"data"];
    
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
    return [childrenData count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"DEBUG");
    static NSString *frontPageTableIdentifier = @"frontPageTableCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:frontPageTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:frontPageTableIdentifier];
    }
    
    //cell.textLabel.text = [tableContent  objectAtIndex:indexPath.row];
    
    //  TODO: Redundant, do this outside the function!
    NSArray *titles = [childrenData valueForKey:@"title"];
    NSArray *subReddits = [childrenData valueForKey:@"subreddit"];
    
    cell.textLabel.text = [titles objectAtIndex:indexPath.row];
    //cell.detailTextLabel.text = @"test";
    cell.detailTextLabel.text = [subReddits objectAtIndex:indexPath.row];
    return cell;
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


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([[segue identifier]isEqualToString:@"showPostDetail"]) {
        PostDetailViewController *postDetailViewController = [segue destinationViewController];
        NSIndexPath *currentPath = [self.FrontPageTableView indexPathForSelectedRow];
        //NSLog(@"%ld", (long)[currentPath row]);
        NSArray *test = [self.apiCall dataForKeyArray:@"children"];
        //NSLog(@"%@", [test objectAtIndex:(long)[currentPath row]]);
        postDetailViewController.postContent = test[[currentPath row]];
        
    }
}


@end
