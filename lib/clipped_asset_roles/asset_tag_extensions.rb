module ClippedAssetRoles::AssetTagExtensions
  include Radiant::Taggable

  class TagError < StandardError; end

  def self.included(base)
    base.class_eval {
      alias_method_chain :assets_find_options, :roles
      alias_method_chain :find_asset, :roles
    }
  end

  desc %{
    Cycles through all assets attached to the current page.  
    This tag does not require the name atttribute, nor do any of its children.
    Use the @limit@ and @offset@ attribute to render a specific number of assets.
    Use @by@ and @order@ attributes to control the order of assets.
    Use @extensions@ and/or @roles@ attribute to specify which assets to be rendered.
    
    *Usage:* 
    <pre><code><r:assets:each [limit=0] [offset=0] [order="asc|desc"] [by="position|title|..."] [extensions="png|pdf|doc"] [roles="page_icon|portfolio"]>...</r:assets:each></code></pre>
  }    
  tag 'assets' do |tag|
    tag.expand
  end
  
  desc %{
    Renders the contained elements only if the current contextual page has one or
    more assets. The @min_count@ attribute specifies the minimum number of required
    assets. You can also filter by extensions with the @extensions@ or @roles@ attribute.
  
    *Usage:*
    <pre><code><r:if_assets [min_count="n"]>...</r:if_assets></code></pre>
  }
  tag 'if_assets' do |tag|
    count = tag.attr['min_count'] && tag.attr['min_count'].to_i || 1
    assets = tag.locals.page.assets.count(:conditions => assets_find_options(tag)[:conditions], :joins => assets_find_options(tag)[:joins])
    tag.expand if assets >= count
  end
  
  desc %{
    The opposite of @<r:if_assets/>@.
  }
  tag 'unless_assets' do |tag|
    count = tag.attr['min_count'] && tag.attr['min_count'].to_i || 1
    assets = tag.locals.page.assets.count(:conditions => assets_find_options(tag)[:conditions], :joins => assets_find_options(tag)[:joins])
    tag.expand unless assets >= count
  end
  
  def find_asset_with_roles(tag, options)
    if tag.locals.asset.nil? and roles = options.delete('roles')
      roles.split('|').each do |role|
        tag.locals.asset = tag.locals.page.attachments_with_role(role).first.try(:asset)
        return tag.locals.asset unless tag.locals.asset.nil?
      end
      raise(TagError, "Asset not found.") unless tag.locals.asset
    else
      find_asset_without_roles(tag, options)
    end
    tag.locals.asset
  end
  
  def assets_find_options_with_roles(tag)
    options = assets_find_options_without_roles(tag)
    roles = tag.attr['roles'].to_s.split('|')
    if roles.any?
      if options[:conditions]
        options[:conditions].concat [ roles.map { |role| "asset_roles.role = ?" }.join(' OR '),
          *roles.map { |role| role } ]
      else
        options[:conditions] = [ roles.map { |role| "asset_roles.role = ?" }.join(' OR '),
          *roles.map { |role| role } ]
      end
      
      options[:joins] = "INNER JOIN `page_attachments` pa ON `assets`.id = pa.asset_id AND pa.page_id = #{tag.locals.page.id} INNER JOIN `asset_roles` ON (`asset_roles`.page_attachment_id = pa.id)"
    end
    options
  end
  
end

