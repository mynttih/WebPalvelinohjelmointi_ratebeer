class RenameBeerStyleColumn < ActiveRecord::Migration[5.2]
  change_table :beers do |t|
    t.rename :style, :old_style
  end
end
