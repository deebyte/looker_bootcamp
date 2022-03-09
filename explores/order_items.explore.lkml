include: "/views/order_items.view.lkml"
include: "/views/inventory_items.view.lkml"
include: "/views/users.view.lkml"
include: "/views/products.view.lkml"
include: "/views/distribution_centers.view.lkml"
include: "/views/user_facts.view.lkml"
include: "/views/category_order_facts.view.lkml"
include: "/views/user_order_sequence_facts.view.lkml"



explore: order_items {

  ## Exercise 5 - Task 1: Add a filter to the Order Items Explore that always excludes returned items.  Then add a second filter that always limits the results
  ##                      to only those in which the total swales amount is > $200

  # sql_always_where: ${___________._________date} IS NULL ;;
  # sql_always_having: ${___________.______sales} > 200 ;;

  ##

  ## Exercise 5 - Task 2:  Add a filter to the Order Items Explore that forces this Explore to always include only orders with a Status of “Complete”.
  ##                       Then add a second filter that always limits the results to only show values in which the order item count is greater than 5

  # sql_always_where: ${___________.______} = ‘Complete’ ;;
  # sql_always_having: ${___________._____} > 5 ;;

  ##

  ## Exercise 5 - Task 3: Add a filter (in the UI) the Users Explore to only show users that have created orders before today. Then, add a
  ##                      filter to the Order Items Explore to only include orders created within the past 2 years unless a filter is applied to the users.id field

  # always_filter: {filters:[: ""]}

  # conditionally_filter: {filters:[: ""] unless: []}

  ##


  label: "Orders"
  view_label: "(1) Orders and Items"
  # persist_with:
  join: users {
    view_label: "(2) Users"
    type: left_outer
    sql_on: ${order_items.user_id} = ${users.id} ;;
    relationship: many_to_one
  }

  join: user_facts {
    view_label: "(2) Users"
    type: left_outer
    sql_on: ${users.id} = ${user_facts.user_id} ;;
    relationship: one_to_one
  }

  join: category_order_facts {
    type: left_outer
    sql_on: ${products.category} = ${category_order_facts.category} ;;
    relationship: many_to_one
  }

  join: inventory_items {
    view_label: "(3) Inventory"
    type: left_outer
    sql_on: ${order_items.inventory_item_id} = ${inventory_items.id} ;;
    relationship: many_to_one
  }

  join: products {
    view_label: "(4) Products"
    type: left_outer
    sql_on: ${inventory_items.product_id} = ${products.id} ;;
    relationship: many_to_one
  }

  join: distribution_centers {
    view_label: "(5) Distribution Centers"
    type: left_outer
    sql_on: ${products.distribution_center_id} = ${distribution_centers.id} ;;
    relationship: many_to_one
  }

  join: user_order_sequence_facts {
    view_label: "(6) User Order Sequencing"
    type: left_outer
    sql_on: ${order_items.id} = ${user_order_sequence_facts.order_id} ;;
    relationship: many_to_one
  }
}
