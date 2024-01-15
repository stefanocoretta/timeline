function Meta(meta)
  if FORMAT:match "html" then

    -- add timeline css and js
    quarto.doc.add_html_dependency({
      name = "timeline",
      version = "1.0",
      stylesheets = {"horizontal-timeline-with-swiper/src/style.css"},
      scripts = {{path = "horizontal-timeline-with-swiper/src/script.js", afterBody = true}}
    })

    -- add swiper stylesheet in header
    table.insert(meta["header-includes"], pandoc.RawBlock("html", "<link rel='stylesheet' href='https://cdnjs.cloudflare.com/ajax/libs/Swiper/3.4.2/css/swiper.min.css'>"))
    
    -- add vue and swiper js after body
    table.insert(meta["include-after"], pandoc.RawBlock("html", [[
<script src="https://cdnjs.cloudflare.com/ajax/libs/vue/2.3.4/vue.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/Swiper/3.4.2/js/swiper.min.js"></script>
    ]]))
      
    return meta
  end
end


function Div(div)
  if div.classes:includes("timeline") then
    if FORMAT:match "html" then

      -- timeline div
      tl_div = pandoc.Div({}, {class = "swiper-wrapper timeline"})


      local tl_list = div.content[1]
      -- append slides into timeline main div
      for _, block in ipairs(tl_list.content) do

        local year = block[1].content[1]

        year = pandoc.Span(year, {class = "date"})

        if #block[1].content == 3 then
          local title = block[1].content[3]
          local title = pandoc.Span(title)

          slide_cont = {
            pandoc.Div(year, {class = "timestamp"}),
            pandoc.Div(title, {class = "status"})
          }
        else
          slide_cont = {
            pandoc.Div(year, {class = "timestamp"}),
            pandoc.Div(pandoc.Span(""), {class = "status"})
          }
        end
        -- create current slide div
        slide_div = {pandoc.Div(slide_cont, {class = "swiper-slide"})}
        tl_div.content:extend(slide_div)

      end

      buttons = pandoc.RawBlock("html", [[
<p class="swiper-control">
<button type="button" class="btn btn-default btn-sm prev-slide">Prev</button>
<button type="button" class="btn btn-default btn-sm next-slide">Next</button>
</p>
]])
      pagination = pandoc.RawBlock("html", [[
<div class="swiper-pagination"></div>
      ]])

      -- timeline main div
      swiper_container = pandoc.Div({buttons, tl_div, pagination}, {class = "swiper-container"})

      return(swiper_container)
    end
  end
end