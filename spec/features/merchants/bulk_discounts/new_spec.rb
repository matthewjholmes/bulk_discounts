require 'rails_helper'

RSpec.describe 'Bulk Discount New Form' do
  before do
    @merchant = create(:merchant)

    visit new_merchant_bulk_discount_path(@merchant)
  end

  it 'i am taken to a new page' do
    expect(current_path).to eq(new_merchant_bulk_discount_path(@merchant))
  end

  it 'i fill in the form with valid data and am redirected to discount index' do
    fill_in 'Percentage discount', with: 25
    fill_in 'Quantity threshold', with: 25
    click_button 'Create Bulk discount'

    expect(current_path).to eq(merchant_bulk_discounts_path(@merchant))
    expect(page).to have_content('Percentage Discount: 25%')
    expect(page).to have_content('Quantity Threshold: 25')
  end
end
