# frozen_string_literal: true

require "active_support/concern"
module Sortable
  module Model
    extend ActiveSupport::Concern

    class_methods do
      def sortable(*args)
        @sortable ||= []
        @sortable << args unless args.empty?
        @sortable
      end

      def sorting(column, direction = :asc, *args)
        Sortable::Sort.new(self, column, direction, *args).all
      end
    end
  end

  class Column
    attr_reader :name, :column, :scope, :method
    def initialize(name, scope = nil, column: name, method: nil)
      @name = name
      @column = column
      @method = method
      @scope = scope
    end
  end

  class Sort
    attr_reader :scope, :args

    def initialize(scope, column, direction, *args)
      @scope = scope
      @column = column
      @direction = direction
      @args = args
    end

    def columns
      @columns ||= create_columns
    end

    def all
      all = scope.all

      if column
        all = all.merge(column.scope) if column.scope.present?

        if column.method
          all = all.public_send(column.method, direction.to_sym, *args)
        elsif column.column.is_a?(Symbol)
          all = all.order(column.column => direction)
        else
          all = all.order("#{column.column} #{direction}")
        end
      end

      all
    end

    def direction
      @direction.to_s == "desc" ? "desc" : "asc"
    end

    def column
      columns[@column.to_s]&.first
    end

    def create_columns
      scope.sortable.flat_map do |columns|
        columns = [columns] unless columns.all? { |column| column.is_a?(Symbol) }
        columns.map { |column| create_column(column) }
      end.group_by { |column| column.name.to_s }
    end

    def create_column(column)
      options = column.respond_to?(:last) && column.last.is_a?(Hash) ? column.pop : {}
      Column.new(*column, **options)
    end
  end
end
