class CreateAssetRoles < ActiveRecord::Migration
  def self.up
    create_table :asset_roles do |t|
      t.integer :page_attachment_id
      t.string :role

      t.timestamps
    end
    
    add_index :asset_roles, %w{page_attachment_id role}, :name => "attachment_with_role"
    add_index :asset_roles, 'page_attachment_id', :name => "roles_for_attachment"
    add_index :asset_roles, 'role', :name => "attachments_with_role"
  end

  def self.down
    drop_table :asset_roles
  end
end
