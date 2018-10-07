class RemoveOldStyleFromBeers < ActiveRecord::Migration[5.2]
  change_table :beers do |t|
    t.remove :old_style
  end
end
