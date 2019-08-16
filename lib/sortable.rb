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

      def sorting(column, direction = :asc)
        Sortable::Sort.new(self, column, direction).all
      end
    end
  end

  class Column
    attr_reader :name, :column, :scope
    def initialize(name, scope = nil, column: name)
      @name = name
      @column = column
      @scope = scope
    end
  end

  class Sort
    attr_reader :scope

    def initialize(scope, column, direction)
      @scope = scope
      @column = column
      @direction = direction
    end

    def columns
      @columns = create_columns
    end

    def all
      all = scope.all

      if column
        all = all.merge(column.scope) if column.scope.present?
        all = all.order("#{column.column} #{direction}")
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
        columns.map { |column| Column.new(*column) }
      end.group_by { |column| column.name.to_s }
    end
  end
end
