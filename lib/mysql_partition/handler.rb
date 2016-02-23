require "mysql_partition/sql_maker"

module MysqlPartition
  class Handler
    attr_accessor :dbh, :executed, :sql_maker
    def initialize(hash)
      # dbh = Sequel only
      if !(hash[:dbh])
        raise ArgumentError, "need dbh"
      end

      @sql_maker = SqlMaker.new(hash)
      @dbh = hash[:dbh]
      @executed = 0
      @hash = hash
    end

    def method_missing name, *args, &c
      if (@sql_maker.respond_to?(name))
        statement = @sql_maker.send(name, *args)
        p statement
        @dbh.run(statement)
      else
        raise StandardError, "not implement #{name} in sql maker"
      end
    end
  end
end
