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

  it 'i see all my discoutns with attributes and each one is a link to show' do
    BulkDiscount.all.each do |discount|
      within("#discount-#{discount.id}") do
        expect(page).to have_content(discount.id)
        expect(page).to have_content(discount.percentage_discount)
        expect(page).to have_content(discount.quantity_threshold)

        click_link "Details"
      end
      expect(current_path).to eq(merchant_bulk_discount_path(@merchant, discount))
    end
  end
end
