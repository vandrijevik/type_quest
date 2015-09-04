class CreateFinishedGames < ActiveRecord::Migration
  def change
    create_table :finished_games do |t|
      t.string :outcome, null: false
      t.timestamps
    end
  end
end
