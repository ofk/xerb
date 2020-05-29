# frozen_string_literal: true

require 'xerb/version'
require 'erb'

class XERB < ::ERB
  def self.erb_version
    @erb_version ||= ::Gem::Version.create(version.match(/(?<=\[)[\w\.]+/))
  end

  class Compiler < ::ERB::Compiler
    attr_accessor :proc_cmd

    def add_insert_cmd(out, content)
      out.push("#{@insert_cmd}(#{@proc_cmd}(#{content}).to_s)")
    end
  end

  def initialize(*args, **kwargs, &block)
    if self.class.erb_version >= ::Gem::Version.create('2.2.0')
      super(*args, **kwargs)
    else
      super(*args)
    end
    @prcval = block || :itself.to_proc
  end

  def make_compiler(trim_mode)
    Compiler.new(trim_mode)
  end

  def set_eoutvar(compiler, eoutvar = '_erbout')
    super(compiler, eoutvar)
    @prcvar = "#{eoutvar}_prc"
    compiler.proc_cmd = "#{@prcvar}.call"
  end

  def result(b = new_toplevel)
    b.local_variable_set(@prcvar, @prcval)
    super(b)
  end
end
