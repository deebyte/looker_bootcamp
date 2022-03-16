# The name of this view in Looker is "Order Items"
view: order_items {
  # The sql_table_name parameter indicates the underlying database table
  # to be used for all fields in this view.
  sql_table_name: `looker-onboarding.ecommerce.order_items`
    ;;
  drill_fields: [id]
  # This primary key is the unique key for this table in the underlying database.
  # You need to define a primary key in a view in order to join to other views.

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  # Dates and timestamps can be represented in Looker using a dimension group of type: time.
  # Looker converts dates and timestamps to the specified timeframes within the dimension group.

  dimension_group: created {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      month_name,
      quarter,
      year
    ]
    sql: ${TABLE}.created_at ;;
  }

  dimension_group: delivered {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.delivered_at ;;
  }

  # Here's what a typical dimension looks like in LookML.
  # A dimension is a groupable field that can be used to filter query results.
  # This dimension will be called "Inventory Item ID" in Explore.

  dimension: inventory_item_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.inventory_item_id ;;
  }

  dimension: order_id {
    type: number
    sql: ${TABLE}.order_id ;;
  }


  dimension_group: returned {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.returned_at ;;
  }

  dimension: sale_price {
    type: number
    sql: ${TABLE}.sale_price ;;
  }

  # A measure is a field that uses a SQL aggregate function. Here are defined sum and average
  # measures for this dimension, but you can also add measures of many different aggregates.
  # Click on the type parameter to see all the options in the Quick Help panel on the right.

  measure: average_sale_price {
    type: average
    sql: ${sale_price} ;;
  }

  dimension_group: shipped {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.shipped_at ;;
  }

  dimension: status {
    type: string
    sql: ${TABLE}.status ;;
  }

  dimension: shipping_time {
    description: "Shipping time in days"
    type: number
    sql: DATEDIFF(day, ${order_items.shipped_date}, ${order_items.delivered_date}) ;;
  }

  ## Exercise 1 - Task 4: Create a Shipping Days dimension that calculates the number of days between order ship date and order delivered date
  ## Hint: See dimension below if you're having trouble


  dimension_group: delivery_times {
    type: duration
    intervals: [
      hour,
      day,
      week
    ]
    sql_start: ${created_date};;
    sql_end: ${delivered_date} ;;
  }



##

  dimension_group: shipping_times {
    type: duration
    intervals: [
      hour,
      day,
      week
    ]
    sql_start: ${shipped_date} ;;
    sql_end: ${delivered_date} ;;
  }

  dimension: months_since_signup {
    description: "Time between current order and when that user was created"
    type: number
    sql: DATEDIFF('month',${users.created_raw},${created_raw}) ;;
  }

  ## HIDDEN DIMENSIONS ##

  dimension: user_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.user_id ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  measure: total_revenue {
    type: sum
    value_format_name: usd
    sql: ${sale_price} ;;
    drill_fields: [detail*]
  }

  measure: average_spend_per_user {
    type: number
    sql: ${total_revenue}*1.0/nullif(${users.count},0) ;;
    value_format_name: usd
  }

  measure: total_sale_price {
    type: sum
    sql: ${sale_price} ;;
  }

  ## Exercise 3 - Task 1: Create a filtered measure that calculates the total sales for only users that came to the site through email

  # measure: total_sales_email_users {
  #   type:
  #   sql: ;;
  #   filters: [users.traffic_source: ""]
  # }


  ##

  ## Exercise 3 - Task 2: Create a field that calculates the percentage of sales that are attributed to users coming the fomr email traffic

  # measure: percentagle_sales_email_source {
  #   type:
  #   value_format_name:
  #   sql: 1.0 * ${} / NULLIF(${},0) ;;
  # }


  measure: count_orders {
    label: "Distinct Order Ids"
    type:  count_distinct
    sql: ${order_id} ;;
  }

  # ----- Sets of fields for drilling ------
  set: detail {
    fields: [
      id,
      users.last_name,
      users.id,
      users.first_name,
      inventory_items.id,
      inventory_items.product_name
    ]
  }
}
