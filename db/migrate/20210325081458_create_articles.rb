class CreateArticles < ActiveRecord::Migration[6.1]
  def change
    create_table :articles do |t|
      t.belongs_to :user
      t.string :title
      t.string :annotation
      t.text :text
      t.string :imgUrl

      t.timestamps
    end
  end
end
