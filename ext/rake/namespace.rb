# add some useful introspection to Rake::NameSpace
#
# these methods are instrumental, not necessarily well-conceived
#

class Rake::NameSpace
  def namespaces
    tasks.map do |t|
      depth = @scope.to_a.count
      h = t.name.split(':')
      h[depth] if h.length > depth + 1
    end.compact.sort.uniq
  end

  def scope_name
    @scope.to_a.reverse.join(':')
  end
end
