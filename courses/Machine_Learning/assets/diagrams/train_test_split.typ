#import "@preview/fletcher:0.5.8" as fletcher: diagram, node, edge

#set page(width: auto, height: auto, margin: 6pt)

#diagram(
  node-stroke: luma(80%),
  edge-corner-radius: none,
  spacing: (12pt, 28pt),

  node((0, 0), [*Dataset*], name: <dataset>),
  node((-1.2, 1.4), [*Training Set* \ 80%], name: <train>),
  node((1.2, 1.4), [*Testing Set* \ 20%], name: <test>),

  edge(<dataset>, <train>, "-|>"),
  edge(<dataset>, <test>, "-|>"),
)
