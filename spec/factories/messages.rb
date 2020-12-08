FactoryBot.define do
  factory :message do
    content { "MyString" }
    user_id { 1 }
    chatroom_id { 1 }
  end
end
