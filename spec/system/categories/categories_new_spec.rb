require 'rails_helper'

RSpec.describe 'Recipes list page', type: :system do
  subject do
    @u = User.create(name: 'Maria', email: 'maria@example.com', password: 'password')

    within('#new_user') do
      fill_in 'Email', with: 'maria@example.com'
      fill_in 'Password', with: 'password'
    end

    find_button('Log In').click
  end

  it 'If I\'m not signed in, I should not be able to access the page' do
    visit new_category_path

    expect(page).to have_content('You need to sign in or sign up before continuing.')
    expect(page).to have_current_path(new_user_session_path)
  end

  it 'I should see the Add category page with a form, title "NEW CATEGORY", and a back button' do
    visit new_category_path
    subject

    expect(page).to have_selector('a.back-btn')
    expect(page).to have_field('category_name')
    expect(page).to have_selector('input#category_icon', visible: false)
    expect(page).to have_button('Save')
    expect(page).to have_content('NEW CATEGORY')
  end

  it 'Clicking the "Save" with no data should display detailed errors' do
    visit new_category_path
    subject

    find_button('Save').click

    expect(page).to have_content('Name can\'t be blank')
    expect(page).to have_content('Icon can\'t be blank')
  end

  it 'Clicking the back button should redirect to the categories page' do
    visit new_category_path
    subject

    find('a.back-btn').click

    expect(page).to have_content('CATEGORIES')
    expect(page).to have_current_path(root_path)
  end

  it 'Clicking the "Save" with no icon uploaded should display detailed errors' do
    visit new_category_path
    subject

    fill_in 'Name', with: 'Valid Name'
    find_button('Save').click

    expect(page).to have_content('Icon can\'t be blank')
  end

  it 'Clicking the "Save" with an invalid name should display detailed errors' do
    visit new_category_path
    subject

    fill_in 'Name', with: 'Invalid Name' * 30
    page.attach_file('category_icon', "#{Rails.root}/spec/fixtures/files/test_icon.png", make_visible: true)
    find_button('Save').click

    expect(page).to have_content('Name is too long')
  end

  it 'Clicking the "Save" with valid data should redirect to the category list with the new category added' do
    visit new_category_path
    subject

    fill_in 'Name', with: 'Test cat'
    page.attach_file('category_icon', "#{Rails.root}/spec/fixtures/files/test_icon.png", make_visible: true)
    find_button('Save').click

    expect(page).to have_current_path(categories_path)
    expect(page).to have_content('Category created successfully.')
    expect(page).to have_content('Test cat')
  end
end
