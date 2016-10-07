envelope json, response_state do
  json.path ('/' + @path.join('/'))
  json.hash @hash
end
