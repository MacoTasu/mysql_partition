require "mysql_partition/sql_maker"

module MysqlPartition
  class Handler
    attr_accessor :dbh, :sql_maker
    def initialize(hash)
      # dbh = mysql2_cli
      if !(hash[:dbh])
        raise ArgumentError, "need dbh"
      end

      @sql_maker = SqlMaker.new(hash)
      @dbh = hash[:dbh]
    end

    def self.method_list
      ['create_partitions', 'drop_partiitons', 'add_partitions']
    end

    def method_missing name, *args, &c
      if (@sql_maker.respond_to?(name) && self.class.method_list.include?(name.to_s))
        statement = @sql_maker.send(name, *args)
        @dbh.query(statement)
      else
        raise StandardError, "#{name} is not implemented in sql maker, or disallowed method"
      end
    end
  end
end
