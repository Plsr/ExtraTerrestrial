//
//  ForntPageTableViewController.m
//  ExtraTerrestrial
//
//  Created by Christian Poplawski on 10/02/15.
//  Copyright (c) 2015 chrispop. All rights reserved.
//

#import "SubredditTableViewController.h"

@interface SubredditTableViewController ()
{
    NSURL *frontpageURL;
    NSArray *tableContents;
    NSArray *test;

}


@end

@implementation SubredditTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Height of the rows in the Table View
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 44.0; // random number
    
    // Initialize table data
    frontpageURL = [NSURL URLWithString:@"http://reddit.com/.json"];
    self.apiCall = [[RedditAPICall alloc] initWithURL:frontpageURL];
    
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

    static NSString *selfPostTableIdentifier = @"selfPostTableCell";
    static NSString *linkPostTableIdentifier = @"linkPostTableViewCell";
    
    if([self isSelfPost:indexPath.row]) {
        SubredditTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:selfPostTableIdentifier];
        [self configureSelfPostCell:cell atIndexPath:indexPath];
        return cell;
    } else {
        SubredditTableViewImageCell *cell = [tableView dequeueReusableCellWithIdentifier:linkPostTableIdentifier];
        if([self hasImageAtIndexPath:indexPath.row]) {
            [self configureLinkPostCellWithThumbnail:cell atIndexPath:indexPath];
            return cell;
        } else {
            [self configureLinkPostCellWithPlaceholder:cell atIndexPath:indexPath];
            return cell;
        }
    }

}


- (void)configureSelfPostCell:(SubredditTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    cell.titleLabel.text = [[tableContents objectAtIndex:indexPath.row] valueForKey:@"title"];
    cell.subredditLabel.text = [[tableContents objectAtIndex:indexPath.row] valueForKey:@"subreddit"];
    cell.destinationLabel.text = [[tableContents objectAtIndex:indexPath.row] valueForKey:@"domain"];
}


- (void)configureLinkPostCellWithThumbnail:(SubredditTableViewImageCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    cell.titleLabel.text = [[tableContents objectAtIndex:indexPath.row] valueForKey:@"title"];
    cell.subredditLabel.text = [[tableContents objectAtIndex:indexPath.row] valueForKey:@"subreddit"];
    cell.destinationLabel.text = [[tableContents objectAtIndex:indexPath.row] valueForKey:@"domain"];
    cell.customImageView.image = [[tableContents objectAtIndex:indexPath.row] valueForKey:@"thumbnail"];
}


- (void)configureLinkPostCellWithPlaceholder:(SubredditTableViewImageCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    cell.titleLabel.text = [[tableContents objectAtIndex:indexPath.row] valueForKey:@"title"];
    cell.subredditLabel.text = [[tableContents objectAtIndex:indexPath.row] valueForKey:@"subreddit"];
    cell.destinationLabel.text = [[tableContents objectAtIndex:indexPath.row] valueForKey:@"domain"];
    cell.customImageView.image = [UIImage imageNamed:@"globe_icon"];
}



-(BOOL) hasImageAtIndexPath: (NSUInteger) indexOfPost {
    if ([[tableContents objectAtIndex:indexOfPost] objectForKey:@"thumbnail"]) {
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


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    // TODO: use new dictionary?
    if([[segue identifier]isEqualToString:@"showSelfPostDetail"]) {
        //NSLog(@"Segue recognized");
        SelfPostTableViewController *postDetailViewController = [segue destinationViewController];
        NSIndexPath *currentPath = [self.tableView indexPathForSelectedRow];
        postDetailViewController.postData = [tableContents objectAtIndex:currentPath.row];
//        NSString *postURLString = [[tableContents objectAtIndex:currentPath.row] objectForKey:@"permalink"];
//        postDetailViewController.postURLString = postURLString;
        
        //TODO: Use isSelf to check which view should be loaded
//        postDetailViewController.isSelf = [[[tableContents objectAtIndex:currentPath.row] objectForKey:@"is_self"] boolValue];
    } else if ([[segue identifier] isEqualToString:@"showLinkPostDetail"]) {
        LinkPostViewController *linkPostDetailVC = [segue destinationViewController];
    }
}


/*
 *  Checks if the post at the given index of the posts array is a self.subreddit post.
 */
-(BOOL) isSelfPost: (NSUInteger) indexOfPost  {
    return [[[tableContents objectAtIndex:indexOfPost] objectForKey:@"is_self"] boolValue];
}

@end
