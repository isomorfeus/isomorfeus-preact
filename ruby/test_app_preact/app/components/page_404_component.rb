class Page404Component < LucidComponent::Base
  render do
    Isomorfeus.ssr_response_status = 404
    P "Oops, page not found!"
    NavigationLinks()
  end
end
