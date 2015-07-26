every 1.hour, roles: [:app] do
  rake 'ranking:aggreagte'
end
