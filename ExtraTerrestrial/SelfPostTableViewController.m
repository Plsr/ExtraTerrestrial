//
//  SelfPostTableViewController.m
//  ExtraTerrestrial
//
//  Created by Christian Poplawski on 13/02/15.
//  Copyright (c) 2015 chrispop. All rights reserved.
//

#import "SelfPostTableViewController.h"

// Identifiers for prototype cells
static NSString * const kContentCellIdentifier = @"contentCell";
static NSString * const kCommentCellIdentifier = @"commentCell";
static NSString * const kContinueCellIdentifier = @"continueCell";

@interface SelfPostTableViewController (){
    NSArray *commentsData;
}

@end

@implementation SelfPostTableViewController

// TODO: Add activity indicator until data is loaded, load data elesewhere
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Set estimated row height, overridden when cells now their exact size
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 144.0;
    
    // Load comment data
    // Data of the post itself is set by SubredditTableViewController
    self.postURLString = [self.postData objectForKey:@"permalink"];
    NSURL *singlePostURL = [self urlFromPermalink:self.postURLString];
    SinglePostDataModel *dataModel = [[SinglePostDataModel alloc] initWithURL:singlePostURL];
    commentsData = [NSArray arrayWithArray:[dataModel topLevelComments]];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source


/*
 *  Number of sections in the table view.
 *  In this case we got two: One section with the post data
 *  and one section with the comments.
 */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}


/*
 *  Set the number of rows in each section.
 *  For the first section this is only one rwo - the content.
 *  The second view contains a dynamic number of row given by the number of comments.
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else {
        // Quickfix for last element of array, which only contains the links to the "load more" comments
        // TODO: Do somethinge useful with the "more comments" links
        return [commentsData count] - 1;
    }
}


/*
 *  Decide which cell should be set for the current indexPath.
 *  For the SelfPostTableView we have three different kinds of cells:
 *      1. ContentTableViewCell, only configured once in the entire view,
 *         contains the content of the post.
 *      2. CommentTableViewCell, cell for one single comment, is indented by
 *         level.
 *      3. ContinueTableViewCell, indicates that the current thread was not fully
 *         loaded, is indented by level.
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        // First section only contains the content cell
        ContentTableViewCell *contentCell = [tableView dequeueReusableCellWithIdentifier:kContentCellIdentifier];
        [self configureContentCell:contentCell atIndexPath:indexPath];
        return contentCell;
    } else {
        if ([[[commentsData objectAtIndex:indexPath.row] objectForKey:@"isMoreIndicator"] boolValue]) {
            // If cell is a "more indicator", set a continue cell
            ContinueTableViewCell *continueCell = [tableView dequeueReusableCellWithIdentifier:kContinueCellIdentifier];
            [self configerContinueCell:continueCell atIndexPath:indexPath];
            return continueCell;
        } else {
            // Regular comment cell
            CommentTableViewCell *commentCell = [tableView dequeueReusableCellWithIdentifier:kCommentCellIdentifier];
            [self configureCommentCell:commentCell atIndexPath:indexPath];
            return commentCell;
        }
    }
}


/**
 *  Configures a content cell.
 *
 *  @param cell         The cell to be configured
 *  @param indexPath    The current indexPath
 *
 */
