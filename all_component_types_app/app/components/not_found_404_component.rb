class NotFound404Component < LucidComponent::Base
  render do
    Isomorfeus.ssr_response_status = 404 # keep
    P "Oops, page not found!"
    NavigationLinks()
  end
end