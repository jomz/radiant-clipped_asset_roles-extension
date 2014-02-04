module ClippedAssetRoles::AssetTagExtensions
  include Radiant::Taggable

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
    References the first asset attached to the current page.  
    
    *Usage:* 
    <pre><code><r:assets:first>...</r:assets:first></code></pre>
  }
  tag 'assets:first' do |tag|
    if role = options.delete('role') && tag.locals.asset = tag.locals.page.attachments_with_role(role).first
      tag.expand
    elsif tag.locals.asset = tag.locals.page.assets.first
      tag.expand
    end
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
    assets = tag.locals.page.assets.count(:conditions => assets_find_options(tag)[:conditions])
    tag.expand if assets >= count
  end
  
  def find_asset_with_roles(tag, options)
    begin
      find_asset_without_roles
    rescue TagError
      if role = options.delete('role')
        tag.locals.asset = tag.locals.page.attachments_with_role(role).first
      else
        raise(TagError, "Asset not found.")
      end
    end
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
      # raise options.to_s
      options[:joins] = "INNER JOIN `page_attachments` pa ON `assets`.id = pa.asset_id INNER JOIN `asset_roles` ON (`asset_roles`.page_attachment_id = pa.id)"
      # options[:joins] = [:page_attachments, :asset_roles]
    end
    options
  end
  
end

