class Hash
  def method_missing(method, *args)
    begin
      fetch(method.to_s)
    rescue
      super(method, args)
    end
  end
end
