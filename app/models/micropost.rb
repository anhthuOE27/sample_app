class Micropost < ApplicationRecord
  belongs_to :user
  scope :order_desc, ->{order created_at: :desc}
  scope :feed, ->(id){where user_id: id}
  mount_uploader :picture, PictureUploader
  validates :user_id, presence: true
  validates :content, presence: true,
   length: {maximum: Settings.micropost.content.maxcontent}
  validate  :picture_size

  private

  def picture_size
    return unless picture.size > Settings.picturesize.megabytes
    errors.add(:picture, t("models.micropost.picture_size.less5MB"))
  end
end
