module ClippedAssetRoles
  module PageExtensions
    def attachments_with_role(role)
      page_attachments.select do |attachment|
        attachment.asset_roles.select{|asset_role| asset_role.role == role}.any?
      end
    end
    
    def available_roles
      return overwritten_roles if overwritten_roles
      return overwritten_roles_through_parent if overwritten_roles_through_parent
      return configured_roles.concat(extra_roles) if extra_roles
      return configured_roles.concat(extra_roles_through_parent) if extra_roles_through_parent
      configured_roles
    end
    
    def configured_roles
      Radiant::Config['clipped_asset_roles.roles'].to_s.split(',')
    end
    
    def extra_roles
      return false unless config = field(:extra_asset_roles)
      config.content.to_s.split(',')
    end
    
    def overwritten_roles
      return false unless config = field(:asset_roles)
      config.content.to_s.split(',')
    end
    
    def extra_roles_through_parent
      return false unless parent && config = parent.field(:extra_children_asset_roles)
      config.content.to_s.split(',')
    end
    
    def overwritten_roles_through_parent
      return false unless parent && config = parent.field(:children_asset_roles)
      config.content.to_s.split(',')
    end
  end
end