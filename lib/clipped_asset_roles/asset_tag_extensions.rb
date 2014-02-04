module ClippedAssetRoles::AssetTagExtensions
  include Radiant::Taggable

  def self.included(base)
    base.class_eval {
      alias_method_chain :assets_find_options, :roles
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

