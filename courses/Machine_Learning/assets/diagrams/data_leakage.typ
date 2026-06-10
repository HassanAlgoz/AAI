#import "@preview/fletcher:0.5.8" as fletcher: diagram, node, edge

#set page(width: auto, height: auto, margin: 10pt)

#let wrong = rgb("#cc3333")
#let right = rgb("#2e8b57")

#diagram(
  edge-corner-radius: 4pt,
  spacing: (26pt, 30pt),

  // ---- WRONG flow (left column) ----
  node((1, -1), text(fill: wrong, weight: "bold")[WRONG — Data Leakage], stroke: none),
  node((1, 0), [Entire Dataset], stroke: wrong, name: <w-all>),
  node((1, 1), [Fit Scaler on ALL data], stroke: wrong, name: <w-fit>),
  node((1, 2), [Split Data], stroke: wrong, name: <w-split>),
  node((0, 3), [Train Data \ (leaked test stats)], stroke: wrong, name: <w-train>),
  node((2, 3), [Test Data], stroke: wrong, name: <w-test>),

  edge(<w-all>, <w-fit>, "-|>", stroke: wrong),
  edge(<w-fit>, <w-split>, "-|>", stroke: wrong),
  edge(<w-split>, <w-train>, "-|>", stroke: wrong),
  edge(<w-split>, <w-test>, "-|>", stroke: wrong),

  // ---- RIGHT flow (right column) ----
  node((5, -1), text(fill: right, weight: "bold")[RIGHT — Proper Process], stroke: none),
  node((5, 0), [Entire Dataset], stroke: right, name: <r-all>),
  node((5, 1), [Split Data FIRST], stroke: right, name: <r-split>),
  node((4, 2), [Train Data], stroke: right, name: <r-train>),
  node((6, 2), [Test Data], stroke: right, name: <r-test>),
  node((4, 3), [Fit Scaler on \ Train ONLY], stroke: right, name: <r-fit>),
  node((5.5, 4), [Transform \ Test Data], stroke: right, name: <r-transform>),

  edge(<r-all>, <r-split>, "-|>", stroke: right),
  edge(<r-split>, <r-train>, "-|>", stroke: right),
  edge(<r-split>, <r-test>, "-|>", stroke: right),
  edge(<r-train>, <r-fit>, "-|>", stroke: right),
  edge(<r-fit>, <r-transform>, "-|>", stroke: right),
  edge(<r-test>, <r-transform>, "-|>", stroke: right),
)
