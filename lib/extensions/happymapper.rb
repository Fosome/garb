require 'libxml'

module HappyMapper

  module ClassMethods
    include LibXML

    def parse(xml, options = {})
      # locally scoped copy of namespace for this parse run
      namespace = @namespace

      if xml.is_a?(XML::Node)
        node = xml
      else
        if xml.is_a?(XML::Document)
          node = xml.root
        else
          node = XML::Parser.string(xml).parse.root
        end

        root = node.name == tag_name
      end

      # This is the entry point into the parsing pipeline, so the default
      # namespace prefix registered here will propagate down
      namespaces = node.namespaces
      if namespaces && namespaces.default
        already_assigned = namespaces.definitions.detect do |defn|
          namespaces.default && namespaces.default.href == defn.href && defn.prefix
        end
        namespaces.default_prefix = DEFAULT_NS unless already_assigned
        namespace ||= DEFAULT_NS
      end

      xpath = root ? '/' : './/'
      xpath += "#{namespace}:" if namespace
      xpath += tag_name
      # puts "parse: #{xpath}"
      
      nodes = node.find(xpath)
      collection = nodes.collect do |n|
        obj = new
        
        attributes.each do |attr| 
          obj.send("#{attr.method_name}=", 
                    attr.from_xml_node(n, namespace))
        end
        
        elements.each do |elem|
          obj.send("#{elem.method_name}=", 
                    elem.from_xml_node(n, namespace))
        end
        
        obj
      end

      # per http://libxml.rubyforge.org/rdoc/classes/LibXML/XML/Document.html#M000354
      nodes = nil

      if options[:single] || root
        collection.first
      else
        collection
      end
    end
  end
end