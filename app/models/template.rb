class Template < ApplicationRecord
  has_one_attached :scanned_copy
  has_many :active_storage_blobs, foreign_key: 'filename', primary_key: 'filename'
end
