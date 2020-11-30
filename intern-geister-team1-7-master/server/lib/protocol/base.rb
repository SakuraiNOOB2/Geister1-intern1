module Protocol
  class Base
    include JsonWorld::DSL
    include Protocol::DefinitionMethods
    include Protocol::LinkMethods
  end
end
