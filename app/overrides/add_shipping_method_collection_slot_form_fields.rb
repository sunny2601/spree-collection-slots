Deface::Override.new(virtual_path: 'spree/admin/shipping_methods/_form',
  name: 'add_shipping_method_collection_slot_form_fields',
  insert_after: ":root > .row:last-child",
  partial: 'spree/admin/shipping_methods/collection_slot_form')
