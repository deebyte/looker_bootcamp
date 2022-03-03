# The name of this view in Looker is "Order Items"
view: order_items {
  # The sql_table_name parameter indicates the underlying database table
  # to be used for all fields in this view.
  sql_table_name: "PUBLIC"."ORDER_ITEMS"
    ;;
  drill_fields: [id]
  # This primary key is the unique key for this table in the underlying database.
  # You need to define a primary key in a view in order to join to other views.

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}."ID" ;;
    value_format_name: id
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
      month_num,
      quarter,
      year
    ]
    sql: ${TABLE}."CREATED_AT" ;;
  }

  dimension: reporting_period {
    description: "This Year to date versus Last Year to date"
    group_label: "Created Date"
    sql: CASE
        WHEN date_part('year',${created_raw}) = date_part('year',current_date)
        AND ${created_raw} < CURRENT_DATE
        THEN 'This Year to Date'

        WHEN date_part('year',${created_raw}) + 1 = date_part('year',current_date)
        AND date_part('dayofyear',${created_raw}) <= date_part('dayofyear',current_date)
        THEN 'Last Year to Date'

      END
       ;;
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
    sql: ${TABLE}."DELIVERED_AT" ;;
  }

  # Here's what a typical dimension looks like in LookML.
  # A dimension is a groupable field that can be used to filter query results.
  # This dimension will be called "Inventory Item ID" in Explore.

  dimension: order_id {
    type: number
    sql: ${TABLE}."ORDER_ID" ;;
    value_format_name: id
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
    sql: ${TABLE}."RETURNED_AT" ;;
  }

  dimension: sale_price {
    type: number
    sql: ${TABLE}."SALE_PRICE" ;;
    value_format_name: usd
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
      year,
      day_of_week
    ]
    sql: ${TABLE}."SHIPPED_AT" ;;
  }

  dimension: status {
    description: "Whether order is processing, shipped, completed, etc."
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

  dimension: inventory_item_id {
    type: number
    hidden: yes
    sql: ${TABLE}."INVENTORY_ITEM_ID" ;;
  }

  dimension: user_id {
    type: number
    hidden: yes
    sql: ${TABLE}."USER_ID" ;;
  }

  dimension: profit {
    description: "Profit made on any one item"
    hidden:  yes
    type: number
    value_format_name: usd
    sql: ${sale_price} - ${inventory_items.cost} ;;
  }

  ## MEASURES ##


  # A measure is a field that uses a SQL aggregate function. Here are count, sum, and average
  # measures for numeric dimensions, but you can also add measures of many different types.
  # Click on the type parameter to see all the options in the Quick Help panel on the right.

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  # These sum and average measures are hidden by default.
  # If you want them to show up in your explore, remove hidden: yes.

  measure: order_item_count {
    type: count
    drill_fields: [detail*]
  }

  measure: total_revenue {
    type: sum
    value_format_name: usd
    sql: ${sale_price} ;;
    drill_fields: [detail*]
  }

  measure: total_revenue_completed {
    label: "Total Revenue from Completed Orders"
    type: sum
    value_format_name: usd
    sql: ${sale_price} ;;
    filters: {
      field: status
      value: "Complete"
    }
  }

  measure: total_revenue_returned {
    label: "Total Revenue Lost from Returns"
    description: "Revenue not gained due to the ordered item being returned by the customer"
    type: sum
    value_format_name: usd
    sql: ${sale_price} ;;
    filters: {
      field: returned_date
      value: "-NULL"
    }
  }

  measure: order_count {
    description: "A count of unique orders"
    type: count_distinct
    sql: ${order_id} ;;
    drill_fields: [user_id,order_id,created_date,order_item_count,total_revenue]
  }

  measure: total_profit {
    type: sum
    sql: ${profit} ;;
    value_format_name: usd
  }

  measure: average_shipping_time {
    type: average
    sql: ${shipping_time} ;;
    value_format: "0.00\" days\""
  }

  measure: average_sale_price {
    type: average
    sql: ${sale_price} ;;
    value_format_name: usd
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

  ##
  # ----- Sets of fields for drilling ------
  set: detail {
    fields: [
      id,
      inventory_items.product_name,
      inventory_items.id,
      users.last_name,
      users.first_name,
      users.id
    ]
  }
}
