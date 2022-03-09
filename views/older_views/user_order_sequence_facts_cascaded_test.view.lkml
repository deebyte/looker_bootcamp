view: user_order_sequence_facts{
  derived_table: {
    sql: SELECT
      order_id, datediff(day, previous_created_at, created_at) as days, sequence_number
      FROM
      (SELECT order_id, user_id, created_at,
      LAG (created_at,1) over (partition by user_id order by created_at) as previous_created_at,
      rank() over (partition by user_id order by created_at) as sequence_number
      FROM order_items
      GROUP BY order_id, user_id, created_at
      order by user_id)
      group by order_id, days, sequence_number
       ;;
  }

  dimension: order_id {
    primary_key: yes
    type: number
    sql: ${TABLE}.order_id ;;
  }

  dimension: days {
    label: "Days Since Previous Order"
    type: number
    sql: ${TABLE}.days ;;
  }

  dimension: sequence_number {
    label: "Order Sequence Number"
    type: number
    sql: ${TABLE}.sequence_number ;;
  }

  measure: avg_days_between_user_orders {
    type: average
    sql: ${days} ;;
  }

}
