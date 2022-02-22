class NavigationLinks < Preact::FunctionComponent::Base
  render do
    P do
      Link(to: '/') { 'Hello World!' }
      SPAN " | "
      Link(id: :link_welcome, to: '/welcome') { 'Welcome!' }
      SPAN " | "
      Link(to: '/ssr') { 'SSR!' }
      SPAN " | "
      Link(to: '/whatever') { '404!' }
    end
  end
end
