
function Div(div)
  if div.classes:includes("timeline") then
    if FORMAT:match "html" then

      tl_div = pandoc.Div({}, {class = "swiper-wrapper timeline"})
      quarto.log.output(tl_div)

      local tl_list = div.content[1]
      for _, block in ipairs(tl_list.content) do

        local year = block[1].content[1]
        local title = block[1].content[3]

        year = pandoc.Span(year, {class = "date"})
        slide_cont = {
          pandoc.Div(year, {class = "timestamp"}),
          pandoc.Div(title, {class = "status"})
        }
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
      swiper_container = pandoc.Div({buttons, tl_div, pagination}, {class = "swiper-container"})

      return(swiper_container)
    end
  end
end