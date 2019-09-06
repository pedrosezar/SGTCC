class Page < ApplicationRecord
  include Searchable

  searchable menu_title: { unaccent: true }

  validates :url,
            presence: true,
            uniqueness: { case_sensitive: false },
            format: {
              with: /\A^[a-z-]+$\z/i,
              message: I18n.t('activerecord.errors.models.page.attributes.url.invalid_format')
            }

  validates :menu_title,
            presence: true,
            uniqueness: { case_sensitive: false }

  validates :fa_icon,
            presence: true

  validates :content,
            presence: true

  before_save do
    url.downcase!
    self.order = Page.maximum('order').to_i + 1 if order.blank?
  end

  def site
    Site.first
  end
end
