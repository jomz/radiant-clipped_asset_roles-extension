module ClippedAssetRoles::PageAttachmentExtensions
  def self.included(base)
    base.class_eval {
      has_many :asset_roles
      accepts_nested_attributes_for :asset_roles, :allow_destroy => true
    }
  end
end