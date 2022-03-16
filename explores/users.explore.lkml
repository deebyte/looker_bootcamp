include: "/views/users.view.lkml"

explore: users {

  persist_with: 24_hour_cache_policy

  # join: order_items {
  #   type: left_outer
    # sql_on: ${user_id} = ${items} ;;
  #   relationship: one_to_many
  # }
}
