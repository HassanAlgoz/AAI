#import "@preview/fletcher:0.5.8" as fletcher: diagram, node, edge

#set page(width: auto, height: auto, margin: 6pt)

#diagram(
  node-stroke: luma(80%),
  edge-corner-radius: none,
  spacing: (10pt, 18pt),

  node((-2.2, 1.6), [*Small dataset* \ (thousands of rows)], name: <small-title>),
  node((-2.8, 0.6), [Train \ 80%], fill: luma(92%), name: <small-train>),
  node((-1.6, 0.6), [Test \ 20%], fill: luma(85%), name: <small-test>),
  edge(<small-title>, <small-train>, "-|>"),
  edge(<small-title>, <small-test>, "-|>"),

  node((2.2, 1.6), [*Big dataset* \ (millions of rows)], name: <big-title>),
  node((1.4, 0.6), [Train \ 98%], fill: luma(92%), name: <big-train>),
  node((3.0, 0.6), [Test \ 2%], fill: luma(85%), name: <big-test>),
  edge(<big-title>, <big-train>, "-|>"),
  edge(<big-title>, <big-test>, "-|>"),
)
