class CreateIssues < ActiveRecord::Migration
  def change
    create_table :issues do |t|
      t.string :content
      t.integer :user_id
      t.integer :project_id
      t.string :status
      t.integer :who_is_solving
      t.integer :who_is_validating

      t.timestamps
    end
  end
end