- (void)configureContentCell:(ContentTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    // Set the labels
    cell.titleLabel.text = [self.postData objectForKey:@"title"];
    cell.authorLabel.text = [self.postData objectForKey:@"author"];
    cell.scoreLabel.text = [[self.postData objectForKey:@"score"] stringValue];
    cell.subredditLabel.text = [self.postData objectForKey:@"subreddit"];
    cell.timeLabel.text = [self timeSincePosted:[[self.postData objectForKey:@"created_utc"] doubleValue]];
    
    // Set the content
    // This whole thing is kind of slow
    if ([[self.postData objectForKey:@"selftext"] length]) {
        NSString *htmlSelftext = [self createHTMLStringFromMarkdown:[self.postData objectForKey:@"selftext"]];
        NSAttributedString *attributedString = [[NSAttributedString alloc] initWithData:[htmlSelftext dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
        cell.contentTextView.attributedText = attributedString;
        [cell.contentTextView setFont:[UIFont systemFontOfSize:17]];
    } else {
        // No body content, remove UITextView.
        // TODO: Collapses the whole cell
        [cell.contentTextView removeFromSuperview];
    }
    
    // Update constraints after elements are filled with content.
    [cell setNeedsUpdateConstraints];
    [cell updateConstraintsIfNeeded];
}


/**
 *  Configures a comment cell.
 *
 *  @param cell         The cell to be configured
 *  @param indexPath    The current indexPath
 *
 */
-(void)configureCommentCell: (CommentTableViewCell *) cell atIndexPath: (NSIndexPath *) indexPath {
    // Fill the cell with its content
    cell.authorLabel.text = [[commentsData objectAtIndex:indexPath.row] objectForKey:@"author"];
    cell.scoreLabel.text = [[[commentsData objectAtIndex:indexPath.row] objectForKey:@"score"] stringValue];
    cell.timeLabel.text = [self timeSincePosted:[[[commentsData objectAtIndex:indexPath.row] objectForKey:@"created_utc"] doubleValue]];
    cell.bodyTextView.text = [[commentsData objectAtIndex:indexPath.row] objectForKey:@"body"];
    
    // Decide how deep indented the cell should be
    NSInteger level = [[[commentsData objectAtIndex:indexPath.row] objectForKey:@"commentLevel"] integerValue];
    cell.textViewLeftPadding.constant = 20 * level;
    cell.authorLabelLeftPadding.constant = 20 * level;
    
    // Update constraints after content is inserted
    [cell.bodyTextView setNeedsUpdateConstraints];
    [cell updateConstraints];
    [cell layoutSubviews];
}


/**
 *  Configures a continue cell.
 *
 *  @param cell         The cell to be configured
 *  @param indexPath    The current indexPath
 *
 */
-(void) configerContinueCell: (ContinueTableViewCell *) cell atIndexPath: (NSIndexPath *) indexPath {
    // Content is always identical, only need to set indentation here.
    NSInteger level = [[[commentsData objectAtIndex:indexPath.row] objectForKey:@"commentLevel"] integerValue];
    cell.continueLabelLeftPadding.constant = 20 * level;
}


// None of the Table Cells are selectable
// TODO: Disable later for replys of comments etc.
- (NSIndexPath *)tableView:(UITableView *)tv willSelectRowAtIndexPath:(NSIndexPath *)path {
    return nil;
}


#pragma mark - Helper methods for data source

/**
 *  Constructs a valid URL from the permalink provided by the reddit api
 *
 *  @param permalink Permalink provided by the reddit api
 *
 *  @return A NSURL ready for an api call.
 *
 *  @note ".json" is already appended to the returned NSURL
 *
 */
-(NSURL *) urlFromPermalink: (NSString *) permalink {
    NSString *redditURL = @"http://reddit.com";
    NSString *json = @".json";
    NSString *construct = [[redditURL stringByAppendingString:permalink] stringByAppendingString:json];
    NSURL *validPermalinkURL = [NSURL URLWithString:construct];
    return validPermalinkURL;
}


/**
 *  Returns an NSString with html-tags from a given String in markdown format.
 *
 *  @param markdownFromAPI The markdown String provided by the reddit API
 *
 *  @return An NSString with html-tags
 *
 */
-(NSString *) createHTMLStringFromMarkdown: (NSString *) markdownFromAPI {
    NSMutableString *html = [NSMutableString stringWithString: @"<html><head><title></title></head><body style=\"background:transparent;\">"];
    NSError *error;
    NSString *htmlString = [MMMarkdown HTMLStringWithMarkdown:markdownFromAPI error:&error];
    [html appendString:htmlString];
    [html appendString:@"</body></html>"];
    return [html description];
}


/**
 *  Returns an NSString with a reading description of when a timestamp was created.
 *
 *  @param timestamp A unix-timestamp
 *
 *  @return An NSSTring whith a reading description of when the timestamp was created.
 *
 *  @see For more information see <a href="https://github.com/mattt/FormatterKit">FormatterKit</a>
 *
 */
-(NSString *) timeSincePosted: (double) timestamp {
    // Transform timestamp to NSDate and retrieve the seconds passed since creation date
    NSTimeInterval _interval = timestamp;
    NSDate *postDate = [NSDate dateWithTimeIntervalSince1970:_interval];
    NSTimeInterval secondsPassed = [postDate timeIntervalSinceNow];
    
    // Using FormatterKit to construct reading descriptions (e.g. "4 hours ago")
    // God bless Mattt Thompson
    TTTTimeIntervalFormatter *timeIntervalFormatter = [[TTTTimeIntervalFormatter alloc] init];
    NSString *result = [timeIntervalFormatter stringForTimeInterval:secondsPassed];
   
    return result;
}


#pragma mark - Section headers

// Set the title for the header in the given section.
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        // Content Section does not have a header
        return nil;
    } else {
        // Comment section has a header with the count of the comments in it
        return [NSString stringWithFormat:@"Comments • %lu", (unsigned long)[commentsData count]];
    }
}


/*
 *  Custom height for headers.
 *  Content sections header has a height of 0 and therefor is not visible.
 *
 */
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0;
    } else {
        return 40.0f;
    }
}


/*
 *  Creates the custom header for the sections
 *  TODO: Only construct one for section 1
 */
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    // Custom Label
    UILabel *headerLabel = [[UILabel alloc] init];
    headerLabel.frame = CGRectMake(20, 10, 300, 20);
    headerLabel.font = [UIFont boldSystemFontOfSize:16];
    headerLabel.text = [self tableView:tableView titleForHeaderInSection:section];
    
    // Add label to header view
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = [UIColor colorWithWhite:0.96 alpha:1];
    [headerView addSubview:headerLabel];
    
    return headerView;
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
