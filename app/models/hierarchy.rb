class Hierarchy
  attr_reader :name, :environment, :datadir, :backend, :files

  def self.all(environment, node)
    facts = node.facts
    HieraData.new(environment.name).hierarchies.map do |hierarchy|
      new(environment: environment,
          name: hierarchy.name,
          datadir: hierarchy.datadir,
          backend: hierarchy.backend,
          files: hierarchy.resolved_paths(facts: facts),
          encryptable: hierarchy.encryptable?)
    end
  end

  def self.find(environment, node, name)
    all(environment, node).find { |h| h.name == name }
  end

  def initialize(environment:, name:, datadir:, backend:, files:, encryptable: false)
    @environment = environment
    @name = name
    @datadir = datadir
    @backend = backend
    @files = files
    @encryptable = encryptable
  end

  def values_for(key)
    @values ||= {}
    @values[key] ||=
      hiera_data.search_key(@datadir, @files, key.name).map do |path, path_data|
        Value.new(hierarchy: self,
                  key: key,
                  path: path,
                  file_present: path_data[:file_present],
                  file_writable: path_data[:file_writable],
                  key_present: path_data[:key_present],
                  value: path_data[:value])
      end
  end

  def encrypt_value(value)
    hiera_data.encrypt_value(name, value)
  end

  def decrypt_value(value)
    hiera_data.decrypt_value(name, value)
  end

  def eyaml?
    backend == :eyaml
  end

  def encryption_possible?
    eyaml? &&
      Rails.configuration.hdm['allow_encryption'] &&
      @encryptable
  end

  private

  def hiera_data
    @hiera_data ||= HieraData.new(@environment.name)
  end
end
