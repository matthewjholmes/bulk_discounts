require 'rails_helper'

RSpec.describe Invoice, type: :model do
  describe 'relationships' do
    it { should belong_to(:customer) }
    it { should have_many(:transactions) }
    it { should have_many(:invoice_items) }
    it { should have_many(:items).through(:invoice_items) }
  end

  describe 'validations' do
    it { should validate_presence_of(:customer_id) }
    it { should validate_presence_of(:status) }
  end

  describe 'model methods' do
    before do
      @merchant = create(:merchant)
      @merchant2 = create(:merchant)

      @discount = create :bulk_discount, { quantity_threshold: 10, percentage_discount: 50, merchant: @merchant }

      @customer1 = create :customer
      @customer2 = create :customer
      @customer3 = create :customer
      @customer4 = create :customer
      @customer5 = create :customer
      @customer6 = create :customer

      @item = create :item, { merchant_id: @merchant.id }
      @item2 = create :item, { merchant_id: @merchant.id }
      @item3 = create :item, { merchant_id: @merchant.id }
      @item4 = create :item, { merchant_id: @merchant2.id }

      @invoice1 = create :invoice, { customer_id: @customer1.id, status: 'in progress' }
      @invoice2 = create :invoice, { customer_id: @customer2.id, status: 'in progress' }
      @invoice3 = create :invoice, { customer_id: @customer3.id, status: 'in progress' }
      @invoice4 = create :invoice, { customer_id: @customer4.id, status: 'in progress' }
      @invoice5 = create :invoice, { customer_id: @customer5.id, status: 'cancelled' }
      @invoice6 = create :invoice, { customer_id: @customer6.id, status: 'completed' }
      @invoice7 = create :invoice, { customer_id: @customer6.id, status: 'completed' }

      @transaction1 = create :transaction, { invoice_id: @invoice1.id, result: 'success' }
      @transaction2 = create :transaction, { invoice_id: @invoice2.id, result: 'success' }
      @transaction3 = create :transaction, { invoice_id: @invoice3.id, result: 'success' }
      @transaction4 = create :transaction, { invoice_id: @invoice4.id, result: 'success' }
      @transaction5 = create :transaction, { invoice_id: @invoice5.id, result: 'success' }
      @transaction6 = create :transaction, { invoice_id: @invoice6.id, result: 'failed' }
      @transaction7 = create :transaction, { invoice_id: @invoice7.id, result: 'success' }

      @inv_item1 = create :invoice_item, { item_id: @item.id, invoice_id: @invoice1.id, unit_price: 100, quantity: 1 }
      @inv_item2 = create :invoice_item, { item_id: @item.id, invoice_id: @invoice2.id}
      @inv_item3 = create :invoice_item, { item_id: @item.id, invoice_id: @invoice3.id}
      @inv_item4 = create :invoice_item, { item_id: @item.id, invoice_id: @invoice4.id}
      @inv_item5 = create :invoice_item, { item_id: @item.id, invoice_id: @invoice5.id}
      @inv_item6 = create :invoice_item, { item_id: @item.id, invoice_id: @invoice6.id}
      @inv_item7 = create :invoice_item, { item_id: @item.id, invoice_id: @invoice1.id, unit_price: 100, quantity: 1 }
      @inv_item8 = create :invoice_item, { item_id: @item.id, invoice_id: @invoice1.id, unit_price: 100, quantity: 3 }
      @inv_item9 = create :invoice_item, { item_id: @item4.id, invoice_id: @invoice1.id, unit_price: 100, quantity: 1 }
      @inv_item10 = create :invoice_item, { item_id: @item.id, invoice_id: @invoice7.id, unit_price: 100, quantity: 10 }
      @inv_item11 = create :invoice_item, { item_id: @item.id, invoice_id: @invoice7.id, unit_price: 100, quantity: 10 }
    end

    it 'returns invoices where status is in progress' do
      expect(Invoice.in_progress).to eq([@invoice1, @invoice2, @invoice3, @invoice4])
    end

    it 'orders invoices from oldest to newest' do
      expect(Invoice.order_from_oldest).to eq([@invoice7, @invoice6, @invoice5, @invoice4, @invoice3, @invoice2, @invoice1])
    end

    describe "#total_revenue" do
      it 'calcs total revenue from an invoice for a given merchant' do
        expect(@invoice1.total_item_revenue_by_merchant(@merchant.id)).to eq(500)
      end

      # it 'calculates total revenue for an invoice' do
      #   expect(@invoice1.total_invoice_revenue(@invoice1.id)).to eq(600)
      # end
    end

    describe "#total_undiscounted_invoice_revenue" do
      it 'returns revenue before discounts' do
        expect(@invoice7.total_undiscounted_invoice_revenue).to eq(2000)
      end
    end

    # describe "#total_discounted_invoice_revenue" do
    #   it 'returns remaining revenue after discounts' do
    #     expect(@invoice7.total_discounted_invoice_revenue).to eq(600)
    #   end
    # end

    describe "#total_discounted_invoice_revenue" do
      it 'returns remaining revenue after discounts' do
        merchant = create(:merchant)
        discount = create :bulk_discount, { quantity_threshold: 10, percentage_discount: 50, merchant: merchant }
        customer = create :customer
        item = create :item, { merchant_id: merchant.id }
        invoice = create :invoice, { customer_id: customer.id, status: 'completed' }
        transaction1 = create :transaction, { invoice_id: invoice.id, result: 'success' }
        inv_item1 = create :invoice_item, { item_id: item.id, invoice_id: invoice.id, unit_price: 100, quantity: 10 }
        inv_item2 = create :invoice_item, { item_id: item.id, invoice_id: invoice.id, unit_price: 100, quantity: 10 }


        expect(invoice.total_discounted_invoice_revenue).to eq(1000)
      end
    end


  end
end
