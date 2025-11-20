library(DiagrammeR)
library(DiagrammeRsvg)
library(htmltools)

svg <- export_svg(grViz("
digraph LGM {

  graph [rankdir = UD, splines=line]

  # Global style
  node [fontsize = 12, labelfontname = 'Times New Roman', width = 1.25, height = 1.25, margin = .01]

  # Voting indicator
  {rank = min;
    x1 [label = 'Voting\nResult', shape = box, style = filled, fillcolor = white]
  }

  {rank = same;
    eta1 [label = 'Hate Crime\nLatent Slope', shape = circle, style = filled, fillcolor = white]
    eta2 [label = 'Hate Crime\nLatent Intercept', shape = circle, style = filled, fillcolor = white]
  }

  # indicators (rank = max)
  {rank = max;
    x2  [label = '2017,\nQuarter 1',  shape = box, style = filled, fillcolor = white];
    x3  [label = '2017,\nQuarter 2',  shape = box, style = filled, fillcolor = white];
    x4  [label = '2017,\nQuarter 3',  shape = box, style = filled, fillcolor = white];
    x5  [label = '2017,\nQuarter 4',  shape = box, style = filled, fillcolor = white];
    x13 [label = '. . .', shape = plaintext];
    x14 [label = '2020,\nQuarter 1', shape = box, style = filled, fillcolor = white];
    x15 [label = '2020,\nQuarter 2', shape = box, style = filled, fillcolor = white];
    x16 [label = '2020,\nQuarter 3', shape = box, style = filled, fillcolor = white];
    x17 [label = '2020,\nQuarter 4', shape = box, style = filled, fillcolor = white];
  }

  # Edges: Left indicator -> latent variables
  x1 -> eta1 [splines = line]
  x1 -> eta2 [splines = line]

  # Edges: Right indicators -> latent variables
  x2  -> x3  [style = invis]
  x3  -> x4  [style = invis]
  x4  -> x5  [style = invis]
  x5  -> x13 [style = invis]
  x13 -> x14 [style = invis]
  x14 -> x15 [style = invis]
  x15 -> x16 [style = invis]
  x16 -> x17 [style = invis]
  x2:n  -> eta1:s [splines = line];  x2:n  -> eta2:s [splines = line]
  x3:n  -> eta1:s [splines = line];  x3:n  -> eta2:s [splines = line]
  x4:n  -> eta1:s [splines = line];  x4:n  -> eta2:s [splines = line]
  x5:n  -> eta1:s [splines = line];  x5:n  -> eta2:s [splines = line]
  x14:n -> eta1:s [splines = line];  x14:n -> eta2:s [splines = line]
  x15:n -> eta1:s [splines = line];  x15:n -> eta2:s [splines = line]
  x16:n -> eta1:s [splines = line];  x16:n -> eta2:s [splines = line]
  x17:n -> eta1:s [splines = line];  x17:n -> eta2:s [splines = line]
}
"))

# I had to cheat a little to get curved lines between the latent variables in the diagram.
# by including:
# eta1:n -> eta2:n
# eta2:n -> eta1:n
# and removing splines=line you should get curved lines between the latent variables (and everything else). 

html_print(HTML(svg))

