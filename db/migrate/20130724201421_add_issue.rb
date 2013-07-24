class AddIssue < ActiveRecord::Migration
  def up
    create_table :issues do |t|
      t.string :title
      t.text :body
      t.datetime :updated_at
      t.integer :number
    end
  end

  def down
    drop_table :issues
  end
end
