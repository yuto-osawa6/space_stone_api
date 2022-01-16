class Scra2
  def War
    @a = ReturnCommentReview.find(12)
    # ReturnCommentReview.where(comment_review_id:)
    # puts @a.return_return_comment_reviews.ids
    if @a.return_returns[0].present?
    puts @a.return_returns[0].user.id
    end
    # puts @a.reverse_of_return_return_comment_reviews.ids
    # puts @a.rereturn_returns.ids

  end

  # def war2
  #   ¥
  # end
end