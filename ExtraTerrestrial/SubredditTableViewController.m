//
//  SubredditTableViewController.m
//  ExtraTerrestrial
//
//  Created by Christian Poplawski on 10/02/15.
//  Copyright (c) 2015 chrispop. All rights reserved.
//

#import "SubredditTableViewController.h"

static NSString * const kSelfPostTableIdentifier = @"selfPostTableCell";
static NSString * const kLinkPostTableIdentifier = @"linkPostTableViewCell";

@interface SubredditTableViewController ()
{
    // TODO: Declare in header?
    NSURL *frontpageURL;
    NSArray *tableContents;
}


@end

@implementation SubredditTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Height of the rows in the Table View
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 44.0; // random number
    
    self.apiCall = [[SubredditDataModel alloc] initWithURL:self.subredditURL];
    NSArray *keys = [[NSArray alloc] initWithObjects:@"title", @"subreddit", @"score", @"num_comments", @"thumbnail", @"domain", @"permalink", @"is_self", @"selftext", @"author", nil];
    tableContents = [self.apiCall contentOfChildrenForKeys:keys];
    
    self.navigationItem.title = self.subredditTitle;
    
    
    // Initialize table data
    //frontpageURL = [NSURL URLWithString:@"http://reddit.com/.json"];
    
    
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
    // Return the number of sections.
    // Subreddit views always have just one section.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [tableContents count];
}


#pragma mark - Fill table with data


/*
 *  Fills the cell at the given indexPath with content.
 *  There are 2 different types of cells:
 *      1. Posts leading to a self.subreddit posts. Those do not contain an UIImageView
 *      2. Post linking to a 3rd-Party website. Those do _always_ have an UIImageView
 *  For link posts, the function checks if there is a thumbnail in the post (e.g. for imgur, 
 *  youtube and some "text-links") or if the post has to be set up with a default image.
 *  
 *  NOTE: It's a design decision to set up _all_ link-posts with an UIImage to make it easier
 *  for the user to scan over the overview.
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // is self post?
    if([self isSelfPost:indexPath.row]) {
        // set cell up
        SubredditTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kSelfPostTableIdentifier];
        [self configureSelfPostCell:cell atIndexPath:indexPath];
        return cell;
    } else {
        SubredditTableViewImageCell *cell = [tableView dequeueReusableCellWithIdentifier:kLinkPostTableIdentifier];
        // has thumbnail?
        if([self hasImageAtIndexPath:indexPath.row]) {
            // set cell up with given thumbnail
            [self configureLinkPostCellWithThumbnail:cell atIndexPath:indexPath];
            return cell;
        } else {
            // set cell up with default thumbnail
            [self configureLinkPostCellWithPlaceholder:cell atIndexPath:indexPath];
            return cell;
        }
    }

}


/*
 *  Configures a self.subreddit cell. Sets the title, the subreddit and the domain.
 */
- (void)configureSelfPostCell:(SubredditTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    cell.titleLabel.text = [[tableContents objectAtIndex:indexPath.row] valueForKey:@"title"];
    cell.subredditLabel.text = [[tableContents objectAtIndex:indexPath.row] valueForKey:@"subreddit"];
    cell.destinationLabel.text = [[tableContents objectAtIndex:indexPath.row] valueForKey:@"domain"];
    cell.scoreLabel.text = [[[tableContents objectAtIndex:indexPath.row] valueForKey:@"score"] stringValue];
}


/*
 *  Sets up a link-post cell with a given thumbnail.
 */
- (void)configureLinkPostCellWithThumbnail:(SubredditTableViewImageCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    cell.titleLabel.text = [[tableContents objectAtIndex:indexPath.row] valueForKey:@"title"];
    cell.subredditLabel.text = [[tableContents objectAtIndex:indexPath.row] valueForKey:@"subreddit"];
    cell.destinationLabel.text = [[tableContents objectAtIndex:indexPath.row] valueForKey:@"domain"];
    cell.customImageView.image = [[tableContents objectAtIndex:indexPath.row] valueForKey:@"thumbnail"];
    cell.scoreLabel.text = [[[tableContents objectAtIndex:indexPath.row] valueForKey:@"score"] stringValue];
}


/*
 *  Sets up a link-post cell with the default thumbnail.
 */
- (void)configureLinkPostCellWithPlaceholder:(SubredditTableViewImageCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    cell.titleLabel.text = [[tableContents objectAtIndex:indexPath.row] valueForKey:@"title"];
    cell.subredditLabel.text = [[tableContents objectAtIndex:indexPath.row] valueForKey:@"subreddit"];
    cell.destinationLabel.text = [[tableContents objectAtIndex:indexPath.row] valueForKey:@"domain"];
    cell.customImageView.image = [UIImage imageNamed:@"globe_icon"];
    cell.scoreLabel.text = [[[tableContents objectAtIndex:indexPath.row] valueForKey:@"score"] stringValue];
}



#pragma mark - Helper methods

/*
 *  Checks if the post at the given index does contain a thumbnail.
 */
-(BOOL) hasImageAtIndexPath: (NSUInteger) indexOfPost {
    if ([[tableContents objectAtIndex:indexOfPost] objectForKey:@"thumbnail"]) {
        return YES;
    } else {
        return NO;
    }
}


/*
 *  Checks if the post at the given index of the posts array is a self.subreddit post.
 */
-(BOOL) isSelfPost: (NSUInteger) indexOfPost  {
    return [[[tableContents objectAtIndex:indexOfPost] objectForKey:@"is_self"] boolValue];
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




@end
