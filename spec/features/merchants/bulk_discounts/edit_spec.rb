require 'rails_helper'

RSpec.describe 'Discount edit form' do
  before do
    @merchant = create :merchant
    @discount = create :bulk_discount, { merchant_id: @merchant.id }

    visit edit_merchant_bulk_discount_path(@merchant, @discount)
  end

  it 'i am taken to a page with a form to edit' do
    expect(current_path).to eq(edit_merchant_bulk_discount_path(@merchant, @discount))
  end

  it 'i see the discount current attributes prepopulated' do
    expect(page).to have_field(:bulk_discount_percentage_discount, with: @discount.percentage_discount)
    expect(page).to have_field(:bulk_discount_quantity_threshold, with: @discount.quantity_threshold)
  end

  it 'when i change some of the attributes and click submit' do
    fill_in :bulk_discount_percentage_discount, with: 50
    click_button 'Update Bulk discount'

    expect(current_path).to eq(merchant_bulk_discount_path(@merchant, @discount))
    expect(page).to have_content(50)
  end

  it 'handles incorrect input' do
    fill_in :bulk_discount_percentage_discount, with: ''
    click_button 'Update Bulk discount'

    expect(current_path).to eq(edit_merchant_bulk_discount_path(@merchant, @discount))
  end
end
