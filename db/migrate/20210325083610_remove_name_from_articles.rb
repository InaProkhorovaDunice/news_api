class RemoveNameFromArticles < ActiveRecord::Migration[6.1]
  def change
    remove_column :articles, :name
  end
end
