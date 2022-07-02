require 'rails_helper'

RSpec.describe 'Add operation page', type: :system do
  subject do
    @u = User.create(name: 'Maria', email: 'maria@example.com', password: 'password')

    @c = Category.create(name: 'Test Cat', user: @u, icon: fixture_file_upload('test_icon.png', 'image/png'))

    visit new_category_operation_path(category_id: @c.id)

    within('#new_user') do
      fill_in 'Email', with: 'maria@example.com'
      fill_in 'Password', with: 'password'
    end

    find_button('Log In').click
  end

  it 'If I\'m not signed in, I should not be able to access the page' do
    u = User.create(name: 'Jhon', email: 'test123@test.com', password: 'abc123')
    c = Category.create(name: 'Test Cat', user: u, icon: fixture_file_upload('test_icon.png', 'image/png'))
    visit new_category_operation_path(category_id: c.id)

    expect(page).to have_content('You need to sign in or sign up before continuing.')
    expect(page).to have_current_path(new_user_session_path)
  end

  it 'I should see the Add transaction page with a form, title "NEW TRANSACTION", and a back button' do
    subject

    expect(page).to have_selector('a.back-btn')
    expect(page).to have_field('operation_name')
    expect(page).to have_field('operation_amount')
    expect(page).to have_button('Save')
    expect(page).to have_content('NEW TRANSACTION')
    expect(page).to have_content('Current category:')
    expect(page).to have_selector('img.icon-thumbnail')
    expect(page).to have_content('Test Cat')
  end

  it 'Clicking the "Save" with no data should display detailed errors' do
    subject

    find_button('Save').click

    expect(page).to have_content('Name can\'t be blank')
    expect(page).to have_content('Amount can\'t be blank')
  end

  it 'Clicking the back button should redirect to the transactions page' do
    subject

    find('a.back-btn').click

    expect(page).to have_content('TRANSACTIONS')
    expect(page).to have_current_path(category_path(@c))
  end

  it 'Clicking the "Save" with no amount data should display detailed errors' do
    subject

    fill_in 'Name', with: 'Valid Name'
    find_button('Save').click

    expect(page).to have_content('Amount can\'t be blank')
  end

  it 'Clicking the "Save" with an invalid name should display detailed errors' do
    subject

    fill_in 'Name', with: 'Invalid Name' * 30
    find_button('Save').click

    expect(page).to have_content('Name is too long')
  end

  it 'Clicking the "Save" with valid data should redirect to the category transactions page with the new transaction added' do
    subject

    fill_in 'Name', with: 'Buy food'
    fill_in 'Amount', with: 31.49
    find_button('Save').click

    expect(page).to have_current_path(category_path(@c))
    expect(page).to have_content('Transaction created successfully.')
    expect(page).to have_content('Buy food')
    expect(page).to have_content('$31.49')
  end
end
