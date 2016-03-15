require "mysql_partition/sql_maker"

module MysqlPartition
  class Client
    attr_accessor :cli, :sql_maker
    def initialize(hash)
      # cli = mysql2_cli
      if !(hash[:cli])
        raise ArgumentError, "need cli"
      end

      @sql_maker = SqlMaker.new(hash)
      @cli = hash[:cli]
    end

    def self.method_list
      ['create_partitions', 'drop_partiitons', 'add_partitions']
    end

    def method_missing name, *args, &c
      if (@sql_maker.respond_to?(name) && self.class.method_list.include?(name.to_s))
        statement = @sql_maker.send(name, *args)
        @cli.query(statement)
      else
        raise StandardError, "#{name} is not implemented in sql maker, or disallowed method"
      end
    end
  end
end
