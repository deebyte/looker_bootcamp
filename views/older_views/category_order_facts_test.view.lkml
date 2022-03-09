view: category_order_facts {
  derived_table: {
    explore_source: order_items {
      column: category { field: products.category }
      column: order_count {}
#         filters: {
#           field: order_items.created_date
#           value: "6 months"
#         }
    }
  }
  dimension: category {
    primary_key: yes
    sql: ${TABLE}.category ;;
    type: string
    hidden: yes
  }
  dimension: order_count {
    description: "A count of unique orders"
    type: number
    sql: ${TABLE}.order_count ;;
    hidden: yes
  }
}
