view: events {
  sql_table_name: public.events ;;

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: browser {
    type: string
    sql: ${TABLE}.browser ;;
  }

  dimension: city {
    label: "City Name"
    description: "this is my test description"
    type: string
    sql: ${TABLE}.city ;;
  }

  dimension: country {
    type: string
    map_layer_name: countries
    sql: ${TABLE}.country ;;
  }

  dimension_group: created {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year,
      day_of_year
    ]
    sql: ${TABLE}.created_at ;;
  }


  dimension: day_of_campaign {
    hidden: yes
    type: number
    sql: 43 ;;
  }

  dimension: event_type {
    type: string
    sql: ${TABLE}.event_type ;;
  }

  dimension: ip_address {
    type: string
    sql: ${TABLE}.ip_address ;;
  }

  dimension: latitude {
    type: number
    sql: ${TABLE}.latitude ;;
  }

  dimension: longitude {
    type: number
    sql: ${TABLE}.longitude ;;
  }

  dimension: os {
    type: string
    sql: ${TABLE}.os ;;
  }

  dimension: sequence_number {
    type: number
    sql: ${TABLE}.sequence_number ;;
  }

  dimension: session_id {
    type: string
    sql: ${TABLE}.session_id ;;
  }

  dimension: state {
    type: string
    sql: ${TABLE}.state ;;
  }

  dimension: traffic_source {
    type: string
    sql: ${TABLE}.traffic_source ;;
  }

  dimension: uri {
    type: string
    sql: ${TABLE}.uri ;;
  }

  dimension: user_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.user_id ;;
  }

  dimension: zip {
    type: zipcode
    sql: ${TABLE}.zip ;;
  }

  measure: count {
    type: count
    drill_fields: [id, users.id, users.first_name, users.last_name]
  }

  measure: count_events_facebook {
    hidden: yes
    type: count_distinct
    sql: ${id} ;;
    filters: {
      field: traffic_source
      value: "Facebook"
    }
  }



  measure: count_events_search {
    hidden: yes
    type: count_distinct
    sql: ${id} ;;
    filters: {
      field: traffic_source
      value: "Search"
    }
  }



  measure: count_events_organic {
    hidden: yes
    type: count_distinct
    sql: ${id} ;;
    filters: {
      field: traffic_source
      value: "Organic"
    }
  }




  measure: testface {
    type: count
    html: <div class="vis">
          <div class="vis-single-value" style="font-size:30px; background-image: linear-gradient(to right, #5A2FC2, #F84066); color:#ffffff">
          <font color="#5A2FC2"><center><b>Day of campaign:</b>&nbsp; {{events.day_of_campaign._rendered_value}} / 90 </font>
          <p><em>68% of Goal</em></p>
          <p style="color:#ffffff;">{{ rendered_value }} Total Events </p>
          <p style="float:left; font-family: Trebuchet MS;">
          <i class="fa fa-facebook">&nbsp;</i> {{ events.count_events_facebook._rendered_value }} Events&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
          <i class="fa fa-search">&nbsp;</i> {{ events.count_events_search._rendered_value }} Events&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
          <i class="fa fa-leaf">&nbsp;</i> {{ events.count_events_organic._rendered_value }} Events</p></center>
          </div>
          </div>
       ;;
  }
}
