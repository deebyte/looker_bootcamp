# Define the database connection to be used for this model.
connection: "ecommerce"

# include all the explores
include: "/explores/*.explore"


# Datagroups

# Use datagroup to assign a caching policy to Explores and/or PDTs. If you want different caching policies for different Explores and/or PDTs,
# then use a separate datagroup parameter to specify each policy.

    # max_cache_age:    Specifies a string defining a time period. When the age of a query’s cache exceeds the time period, Looker invalidates the cache.
    #                   The next time the query is issued, Looker sends the query to the database for fresh results.

    # sql_trigger:      Specifies a SQL query that returns one row with one column. If the value returned by the query is different than the query’s prior results,
    #                   then the datagroup goes into a triggered state. See the sql_trigger section on this page for details.

# default datagroup
datagroup: applovin_bootcamp_default_datagroup {
  max_cache_age: "1 hour"
}

# this one build cache for 6 hours
datagroup: 6_hours {
  max_cache_age: "6 hours"
}

# this one resets cache at midnight
datagroup: midnight {
  sql_trigger: select CURRENT_DATE() ;;
}

# this resets cache at 7am AND then sets cache for 10 hours
datagroup: morning_dashboard {
  sql_trigger: select FLOOR((EXTRACT(epoch from GETDATE()) - 60*60*7)/(60*60*24)) ;;
  max_cache_age: "10 hour"
}

## Exercise 6 - Task 1: Set up a default datagroup that triggers at midnight each day with the date changes.
#                      Ensure that the cache age will never exceed 24 hours.  Apply this datagroup to the Users Explore
# Hint: The Snowflake function to return the current date is "CURRENT_DATE()"

# datagroup: 24_hour_cache_policy {
#   sql_trigger:  ;;
#   max_cache_age: ""
# }

##

## Exercise 6 - Task 2: Set up an order_items datagroup that triggers any time the maximum created_at timestamp in the order_items table changes.
#               Ensure that the cache age will never exceed 4 hours. Apply this data group to the Order Items Explore

# datagroup: order_items_datagroup {
#   sql_trigger: select max() from ;;
#   max_cache_age: ""
# }

##

#Use persist_with at the model level to specify the default datagroup caching policy to use for all Explores in the model.

persist_with: applovin_bootcamp_default_datagroup


# Dashboards

include: "/dashboards/business_pulse.dashboard"
