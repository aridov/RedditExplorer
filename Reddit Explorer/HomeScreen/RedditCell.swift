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
        titleLabel.text = redditEntry.title
        commentsLabel.text = String(redditEntry.num_comments)
        
        updateEntryDate(with: redditEntry)
    }
    
    override func prepareForReuse() {
        authorLabel.text = nil
        entryDateLabel.text = nil
        titleLabel.text = nil
        commentsLabel.text = nil
        thumbnailImageView.image = nil
    }
    
    fileprivate func updateEntryDate(with redditEntry: RedditEntry) {
        let currentTime = Date().timeIntervalSince1970
        let timeDifference = currentTime - redditEntry.created_utc
        let secondsInHour = 3600
        let hoursAgo = Int(timeDifference) / secondsInHour
        
        entryDateLabel.text = "\(hoursAgo) hours ago"
    }
}
