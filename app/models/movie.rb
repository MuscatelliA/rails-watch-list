class Movie < ApplicationRecord
  has_many :bookmarks, dependent: :restrict_with_error
  has_many :list, through: :bookmarks

  validates :title, presence: true, uniqueness: true
  validates :overview, presence: true
end
