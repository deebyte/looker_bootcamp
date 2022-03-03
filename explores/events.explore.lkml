include: "/views/events.view.lkml"
include: "/views/users.view.lkml"

explore: events {
  join: users {
    type: left_outer
    sql_on: ${events.user_id} = ${users.id} ;;
    relationship: many_to_one
  }
}
