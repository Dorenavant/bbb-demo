class CreateMeetings < ActiveRecord::Migration[5.2]
  def change
    create_table :meetings do |t|
      t.string :meeting_name
      t.string :meeting_id
      t.string :moderator_pw
      t.string :attendee_pw

      t.timestamps
    end
  end
end
