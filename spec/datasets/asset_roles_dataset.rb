class AssetRolesDataset < Dataset::Base
  uses :assets
  
  def load
    create_page "pictured", :slug => 'pictured' do
      create_asset "test1", :caption => "testing", :position => 1
      create_asset "test2", :caption => "also testing", :position => 2
    end    
    create_record :asset_role, :test1_role, {
      :page_attachment_id => page_attachment_id(:pictured_attachment),
      :asset_role => 'portfolio'
    }
  end
  
    # 
  # helpers do
  #   def create_asset(name, attributes={})
  #     pos = attributes.delete(:position)
  #     create_record :asset, name.symbolize, {
  #       :title => name,
  #       :asset_file_name =>  'asset.jpg',
  #       :asset_content_type =>  'image/jpeg',
  #       :asset_file_size => '46248',
  #       :original_height => 200,
  #       :original_width => 400,
  #       :uuid => UUIDTools::UUID.timestamp_create.to_s
  #     }.merge(attributes)
  #     if @current_page_id
  #       create_record :page_attachment, "#{name}_attachment".symbolize, {
  #         :page_id => @current_page_id,
  #         :asset_id => asset_id(name.symbolize),
  #         :position => pos
  #       }
  #     end
  #   end
  # end
  # 
end