# -*- encoding: utf-8 -*-
# Author:: Farzad FARID (<ffarid@pragmatic-source.com>)
# Copyright:: Copyright (c) 2011-2012 Farzad FARID
# License:: Simplified BSD License

module Zabby
  # Create Zabbix classes as provided by the Zabbix API
  module ZClass
    # List of available Zabbix classes
    @zabbix_classes = []

    def self.included(base)
      base.extend(ClassMethods)
      # Keep a list of Zabbix classes
      @zabbix_classes << base.name.gsub(/^.*::/, '')
    end

    # Return the list of Zabbix classes
    # @return [Array] List of Zabbix classes
    def self.zabbix_classes
      @zabbix_classes
    end

    module ClassMethods
      # List of valid Web Service methods for the current Zabbix Object
      attr_reader :zmethods
      # The id field name for the model ("actionid", "hostid", etc.)
      attr_reader :id

      # Name of the current class without the namespace
      # @return [String]
      # @example
      #   Zabby::Host.object_name => "Host"
      def class_name
        @class_name ||= self.name.split(/::/).last.downcase
      end

      # Human representation of the Zabbix Class
      # @return [String] Class representation
      # @example
      #   Host.inspect => "<Zabby::Host methods=(create, delete, exists, get, update)>"
      def inspect
        "<#{name} methods=(#{@zmethods.join(', ')})>"
      end

      private

      # Set the name of the primary key
      # @param key [String] Primary key name
      def primary_key(key)
        @id = key.to_sym
      end

      # Add the list of Web Service methods to the current class.
      # @param [Array] zmethods Method names
      # @example
      #   class Host
      #     include ZClass
      #     add_zmethods :create, :delete, :exists, :get, :update
      #   end
      def add_zmethods(*zmethods)
        @zmethods = zmethods.map { |f| f.to_sym }
      end

      # Simulate methods on the object and call the Zabbix Web Service ("host.get", "item.create", etc.).
      # See http://www.zabbix.com/documentation/1.8/api for the API documentation.
      # @param [String] zmethod Name of the Web Service methods
      # @param [Array] args Method arguments
      # @param [Proc] block Unused
      # @raise [NoMethodError] Raised on invalid method names.
      def method_missing(zmethod, *args, &block)
        if @zmethods.include? zmethod
          Zabby::Runner.instance.connection.perform_request(class_name, zmethod, args.first)
        else
          super
        end
      end
    end
  end

  # Create all Zabbix object types and theirs methods.

  class Action
    include ZClass
    primary_key :actionid
    add_zmethods :create, :delete, :exists, :get, :update
  end

  class Alert
    include ZClass
    primary_key :alertid
    add_zmethods :create, :delete, :get
  end

  class APIInfo
    include ZClass
    add_zmethods :version
  end

  class Application
    include ZClass
    primary_key :applicationid
    add_zmethods :create, :delete, :exists, :get, :massAdd, :update
  end

  class Configuration
    include ZClass
    add_zmethods :import, :export
  end

  class DHost
    include ZClass
    add_zmethods :exists, :get
  end

  class DService
    include ZClass
    add_zmethods :exists, :get
  end

  class DCheck
    include ZClass
    add_zmethods :get
  end

  class DRule
    include ZClass
    add_zmethods :create, :delete, :exists, :get, :isReadable, :isWritable, :update
  end

  class Event
    include ZClass
    primary_key :eventid
    add_zmethods :acknowledge, :create, :delete, :get
  end

  class Graph
    include ZClass
    primary_key :graphid
    add_zmethods :create, :delete, :exists, :get, :getObjects, :update
  end

  class Graphitem
    include ZClass
    primary_key :gitemid
    add_zmethods :get
  end

  class GraphPrototype
    include ZClass
    primary_key :graphid
    add_zmethods :create, :delete, :exists, :get, :getObjects, :update
  end

  class History
    include ZClass
    primary_key :id # TODO Verify. The online documentation is not clear.
    add_zmethods :delete, :get
  end

  class HTTPTest
    include ZClass
    primary_key :httptestid
    add_zmethods :create, :delete, :get, :isReadable, :isWritable, :update
  end

  class Host
    include ZClass
    primary_key :hostid
    add_zmethods :create, :delete, :exists, :get, :getObjects, :isReadable, :isWritable, :massAdd, :massRemove, :massUpdate :update
  end

  class Hostgroup
    include ZClass
    primary_key :groupid
    add_zmethods :create, :delete, :exists, :get, :getObjects, :isReadable, :isWritable, :massAdd, :massRemove, :massUpdate :update
  end

  class Hostinterface
    include ZClass
	primary_key :interfaceid
	add_zmethods :create, :delete, :exists, :get, :massAdd, :massRemove, :replaceHostInterfaces, :update
  end
  
  class HostPrototype
    include ZClass
    primary_key :hostid
    add_zmethods :create, :delete, :get, :isReadable, :isWritable, :update
  end


  class Image
    include ZClass
    primary_key :imageid
    add_zmethods :create, :delete, :exists, :get, :getObjects :update
  end

  class Item
    include ZClass
    primary_key :itemid
    add_zmethods :create, :delete, :exists, :get, :getObjects, :isReadable, :isWritable :update
  end

  class ItemPrototype
    include ZClass
    primary_key :itemid
    add_zmethods :create, :delete, :exists, :get, :isReadable, :isWritable :update
  end

  class Service
    include ZClass
    primary_key :serviceid
    add_zmethods :addDependencies, :addTimes, :create, :delete, :deleteDependencies, :deleteTimes, :get, :getSLA, :isReadable, :isWritable, :update
  end

  class DiscoveryRule
    include ZClass
    primary_key :itemid
    add_zmethods :copy, :create, :delete, :exists, :get, :isReadable, :isWritable, :update
  end

  class Maintenance
    include ZClass
    primary_key :maintenanceid
    add_zmethods :create, :delete, :exists, :get, :update
  end

  class Map
    include ZClass
    primary_key :sysmapid
    add_zmethods :create, :delete, :exists, :get, :getObjects, :isReadable, :isWritable, :update
  end

  class Mediatype
    include ZClass
    primary_key :mediatypeid
    add_zmethods :create, :delete, :get, :update
  end

  class Proxy
    include ZClass
    primary_key :proxyid
    add_zmethods :create, :delete, :get, :isReadable, :isWritable, :update
  end

  class Screen
    include ZClass
    primary_key :screenid
    add_zmethods :create, :delete, :exists, :get, :update
  end

  class ScreenItem
    include ZClass
    primary_key :screenitemid
    add_zmethods :create, :delete, :get, :isReadable, :isWritable, :update, :updateByPosition
  end

  class Script
    include ZClass
    primary_key :scriptid
    add_zmethods :create, :delete, :execute, :get, :getScriptsByHost, :update
  end

  class Template
    include ZClass
    primary_key :templateid
    add_zmethods :create, :delete, :exists, :get, :getObjects, :isReadable, :isWritable, :massAdd, :massRemove, :massUpdate, :update
  end

  class TemplateScreen
    include ZClass
    primary_key
    add_zmethods :copy, :create, :delete, :exists, :get, :isReadable, :isWritable, :update
  end

  class TemplateScreenItem
    include ZClass
    primary_key :templateid
    add_zmethods :get
  end

  class Trigger
    include ZClass
    primary_key :triggerid
    add_zmethods :addDependencies, :create, :delete, :deleteDependencies, :exists, :get, :getObjects, :isReadable, :isWritable, :update
  end

  class TriggerPrototype
    include ZClass
    add_zmethods :create, :delete, :get, :update
  end

  class User
    include ZClass
    primary_key :userid
    add_zmethods :addMedia, :authenticate, :create, :delete, :deleteMedia, :get, :isReadable, :isWritable, :login, :logout, :update, :updateMedia, :updateProfile
  end

  class Usergroup
    include ZClass
    primary_key :usrgrpid
    add_zmethods :create, :delete, :exists, :get, :getObjects, :isReadable, :isWritable, :massAdd, :massRemove, :massUpdate, :update
  end

  class Usermacro
    include ZClass
    primary_key :hostmacroid
    add_zmethods :create, :createGlobal, :delete, :deleteGlobal, :deleteHostMacro, :get, :massAdd, :massRemove, :massUpdate, :update, :updateGlobal
  end

  class Usermedia
    include ZClass
    primary_key :mediatypeid
    add_zmethods :get
  end

end
