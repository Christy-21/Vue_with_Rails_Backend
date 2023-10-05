class ActiveStorageBlob < ApplicationRecord
    belongs_to :template, foreign_key: 'filename', primary_key: 'filename', optional: true
  end
  