class RenameColumnInArticles < ActiveRecord::Migration[6.1]
  def change
    rename_column :articles, :tags, :hashTags
  end
end
