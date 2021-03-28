class Article < ApplicationRecord
  belongs_to :user
  has_many :tags
  include PgSearch
  pg_search_scope :search,
                  associated_against: {
                      user: [:email, :nickname],
                  },
                  against: [:title, :annotation, :text, :hashTags]
  pg_search_scope :search_by_tags, against: :hashTags
  pg_search_scope :search_by_user, associated_against: { user: [:email, :nickname] }
end
