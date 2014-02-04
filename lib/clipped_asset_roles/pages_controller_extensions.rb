module ClippedAssetRoles
  module PagesControllerExtensions
  
    def self.included(klazz)
      klazz.class_eval {
        after_filter :update_asset_roles_from_params, :only => [:create, :update, :destroy]
      }
    end
    # alias_method_chain :create, :asset_roles
    # alias_method_chain :update, :asset_roles
    # alias_method_chain :destroy, :asset_roles
  
    def update_asset_roles_from_params
      params.select{|k,v| k =~ /asset_role_/}.each do |k,v|
        role_name = k[/asset_role_(.*)/, 1]
        
        @page.attachments_with_role(role_name).each do |att|
          att.asset_roles.select{|r| r.role == role_name}.first.destroy
        end
        
        if v.class != String
          v.each do |asset_id, on|
            AssetRole.create(:page_attachment_id => asset_id, :role => role_name)
          end
        else
          AssetRole.create(:page_attachment_id => v, :role => role_name)        
        end
        
      end
    end
  
  end
end