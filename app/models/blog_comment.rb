class BlogComment < ActiveRecord::Base
   belongs_to :blog_post
   belongs_to :user
   
   delegate :username, to: :user
end
