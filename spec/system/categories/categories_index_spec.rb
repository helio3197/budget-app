require 'rails_helper'

RSpec.describe 'Recipes list page', type: :system do
  subject do
    @u = User.create(name: 'Maria', email: 'maria@example.com', password: 'password')

    visit new_user_session_path

    within('#new_user') do
      fill_in 'Email', with: 'maria@example.com'
      fill_in 'Password', with: 'password'
    end

    find_button('Log In').click
  end

  it 'If I\'m not signed in, I should see the spash page with links to Log in and Sign up' do
    visit categories_path

    expect(page).to have_link('LOG IN')
    expect(page).to have_link('SIGN UP')
  end

  it 'I should see an empty categories list page if no category exists, the navbar with title "CATEGORIES", menu button, and a search button; and the "ADD CATEGORY" button' do
    subject

    expect(page).to have_selector('button[data-controller="search-item"]')
    expect(page).to have_selector('button.navbar-toggler')
    expect(page).to have_link('ADD CATEGORY')
    expect(page).to have_content('CATEGORIES')
    expect(page).to have_content('There are no categories yet.')
  end

  it 'Clicking the "ADD CATEGORY" button should redirect to the create category page' do
    subject

    find_link('ADD CATEGORY').click

    expect(page).to have_current_path(new_category_path)
  end

  it 'Clicking the menu button should display side menu' do
    subject

    find('button.navbar-toggler').click

    expect(page).to have_content('MyBudgetApp')
    expect(page).to have_content(@u.name)
    expect(page).to have_link('Account settings')
    expect(page).to have_link('Sign out')
  end

  it 'Clicking the search icon button should display a search module' do
    subject

    find('button[data-controller="search-item"]').click

    expect(page).to have_field('search')
    expect(page).to have_button('Search')
  end

  it 'If there is a category existing, I should see the name, description and a remove button' do
    subject
    Category.create(user: @u, name: 'Test Cat', icon: fixture_file_upload('test_icon.png', 'image/png'))

    visit categories_path

    expect(page).to have_content('Test Cat')
    expect(page).to have_content('$0.0')
    expect(page).to have_selector('img.category-item-icon')
  end

  it 'Clicking on a category item should redirect to the transactions page of the category' do
    subject
    c = Category.create(user: @u, name: 'Test Cat', icon: fixture_file_upload('test_icon.png', 'image/png'))

    visit categories_path

    find('p', text: 'Test Cat').click

    expect(page).to have_current_path(category_path(c))
  end
end
