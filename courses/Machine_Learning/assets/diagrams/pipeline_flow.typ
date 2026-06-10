#import "@preview/fletcher:0.5.8" as fletcher: diagram, node, edge

#set page(width: auto, height: auto, margin: 10pt)

#diagram(
  node-stroke: luma(70%),
  edge-stroke: 0.9pt + luma(40%),
  spacing: (34pt, 30pt),

  node((0, 0), [$X$], name: <x>),
  node((1, 0), [*SimpleImputer* \ (Transformer)], name: <imputer>),
  node((2, 0), [*OneHotEncoder* \ (Transformer)], name: <encoder>),
  node((3, 0), [*LinearRegression* \ (Predictor)], name: <model>),
  node((4, 0), [$y$], name: <y>),

  // Dashed box drawn behind the steps to show they live inside one Pipeline
  node(
    enclose: (<imputer>, <encoder>, <model>),
    stroke: (paint: luma(55%), dash: "dashed", thickness: 1pt),
    fill: luma(96%),
    inset: 14pt,
    layer: -1,
    name: <pipe>,
  ),
  node((2, -0.95), text(style: "italic")[Pipeline], stroke: none, fill: none),

  edge(<x>, <imputer>, "-|>"),
  edge(<imputer>, <encoder>, "-|>"),
  edge(<encoder>, <model>, "-|>"),
  edge(<model>, <y>, "-|>"),
)
