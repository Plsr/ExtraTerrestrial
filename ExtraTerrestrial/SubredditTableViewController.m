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
    
    // If view is not set from segue it's the first startup of the app
    if(!self.setFromSegue) {
        self.subredditURL = [NSURL URLWithString:@"http://reddit.com/.json"];
        self.subredditTitle = @"front";
    }
    
    // Height of the rows in the Table View
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 44.0; // random number
    
    // Data
    self.apiCall = [[SubredditDataModel alloc] initWithURL:self.subredditURL];
    NSArray *keys = [[NSArray alloc] initWithObjects:@"title", @"subreddit", @"score", @"num_comments", @"thumbnail", @"domain", @"permalink", @"is_self", @"selftext", @"author", @"url", @"created_utc", nil];
    tableContents = [self.apiCall contentOfChildrenForKeys:keys];
    
    self.navigationItem.title = self.subredditTitle;
    self.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source


/*
 *  Subreddit tables do always just have one section.
 */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

/*
 *  Number of rows equals the number of items to bes displayed.
 */
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


/**
 *  Configures a selfPost cell without a thumbnail.
 *
 *  @param cell         The cell to be configured.
 *  @param indexPath    The indexPath of the given cell.
 *
 *  @return A configured cell of the type SubredditTableViewCell.
 *
 */
- (void)configureSelfPostCell:(SubredditTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    cell.titleLabel.text = [[tableContents objectAtIndex:indexPath.row] valueForKey:@"title"];
    cell.subredditLabel.text = [[tableContents objectAtIndex:indexPath.row] valueForKey:@"subreddit"];
    cell.destinationLabel.text = [[tableContents objectAtIndex:indexPath.row] valueForKey:@"domain"];
    cell.scoreLabel.text = [[[tableContents objectAtIndex:indexPath.row] valueForKey:@"score"] stringValue];
}


/**
 *  Configures a linkPost cell with a thumbnail provided by the API.
 *
 *  @param cell         The cell to be configured.
 *  @param indexPath    The indexPath of the given cell.
 *
 *  @return A configured cell of the type SubredditTableViewImageCell.
 *
 */
- (void)configureLinkPostCellWithThumbnail:(SubredditTableViewImageCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    cell.titleLabel.text = [[tableContents objectAtIndex:indexPath.row] valueForKey:@"title"];
    cell.subredditLabel.text = [[tableContents objectAtIndex:indexPath.row] valueForKey:@"subreddit"];
    cell.destinationLabel.text = [[tableContents objectAtIndex:indexPath.row] valueForKey:@"domain"];
    cell.customImageView.image = [[tableContents objectAtIndex:indexPath.row] valueForKey:@"thumbnail"];
    cell.scoreLabel.text = [[[tableContents objectAtIndex:indexPath.row] valueForKey:@"score"] stringValue];
}


/**
 *  Configures a linkPost cell with the default thumbnail thumbnail.
 *
 *  @param cell         The cell to be configured.
 *  @param indexPath    The indexPath of the given cell.
 *
 *  @return A configured cell of the type SubredditTableViewImageCell.
 *
 */
- (void)configureLinkPostCellWithPlaceholder:(SubredditTableViewImageCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    cell.titleLabel.text = [[tableContents objectAtIndex:indexPath.row] valueForKey:@"title"];
    cell.subredditLabel.text = [[tableContents objectAtIndex:indexPath.row] valueForKey:@"subreddit"];
    cell.destinationLabel.text = [[tableContents objectAtIndex:indexPath.row] valueForKey:@"domain"];
    cell.customImageView.image = [UIImage imageNamed:@"globe_icon"];
    cell.scoreLabel.text = [[[tableContents objectAtIndex:indexPath.row] valueForKey:@"score"] stringValue];
}



#pragma mark - Helper methods

/**
 *  Checks if the post at the given index does contain a thumbnail.
 *
 *  @param indexOfPost The index of the post to be checked.
 *
 *  @return YES if the thumbnail-key is set, NO otherwise.
 *
 */
-(BOOL) hasImageAtIndexPath: (NSUInteger) indexOfPost {
    if ([[tableContents objectAtIndex:indexOfPost] objectForKey:@"thumbnail"]) {
        return YES;
    } else {
        return NO;
    }
}


/**
 *  Checks if the post at the given index of the posts array is a self.subreddit post.
 *
 *  @param indexOfPost  Index of the post to be checked
 *
 *  @return             YES if post is s selfPost, NO otherwise.
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
    
    NSIndexPath *currentPath = [self.tableView indexPathForSelectedRow];
    
    if([[segue identifier]isEqualToString:@"showSelfPostDetail"]) {
        SelfPostTableViewController *postDetailViewController = [segue destinationViewController];
        postDetailViewController.postData = [tableContents objectAtIndex:currentPath.row];

        
    } else if ([[segue identifier] isEqualToString:@"showLinkPostDetail"]) {
        LinkPostViewController *linkPostDetailVC = [segue destinationViewController];
        linkPostDetailVC.contentURL = [[tableContents objectAtIndex:currentPath.row] valueForKey:@"url"];
    }
}




@end
