class Object
  def returning(receiver)
    yield receiver
    receiver
  end
end