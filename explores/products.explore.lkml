include: "/views/products.view.lkml"
include: "/views/distribution_centers.view.lkml"

explore: products {
  join: distribution_centers {
    type: left_outer
    sql_on: ${products.distribution_center_id} = ${distribution_centers.id} ;;
    relationship: many_to_one
  }
}
