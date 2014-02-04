# Uncomment this if you reference any of your controllers in activate
# require_dependency "application_controller"
require "radiant-clipped_asset_roles-extension"

class ClippedAssetRolesExtension < Radiant::Extension
  version     RadiantClippedAssetRolesExtension::VERSION
  description RadiantClippedAssetRolesExtension::DESCRIPTION
  url         RadiantClippedAssetRolesExtension::URL

  # See your config/routes.rb file in this extension to define custom routes

  extension_config do |config|
    # config is the Radiant.configuration object
  end

  def activate
    PageAttachment.send :include, ClippedAssetRoles::PageAttachmentExtensions
    Admin::PagesController.send :include, ClippedAssetRoles::PagesControllerExtensions
    Page.send :include, ClippedAssetRoles::PageExtensions
    Page.send :include, ClippedAssetRoles::AssetTagExtensions
  end
end
