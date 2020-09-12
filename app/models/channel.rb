class Channel < ApplicationRecord
    has_one :target_url
    has_many :histories
end
