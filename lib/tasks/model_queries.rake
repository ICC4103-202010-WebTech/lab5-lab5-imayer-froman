namespace :db do
  task :populate_fake_data => :environment do
    # If you are curious, you may check out the file
    # RAILS_ROOT/test/factories.rb to see how fake
    # model data is created using the Faker and
    # FactoryBot gems.
    puts "Populating database"
    # 10 event venues is reasonable...
    create_list(:event_venue, 10)
    # 50 customers with orders should be alright
    create_list(:customer_with_orders, 50)
    # You may try increasing the number of events:
    create_list(:event_with_ticket_types_and_tickets, 3)
  end
  task :model_queries => :environment do
    # Sample query: Get the names of the events available and print them out.
    # Always print out a title for your query
    puts("Query 0: Sample query; show the names of the events available")
    result = Event.select(:name).distinct.map { |x| x.name }
    puts(result)
    puts("EOQ") # End Of Query -- always add this line after a query.
    puts("")

    ###LAB 5###

    puts("Query 1:") # Inside "where" you can specify the customer
    result1 = Customer.joins(orders: :tickets).where(id: 1).count
    puts(result1)
    puts("EOQ") # End Of Query
    puts("")

    puts("Query 2:") # Inside "where" you can specify the customer by its "id"
    result2 =  Order.joins(tickets: :ticket_type).where(customer_id: 1).group(:event_id).count.count
    puts(result2)
    puts("EOQ") # End Of Query
    puts("")

    puts("Query 3:") # Inside "where" you can specify the customer by its "id"
    result3 =  Event.joins(ticket_types: [{tickets: :order}]).where(orders: {customer_id: 2}).distinct.pluck(:name)
    puts(result3)
    puts("EOQ") # End Of Query
    puts("")

    puts("Query 4:") # Inside "where" you can specify the event
    result4 =  Event.joins(ticket_types: [{tickets: :order}]).where(id: 1).group('tickets.id').count.count
    puts(result4)
    puts("EOQ") # End Of Query
    puts("")

    puts("Query 5:") # Inside "where" you can specify the event
    result5 =  Event.joins(ticket_types: [{tickets: :order}]).where(id: 1).
        group('tickets.id').pluck('ticket_types.ticket_price').sum
    puts(result5)
    puts("EOQ") # End Of Query
    puts("")

    puts("Query 6:") # The query shows the events attendance in ASC order
    result6 =  Event.joins(ticket_types: [{tickets: [{order: :customer}]}]).
        where(customers: {gender: "f"}).
        group(:name).count(:name)
    puts(result6)
    puts("EOQ") # End Of Query
    puts("")

    puts("Query 7:") # The query shows the events attendance in ASC order
    result7 =  Event.joins(ticket_types: [{tickets: [{order: :customer}]}]).
        where(customers: {gender: "m", age: 18..30}).
        group(:name).count(:name)
    puts(result7)
    puts("EOQ") # End Of Query
    puts("")



  end



end