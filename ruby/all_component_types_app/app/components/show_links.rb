class ShowLinks < Preact::Component::Base
  render do
    H2 { 'Functionality' }
    DIV do
      H3 { 'Preact::FunctionComponent, Props:' }
      Link(to: '/fun_fun/10') { 'Render 10 Components' }
    end
    DIV do
      H3 { 'Preact::Component, Props, State:' }
      Link(to: '/com_fun/10') { 'Render 10 Components'  }
    end
    DIV do
      H3 { 'LucidComponent, Props, State, Store:' }
      Link(to: '/luc_fun/10') { 'Render 10 Components'  }
    end
    DIV do
      H3 { 'LucidFunc, Props:' }
      Link(to: '/func_fun/10') { 'Render 10 Components'  }
    end
    DIV do
      H3 { 'LucidMaterial::Component, Props, State, Store:' }
      Link(to: '/mat_fun/10') { 'Render 10 Components'  }
    end
    DIV do
      H3 { 'Javascript Component, Props:' }
      Link(to: '/js_fun/10') { 'Render 10 Components'  }
    end
    DIV do
      H3 { 'Everything together:' }
      Link(to: '/all_the_fun/1') { 'Render all Component types'  }
    end
    H2 { 'Performance' }
    DIV { 'For example:' }
    DIV { '~ 1000 nodes -> most sites' }
    DIV { '~ 3000 nodes -> amazon' }
    DIV { '~ 10000 nodes -> youtube, twitter' }
    DIV do
      H3 { 'Preact::FunctionComponent, Props:' }
      Link(to: '/fun_run/1000') { 'Render 1000 nodes' }
      SPAN { ' | ' }
      Link(to: '/fun_run/3000') { 'Render 3000 nodes' }
      SPAN { ' | ' }
      Link(to: '/fun_run/10000') { 'Render 10000 nodes' }
    end
    DIV do
      H3 { 'Preact::Component, Props, State:' }
      Link(to: '/com_run/1000') { 'Render 1000 nodes' }
      SPAN { ' | ' }
      Link(to: '/com_run/3000') { 'Render 3000 nodes' }
      SPAN { ' | ' }
      Link(to: '/com_run/10000') { 'Render 10000 nodes' }
    end
    DIV do
      H3 { 'LucidComponent, Props, State, Store:' }
      Link(to: '/luc_run/1000') { 'Render 1000 nodes' }
      SPAN { ' | ' }
      Link(to: '/luc_run/3000') { 'Render 3000 nodes' }
      SPAN { ' | ' }
      Link(to: '/luc_run/10000') { 'Render 10000 nodes' }
    end
    DIV do
      H3 { 'LucidFunc, Props:' }
      Link(to: '/func_run/1000') { 'Render 1000 nodes' }
      SPAN { ' | ' }
      Link(to: '/func_run/3000') { 'Render 3000 nodes' }
      SPAN { ' | ' }
      Link(to: '/func_run/10000') { 'Render 10000 nodes' }
    end
    DIV do
      H3 { 'Only LucidComponent, Props, State, Store:' }
      Link(to: '/lucs_run/1000') { 'Render 1000 nodes' }
      SPAN { ' | ' }
      Link(to: '/lucs_run/3000') { 'Render 3000 nodes' }
      SPAN { ' | ' }
      Link(to: '/lucs_run/10000') { 'Render 10000 nodes' }
    end
    DIV do
      H3 { 'LucidComponent, Props, State, Store, new Syntax:' }
      Link(to: '/lucsy_run/1000') { 'Render 1000 nodes' }
      SPAN { ' | ' }
      Link(to: '/lucsy_run/3000') { 'Render 3000 nodes' }
      SPAN { ' | ' }
      Link(to: '/lucsy_run/10000') { 'Render 10000 nodes' }
    end
    DIV do
      H3 { 'Only LucidComponent, Props, State, Store, new Syntax:' }
      Link(to: '/lucssy_run/1000') { 'Render 1000 nodes' }
      SPAN { ' | ' }
      Link(to: '/lucssy_run/3000') { 'Render 3000 nodes' }
      SPAN { ' | ' }
      Link(to: '/lucssy_run/10000') { 'Render 10000 nodes' }
    end
    DIV do
      H3 { 'MaterialComponent, Props, State, Store, Style:' }
      Link(to: '/mat_run/1000') { 'Render 1000 nodes' }
      SPAN { ' | ' }
      Link(to: '/mat_run/3000') { 'Render 3000 nodes' }
      SPAN { ' | ' }
      Link(to: '/mat_run/10000') { 'Render 10000 nodes' }
    end
    DIV do
      H3 { 'Only MaterialComponent, Props, State, Store, Style:' }
      Link(to: '/mats_run/1000') { 'Render 1000 nodes' }
      SPAN { ' | ' }
      Link(to: '/mats_run/3000') { 'Render 3000 nodes' }
      SPAN { ' | ' }
      Link(to: '/mats_run/10000') { 'Render 10000 nodes' }
    end
    DIV do
      H3 { 'Javascript Component, Props:' }
      Link(to: '/js_run/1000') { 'Render 1000 nodes' }
      SPAN { ' | ' }
      Link(to: '/js_run/3000') { 'Render 3000 nodes' }
      SPAN { ' | ' }
      Link(to: '/js_run/10000') { 'Render 10000 nodes' }
    end
  end
end
