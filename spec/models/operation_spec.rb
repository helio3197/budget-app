require 'rails_helper'

RSpec.describe Operation, type: :model do
  subject do
    u = User.create(name: 'Jhon', email: 'test123@test.com', password: 'abc123')
    c = [Category.new(name: 'Test Cat', user: u, icon: fixture_file_upload('test_icon.png', 'image/png'))]
    described_class.new(user: u, name: 'Test', amount: 25, categories: c)
  end

  it 'Should be valid with valid attributes' do
    expect(subject).to be_valid
  end

  it 'Should not be valid without a name' do
    subject.name = nil
    expect(subject).to_not be_valid
  end

  it 'Should not be valid without an amount' do
    subject.amount = nil
    expect(subject).to_not be_valid
  end

  it 'Should not be valid with an invalid amount' do
    subject.amount = -23
    expect(subject).to_not be_valid
  end

  it 'Should have a belong_to association with User model' do
    expect(subject.user).to be_instance_of User
  end
end
