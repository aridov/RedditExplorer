//
//  RedditCell.swift
//  Reddit Explorer
//
//  Created by Vladimir Aridov on 20.12.2020.
//

import UIKit

class RedditCell: UITableViewCell {

    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var entryDateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var commentsLabel: UILabel!
    @IBOutlet weak var thumbnailImageView: UIImageView!
    
    
    func setRedditEntry(_ redditEntry: RedditEntry) {
        authorLabel.text = redditEntry.author
        entryDateLabel.text = String(redditEntry.created_utc)
        titleLabel.text = redditEntry.title
        commentsLabel.text = String(redditEntry.num_comments)
    }
    
    override func prepareForReuse() {
        authorLabel.text = nil
        entryDateLabel.text = nil
        titleLabel.text = nil
        commentsLabel.text = nil
        thumbnailImageView.image = nil
    }
}
