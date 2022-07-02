require 'rails_helper'

RSpec.describe 'Category transactions page', type: :system do
  subject do
    @u = User.create(name: 'Maria', email: 'maria@example.com', password: 'password')

    @c = Category.create(name: 'Test Cat', user: @u, icon: fixture_file_upload('test_icon.png', 'image/png'))

    visit category_path(id: @c.id)

    within('#new_user') do
      fill_in 'Email', with: 'maria@example.com'
      fill_in 'Password', with: 'password'
    end

    find_button('Log In').click
  end

  it 'If I\'m not signed in, I should not be able to access the page' do
    u = User.create(name: 'Jhon', email: 'test123@test.com', password: 'abc123')
    c = Category.create(name: 'Test Cat', user: u, icon: fixture_file_upload('test_icon.png', 'image/png'))
    visit category_path(id: c.id)

    expect(page).to have_content('You need to sign in or sign up before continuing.')
    expect(page).to have_current_path(new_user_session_path)
  end

  it 'I should see the Transactions page with title "TRANSACTIONS", and a back button' do
    subject

    expect(page).to have_selector('a.back-btn')
    expect(page).to have_content('Total expenses:')
    expect(page).to have_content('Test Cat')
    expect(page).to have_content('Created at:')
    expect(page).to have_content('There are no transactions yet.')
    expect(page).to have_link('ADD TRANSACTION')
    expect(page).to have_content('TRANSACTIONS')
  end

  it 'Clicking the "ADD TRANSACTION" button should redirect to the create transaction page' do
    subject

    find_link('ADD TRANSACTION').click

    expect(page).to have_current_path(new_category_operation_path(@c))
  end

  it 'If there is a category existing, I should see the name, description and a remove button' do
    subject
    o = Operation.create(user: @u, name: 'Buy pizza', amount: 25.4, categories: [@c])

    visit category_path(@c)

    expect(page).to have_content('Buy pizza')
    expect(page).to have_content('$25.4')
    expect(page).to have_content(o.created_at.localtime.strftime('%b %d %Y at%l:%M %P'))
  end
end
