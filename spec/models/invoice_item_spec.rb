require 'rails_helper'

RSpec.describe InvoiceItem, type: :model do
  describe 'relationships' do
    it { should belong_to(:item) }
    it { should belong_to(:invoice) }
    it { should have_one(:merchant).through(:item) }
    it { should have_many(:bulk_discounts).through(:merchant) }
  end

  describe 'validations' do
    it { should validate_presence_of(:item_id) }
    it { should validate_presence_of(:invoice_id) }
    it { should validate_presence_of(:quantity) }
    it { should validate_presence_of(:unit_price) }
    it { should validate_presence_of(:status) }
  end

  describe 'model methods' do
    before do
      @merchant = create(:merchant)

      @discount1 = create :bulk_discount, { quantity_threshold: 10, percentage_discount: 20, merchant: @merchant }
      @discount2 = create :bulk_discount, { quantity_threshold: 10, percentage_discount: 50, merchant: @merchant }
      @discount3 = create :bulk_discount, { quantity_threshold: 5, percentage_discount: 35, merchant: @merchant }

      @customer1 = create :customer
      @customer2 = create :customer
      @customer3 = create :customer
      @customer4 = create :customer
      @customer5 = create :customer
      @customer6 = create :customer

      @item = create :item, { merchant_id: @merchant.id }

      @invoice1 = create :invoice, { customer_id: @customer1.id, status: 'in progress' }
      @invoice2 = create :invoice, { customer_id: @customer2.id, status: 'in progress' }
      @invoice3 = create :invoice, { customer_id: @customer3.id, status: 'in progress' }
      @invoice4 = create :invoice, { customer_id: @customer4.id, status: 'in progress' }
      @invoice5 = create :invoice, { customer_id: @customer5.id, status: 'cancelled' }
      @invoice6 = create :invoice, { customer_id: @customer6.id, status: 'completed' }

      @transaction1 = create :transaction, { invoice_id: @invoice1.id, result: 'success' }
      @transaction2 = create :transaction, { invoice_id: @invoice2.id, result: 'success' }
      @transaction3 = create :transaction, { invoice_id: @invoice3.id, result: 'success' }
      @transaction4 = create :transaction, { invoice_id: @invoice4.id, result: 'success' }
      @transaction5 = create :transaction, { invoice_id: @invoice5.id, result: 'success' }
      @transaction6 = create :transaction, { invoice_id: @invoice6.id, result: 'failed' }

      @inv_item1 = create :invoice_item, { item_id: @item.id, invoice_id: @invoice1.id, status: "pending" }
      @inv_item2 = create :invoice_item, { item_id: @item.id, invoice_id: @invoice2.id, status: "pending" }
      @inv_item3 = create :invoice_item, { item_id: @item.id, invoice_id: @invoice3.id, status: "pending" }
      @inv_item4 = create :invoice_item, { item_id: @item.id, invoice_id: @invoice4.id, status: "packaged" }
      @inv_item5 = create :invoice_item, { item_id: @item.id, invoice_id: @invoice5.id, status: "packaged" }
      @inv_item6 = create :invoice_item, { item_id: @item.id, invoice_id: @invoice6.id, status: "shipped", quantity: 10, unit_price: 100 }
    end

    it 'returns incomplete invoices' do
      expect(InvoiceItem.incomplete_inv).to eq([@inv_item1, @inv_item2, @inv_item3, @inv_item4, @inv_item5])
    end

    it '#best_discount returns most valuable discount' do
      expect(@inv_item6.best_discount).to eq(@discount2)
    end

    it '#revenue returns total revenue from invoice item undiscounted' do
      expect(@inv_item6.revenue).to eq(1000)
    end

    it '#discount_amount returns value of the discount on invoice item' do
      expect(@inv_item6.discount_percentage).to eq(0.5)
    end

    it '#discount_amount returns value of revenue remaining after discount' do
      expect(@inv_item6.discounted_revenue).to eq(500)
    end
  end
end
