require 'forwardable'
require 'prestashop/client/error'
require 'prestashop/client/implementation'
require 'prestashop/client/settings'

module Prestashop
  module Client
    extend SingleForwardable
    def_delegators :current, :connection, :settings

    # Delegate to current user implementation
    def self.current
      Implementation.current
    end
  end
end