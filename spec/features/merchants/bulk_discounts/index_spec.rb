require 'rails_helper'

RSpec.describe 'Bulk Discount index page' do
  before do
    @merchant = create :merchant

    @discount1 = create :bulk_discount, { merchant_id: @merchant.id }
    @discount2 = create :bulk_discount, { merchant_id: @merchant.id }
    @discount3 = create :bulk_discount, { merchant_id: @merchant.id }

    visit merchant_bulk_discounts_path(@merchant)
  end

  it 'when i visit my discounts index page' do
    expect(current_path).to eq(merchant_bulk_discounts_path(@merchant))
  end

  it 'i see all my discounts with attributes and each one is a link to show' do
    within("#discount-#{@discount1.id}") do
      expect(page).to have_content(@discount1.id)
      expect(page).to have_content(@discount1.percentage_discount)
      expect(page).to have_content(@discount1.quantity_threshold)

      click_link "Details"
    end

    expect(current_path).to eq(merchant_bulk_discount_path(@merchant, @discount1))
    # require "pry"; binding.pry
    # BulkDiscount.all.each do |discount|
    #   within("#discount-#{discount.id}") do
    #     expect(page).to have_content(discount.id)
    #     expect(page).to have_content(discount.percentage_discount)
    #     expect(page).to have_content(discount.quantity_threshold)
    #
    #     click_link "Details"
    #   end
    #   expect(current_path).to eq(merchant_bulk_discount_path(@merchant, discount))
    # end
  end

  it 'I a header of Upcoming Holidays with the name and date of the next 3 upcoming US holidays' do
    expect(page).to have_content('Upcoming Holidays')
    expect(page).to have_content('Holiday Name', count: 3)
    expect(page).to have_content('1-1-11', count: 3)
  end

  it 'i see a link to create a new discount' do
    click_link 'Create New Discount'

    expect(current_path).to eq(new_merchant_bulk_discount_path(@merchant))
  end

  it 'i see a link to delete each discount' do
    within("#discount-#{@discount1.id}") do
      click_link "Delete"
    end

    expect(current_path).to eq(merchant_bulk_discounts_path(@merchant))
    expect(page).to_not have_content(@discount1.id)
  end
end
